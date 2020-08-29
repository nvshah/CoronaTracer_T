import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedStatus extends StatelessWidget {
  final DateTime date;

  LastUpdatedStatus({@required this.date});
  
  ///Format the date using intl package
  ///i/p -> DateTime obj
  ///o/p -> String, formatted date
  String _dateFormatter(DateTime date){
    if(date != null){
      final formatter = DateFormat.yMMMd().add_Hms();
      final formattedDate = formatter.format(date);
      return formattedDate;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      date != null ? 'Last Updated: $_dateFormatter(date)' : '',
      textAlign: TextAlign.center,
    );
  }
}
