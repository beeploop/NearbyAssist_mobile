import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/tag_model.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ServiceOverview extends StatefulWidget {
  const ServiceOverview({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedTags,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<TagModel> selectedTags;

  @override
  State<ServiceOverview> createState() => _ServiceOverviewState();
}

class _ServiceOverviewState extends State<ServiceOverview> {
  final List<TagModel> _availableTags = [];

  void initializeTags() {
    final expertises =
        Provider.of<UserProvider>(context, listen: false).user.expertise;

    for (final expertise in expertises) {
      _availableTags.addAll(expertise.tags);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeTags();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Title
        const AutoSizeText('Title'),
        const SizedBox(height: 10),
        TextFormField(
          maxLength: 50,
          controller: widget.titleController,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        // Description
        const AutoSizeText('Description'),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.descriptionController,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          minLines: 3,
          maxLines: 6,
        ),
        const SizedBox(height: 20),

        // Tags
        const AutoSizeText('Tags'),
        const SizedBox(height: 10),
        _tagDropdownField(),

        // Bottom padding
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _tagDropdownField() {
    return DropdownSearch<TagModel>.multiSelection(
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
      selectedItems: widget.selectedTags,
      onChanged: (items) {
        widget.selectedTags.clear();
        widget.selectedTags.addAll(items);
      },
    );
  }
}
