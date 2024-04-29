// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';

// String uri = "192.168.10.17";
// String uri = "https://mowingandplowing.com";

// String uri = "https://mowing-plowing.mangoitsol.com";
// String uri1 = "mowingandplowing.com";
String uri1 = "staging.mowingandplowing.com";
String uri = "https://staging.mowingandplowing.com";

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}

/*Had to use localhost (10.0.3.2 for Genymotion, 10.0.2.2 for official emulator) 
  because websocket port 6001 cannot be setup on expose or ngrok. 
*/
Echo echoSetup(token, pusherClient) {
  return Echo({
    'broadcaster': 'pusher',
    'client': pusherClient,
    "wsHost": uri1,
    "wssHost": uri1,
    "wsPort": 6001,
    "wssPort": 6001,
    'auth': {
      "headers": {'Authorization': 'Bearer $token'}
    },
    // 'authEndpoint': '192.168.10.17/broadcasting/auth',
    'authEndpoint': '$uri/api/broadcasting/auth',
    "disableStats": true,
    "forceTLS": false,
    "enabledTransports": ['ws', 'wss'],
  });
}

FlutterPusher getPusherClient(String token) {
  PusherOptions options = PusherOptions(
      encrypted: true,
      // host: '192.168.10.17',
      host: uri1,
      cluster: 'mt1',
      port: 6001,
      // auth: PusherAuth('192.168.10.17/broadcasting/auth',
      auth: PusherAuth('$uri/api/broadcasting/auth',
          headers: {'Authorization': 'Bearer $token'}));
  return FlutterPusher(
    '34jkb5jk3b6k53hj34534kj5sbdf8sd6ifs6d',
    options,
    enableLogging: true,
    lazyConnect: true,
  );
}

void onConnectionStateChange(ConnectionStateChange event) {
  print(event.currentState);
  if (event.currentState == 'CONNECTED') {
    print('CONNECTED');
  } else if (event.currentState == 'DISCONNECTED') {
    print('DISCONNECTED');
  }
}
