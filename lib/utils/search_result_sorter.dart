import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/pages/search/widget/service_sorting_method.dart';

class SearchResultSorter {
  ServiceSortingMethod method;
  List<SearchResultModel> services;

  SearchResultSorter({
    required this.method,
    required this.services,
  });

  List<SearchResultModel> sort() {
    switch (method) {
      case ServiceSortingMethod.suggestionScore:
        return _sortWithSuggestionScore();
      case ServiceSortingMethod.rate:
        return _sortWithRate();
      case ServiceSortingMethod.rating:
        return _sortWithRating();
      case ServiceSortingMethod.completedBookings:
        return _sortWithCompletedBookings();
      case ServiceSortingMethod.distance:
        return _sortWithDistance();
    }
  }

  List<SearchResultModel> _sortWithSuggestionScore() {
    services.sort((a, b) => a.suggestionScore.compareTo(b.suggestionScore));
    return services;
  }

  List<SearchResultModel> _sortWithRate() {
    services.sort((a, b) => a.rate.compareTo(b.rate));
    return services;
  }

  List<SearchResultModel> _sortWithRating() {
    services.sort((a, b) => a.rating.compareTo(b.rating));
    return services;
  }

  List<SearchResultModel> _sortWithCompletedBookings() {
    services.sort(
      (a, b) => a.completedBookings.compareTo(b.completedBookings),
    );
    return services;
  }

  List<SearchResultModel> _sortWithDistance() {
    services.sort((a, b) => a.distance.compareTo(b.distance));
    return services;
  }
}
