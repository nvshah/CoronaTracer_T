import 'package:flutter/foundation.dart';

import '../services/api.dart';
import './endpoint_data.dart';

class EndpointsData{
  // final int cases;
  // final int casesSuspected;
  // final int casesConfirmed;
  // final int deaths;
  // final int recovered;

  final Map<Endpoint, EndpointData> values;

  EndpointsData({@required this.values});

  @override
  String toString() {
  return 'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
   }

  //GETTERS
  EndpointData get cases => values[Endpoint.cases];
  EndpointData get casesConfirmed => values[Endpoint.casesConfirmed];
  EndpointData get casesSuspected => values[Endpoint.casesSuspected];
  EndpointData get deaths => values[Endpoint.deaths];
  EndpointData get recovered => values[Endpoint.recovered];   
}