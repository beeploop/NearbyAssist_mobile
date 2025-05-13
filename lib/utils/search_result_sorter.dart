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
      case ServiceSortingMethod.suggestibility:
        return _sortWithSuggesibility();
      case ServiceSortingMethod.price:
        return _sortWithPrice();
      case ServiceSortingMethod.rating:
        return _sortWithRating();
      case ServiceSortingMethod.completedBookings:
        return _sortWithCompletedBookings();
      case ServiceSortingMethod.distance:
        return _sortWithDistance();
    }
  }

  List<SearchResultModel> _sortWithSuggesibility() {
    services.sort((a, b) => b.suggestibility.compareTo(a.suggestibility));
    return services;
  }

  List<SearchResultModel> _sortWithPrice() {
    services.sort((a, b) => a.price.compareTo(b.price));
    return services;
  }

  List<SearchResultModel> _sortWithRating() {
    services.sort((a, b) => b.rating.compareTo(a.rating));
    return services;
  }

  List<SearchResultModel> _sortWithCompletedBookings() {
    services.sort(
      (a, b) => b.completedBookings.compareTo(a.completedBookings),
    );
    return services;
  }

  List<SearchResultModel> _sortWithDistance() {
    services.sort((a, b) => a.distance.compareTo(b.distance));
    return services;
  }
}
