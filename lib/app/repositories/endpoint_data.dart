import 'package:flutter/foundation.dart';

class EndpointData {
  final int numbers;
  final DateTime date;

  EndpointData({
    @required this.numbers,
    this.date,
  }) : assert(numbers != null);

  @override
  String toString() {
    return 'date: $date, value: $numbers';
  }
}
