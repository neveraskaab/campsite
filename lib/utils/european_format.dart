import 'package:intl/intl.dart';

extension EuropeanFormat on double {
  String toEuropeanCurrency() {
    final formatter = NumberFormat.currency(
      locale: 'de_DE',
      symbol: '',
      decimalDigits: 2,
    );

    return formatter.format(this);
  }
}
