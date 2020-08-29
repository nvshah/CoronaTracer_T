import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './api.dart';
import '../repositories/endpoint_data.dart';

//Make Requests & Parse Resposne
class APIService {
  final API api;

  APIService(this.api);

  //TOKEN
  Future<String> getAccessToken() async {
    //make request
    final response = await http.post(
      api.tokenUri().toString(),
      headers: {
        'Authorization': 'Basic ${api.apiKey}',
      },
    );

    //successful
    if (response.statusCode == 200) {
      //parse response
      final data = json.decode(response.body);
      //get info
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    //Something went Wrong
    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    //Will be handle at Presentation(UI) layer
    throw response;
  }

  //PAYLOAD
  Future<EndpointData> getEndpointData(
      {@required String accessToken, @required Endpoint endPoint}) async {
    final uri = api.endpointUri(endPoint);
    //make request
    final response = await http.post(uri.toString(), headers: {
      'Authorization': 'Bearer ${api.apiKey}',
    });

    //successful
    if (response.statusCode == 200) {
      //parse response
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endPointData = data[0];
        final String responseJsonInfoKey = _responseJsonKeysForInfo[endPoint];
        final int numbers = endPointData[responseJsonInfoKey];
        final date = DateTime.tryParse(endPointData['date']);
        if (numbers != null) {
          return EndpointData(
            numbers: numbers,
            date: date,
          );
        }
      }
    }
    //Something went Wrong
    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    //Will be handle at Presentation(UI) layer
    throw response;
  }

  //Map(helper) to get 'key name' for information from payload data
  static Map<Endpoint, String> _responseJsonKeysForInfo = {
    Endpoint.cases: 'cases',
    Endpoint.casesConfirmed: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.casesSuspected: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
