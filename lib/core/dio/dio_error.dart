import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handleError(DioException error) {
    String errorDescription = "An error occurred";

    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = "Request was cancelled";
        break;

      case DioExceptionType.connectionTimeout:
        errorDescription =
            "Connection timeout - please check your internet connection";
        break;

      case DioExceptionType.sendTimeout:
        errorDescription = "Send timeout - request took too long to send";
        break;

      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout - server took too long to respond";
        break;

      case DioExceptionType.badResponse:
        errorDescription = _handleStatusCode(error.response?.statusCode);
        break;

      case DioExceptionType.badCertificate:
        errorDescription =
            "Certificate verification failed - connection not secure";
        break;

      case DioExceptionType.connectionError:
        errorDescription = "No internet connection - please check your network";
        break;

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          errorDescription = "No internet connection";
        } else {
          errorDescription = "Unexpected error occurred: ${error.message}";
        }
        break;
    }

    return errorDescription;
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request - invalid data sent";
      case 401:
        return "Unauthorized - please login again";
      case 403:
        return "Forbidden - you don't have permission";
      case 404:
        return "Not found - the resource doesn't exist";
      case 408:
        return "Request timeout - please try again";
      case 429:
        return "Too many requests - please wait and try again";
      case 500:
        return "Internal server error - please try again later";
      case 502:
        return "Bad gateway - server is temporarily unavailable";
      case 503:
        return "Service unavailable - please try again later";
      case 504:
        return "Gateway timeout - server took too long to respond";
      default:
        return "Received error status code: $statusCode";
    }
  }

  static String getErrorMessage(DioException error, {String? customMessage}) {
    if (customMessage != null) return customMessage;
    return handleError(error);
  }
}
