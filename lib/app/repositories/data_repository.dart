import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../services/api_service.dart';
import '../services/api.dart';

class DataRepository{
  final APIService apiService;
  String _accessToken;

  DataRepository({@required this.apiService});

  Future<int> getEndpointData(Endpoint endpoint) async {
    try{
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
      //give this to caller side
      rethrow;
    }
  }
}