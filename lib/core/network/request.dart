import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/core/errors/app_exception.dart';
import 'package:momaspayplus/main.dart';

import '../storage/shared_pref.dart';

const _kTimeout = Duration(seconds: 30);

Future<Map<String, String>> getHeader() async {
  final token = await SharedPreferenceHelper.getToken() ?? '';
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'Access-Point': 'mobile',
  };
}

class ServerRequest {
  // ─── Core wrapper ────────────────────────────────────────────────────────────

  Future<T> _safeCall<T>(Future<http.Response> Function() call,
      T Function(dynamic body) onSuccess, String debugLabel,
      {String? requestBody}) async {
    http.Response? response;
    try {
      if (requestBody != null) {
        log('$debugLabel ← $requestBody', name: 'HTTP');
      } else {
        log(debugLabel, name: 'HTTP');
      }
      response = await call().timeout(_kTimeout);

      final body = _decode(response.body, debugLabel);

      log('$debugLabel ${response.statusCode} → $body', name: 'HTTP');

      if (response.statusCode == 401) {
        getIt<AuthCubit>().sessionExpired();
        throw const AppException(
          message: 'Your session has expired. Please log in again.',
          type: ErrorType.auth,
        );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return onSuccess(body);
        } catch (e) {
          log('$debugLabel PARSE ERROR: $e', name: 'HTTP');
          throw AppException.parse(e);
        }
      }
      // final backendMsg =
      //     response.statusCode < 500 ? _extractMessage(body) : null;

      // throw AppException(
      //   message: backendMsg ?? 'Something went wrong. Please try again.',
      //   type:
      //       response.statusCode < 500 ? ErrorType.business : ErrorType.network,
      //   statusCode: response.statusCode,
      //   debugMessage: body.toString(),
      // );

      String? backendMsg = _extractMessage(body);
      String? backendDetails = _extractDetails(body);

      throw AppException(
        message: backendDetails?.isNotEmpty == true
            ? backendDetails!
            : (backendMsg?.isNotEmpty == true
            ? backendMsg!
            : 'Something went wrong. Please try again.'),
        type: response.statusCode < 500
            ? ErrorType.business
            : ErrorType.network,
        statusCode: response.statusCode,
        debugMessage: body.toString(),
      );
    } on AppException {
      rethrow;
    } on SocketException {
      throw AppException.network();
    } on TimeoutException {
      throw const AppException(
        message: 'Request timed out. Please try again.',
        type: ErrorType.network,
      );
    } on HandshakeException {
      throw const AppException(
        message: 'Secure connection failed. Please try again.',
        type: ErrorType.network,
      );
    } on FormatException catch (e) {
      log('$debugLabel FORMAT ERROR: $e', name: 'HTTP');
      throw AppException.parse(e);
    } catch (e) {
      log('$debugLabel ERROR: $e', name: 'HTTP');
      throw AppException.unknown(e);
    }
  }

  String? _extractDetails(dynamic body) {
    if (body is Map<String, dynamic>) {
      final details = body['details'];
      if (details is String && details.trim().isNotEmpty) {
        return details;
      }
    }
    return null;
  }

  // ─── Public methods ───────────────────────────────────────────────────────

  Future<HttpResponse> getData({
    String? path,
    Map<String, String>? dataToSend,
  }) async {
    final header = await getHeader();
    final url = Uri.parse(path!).replace(queryParameters: dataToSend);

    return _safeCall(
      () => http.get(url, headers: header),
      (body) => HttpData(body),
      'GET $path',
    );
  }

  Future<HttpResponse> postData(
      {String? path, Map? body, List<Map>? bodyII}) async {
    final header = await getHeader();
    final url = Uri.parse(path!);
    final encoded = json.encode(body ?? bodyII);

    return _safeCall(
      () => http.post(url, body: encoded, headers: header),
      (data) => HttpData(data),
      'POST $path',
      requestBody: encoded,
    );
  }

  Future<HttpResponse> postHesData(
      {String? path, Map? body, List<Map>? bodyII, required Map<String, String> headers}) async {
    // final header = await getHeader();
    final url = Uri.parse(path!);
    final encoded = json.encode(body ?? bodyII);

    return _safeCall(
          () => http.post(url, body: encoded, headers: headers),
          (data) => HttpData(data),
      'POST $path',
      requestBody: encoded,
    );
  }

  Future<dynamic> postSetTokenData({
    required String path,
    Map<String, String>? queryParams,
    Map? body,
    List<Map>? bodyII, required Map<String, String> header,
  }) async {

    // final header = await getHesHeader();

    final uri = Uri.parse(path).replace(
      queryParameters: queryParams,
    );

    final encoded = body == null && bodyII == null
        ? null
        : jsonEncode(body ?? bodyII);

    return _safeCall(
          () => http.post(
        uri,
        headers: header,
        body: encoded,
      ),
          (data) => HttpData(data),
      'POST $uri',
      requestBody: encoded,
    );
  }

  Future<HttpResponse> getHesData({
    required String path,
    Map<String, String>? queryParams,
    Map? body,
    List<Map>? bodyII, required Map<String, String> header,
  }) async {

    // final header = await getHesHeader();

    final uri = Uri.parse(path).replace(
      queryParameters: queryParams,
    );

    final encoded = body == null && bodyII == null
        ? null
        : jsonEncode(body ?? bodyII);

    return _safeCall(
          () => http.get(
        uri,
        headers: header,
        // body: encoded,
      ),
          (data) => HttpData(data),
      'GET $uri',
      requestBody: encoded,
    );
  }

  // Future<dynamic> postSetTokenData({
  //   required String path, Map? body, List<Map>? bodyII}) async {
  //   final header = await getHeader();
  //   final url = Uri.parse(path!);
  //   final encoded = json.encode(body ?? bodyII);
  //
  //   return _safeCall(
  //         () => http.post(url, body: encoded, headers: header),
  //         (data) => HttpData(data),
  //     'POST $path',
  //     requestBody: encoded,
  //   );
  // }

  Future<HttpResponse> putData(
      {String? path, Map? body, List<Map>? bodyII}) async {
    final header = await getHeader();
    final url = Uri.parse(path!);
    final encoded = json.encode(body ?? bodyII);

    return _safeCall(
      () => http.put(url, body: encoded, headers: header),
      (data) => HttpData(data),
      'PUT $path',
      requestBody: encoded,
    );
  }

  Future<HttpResponse> deleteData({String? path}) async {
    final header = await getHeader();
    final url = Uri.parse(path!);

    return _safeCall(
      () => http.delete(url, headers: header),
      (data) => HttpData(data),
      'DELETE $path',
    );
  }

  Future<HttpResponse> uploadFile({
    String? path,
    Map? body,
    List<FileKeyValue>? fileKeyValue,
  }) async {
    final header = await getHeader();
    final uri = Uri.parse(path!);
    final request = http.MultipartRequest('POST', uri)..headers.addAll(header);

    body?.forEach((k, v) => request.fields['$k'] = v.toString());

    if (fileKeyValue != null) {
      for (final fkv in fileKeyValue) {
        request.files.add(
          await http.MultipartFile.fromPath(fkv.key!, fkv.file!.path),
        );
      }
    }

    log('UPLOAD $path ← fields: ${request.fields}', name: 'HTTP');
    try {
      final streamed = await request.send().timeout(_kTimeout);
      final response = await http.Response.fromStream(streamed);

      if (streamed.statusCode == 401) {
        getIt<AuthCubit>().sessionExpired();
        throw const AppException(
          message: 'Your session has expired. Please log in again.',
          type: ErrorType.auth,
        );
      }

      final data = _decode(response.body, 'UPLOAD $path');
      log('UPLOAD $path ${streamed.statusCode} → $data', name: 'HTTP');

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return HttpData(data);
      }

      final msg = streamed.statusCode < 500 ? _extractMessage(data) : null;
      throw AppException(
        message: msg ?? 'Upload failed. Please try again.',
        type:
            streamed.statusCode < 500 ? ErrorType.business : ErrorType.network,
        statusCode: streamed.statusCode,
      );
    } on AppException {
      rethrow;
    } on SocketException {
      throw AppException.network();
    } on TimeoutException {
      throw const AppException(
        message: 'Upload timed out. Please try again.',
        type: ErrorType.network,
      );
    } catch (e) {
      log('UPLOAD $path ERROR: $e', name: 'HTTP');
      throw AppException.unknown(e);
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  dynamic _decode(String body, String label) {
    try {
      return jsonDecode(body);
    } catch (e) {
      log('[DECODE ERROR] $label → $e  raw: $body');
      throw FormatException('Invalid JSON from $label');
    }
  }

  String? _extractMessage(dynamic body) {
    if (body is Map) {
      return body['message'] as String? ??
          body['error'] as String? ??
          body['msg'] as String?;
    }
    return null;
  }
}

abstract class HttpResponse {
  dynamic data;
}

class HttpData extends HttpResponse {
  final dynamic data;
  HttpData(this.data);
}

class FileKeyValue {
  final String? key;
  final File? file;
  FileKeyValue(this.key, this.file);
}
