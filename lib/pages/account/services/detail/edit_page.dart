import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/tag_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/manage_services_service.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.service});

  final ServiceModel service;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rateController = TextEditingController();
  final List<TagModel> _availableTags = [];
  final List<TagModel> _selectedTags = [];

  void initializeTags() {
    final expertises =
        Provider.of<UserProvider>(context, listen: false).user.expertise;

    for (final expertise in expertises) {
      _availableTags.addAll(expertise.tags);
    }

    _selectedTags.addAll(widget.service.tags);
  }

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.service.title;
    _descriptionController.text = widget.service.description;
    _rateController.text = widget.service.rate.toString();
    initializeTags();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Edit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: _body(),
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
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            _titleField(),
            const SizedBox(height: 10),

            // Description Field
            _descriptionField(),
            const SizedBox(height: 10),

            // Description Field
            _rateField(),
            const SizedBox(height: 10),

            // Tags Field
            _tagDropdownField(),
            const SizedBox(height: 10),

            // Submit Button
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: _submit,
              child: const Text('Submit'),
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _titleField() {
    return Row(
      children: [
        const Text('Title:'),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _titleController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rateField() {
    return Row(
      children: [
        const Text('Rate:'),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _rateController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionField() {
    return Row(
      children: [
        const Text('Description:'),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _descriptionController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
          ),
        ),
      ],
    );
  }

  Widget _tagDropdownField() {
    return Row(
      children: [
        const Text('Search tags'),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownSearch<TagModel>.multiSelection(
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: 'select tags',
                border: OutlineInputBorder(),
              ),
            ),
            popupProps: PopupPropsMultiSelection.modalBottomSheet(
              containerBuilder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: child,
                );
              },
              modalBottomSheetProps: const ModalBottomSheetProps(
                showDragHandle: true,
              ),
              showSearchBox: true,
              showSelectedItems: true,
              searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'filter tags',
                ),
              ),
              searchDelay: const Duration(milliseconds: 500),
            ),
            autoValidateMode: AutovalidateMode.always,
            items: (filter, props) => _availableTags,
            itemAsString: (tag) => tag.title,
            compareFn: (tag, selected) => tag.id == selected.id,
            selectedItems: _selectedTags,
            onChanged: (items) {
              _selectedTags.clear();
              _selectedTags.addAll(items);
            },
          ),
        ),
      ],
    );
  }

  void _showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    try {
      _showLoader();
      final navigator = Navigator.of(context);
      final provider = context.read<ManagedServiceProvider>();

      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _rateController.text.isEmpty ||
          _selectedTags.isEmpty) {
        throw "Don't leave empty fields";
      }

      final data = UpdateServiceModel(
        id: widget.service.id,
        vendorId: widget.service.vendorId,
        title: _titleController.text,
        description: _descriptionController.text,
        rate: double.parse(_rateController.text),
        tags: _selectedTags,
        latitude: widget.service.latitude,
        longitude: widget.service.longitude,
      );

      await ManageServicesService().update(data);

      provider.update(ServiceModel(
        id: widget.service.id,
        vendorId: widget.service.vendorId,
        title: _titleController.text,
        description: _descriptionController.text,
        rate: double.parse(_rateController.text),
        tags: _selectedTags,
        latitude: widget.service.latitude,
        longitude: widget.service.longitude,
      ));

      navigator.pop();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      _hideLoader();
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
          content: Text(error, textAlign: TextAlign.center),
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
