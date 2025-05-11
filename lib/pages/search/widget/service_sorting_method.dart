enum ServiceSortingMethod {
  suggestionScore(name: 'Suggestion'),
  price(name: 'Price'),
  rating(name: 'Rating'),
  completedBookings(name: 'Completed'),
  distance(name: 'Distance');

  const ServiceSortingMethod({required this.name});
  final String name;
}
