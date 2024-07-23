import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  final DateFormat formatter =
      DateFormat('dd MMM yyyy hh:mm a'); // Customize the format as needed
  return formatter.format(dateTime);
}