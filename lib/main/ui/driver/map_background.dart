import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  final void Function(MaplibreMapController controller)? onMapReady;

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
    this.goongApiKey,
  });

  @override
  State<MapBackground> createState() => _MapBackgroundState();
}

class _MapBackgroundState extends State<MapBackground> {
  // ─── Map ────────────────────────────────────────────────────────────────────
  MaplibreMapController? _mapController;

  // ─── Vị trí ─────────────────────────────────────────────────────────────────
  LatLng _currentPosition = const LatLng(21.03357551700003, 105.81911236900004);
  StreamSubscription<Position>? _locationStream;

  // ─── Marker ─────────────────────────────────────────────────────────────────
  Symbol? _originMarker;
  Symbol? _destinationMarker;

  // ─── Trạng thái ─────────────────────────────────────────────────────────────
  bool _imagesLoaded = false;

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

    // Cập nhật marker đến
    if (widget.destinationPoint != oldWidget.destinationPoint) {
      _updateDestinationMarker();
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
      _onNewPosition(pos);
    } catch (_) {
      // Dùng tọa độ mặc định nếu lỗi
    }

    // Stream cập nhật realtime
    if (widget.followUserLocation) {
      _locationStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // cập nhật khi di chuyển >= 5m
        ),
      ).listen((pos) {
        _onNewPosition(pos);
        widget.onLocationUpdate?.call(pos);
      });
    }
  }

  void _onNewPosition(Position pos) {
    final newLatLng = LatLng(pos.latitude, pos.longitude);
    setState(() => _currentPosition = newLatLng);

    if (_mapController != null && _imagesLoaded) {
      _updateOriginMarker(newLatLng);
    }
  }

  // ─── Sự kiện bản đồ ─────────────────────────────────────────────────────────

  void _onMapCreated(MaplibreMapController controller) {
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

    // Vẽ route nếu được truyền vào ngay khi khởi tạo
    if (widget.routeCoordinates != null) {
      _drawRoute(widget.routeCoordinates!);
    } else if (widget.encodedPolyline != null) {
      _decodeAndDraw(widget.encodedPolyline!);
    } else if (widget.autoFetchRoute &&
        widget.destinationPoint != null &&
        widget.goongApiKey != null) {
      await _autoFetchAndDraw();
    }
  }

  // ─── Ảnh marker ─────────────────────────────────────────────────────────────

  Future<void> _loadImages() async {
    try {
      final ByteData originBytes = await rootBundle.load('assets/location.png');
      await _mapController?.addImage(
          'location', originBytes.buffer.asUint8List());

      final ByteData destBytes =
          await rootBundle.load('assets/locationEnd.png');
      await _mapController?.addImage(
          'locationEnd', destBytes.buffer.asUint8List());
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
        // Vẽ vòng tròn chính xác
        await _mapController!.addCircle(CircleOptions(
          geometry: pos,
          circleRadius: 80.0,
          circleColor: '#3B82F6',
          circleOpacity: 0.15,
          circleStrokeWidth: 1.5,
          circleStrokeColor: '#3B82F6',
        ));

        _originMarker = await _mapController!.addSymbol(SymbolOptions(
          geometry: pos,
          iconImage: 'location',
          iconSize: 0.3,
          zIndex: 2,
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
          iconSize: 0.3,
          zIndex: 2,
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
    if (_mapController == null) return;

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
      final url = Uri.parse(
        'https://rsapi.goong.io/Direction'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${dest.latitude},${dest.longitude}'
        '&vehicle=bike'
        '&api_key=${widget.goongApiKey}',
      );

      // ignore: depend_on_referenced_packages
      final response = await (throw UnimplementedError(
          'Thêm import http và gọi http.get(url) ở đây'));
      // Ví dụ khi đã có http:
      // final response = await http.get(url);
      // final json = jsonDecode(response.body);
      // final encoded = json['routes'][0]['overview_polyline']['points'];
      // _decodeAndDraw(encoded);
      // _ = response;
    } catch (_) {}
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
