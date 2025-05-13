import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/pages/search/widget/service_sorting_method.dart';
import 'package:nearby_assist/utils/search_result_sorter.dart';

void main() {
  final services = [
    SearchResultModel(
      id: '1',
      price: 200,
      rating: 3,
      completedBookings: 1,
      distance: 3.4028235,
      suggestibility: 1.0,
      service: null,
      latitude: 0.00,
      longitude: 0.00,
      vendorName: '',
    ),
    SearchResultModel(
      id: '2',
      price: 450,
      rating: 0,
      completedBookings: 0,
      distance: 3.4028235,
      suggestibility: 0.37776,
      service: null,
      latitude: 0.00,
      longitude: 0.00,
      vendorName: '',
    ),
    SearchResultModel(
      id: '3',
      price: 500,
      rating: 3,
      completedBookings: 0,
      distance: 3.4028235,
      suggestibility: 0.66,
      service: null,
      latitude: 0.00,
      longitude: 0.00,
      vendorName: '',
    ),
  ];

  test('test sorting by suggestibility', () {
    final sorter = SearchResultSorter(
      method: ServiceSortingMethod.suggestibility,
      services: [...services],
    );

    final result = sorter.sort();
    expect(result.map((e) => e.id), ['1', '3', '2']);
  });

  test('test sorting by price', () {
    final sorter = SearchResultSorter(
      method: ServiceSortingMethod.price,
      services: [...services],
    );

    final result = sorter.sort();
    expect(result.map((e) => e.id), ['1', '2', '3']);
  });

  test('test sorting by rating', () {
    final sorter = SearchResultSorter(
      method: ServiceSortingMethod.rating,
      services: [...services],
    );

    final result = sorter.sort();
    expect(result.map((e) => e.id), ['1', '3', '2']);
  });

  test('test sorting by completed bookings', () {
    final sorter = SearchResultSorter(
      method: ServiceSortingMethod.completedBookings,
      services: [...services],
    );

    final result = sorter.sort();
    expect(result.map((e) => e.id), ['1', '2', '3']);
  });

  test('test sorting by distance', () {
    final sorter = SearchResultSorter(
      method: ServiceSortingMethod.distance,
      services: [...services],
    );

    final result = sorter.sort();
    expect(result.map((e) => e.id), ['1', '2', '3']);
  });
}
