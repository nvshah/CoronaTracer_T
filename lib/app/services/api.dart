import 'package:flutter/foundation.dart';

import './api_keys.dart';

//List all endpoints
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
}
