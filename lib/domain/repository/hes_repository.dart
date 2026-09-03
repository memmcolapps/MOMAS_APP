import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:momaspayplus/domain/data/request/hes_client_request.dart';
import 'package:momaspayplus/domain/data/request/set_token_request.dart';
import 'package:momaspayplus/domain/data/response/hes_connection_response.dart';
import 'package:momaspayplus/domain/data/response/hes_token_response.dart';
import 'package:momaspayplus/domain/data/response/set_token_response.dart';

import '../../core/network/request.dart';
import '../../core/network/routes.dart';
import '../../core/storage/shared_pref.dart';


class HesRepository {
  final ServerRequest _request = ServerRequest();

  static const _clientId =
      "123e4567-e89b-12d3-a456-426614174000";

  static const _clientSecret =
      "5D8F2A3B4C5D6E7F8A9B0C1D2E3F4A5B6C7D8E9F0A1B2C3D4E5F6A7B8C9D0E1";

  /// Returns a valid HES token.
  Future<String> _getValidToken() async {
    final token = await SharedPreferenceHelper.getHesToken();
    final created = await SharedPreferenceHelper.getTokenCreatedTime();
    final expiresIn = await SharedPreferenceHelper.getTokenExpiresIn();

    if (token == null || token.isEmpty) {
      return _generateToken();
    }

    final expiry =
        created + (expiresIn * 1000);

    const refreshBuffer = Duration(seconds: 60);

    final shouldRefresh =
        DateTime.now().millisecondsSinceEpoch >=
            expiry - refreshBuffer.inMilliseconds;

    return shouldRefresh ? _generateToken() : token;
  }

  /// Generates and stores a new token.
  Future<String> _generateToken() async {
    final response = await _request.postHesData(
      path: Routes.generateHesToken,
      body: HesClientRequest(
        clientId: _clientId,
        clientSecret: _clientSecret,
      ).toJson(),
      headers: const {
        "Content-Type": "application/json",
      },
    );

    final tokenResponse =
    HesTokenResponse.fromJson(response.data);

    await SharedPreferenceHelper.saveHesToken(
      tokenResponse.accessToken,
    );

    await SharedPreferenceHelper.saveTokenCreatedTime(
      DateTime.now().millisecondsSinceEpoch,
    );

    await SharedPreferenceHelper.saveTokenExpiresIn(
      tokenResponse.expiresIn,
    );

    return tokenResponse.accessToken;
  }

  /// Authorization header used by every HES request.
  Future<Map<String, String>> _authHeader() async {
    final token = await _getValidToken();

    return {
      "Authorization": "Bearer $token",
    };
  }

  Future<SetTokenResponse> hesLoadToken(
      SetTokenRequest request) async {
    final response = await _request.postSetTokenData(
      path: Routes.loadToken,
      queryParams: {
        "serial": request.serial,
        "token": request.token,
      },
      header: await _authHeader(),
    );
    print("load response: "+response.data.toString());
    // debugPrint(jsonEncode(response));
    return SetTokenResponse.fromJson(response.data);
  }

  Future<HesConnectionResponse> hesMeterStatus(
      HesConnectionRequest request) async {
    final response = await _request.getHesData(
      path: Routes.hesConnection,
      queryParams: {
        "serial": request.serial,
      },
      header: await _authHeader(),
    );

    print("response: "+response.data.toString());
    return HesConnectionResponse.fromJson(response.data);
  }
}

// class HesRepository {
//   final ServerRequest _request = ServerRequest();
//
//   Future<String> _getValidToken() async {
//     final savedToken = await SharedPreferenceHelper.getHesToken();
//     final created = await SharedPreferenceHelper.getTokenCreatedTime();
//     final expiresIn = await SharedPreferenceHelper.getTokenExpiresIn();
//
//     if (savedToken == null || savedToken.isEmpty) {
//       return await _generateToken();
//     }
//
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final expiry = created + (expiresIn * 1000);
//     const refreshBuffer = 60; // seconds
//
//     if (now >= expiry - (refreshBuffer * 1000)) {
//       return await _generateToken();
//     }
//
//     return savedToken;
//   }
//
//   Future<String> _generateToken() async {
//    // const clientId: "123e4567-e89b-12d3-a456-426614174000";
//    // const clientSecret: "5D8F2A3B4C5D6E7F8A9B0C1D2E3F4A5B6C7D8E9F0A1B2C3D4E5F6A7B8C9D0E1";
//
//     final response = await _request.postHesData(
//       path: Routes.generateHesToken,
//       body: HesClientRequest(
//         clientId: "123e4567-e89b-12d3-a456-426614174000",
//         clientSecret: "5D8F2A3B4C5D6E7F8A9B0C1D2E3F4A5B6C7D8E9F0A1B2C3D4E5F6A7B8C9D0E1",
//       ).toJson(),
//       headers: {
//         "Content-Type": "application/json",
//       },
//     );
//
//     final tokenResponse = HesTokenResponse.fromJson(response.data);
//
//     final token = tokenResponse.accessToken;
//
//     await SharedPreferenceHelper.saveHesToken(token);
//     await SharedPreferenceHelper.saveTokenCreatedTime(DateTime.now().millisecondsSinceEpoch);
//     await SharedPreferenceHelper.saveTokenExpiresIn(tokenResponse.expiresIn);
//
//     print("token: "+token);
//
//     return token;
//   }
//
//   Future<SetTokenResponse> hesLoadToken(
//       SetTokenRequest request) async {
//     final token = await _getValidToken();
//
//     final response = await _request.postSetTokenData(
//       path: Routes.loadToken,
//       queryParams: {
//         "serial": request.serial,
//         "token": request.token,
//       },
//       header: {
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     return SetTokenResponse.fromJson(response.data);
//   }
//
//   Future<HesConnectionResponse> hesMeterStatus(
//       HesConnectionRequest request) async {
//
//     final response = await _request.postSetTokenData(
//       path: Routes.hesConnection,
//       queryParams: {
//         "serial": request.serial,
//       },
//       header: {
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     return HesConnectionResponse.fromJson(response.data);
//   }
// }
