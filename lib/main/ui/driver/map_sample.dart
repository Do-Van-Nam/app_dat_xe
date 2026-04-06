import 'package:demo_app/core/app_export.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async'; // ignore: unnecessary_import
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:typed_data';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MaplibreMapController? mapController;

  int _symbolCount = 0;
  LatLng? _currentPosition;
  LatLng? _destinationPoint;
  static const clusterLayer = "clusters";
  static const unclusteredPointLayer = "unclustered-point";
  PolylinePoints polylinePoints = PolylinePoints(apiKey: '<API_KEY>');
  Symbol? _currentMarker;
  OverlayEntry? _popupOverlayEntry;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentPosition = LatLng(21.03357551700003, 105.81911236900004);
    });
  }

  void _onMapCreated(MaplibreMapController controller) async {
    mapController = controller;
    _loadMarkerImage();
    _loadMarkerEndImage();
    _addMarkerAtDestinationPoint();
  }

  Future<void> _loadMarkerImage() async {
    final ByteData bytes = await rootBundle.load('assets/location.png');
    mapController?.addImage('location', bytes.buffer.asUint8List());
    // return bytes.buffer.asUint8List();
  }

  Future<void> _loadMarkerEndImage() async {
    final ByteData bytes = await rootBundle.load('assets/locationEnd.png');
    mapController?.addImage('locationEnd', bytes.buffer.asUint8List());
    // return bytes.buffer.asUint8List();
  }

  void _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Style loaded :)"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
    if (_currentPosition != null) {
      _addMarkerAtCurrentPosition();
    }
  }

  void _addMarkerAtCurrentPosition() async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }

    const initialLatitude = 21.03357551700003;
    const initialLongitude = 105.81911236900004;

    try {
      mapController?.addCircle(CircleOptions(
        geometry: LatLng(initialLatitude, initialLongitude),
        circleRadius: 100.0,
        circleColor: "#848484",
        circleOpacity: 0.3,
        circleStrokeWidth: 2,
        circleStrokeColor: "#848484",
      ));

      mapController?.addSymbol(SymbolOptions(
        geometry: LatLng(initialLatitude, initialLongitude),
        iconImage: 'location',
        iconSize: 0.3,
        zIndex: 1, // Ensure marker is above circle
      ));
      print("Initial marker added at ($initialLatitude, $initialLongitude)");
    } catch (e) {
      print("Error adding initial marker: $e");
    }
  }

  void _addMarkerAtDestinationPoint() async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }

    if (_destinationPoint == null) {
      print("Destination point is not set");
      return;
    }

    try {
      // Xóa marker hiện tại nếu có
      if (_currentMarker != null) {
        await mapController!.removeSymbol(_currentMarker!);
      }

      // Add a marker with a title
      _currentMarker = await mapController!.addSymbol(SymbolOptions(
        geometry: _destinationPoint!,
        iconImage: 'locationEnd', // Ensure this matches the loaded image name
        iconSize: 0.3,
        draggable: true,
      ));

      mapController!.onSymbolTapped.add((symbol) {
        _onMarkerTapped(symbol);
      });

      print("Marker added at ($_destinationPoint)");

      //  mapController!.onFeatureDrag.add((value, {
      //     required LatLng current,
      //     required LatLng delta,
      //     required DragEventType eventType,
      //     required LatLng origin,
      //     required Point<double> point,
      //   }) {
      //     print("5656565656($origin)"); // Đây để log ra location khi draggable
      //   });

      // Di chuyển camera đến vị trí mới
      mapController!.animateCamera(CameraUpdate.newLatLng(_destinationPoint!));
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  void _onMarkerDragEnd(LatLng newPosition) {
    print(
        "Marker dragged to: ${newPosition.latitude}, ${newPosition.longitude}");
    setState(() {
      _destinationPoint = newPosition; // Cập nhật vị trí mới
    });
  }

  void _onMarkerTapped(Symbol symbol) async {
    if (mapController == null) return;

    // Remove previous overlay if any
    _popupOverlayEntry?.remove();

    // Convert LatLng to screen coordinates
    LatLng markerLatLng = symbol.options.geometry!;
    Point<num> screenPosition =
        await mapController!.toScreenLocation(markerLatLng);

    // Create a new overlay entry
    _popupOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: screenPosition.x.toDouble() -
            50, // Adjust based on the width of the popup
        top: screenPosition.y.toDouble() -
            80, // Adjust based on the height of the popup
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Text(
              symbol.options.textField ?? 'No Title',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay into the overlay stack
    Overlay.of(context)!.insert(_popupOverlayEntry!);

    // Add a handler to close the popup when tapping on another symbol
    mapController!.onSymbolTapped.add((tappedSymbol) {
      if (tappedSymbol != symbol) {
        _popupOverlayEntry?.remove();
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  String mainText = "";
  String secondText = "";
  List<dynamic> places = [];
  var details = {};
  bool isShow = false;
  bool isHidden = true;

  Future<void> fetchData(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=<API_KEY>');
      // print('url $url');
      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        print('url $url, size: ${places.length}');
        // _circleAnnotationManager?.deleteAll();
        isShow = true;
        isHidden = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Future<void> fetchDataDirection() async {
    if (_currentPosition != null && _destinationPoint != null) {
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destinationPoint!.latitude},${_destinationPoint!.longitude}&vehicle=bike&api_key=<API_KEY>');

      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];

      List<PointLatLng> result = PolylinePoints.decodePolyline(route);
      List<List<double>> coordinates =
          result.map((point) => [point.longitude, point.latitude]).toList();
      _drawLine(coordinates);
    }
  }

  void _drawLine(List<List<double>> coordinates) {
    mapController?.removeLayer("line_layer");
    mapController?.removeSource("line_source");
    final geoJsonData = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": coordinates,
          },
        },
      ],
    };

    mapController?.addSource(
      "line_source",
      GeojsonSourceProperties(
        data: geoJsonData,
      ),
    );

    mapController?.addLineLayer(
      "line_source",
      "line_layer",
      LineLayerProperties(
        lineColor: "#0000FF", // Màu xanh dưới dạng chuỗi
        lineWidth: 10,
        lineCap: "round",
        lineJoin: "round",
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: places.length < 5 ? places.length : 5,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1),
      itemBuilder: (context, index) {
        final coordinate = places[index];

        return ListTile(
          horizontalTitleGap: 5,
          title: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 320,
                child: Text(
                  coordinate['description'],
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              )
            ],
          ),
          onTap: () async {
            setState(() {
              isShow = false;
              isHidden = false;
            });
            final url = Uri.parse(
                'https://rsapi.goong.io/place/detail?place_id=${coordinate['place_id']}&api_key=<API_KEY>');
            var response = await http.get(url);
            final jsonResponse = jsonDecode(response.body);

            details = jsonResponse['result'];
            setState(() {
              _destinationPoint = LatLng(details['geometry']['location']['lat'],
                  details['geometry']['location']['lng']);
              _addMarkerAtDestinationPoint();
              // Thêm marker sau khi cập nhật _destinationPoint
            });

            _searchController.text = coordinate['description'];
            mainText = coordinate['structured_formatting']['main_text'];
            secondText = coordinate['structured_formatting']['secondary_text'];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: MapLibreMap(
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              initialCameraPosition: CameraPosition(
                target: LatLng(21.03357551700003,
                    105.81911236900004), // Vị trí ban đầu của bản đồ (Cái này sẽ bắt vị trí hiện tại của bạn)
                zoom: 14.0,
              ),
              styleString:
                  'https://tiles.goong.io/assets/goong_map_web.json?api_key=<MAP_TILE_KEY>', // URL của style
              attributionButtonPosition: null,
            ),
          ),
          Container(
            height: 70,
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(5, 80, 5, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 4),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 8),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (String text) {
                                    print("onChanged: $text");
                                    fetchData(text);
                                    isHidden = true;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Nhập địa điểm",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.black54, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Thực hiện hành động dẫn đường ở đây
                                fetchDataDirection();
                                print("Dẫn đường");
                              },
                              child: const Text(
                                "Dẫn đường",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isShow == true)
            Container(
              margin: const EdgeInsets.fromLTRB(5, 160, 5, 0),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration: const BoxDecoration(color: Colors.white),
              child: _buildListView(),
            ),
        ],
      ),
    );
  }
}
