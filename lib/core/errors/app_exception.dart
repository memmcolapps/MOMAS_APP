enum ErrorType { network, auth, business, parse, unknown }

class AppException implements Exception {
  final String message;
  final String? debugMessage;
  final ErrorType type;
  final int? statusCode;

  const AppException({
    required this.message,
    required this.type,
    this.debugMessage,
    this.statusCode,
  });

  factory AppException.fromResponse({
    required int statusCode,
    required dynamic body,
  }) {
    if (statusCode == 401) {
      return AppException(
        message: 'Your session has expired. Please log in again.',
        type: ErrorType.auth,
        statusCode: statusCode,
      );
    }

    String? backendMsg;
    if (statusCode >= 400 && statusCode < 500) {
      backendMsg = _extractMessage(body);
    }

    return AppException(
      message: backendMsg ?? 'Something went wrong. Please try again.',
      type: statusCode >= 400 && statusCode < 500
          ? ErrorType.business
          : ErrorType.network,
      statusCode: statusCode,
      debugMessage: body.toString(),
    );
  }

  factory AppException.network() => const AppException(
    message: 'No internet connection. Please check your network.',
    type: ErrorType.network,
  );

  factory AppException.parse(Object error) => AppException(
    message: 'Something went wrong. Please try again.',
    type: ErrorType.parse,
    debugMessage: error.toString(),
  );

  factory AppException.unknown(Object error) => AppException(
    message: 'Something went wrong. Please try again.',
    type: ErrorType.unknown,
    debugMessage: error.toString(),
  );

  static String? _extractMessage(dynamic body) {
    try {
      if (body is Map) {
        return body['message'] as String? ??
            body['error'] as String? ??
            body['msg'] as String?;
      }
    } catch (_) {}
    return null;
  }
}