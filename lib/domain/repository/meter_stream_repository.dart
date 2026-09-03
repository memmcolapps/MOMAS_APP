

import '../../core/network/sse_stream.dart';
import '../data/model/meter_stream_event_data.dart';

class MeterRepository {

  final MeterStatusSseService service;

  MeterRepository(this.service);

  Stream<MeterStreamEventModel> streamMeters() {
    return service.connect();
  }

  void dispose() {
    service.dispose();
  }
}