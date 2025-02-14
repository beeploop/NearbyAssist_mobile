import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:provider/provider.dart';

class Images extends StatefulWidget {
  const Images({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  bool _isLoading = false;
  final _fillableImageController = FillableImageContainerController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagedServiceProvider>(
      builder: (context, provider, child) {
        final details = provider.getServiceUnsafe(widget.serviceId);

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: [
                  ...details.images.map((image) => _imageWidget(image)),
                ],
              ),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: FilledButton(
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            FillableImageContainer(
                              controller: _fillableImageController,
                              icon: CupertinoIcons.photo,
                              labelText: 'Tap to upload',
                            ),
                            const SizedBox(height: 10),

                            // Upload button
                            FilledButton(
                              style: const ButtonStyle(
                                minimumSize:
                                    WidgetStatePropertyAll(Size.fromHeight(50)),
                              ),
                              onPressed: _handleUpload,
                              child: const Text('upload'),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Add New'),
              ),
            ),

            // Show loading overlay
            if (_isLoading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Widget _imageWidget(ServiceImageModel image) {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          onPressed: () => _handleDeleteImage(image.id),
          title: const Text('Delete', style: TextStyle(color: Colors.white)),
          trailingIcon: const Icon(
            CupertinoIcons.trash,
            size: 20,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
      ],
      blurSize: 0.5,
      menuOffset: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: '${endpoint.resource}/${image.url}',
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return CircularProgressIndicator(
                  value: downloadProgress.progress);
            },
            errorWidget: (context, url, error) => const Icon(
              CupertinoIcons.photo,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleLoader(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _handleUpload() async {
    try {
      _toggleLoader(true);

      Navigator.pop(context);
      final provider = context.read<ManagedServiceProvider>();

      if (_fillableImageController.image == null) {
        throw 'No image selected';
      }

      await provider.uploadServiceImage(
        widget.serviceId,
        _fillableImageController.image!,
      );
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      _toggleLoader(false);
    }
  }

  Future<void> _handleDeleteImage(String imageId) async {
    try {
      _toggleLoader(true);
      final provider = context.read<ManagedServiceProvider>();
      await provider.deleteServiceImage(widget.serviceId, imageId);
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      _toggleLoader(false);
    }
  }

  void _onError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Failed'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
