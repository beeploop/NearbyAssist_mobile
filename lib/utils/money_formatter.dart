import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.simpleCurrency(locale: 'en_PH', name: "PHP");
  return formatter.format(amount);
}
