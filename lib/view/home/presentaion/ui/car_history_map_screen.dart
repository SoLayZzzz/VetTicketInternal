import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vet_internal_ticket/components/appbar.dart';

class CarHistoryMapScreen extends StatefulWidget {
  const CarHistoryMapScreen({super.key});

  @override
  State<CarHistoryMapScreen> createState() => _CarHistoryMapScreenState();
}

class _CarHistoryMapScreenState extends State<CarHistoryMapScreen> {
  static const LatLng _defaultPosition = LatLng(11.5449, 104.8922);

  GoogleMapController? _googleMapController;

  late final LatLng _targetPosition;
  // late final String _label;
  static const double _initialZoom = 13.5;

  late final Object _zoomInHeroTag;
  late final Object _zoomOutHeroTag;

  double _asDouble(dynamic v, double fallback) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    final parsed = double.tryParse(v.toString());
    return parsed ?? fallback;
  }

  @override
  void initState() {
    super.initState();

    _zoomInHeroTag = Object();
    _zoomOutHeroTag = Object();

    final args =
        (Get.arguments is Map) ? (Get.arguments as Map) : <String, dynamic>{};

    var lat = _asDouble(args['lat'], _defaultPosition.latitude);
    var lng = _asDouble(args['lng'], _defaultPosition.longitude);
    if (!lat.isFinite || !lng.isFinite) {
      lat = _defaultPosition.latitude;
      lng = _defaultPosition.longitude;
    }
    // _label = (args['label']?.toString().isNotEmpty ?? false)
    //     ? args['label'].toString()
    //     : 'VET Station';
    _targetPosition = LatLng(lat, lng);
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marker = Marker(
      markerId: const MarkerId('target'),
      position: _targetPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    return Scaffold(
      appBar: appBarDefault(
        title: 'ទីតាំង VET',
        onPressed: () => Get.back(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _targetPosition,
                zoom: _initialZoom,
              ),
              onMapCreated: (controller) {
                _googleMapController = controller;
              },
              markers: {marker},
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: false,
              buildingsEnabled: true,
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: _zoomInHeroTag,
                  mini: true,
                  onPressed: () {
                    _googleMapController?.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: _zoomOutHeroTag,
                  mini: true,
                  onPressed: () {
                    _googleMapController?.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
