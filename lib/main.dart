import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './app/services/api_service.dart';
import './app/services/api.dart';
import './app/repositories/data_repository.dart';
import './app/ui/dashboard.dart';
import './app/services/data_cache_service.dart';

void main() async {
  // to avoid binary messenger error ServiceBinding.DefaultBinaryMessenger eexception
  WidgetsFlutterBinding.ensureInitialized();
  //by default US locale is used
  Intl.defaultLocale = 'en_IN';
  await initializeDateFormatting();
  //get shared-pref asynchronously here
  //so that make it available synchronously to the rest of the app
  //so that we can use it in synchronous method build()
  final sharedreferences = await SharedPreferences.getInstance();
  //MyApp() will be mounted only after await call is returned
  runApp(MyApp(
    sharedPreferences: sharedreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  MyApp({
    Key key,
    @required this.sharedPreferences,
  }) : super(key: key);

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        dataCacheService: DataCacheService(
          sharedPreferences: sharedPreferences,
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
