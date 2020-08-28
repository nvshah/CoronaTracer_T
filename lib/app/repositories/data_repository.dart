import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../services/api_service.dart';
import '../services/api.dart';
import '../repositories/endpoints_data.dart';

//Keep track of updated access-token & give behaviours to call endpoints from UI
//Interface between Api Service & UI
class DataRepository{
  final APIService apiService;
  String _accessToken;

  DataRepository({@required this.apiService});

  Future<int> getEndpointData(Endpoint endpoint) async {
    try{
      //requesting access token for first time
      if(_accessToken == null){
        _accessToken = await apiService.getAccessToken();
      }
      return await apiService.getEndpointData(endPoint: endpoint, accessToken: _accessToken);
      
    } on Response catch(response){
      //if unauthorized, get access token again
      if(response.statusCode == 401){
        _accessToken = await apiService.getAccessToken();
        return await apiService.getEndpointData(endPoint: endpoint, accessToken: _accessToken);
      }
      //Some other error so give this to caller side
      rethrow;
    }
  }

  Future<EndpointsData> getAllEndPointData() async {
    // final cases = await apiService.getEndpointData(endPoint: Endpoint.cases, accessToken: _accessToken);
    // final casesSuspected = await apiService.getEndpointData(endPoint: Endpoint.casesSuspected, accessToken: _accessToken);
    // final casesConfirmed = await apiService.getEndpointData(endPoint: Endpoint.casesConfirmed, accessToken: _accessToken);
    // final deaths = await apiService.getEndpointData(endPoint: Endpoint.casesConfirmed, accessToken: _accessToken);
    // final recoverd = await apiService.getEndpointData(endPoint: Endpoint.recovered, accessToken: _accessToken);
    
    //All requests are independent of each other & will get exceuted concurrently. Once all request gets completed It will return result
    final values = await Future.wait([
      apiService.getEndpointData(endPoint: Endpoint.cases, accessToken: _accessToken),
      apiService.getEndpointData(endPoint: Endpoint.casesSuspected, accessToken: _accessToken),
      apiService.getEndpointData(endPoint: Endpoint.casesConfirmed, accessToken: _accessToken),
      apiService.getEndpointData(endPoint: Endpoint.deaths, accessToken: _accessToken),
      apiService.getEndpointData(endPoint: Endpoint.recovered, accessToken: _accessToken),
    ]);

    //create data model object to store those values so that we can use it further to show on dashboard screen
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4], 
    });
  }
}