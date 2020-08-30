import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/endpoints_data.dart';
import '../repositories/endpoint_data.dart';
import './api.dart';

class DataCacheService {
  final SharedPreferences sharedPreferences;

  DataCacheService({
    @required this.sharedPreferences,
  });

  static String endpointValueKey(Endpoint endpoint) => '$endpoint/value';
  static String endpointDateKey(Endpoint endpoint) => '$endpoint/date';

  ///Get cached values ( for Offline mode)
  ///synchronous method
  EndpointsData getData(){
    Map<Endpoint, EndpointData> values = {};
      Endpoint.values.forEach((endpoint){
        final numbers = sharedPreferences.getInt(endpointValueKey(endpoint));
        final dateString = sharedPreferences.getString(endpointDateKey(endpoint));
        if(numbers != null && dateString != null){
          //tryparse can parse date-string in iso8601 format
          final date = DateTime.tryParse(dateString);
          values[endpoint] = EndpointData(numbers: numbers, date: date,);
        }
      });
    return EndpointsData(values: values);
  }

  //Caching Data (for offline mode)
  Future<void> saveData(EndpointsData endpointsData) async {
    //saving data to a shared references is an async operation
    // so need to define async closure at level-1 to use await expression at level-2
    endpointsData.values.forEach((endpoint, endpointData) async {
      await sharedPreferences.setInt(
        endpointValueKey(endpoint),
        endpointData.numbers,
      );
      await sharedPreferences.setString(
        endpointDateKey(endpoint),
        endpointData.date.toIso8601String(),
      );
    });
  }
}
