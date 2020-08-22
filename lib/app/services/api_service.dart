import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:coronatracker/app/services/api.dart';

class APIService {
  final API api;

  APIService(this.api);

  //TOKEN
  Future<String> getAccessToken() async {
    final response = await http.post(
      api.tokenUri().toString(),
      headers: {
        'Authorization': 'Basic ${api.apiKey}',
      },
    );

    //Successful
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if(accessToken != null){
        return accessToken;
      }
    }
    //Something went Wrong
    print('Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    //Will be handle at Presentation(UI) layer
    throw response;
  }

  //PAYLOAD
  Future<int> getEndpointData(@required String accesstToken, @required Endpoint endPoint) async{
    final uri = api.endpointUri(endPoint);
    final response = await http.post(uri.toString(), headers: {
      'Authorization': 'Bearer ${api.apiKey}',
    });

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      if(data.isNotEmpty){
        final Map<String, dynamic> endPointData = data[0];
        final String responseJsonInfoKey = _responseJsonKeysForInfo[endPoint];
        final int information = endPointData[responseJsonInfoKey];
        if(information != null){
          return information;
        }
      }
    }
    //Something went Wrong
    print('Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    //Will be handle at Presentation(UI) layer
    throw response;
  }
  
  //Map to get key name for information from payload data
  static Map<Endpoint, String> _responseJsonKeysForInfo = {
    Endpoint.cases: 'cases',
    Endpoint.casesConfirmed: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.casesSuspected: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
