import 'package:intl/intl.dart';

String formatRupiah(int amount) {
  final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return f.format(amount);
}
