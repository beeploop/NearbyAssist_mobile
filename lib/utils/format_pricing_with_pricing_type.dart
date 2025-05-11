import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

String formatPriceWithPricingType(double amount, PricingType type) {
  final price = formatCurrency(amount);

  switch (type) {
    case PricingType.fixed:
      return '$price (fixed)';
    case PricingType.perHour:
      return '$price / hour';
    case PricingType.perDay:
      return '$price / day';
  }
}
