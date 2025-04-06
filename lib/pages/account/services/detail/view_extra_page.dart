import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';

class ViewExtraPage extends StatefulWidget {
  const ViewExtraPage({
    super.key,
    required this.serviceId,
    required this.extra,
  });

  final String serviceId;
  final ServiceExtraModel extra;

  @override
  State<ViewExtraPage> createState() => _ViewExtraPageState();
}

class _ViewExtraPageState extends State<ViewExtraPage> {
  bool _hasChanged = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  late UserModel user;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.extra.title;
    _descriptionController.text = widget.extra.description;
    _priceController.text = widget.extra.price.toString();

    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Edit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.trash),
              onPressed: () {
                if (user.isRestricted) {
                  showAccountRestrictedModal(context);
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      color: Colors.amber,
                      size: 30,
                    ),
                    title: const Text('Delete Extra'),
                    content: const Text(
                      'This is a permanent action. This will fail if there are active bookings using this extra. Are you sure?',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleDelete();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.red),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text('Title'),
            const SizedBox(height: 10),
            TextFormField(
              onChanged: (value) {
                if (value != widget.extra.title) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
              controller: _titleController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text('Description'),
            const SizedBox(height: 10),
            TextFormField(
              onChanged: (value) {
                if (value != widget.extra.description) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
              controller: _descriptionController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 20),

            // Price
            const Text('Price'),
            TextFormField(
              onChanged: (value) {
                if (double.parse(value) != widget.extra.price) {
                  setState(() {
                    _hasChanged = true;
                  });
                } else {
                  setState(() {
                    _hasChanged = false;
                  });
                }
              },
              keyboardType: TextInputType.number,
              controller: _priceController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            FilledButton(
              style: ButtonStyle(
                minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
                backgroundColor: WidgetStatePropertyAll(
                  !_hasChanged ? Colors.grey : null,
                ),
              ),
              onPressed: () {
                if (user.isRestricted) {
                  showAccountRestrictedModal(context);
                  return;
                }

                if (!_hasChanged) {
                  return;
                }

                _handleSave();
              },
              child: const Text('Save'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final navigator = Navigator.of(context);
      final provider = context.read<ControlCenterProvider>();

      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _priceController.text.isEmpty) {
        _onError("Don't leave empty fields");
        return;
      }

      final updated = ServiceExtraModel(
        id: widget.extra.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
      );

      await provider.updateExtra(widget.serviceId, updated);
      navigator.pop();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
    }
  }

  Future<void> _handleDelete() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final navigator = Navigator.of(context);
      final provider = context.read<ControlCenterProvider>();

      await provider.deleteExtra(widget.serviceId, widget.extra.id);
      navigator.pop();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
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
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
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
