import 'package:flutter/foundation.dart';

import 'package:coronatracker/app/services/api.dart';

class EndpointsData{
  // final int cases;
  // final int casesSuspected;
  // final int casesConfirmed;
  // final int deaths;
  // final int recovered;

  final Map<Endpoint, int> values;

  EndpointsData({@required this.values});

  @override
  String toString() {
  return 'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
   }

  //GETTERS
  int get cases => values[Endpoint.cases];
  int get casesConfirmed => values[Endpoint.casesConfirmed];
  int get casesSuspected => values[Endpoint.casesSuspected];
  int get deaths => values[Endpoint.deaths];
  int get recovered => values[Endpoint.recovered];   
}