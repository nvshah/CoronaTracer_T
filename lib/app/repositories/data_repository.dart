import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../services/api_service.dart';
import '../services/api.dart';
import '../repositories/endpoints_data.dart';
import './endpoint_data.dart';
import '../services/data_cache_service.dart';

//Keep track of updated access-token & give behaviours to call endpoints from UI
//Interface between Api Service & UI
class DataRepository {
  final APIService apiService;
  final DataCacheService dataCacheService;
  
  String _accessToken;

  DataRepository({
    @required this.apiService,
    @required this.dataCacheService,
  });

  /// general methods that make initial setup to enure access token & proceed ahead to make api requests
  /// i/p -> handler for api service call ( interact with apiservice )
  //Generics + Function arg, makes code reusable
  // Future<T> _getDataRefreshingToken<T>({Future<T> Function() getDataHandler}) async {
  Future<T> _getDataRefreshingToken<T>({Function getDataHandler}) async {
    try {
      //requesting access token for first time
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await getDataHandler();
    } on Response catch (response) {
      //if unauthorized, get access token again
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await getDataHandler();
      }
      //Some other error so give this to caller side
      rethrow;
    }
  }

  /// get the endpoint data for given endpoint
  /// i/p -> endpoint,
  /// o/p -> endpoint_data
  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
        getDataHandler: () => apiService.getEndpointData(
          endPoint: endpoint,
          accessToken: _accessToken,
        ),
      );

  /// get the endpoint data for all the endpoints at once
  /// o/p ->  endpoint data mapping
  Future<EndpointsData> getAllEndpointData() async {
      final endpointsData = await _getDataRefreshingToken<EndpointsData>(
        getDataHandler: _getAllEndPointData,
      );

      //save data to cache
      // once we have data from remote, we do update our cache apparently
      await dataCacheService.saveData(endpointsData);

      return endpointsData;
  }
  
  ///get cached data (for offline mode)
  ///For First time it will return empty map, since we haven't cached any endpoint data before
  EndpointsData getAllEndPointCachedData() => dataCacheService.getData();

  Future<EndpointsData> _getAllEndPointData() async {
    // final cases = await apiService.getEndpointData(endPoint: Endpoint.cases, accessToken: _accessToken);
    // final casesSuspected = await apiService.getEndpointData(endPoint: Endpoint.casesSuspected, accessToken: _accessToken);
    // final casesConfirmed = await apiService.getEndpointData(endPoint: Endpoint.casesConfirmed, accessToken: _accessToken);
    // final deaths = await apiService.getEndpointData(endPoint: Endpoint.casesConfirmed, accessToken: _accessToken);
    // final recoverd = await apiService.getEndpointData(endPoint: Endpoint.recovered, accessToken: _accessToken);

    //All requests are independent of each other & will get exceuted concurrently. Once all request gets completed It will return result
    final endPointData = await Future.wait([
      apiService.getEndpointData(
          endPoint: Endpoint.cases, accessToken: _accessToken),
      apiService.getEndpointData(
          endPoint: Endpoint.casesSuspected, accessToken: _accessToken),
      apiService.getEndpointData(
          endPoint: Endpoint.casesConfirmed, accessToken: _accessToken),
      apiService.getEndpointData(
          endPoint: Endpoint.deaths, accessToken: _accessToken),
      apiService.getEndpointData(
          endPoint: Endpoint.recovered, accessToken: _accessToken),
    ]);

    //create data model object to store those values so that we can use it further to show on dashboard screen
    return EndpointsData(
      values: {
        Endpoint.cases: endPointData[0],
        Endpoint.casesSuspected: endPointData[1],
        Endpoint.casesConfirmed: endPointData[2],
        Endpoint.deaths: endPointData[3],
        Endpoint.recovered: endPointData[4],
      },
    );
  }
}
