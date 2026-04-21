import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:demo_app/main/data/repository/operation_repository.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

/// Widget MapBackground — dùng làm lớp nền bản đồ cho các trang khác.
///
/// Cách dùng cơ bản (chỉ hiện map):
/// ```dart
/// MapBackground()
/// ```
///
/// Cách dùng nâng cao (vẽ đường + theo dõi vị trí + đặt lớp UI lên trên):
/// ```dart
/// Stack(
///   children: [
///     MapBackground(
///       destinationPoint: LatLng(21.028, 105.834),
///       showRoute: true,
///       followUserLocation: true,
///       onLocationUpdate: (pos) => print('${pos.latitude}, ${pos.longitude}'),
///     ),
///     // UI của trang đặt ở đây
///     Positioned(bottom: 24, left: 16, right: 16, child: MyBottomCard()),
///   ],
/// )
/// ```
class MapBackground extends StatefulWidget {
  /// Điểm đến (marker đỏ). Nếu null thì không hiển thị marker đến.
  final LatLng? destinationPoint;

  /// Vị trí gốc (override vị trí GPS). Nếu null thì dùng GPS thực tế.
  final LatLng? originPoint;

  /// Danh sách tọa độ đường đi đã decode sẵn.
  /// Nếu cung cấp, MapBackground sẽ vẽ ngay mà không cần gọi API Direction.
  final List<List<double>>? routeCoordinates;

  /// Chuỗi polyline encoded (từ Goong/Google Direction API).
  /// MapBackground sẽ tự decode và vẽ.
  final String? encodedPolyline;

  /// Bật / tắt tính năng cập nhật vị trí realtime.
  final bool followUserLocation;

  /// Callback khi vị trí GPS thay đổi.
  final void Function(Position position)? onLocationUpdate;

  /// Callback khi bản đồ đã sẵn sàng (trả về controller).
  final void Function(MapLibreMapController controller)? onMapReady;

  /// Zoom khởi động.
  final double initialZoom;

  /// Màu đường đi (hex string, mặc định xanh dương).
  final String routeColor;

  /// Độ rộng đường đi.
  final double routeWidth;

  /// Vẽ đường đi khi [destinationPoint] được cung cấp và
  /// [routeCoordinates] / [encodedPolyline] chưa có (tự gọi API nội bộ).
  /// Đặt false nếu trang cha tự quản lý việc fetch route.
  final bool autoFetchRoute;

  /// Goong API key dùng khi [autoFetchRoute] = true.
  final String? goongApiKey;

  const MapBackground({
    super.key,
    this.destinationPoint,
    this.originPoint,
    this.routeCoordinates,
    this.encodedPolyline,
    this.followUserLocation = true,
    this.onLocationUpdate,
    this.onMapReady,
    this.initialZoom = 14.0,
    this.routeColor = '#2563EB',
    this.routeWidth = 6.0,
    this.autoFetchRoute = false,
    this.goongApiKey = "nyVhuiUNsZl54qCI9eYVCNpN43qUa1SEuMui6KVS",
  });

  @override
  State<MapBackground> createState() => _MapBackgroundState();
}

class _MapBackgroundState extends State<MapBackground> {
  // ─── Map ────────────────────────────────────────────────────────────────────
  MapLibreMapController? _mapController;

  // ─── Vị trí ─────────────────────────────────────────────────────────────────
  LatLng _currentPosition = const LatLng(21.03357551700003, 105.81911236900004);
  StreamSubscription<Position>? _locationStream;

  // ─── Marker ─────────────────────────────────────────────────────────────────
  Symbol? _originMarker;
  Symbol? _destinationMarker;

  // ─── Trạng thái ─────────────────────────────────────────────────────────────
  bool _imagesLoaded = false;
  bool _hasCenteredOnStart = false;

  // ─── Vòng đời ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void didUpdateWidget(MapBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Cập nhật route khi tham số thay đổi
    if (widget.routeCoordinates != oldWidget.routeCoordinates &&
        widget.routeCoordinates != null) {
      _drawRoute(widget.routeCoordinates!);
    }

    if (widget.encodedPolyline != oldWidget.encodedPolyline &&
        widget.encodedPolyline != null) {
      _decodeAndDraw(widget.encodedPolyline!);
    }

    // Cập nhật marker đến và vẽ lại route nếu điểm đến thay đổi
    if (widget.destinationPoint != oldWidget.destinationPoint) {
      _updateDestinationMarker();
      if (widget.autoFetchRoute && widget.destinationPoint != null) {
        _autoFetchAndDraw();
      }
    }
  }

  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }

  // ─── Vị trí GPS ─────────────────────────────────────────────────────────────

  Future<void> _initLocation() async {
    // Lấy vị trí ban đầu
    try {
      print("khoi tao vi tri ban dau");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
          " gan current position vi tri ban dau: ${pos.latitude}, ${pos.longitude}");
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _onNewPosition(pos);
      // Vẽ route nếu được truyền vào ngay khi khởi tạo
      if (widget.routeCoordinates != null) {
        _drawRoute(widget.routeCoordinates!);
      } else if (widget.encodedPolyline != null) {
        _decodeAndDraw(widget.encodedPolyline!);
      } else if (widget.autoFetchRoute && widget.destinationPoint != null) {
        print("ve map route khi khoi tao ");
        await _autoFetchAndDraw();
      }
    } catch (_) {
      print("loi khoi tao vi tri ban dau nen dung toa do mac dinh");
      // Dùng tọa độ mặc định nếu lỗi
    }

    // Stream cập nhật realtime
    if (widget.followUserLocation) {
      _locationStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // cập nhật khi di chuyển >= 5m
        ),
      ).listen((pos) async {
        _onNewPosition(pos);
        // goi ham callback
        widget.onLocationUpdate?.call(pos);
        // goi api cap nhat vi tri luon
        print("map bg goi api update vi tri");
        await OperationRepository().updateLocation(pos.latitude, pos.longitude);
        // luu vi tri hien tai vao sharePreference moi khi di chuyen qua 5 met
        await SharePreferenceUtil.saveCurrentPosition(pos);
      });
    }
  }

  void _onNewPosition(Position pos) {
    final newLatLng = LatLng(pos.latitude, pos.longitude);
    setState(() => _currentPosition = newLatLng);

    if (_mapController != null && _imagesLoaded) {
      _updateOriginMarker(newLatLng);

      // Chỉ zoom vào vị trí hiện tại một lần duy nhất khi khởi tạo
      if (!_hasCenteredOnStart) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLatLng, widget.initialZoom),
        );
        _hasCenteredOnStart = true;
      }
    }
  }

  // ─── Sự kiện bản đồ ─────────────────────────────────────────────────────────

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
    widget.onMapReady?.call(controller);
  }

  void _onStyleLoaded() async {
    await _loadImages();
    _imagesLoaded = true;

    // Vẽ marker hiện tại
    final origin = widget.originPoint ?? _currentPosition;
    _updateOriginMarker(origin);

    // Vẽ marker đến nếu có
    if (widget.destinationPoint != null) {
      _updateDestinationMarker();
    }

    // // Vẽ route nếu được truyền vào ngay khi khởi tạo
    // if (widget.routeCoordinates != null) {
    //   _drawRoute(widget.routeCoordinates!);
    // } else if (widget.encodedPolyline != null) {
    //   _decodeAndDraw(widget.encodedPolyline!);
    // } else if (widget.autoFetchRoute &&
    //     widget.destinationPoint != null &&
    //     widget.goongApiKey != null) {
    //   print("ve map route khi khoi tao ");
    //   await _autoFetchAndDraw();
    // }
  }

  // ─── Ảnh marker ─────────────────────────────────────────────────────────────
  Future<Uint8List?> _loadSvgAsImage(
    String assetPath, {
    required int width,
    required int height,
  }) async {
    try {
      final pictureInfo = await vg.loadPicture(
        SvgAssetLoader(assetPath),
        null,
      );

      final image = await pictureInfo.picture.toImage(width, height);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error loading SVG $assetPath: $e');
      return null;
    }
  }

  Future<void> _loadImages() async {
    try {
      final ByteData originBytes =
          await rootBundle.load('assets/images/img_origin.png');
      await _mapController?.addImage(
          'location', originBytes.buffer.asUint8List());
      // Load và resize icon điểm đến
      final ByteData destinationBytes =
          await rootBundle.load('assets/images/img_dest.png');
      await _mapController?.addImage(
          'locationEnd', destinationBytes.buffer.asUint8List());
    } catch (_) {
      // Asset không tồn tại, bỏ qua (dùng icon mặc định)
    }
  }

  // ─── Marker ─────────────────────────────────────────────────────────────────

  Future<void> _updateOriginMarker(LatLng pos) async {
    if (_mapController == null) return;

    try {
      if (_originMarker != null) {
        await _mapController!.updateSymbol(
          _originMarker!,
          SymbolOptions(geometry: pos),
        );
      } else {
        _originMarker = await _mapController!.addSymbol(SymbolOptions(
          geometry: pos,
          iconImage: 'location',
          iconSize: 1.3,
          zIndex: 999,
        ));
      }
    } catch (_) {}
  }

  Future<void> _updateDestinationMarker() async {
    if (_mapController == null || !_imagesLoaded) return;
    final dest = widget.destinationPoint;
    if (dest == null) {
      if (_destinationMarker != null) {
        await _mapController!.removeSymbol(_destinationMarker!);
        _destinationMarker = null;
      }
      return;
    }

    try {
      if (_destinationMarker != null) {
        await _mapController!.updateSymbol(
          _destinationMarker!,
          SymbolOptions(geometry: dest),
        );
      } else {
        _destinationMarker = await _mapController!.addSymbol(SymbolOptions(
          geometry: dest,
          iconImage: 'locationEnd',
          iconSize: 1.3,
          zIndex: 999,
        ));
      }

      // Di chuyển camera đến điểm đến
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: dest, zoom: widget.initialZoom),
        ),
      );
    } catch (_) {}
  }

  // ─── Vẽ đường ───────────────────────────────────────────────────────────────

  /// Vẽ đường từ danh sách tọa độ [[lng, lat], ...]
  Future<void> _drawRoute(List<List<double>> coordinates) async {
    if (_mapController == null) {
      print("map controller null");
      return;
    }
    print("ve duong di");
    try {
      await _mapController!.removeLayer('mb_route_layer');
      await _mapController!.removeSource('mb_route_source');
    } catch (_) {}

    final geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {
            'type': 'LineString',
            'coordinates': coordinates,
          },
        }
      ],
    };

    await _mapController!.addSource(
      'mb_route_source',
      GeojsonSourceProperties(data: geoJson),
    );

    await _mapController!.addLineLayer(
      'mb_route_source',
      'mb_route_layer',
      LineLayerProperties(
        lineColor: widget.routeColor,
        lineWidth: widget.routeWidth,
        lineCap: 'round',
        lineJoin: 'round',
      ),
    );

    // Fit camera để bao trọn route
    if (coordinates.isNotEmpty) {
      final lats = coordinates.map((c) => c[1]);
      final lngs = coordinates.map((c) => c[0]);
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(lats.reduce((a, b) => a < b ? a : b),
                lngs.reduce((a, b) => a < b ? a : b)),
            northeast: LatLng(lats.reduce((a, b) => a > b ? a : b),
                lngs.reduce((a, b) => a > b ? a : b)),
          ),
          left: 60,
          top: 120,
          right: 60,
          bottom: 160,
        ),
      );
    }
  }

  /// Decode polyline encoded rồi vẽ
  void _decodeAndDraw(String encoded) {
    final points = PolylinePoints.decodePolyline(encoded);
    final coords = points.map((p) => [p.longitude, p.latitude]).toList();
    _drawRoute(coords);
  }

  /// Tự gọi Goong Direction API (khi autoFetchRoute = true)
  Future<void> _autoFetchAndDraw() async {
    if (widget.goongApiKey == null || widget.destinationPoint == null) return;
    final origin = widget.originPoint ?? _currentPosition;
    final dest = widget.destinationPoint!;

    try {
      print("bat dau goi api tim duong di");
      print("origin: ${origin.latitude}, ${origin.longitude}");
      print("destination: ${dest.latitude}, ${dest.longitude}");
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=${origin.latitude},${origin.longitude}&destination=${dest.latitude},${dest.longitude}&vehicle=bike&api_key=${widget.goongApiKey}');

      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];

      List<PointLatLng> result = PolylinePoints.decodePolyline(route);
      List<List<double>> coordinates =
          result.map((point) => [point.longitude, point.latitude]).toList();
      _drawRoute(coordinates);
      // _ = response;
    } catch (e) {
      print("loi khi auto fetch and draw: $e");
    }
  }

  // ─── Xoá route ──────────────────────────────────────────────────────────────

  /// Gọi từ bên ngoài qua GlobalKey<_MapBackgroundState> để xoá route.
  Future<void> clearRoute() async {
    try {
      await _mapController?.removeLayer('mb_route_layer');
      await _mapController?.removeSource('mb_route_source');
    } catch (_) {}
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
      initialCameraPosition: CameraPosition(
        target: widget.originPoint ?? _currentPosition,
        zoom: widget.initialZoom,
      ),
      styleString:
          'https://tiles.goong.io/assets/goong_map_web.json?api_key=KACfZd5wh2kqlrhxVVQZp9Ur5SLe50fpszEBDiND',
      attributionButtonPosition: null,
      myLocationEnabled: false, // Dùng marker custom thay vì built-in
      myLocationTrackingMode: MyLocationTrackingMode.none,
    );
  }
}
