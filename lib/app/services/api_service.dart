import 'package:http/http.dart' as http;

import 'package:coronatracker/app/services/api.dart';

class APIService {
  final API api;

  APIService(this.api);

  Future<String> getAccessToken() async {
    final response = await http.post(
      api.tokenUri().toString(),
      headers: {
        'Authorization': 'Basic ${api.apiKey}',
      },
    );
  }
}
