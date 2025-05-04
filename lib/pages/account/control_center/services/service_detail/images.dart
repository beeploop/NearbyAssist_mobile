import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';

class Images extends StatefulWidget {
  const Images({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  final _fillableImageController = FillableImageContainerController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ControlCenterProvider>(
      builder: (context, userProvider, ccProvider, _) {
        final service = ccProvider.services
            .firstWhere((service) => service.id == widget.serviceId);

        return LoaderOverlay(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: service.images
                      .map((image) => _imageWidget(image))
                      .toList(),
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
                    if (userProvider.user.isRestricted) {
                      showAccountRestrictedModal(context);
                      return;
                    }

                    if (service.disabled) {
                      showGenericErrorModal(
                        context,
                        message: 'Service is disabled',
                      );
                      return;
                    }

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
                                  minimumSize: WidgetStatePropertyAll(
                                      Size.fromHeight(50)),
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
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imageWidget(ServiceImageModel image) {
    final user = context.watch<UserProvider>().user;

    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          onPressed: () {
            if (user.isRestricted) {
              showAccountRestrictedModal(context);
              return;
            }

            _handleDeleteImage(image.id);
          },
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
            imageUrl: '${endpoint.publicResource}/${image.url}',
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

  Future<void> _handleUpload() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      Navigator.pop(context);

      if (_fillableImageController.image == null) {
        throw 'No image selected';
      }

      await context.read<ControlCenterProvider>().uploadImage(
            widget.serviceId,
            _fillableImageController.image!,
          );

      _fillableImageController.clearImage();
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }

  Future<void> _handleDeleteImage(String imageId) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      await context
          .read<ControlCenterProvider>()
          .deleteImage(widget.serviceId, imageId);
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
