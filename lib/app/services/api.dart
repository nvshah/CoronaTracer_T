import 'package:flutter/foundation.dart';

import './api_keys.dart';

//List all endpoints
enum Endpoint{
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

//Provide apikey & apiurl for endpoint
class API {
  final String apiKey;
  static final String host = 'ncov2019-admin.firebaseapp.com';

  API({@required this.apiKey});
  factory API.sandbox() => API(apiKey: APIKeys.ncovSandBoxKey);

  //Resource identifier that we will use to get the access token
  Uri tokenUri() => Uri(
        scheme: 'https',
        host: host,
        path: 'token',
      );

  //prepare Uri to fire endpoint api particular functionality
  Uri endpointUri(Endpoint endPoint) => Uri(
    scheme: 'https',
    host: host,
    path: _paths[endPoint],
  ); 
  
  //Map for endpoints
  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesConfirmed: 'casesConfirmed',
    Endpoint.casesSuspected: 'caseSuspected',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };
}
