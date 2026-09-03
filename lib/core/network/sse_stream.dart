import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/data/model/meter_stream_event_data.dart';

class MeterStatusSseService {

  final String url;
  final String token;

  MeterStatusSseService({
    required this.url,
    required this.token,
  });

  http.Client? _client;

  Stream<MeterStreamEventModel> connect() async* {

    _client = http.Client();

    final request = http.Request(
      'GET',
      Uri.parse(url),
    );

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
    });

    final response = await _client!.send(request);

    if (response.statusCode != 200) {
      throw Exception("Unable to connect");
    }

    String data = "";

    await for (final chunk in response.stream.transform(utf8.decoder)) {

      final lines = chunk.split("\n");

      for (final line in lines) {

        if (line.startsWith("data:")) {

          data += line.substring(5).trim();

        } else if (line.trim().isEmpty) {

          if (data.isNotEmpty) {

            final json = jsonDecode(data);

            yield MeterStreamEventModel.fromJson(json);

            data = "";
          }
        }
      }
    }
  }

  void dispose() {
    _client?.close();
  }
}