import 'package:nearby_assist/models/pricing_type.dart';

String formatQuantityBooked(int quantity, PricingType type) {
  switch (type) {
    case PricingType.fixed:
      return '$quantity';
    case PricingType.perHour:
      return '$quantity hour/s';
    case PricingType.perDay:
      return '$quantity day/s';
  }
}
