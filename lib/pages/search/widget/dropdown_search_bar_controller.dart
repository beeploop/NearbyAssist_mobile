class DropdownSearchBarController {
  final List<String> _selectedTags = [];
  bool _searching = false;

  List<String> get selectedTags => _selectedTags;
  bool get isSearching => _searching;

  void toggleSearching() {
    _searching = !_searching;
  }

  void replaceAll(List<String> tags) {
    _selectedTags.clear();
    _selectedTags.addAll(tags);
  }

  void clear() {
    _selectedTags.clear();
  }
}
