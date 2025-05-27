import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/pages/search/widget/custom_map.dart';
import 'package:nearby_assist/pages/search/widget/custom_searchbar.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/debouncer.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_location_disabled_modal.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(seconds: 1));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const CustomMap(),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  CustomSearchbar(
                    onSearchFinished: () {
                      final services = context.read<ServiceProvider>().services;
                      if (services.isEmpty) {
                        showCustomSnackBar(
                          context,
                          '0 services found',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          closeIconColor: Colors.white,
                          dismissable: true,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer<SearchProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(right: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                min: 0,
                                max: 2000,
                                divisions: 10,
                                label: provider.radius.round().toString(),
                                value: provider.radius,
                                onChanged: (value) {
                                  if (value < 100) return;

                                  provider.updateRadius(value);

                                  debouncer.call(() {
                                    _handleSearch(context);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('${provider.radius}m'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSearch(BuildContext context) async {
    try {
      final serviceProvider = context.read<ServiceProvider>();
      final searchProvider = context.read<SearchProvider>();
      final results = await searchProvider.search(
        searchProvider.latestSearchTerm,
      );

      serviceProvider.replaceAll(results);

      if (results.isEmpty) {
        if (!context.mounted) return;
        showCustomSnackBar(
          context,
          '0 services found',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          closeIconColor: Colors.white,
          dismissable: true,
          duration: const Duration(seconds: 3),
        );
        return;
      }
    } on LocationServiceDisabledException catch (_) {
      if (!context.mounted) return;
      showLocationDisabledModal(context);
    } on DioException catch (error) {
      if (!context.mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!context.mounted) return;
      showGenericErrorModal(context, message: error.toString());
    }
  }
}
