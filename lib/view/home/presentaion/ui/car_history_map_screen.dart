import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vet_internal_ticket/components/appbar.dart';

class CarHistoryMapScreen extends StatefulWidget {
  const CarHistoryMapScreen({super.key});

  @override
  State<CarHistoryMapScreen> createState() => _CarHistoryMapScreenState();
}

class _CarHistoryMapScreenState extends State<CarHistoryMapScreen> {
  static const LatLng _defaultPosition = LatLng(11.5449, 104.8922);

  final MapController _mapController = MapController();

  late final LatLng _targetPosition;
  // late final String _label;

  @override
  void initState() {
    super.initState();

    final args =
        (Get.arguments is Map) ? (Get.arguments as Map) : <String, dynamic>{};
    final lat = (args['lat'] is num)
        ? (args['lat'] as num).toDouble()
        : _defaultPosition.latitude;
    final lng = (args['lng'] is num)
        ? (args['lng'] as num).toDouble()
        : _defaultPosition.longitude;
    // _label = (args['label']?.toString().isNotEmpty ?? false)
    //     ? args['label'].toString()
    //     : 'VET Station';
    _targetPosition = LatLng(lat, lng);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const initialZoom = 13.5;

    return Scaffold(
      appBar: appBarDefault(
        title: 'ទីតាំង VET',
        onPressed: () => Get.back(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _targetPosition,
                initialZoom: initialZoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.flingAnimation,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'vet_internal_ticket',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _targetPosition,
                      width: 44,
                      height: 44,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'map-zoom-in',
                  mini: true,
                  onPressed: () {
                    final camera = _mapController.camera;
                    _mapController.move(camera.center, camera.zoom + 1);
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'map-zoom-out',
                  mini: true,
                  onPressed: () {
                    final camera = _mapController.camera;
                    _mapController.move(camera.center, camera.zoom - 1);
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
