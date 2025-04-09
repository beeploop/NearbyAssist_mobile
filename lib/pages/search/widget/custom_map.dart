import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/pages/search/widget/service_sorting_method.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/utils/search_result_sorter.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> with TickerProviderStateMixin {
  final _initialZoom = 13.0;
  final _maxZoom = 18.0;
  final _animateZoom = 16.0;
  OverlayEntry? orderingPreferenceOverlay;
  late final _controller = AnimatedMapController(vsync: this);
  LatLng _location = defaultLocation;

  Future<void> _getLocation() async {
    final position = await LocationService().lastPosition();
    if (position == null) return;

    setState(() {
      _location = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceProvider, SearchProvider>(
      builder: (context, serviceProvider, searchProvider, child) {
        final services = serviceProvider.getServices();
        _fitMarkers(services);

        return Stack(
          children: [
            FlutterMap(
              mapController: _controller.mapController,
              options: MapOptions(
                  initialCenter:
                      LatLng(_location.latitude, _location.longitude),
                  initialZoom: _initialZoom,
                  maxZoom: _maxZoom,
                  onMapReady: _centerMap,
                  onTap: (tapPos, latlng) {
                    // Remove focus from the searchbar
                    FocusManager.instance.primaryFocus?.unfocus();
                  }),
              children: [
                TileLayer(
                  urlTemplate: tileMapProvider,
                  userAgentPackageName: 'com.example.app',
                  tileProvider: _tileProvider(),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      height: 80,
                      width: 60,
                      rotate: true,
                      alignment: Alignment.topCenter,
                      point: LatLng(_location.latitude, _location.longitude),
                      child: GestureDetector(
                        onTap: _centerMap,
                        child: const Icon(
                          CupertinoIcons.person_circle_fill,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),

                    // Display markers for the services
                    ..._displayServices(
                      services,
                      searchProvider.sortingMethod,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(-6, 6),
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.list_bullet,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () {
                        if (orderingPreferenceOverlay == null) {
                          _showOrderingPreference();
                        } else {
                          _hideOrderingPreference();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.map_pin_ellipse,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () => _fitMarkers(services),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOrderingPreference() {
    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size.width * 0.5;

    orderingPreferenceOverlay = OverlayEntry(
      builder: (context) => Positioned(
        right: 86,
        bottom: 90,
        width: size,
        child: _buildOrderingPreference(),
      ),
    );

    overlay.insert(orderingPreferenceOverlay!);
  }

  void _hideOrderingPreference() {
    orderingPreferenceOverlay?.remove();
    orderingPreferenceOverlay = null;
  }

  Widget _buildOrderingPreference() {
    final searchProvider = context.read<SearchProvider>();

    return Material(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text('Ordering Preference'),
            const SizedBox(height: 10),

            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.suggestionScore,
              CupertinoIcons.sparkles,
            ),
            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.rate,
              CupertinoIcons.money_dollar,
            ),
            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.rating,
              CupertinoIcons.star,
            ),
            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.completedBookings,
              CupertinoIcons.checkmark,
            ),
            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.distance,
              CupertinoIcons.map,
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderPreferenceItem(
    SearchProvider searchProvider,
    ServiceSortingMethod method,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(method.name),
      dense: true,
      onTap: () {
        searchProvider.changeSortingMethod(method);
        _hideOrderingPreference();
      },
    );
  }

  TileProvider _tileProvider() {
    return CancellableNetworkTileProvider();
  }

  List<Marker> _displayServices(
      List<SearchResultModel> services, ServiceSortingMethod method) {
    final sorted =
        SearchResultSorter(method: method, services: services).sort();

    List<Marker> markers = [];
    for (int i = 0; i < sorted.length; i++) {
      markers.add(_createMarker(
        point: LatLng(sorted[i].latitude, sorted[i].longitude),
        order: i + 1,
        icon: CupertinoIcons.location_solid,
        color: Colors.red,
        onTap: () => context.pushNamed(
          'viewService',
          queryParameters: {'serviceId': sorted[i].id},
        ),
      ));
    }

    return markers;
  }

  Marker _createMarker({
    required LatLng point,
    required int order,
    required IconData icon,
    required Color color,
    required void Function() onTap,
  }) {
    return Marker(
      height: 80,
      width: 60,
      rotate: true,
      alignment: Alignment.topCenter,
      point: point,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '$order',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(icon, color: color, size: 40),
          ],
        ),
      ),
    );
  }

  void _centerMap() {
    _controller.animateTo(
      dest: LatLng(_location.latitude, _location.longitude),
      zoom: _animateZoom,
    );
  }

  void _fitMarkers(List<SearchResultModel> services) {
    final userPosition = LatLng(_location.latitude, _location.longitude);

    final coordinates = services.map((service) {
      return LatLng(service.latitude, service.longitude);
    }).toList();
    coordinates.add(userPosition);
    final bounds = LatLngBounds.fromPoints(coordinates);

    if (bounds.northEast == bounds.southWest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.animateTo(dest: userPosition, zoom: _animateZoom);
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animatedFitCamera(
        cameraFit: CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.fromLTRB(80, 180, 80, 80),
        ),
      );
    });
  }
}
