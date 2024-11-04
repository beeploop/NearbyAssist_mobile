import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';

class DropdownSearchBar extends StatelessWidget {
  const DropdownSearchBar({super.key, required this.onSearch});

  final void Function() onSearch;

  @override
  Widget build(BuildContext context) {
    List<String> _selected = [];

    return Row(
      children: [
        Expanded(
          child: DropdownSearch<String>.multiSelection(
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: 'select tags',
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
              )),
              searchDelay: const Duration(milliseconds: 500),
            ),
            autoValidateMode: AutovalidateMode.always,
            items: (filter, props) => serviceTags,
            selectedItems: _selected,
            onChanged: (items) => _selected = items,
          ),
        ),
        IconButton(
          onPressed: onSearch,
          icon: const Icon(
            CupertinoIcons.search,
            color: Colors.green,
            size: 24,
          ),
        ),
      ],
    );
  }
}
