String getNiceDatetime(DateTime date) {
  date = date.toLocal();
  int year = date.year;
  int month = date.month;
  int day = date.day;
  int hours = date.hour;
  int minutes = date.minute;
  String result = "${month}.${day}.${year} ${hours}:${minutes}";
  return result;
}
