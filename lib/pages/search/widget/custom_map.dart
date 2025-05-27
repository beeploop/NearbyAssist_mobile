import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/pages/search/widget/search_result_list_item.dart';
import 'package:nearby_assist/pages/search/widget/service_sorting_method.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/providers/system_setting_provider.dart';
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
  final _maxZoom = 22.0;
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
        final services = serviceProvider.services;

        if (searchProvider.boundless) {
          _fitMarkers(services);
        } else {
          _fitCoordinateWithRadius(
            LatLng(_location.latitude, _location.longitude),
            searchProvider.radius,
          );
        }

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

                    if (orderingPreferenceOverlay != null) {
                      _hideOrderingPreference();
                    }
                  }),
              children: [
                TileLayer(
                  urlTemplate: tileMapProvider,
                  userAgentPackageName: 'com.example.app',
                  tileProvider: _tileProvider(),
                ),
                if (!searchProvider.boundless)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(_location.latitude, _location.longitude),
                        radius: searchProvider.radius,
                        useRadiusInMeter: true,
                        color: Colors.blue.withOpacity(0.2),
                        borderColor: Colors.blue.shade600,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      height: 80,
                      width: 60,
                      rotate: true,
                      alignment: Alignment.center,
                      point: LatLng(_location.latitude, _location.longitude),
                      child: GestureDetector(
                        onTap: _centerMap,
                        child: Icon(
                          CupertinoIcons.person_circle_fill,
                          color: Colors.red.withOpacity(0.5),
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
              right: 10,
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
                        if (orderingPreferenceOverlay != null) {
                          _hideOrderingPreference();
                        }
                        _showListView(services);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.sort_down,
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
                        CupertinoIcons.sparkles,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () {
                        if (orderingPreferenceOverlay != null) {
                          _hideOrderingPreference();
                        }
                        _showSuggestionPreferenceSettings();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        searchProvider.boundless
                            ? CupertinoIcons.map_pin_ellipse
                            : CupertinoIcons.map_pin_slash,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () async {
                        searchProvider.toggleBoundless();
                        final results = await searchProvider
                            .search(searchProvider.latestSearchTerm);

                        serviceProvider.replaceAll(results);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () {
                        if (orderingPreferenceOverlay != null) {
                          _hideOrderingPreference();
                        }

                        if (searchProvider.boundless) {
                          _fitMarkers(services);
                        } else {
                          _fitCoordinateWithRadius(
                            LatLng(_location.latitude, _location.longitude),
                            searchProvider.radius,
                          );
                        }
                      },
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

  void _showListView(List<SearchResultModel> results) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              //
              ListView.separated(
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return SearchResultListItem(result: results[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuggestionPreferenceSettings() {
    final criterionPreference = SystemSettingProvider().criteriaRanking;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Suggestion Preferences',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hold & drag to re-arrange the order of the suggestion criteria based on your preference',
              ),
              const SizedBox(height: 20),

              // Criteria ranking
              ReorderableListView.builder(
                shrinkWrap: true,
                proxyDecorator: (child, index, animation) => Material(
                  type: MaterialType.transparency,
                  child: child,
                ),
                onReorder: SystemSettingProvider().reorderCriterion,
                itemCount: criterionPreference.length,
                itemBuilder: (context, index) {
                  final criterion = criterionPreference[index];

                  IconData? icon;
                  switch (criterion.identifier) {
                    case 'p':
                      icon = CupertinoIcons.money_dollar;
                      break;
                    case 'r':
                      icon = CupertinoIcons.star;
                      break;
                    case 'd':
                      icon = CupertinoIcons.map;
                      break;
                    case 'b':
                      icon = CupertinoIcons.checkmark;
                      break;
                  }

                  return Padding(
                    key: ValueKey(criterion.name),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(criterion.name),
                        leading: Icon(icon),
                        trailing: const Icon(Icons.drag_indicator),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
            const Text('Order services by:'),
            const SizedBox(height: 10),

            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.suggestibility,
              CupertinoIcons.sparkles,
            ),
            _orderPreferenceItem(
              searchProvider,
              ServiceSortingMethod.price,
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
      selectedColor: Colors.green,
      selected: searchProvider.sortingMethod == method,
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
    const offset = 0;

    List<Marker> markers = [];
    for (int i = 0; i < sorted.length; i++) {
      markers.add(_createMarker(
        point: LatLng(
          sorted[i].latitude + (i * offset),
          sorted[i].longitude + (i * offset),
        ),
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
      alignment: Alignment.center,
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

  void _fitCoordinateWithRadius(LatLng center, double radius) {
    final north = const Distance().offset(center, radius, 0);
    final south = const Distance().offset(center, radius, 180);
    final east = const Distance().offset(center, radius, 90);
    final west = const Distance().offset(center, radius, 270);

    final bounds = LatLngBounds.fromPoints([
      LatLng(north.latitude, east.longitude),
      LatLng(south.latitude, west.longitude),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animatedFitCamera(
        cameraFit: CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.fromLTRB(20, 180, 20, 20),
        ),
      );
    });
  }
}
