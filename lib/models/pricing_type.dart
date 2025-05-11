enum PricingType {
  fixed(name: 'fixed', label: 'fixed'),
  perHour(name: 'per_hour', label: 'per Hour'),
  perDay(name: 'per_day', label: 'per Day'),
  ;

  const PricingType({required this.name, required this.label});
  final String name;
  final String label;
}
