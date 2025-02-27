enum ServiceSortingMethod {
  suggestionScore(name: 'Suggestion'),
  rate(name: 'Rate'),
  rating(name: 'Rating'),
  completedTransactions(name: 'Completed'),
  distance(name: 'Distance');

  const ServiceSortingMethod({required this.name});
  final String name;
}
