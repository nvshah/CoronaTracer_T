import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import './app/services/api_service.dart';
import './app/services/api.dart';
import './app/services/api_keys.dart';
import './app/repositories/data_repository.dart';
import './app/ui/dashboard.dart';


void main() async{
  //by default US locale is used
  Intl.defaultLocale = 'en_IN';
  await initializeDateFormatting();
  //MyApp() will be mounted only after await call is returned
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(
          API.sandbox(),
        ),
      ),
      child: MaterialApp(
        title: 'Coronavirus Tracker',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF101010),
          cardColor: Color(0xFF222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}
