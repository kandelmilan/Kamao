import 'package:dio/dio.dart';

import 'base_api.dart';

/// Concrete implementation of BaseApi using Dio.
///
/// All HTTP requests in the application go through this service.
class ApiService implements BaseApi {
  ApiService(this._dio);

  final Dio _dio;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> uploadFile(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) {
    return _dio.post(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    return _dio.download(
      path,
      savePath,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }
}

// import 'package:dio/dio.dart';

// import 'base_api.dart';

// /// Concrete implementation of BaseApi using Dio.
// ///
// /// All HTTP requests in the application go through this service.
// class ApiService implements BaseApi {
//   ApiService(this._dio);

//   final Dio _dio;

//   /// Guards against a global default (e.g. a BaseOptions header or an
//   /// interceptor — often the same one that injects Authorization) hard-coding
//   /// `Content-Type: application/json` on every request. That's fine for JSON
//   /// bodies, but when [data] is [FormData] it overrides Dio's automatic
//   /// `multipart/form-data; boundary=...` header and the server rejects the
//   /// request with 415 Unsupported Media Type.
//   ///
//   /// Whenever the body is FormData, this strips any hard-coded JSON content
//   /// type from the outgoing request so Dio can set the correct multipart
//   /// header itself — regardless of where the stale header originated.
//   Options _resolveOptions(dynamic data, Options? options) {
//     if (data is! FormData) return options ?? Options();

//     final headers = <String, dynamic>{...?options?.headers};
//     headers.removeWhere((key, _) => key.toLowerCase() == 'content-type');

//     return (options ?? Options()).copyWith(
//       headers: headers,
//       contentType: null, // let Dio auto-set multipart/form-data; boundary=...
//     );
//   }

//   @override
//   Future<Response<dynamic>> get(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.get(
//       path,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//   }

//   @override
//   Future<Response<dynamic>> post(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.post(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: _resolveOptions(data, options),
//       cancelToken: cancelToken,
//     );
//   }

//   @override
//   Future<Response<dynamic>> put(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.put(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: _resolveOptions(data, options),
//       cancelToken: cancelToken,
//     );
//   }

//   @override
//   Future<Response<dynamic>> patch(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.patch(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: _resolveOptions(data, options),
//       cancelToken: cancelToken,
//     );
//   }

//   @override
//   Future<Response<dynamic>> delete(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.delete(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//   }

//   @override
//   Future<Response<dynamic>> uploadFile(
//     String path, {
//     required FormData formData,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     ProgressCallback? onSendProgress,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.post(
//       path,
//       data: formData,
//       queryParameters: queryParameters,
//       options: _resolveOptions(formData, options),
//       onSendProgress: onSendProgress,
//       cancelToken: cancelToken,
//     );
//   }

//   @override
//   Future<Response<dynamic>> downloadFile(
//     String path,
//     String savePath, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     ProgressCallback? onReceiveProgress,
//     CancelToken? cancelToken,
//   }) {
//     return _dio.download(
//       path,
//       savePath,
//       queryParameters: queryParameters,
//       options: options,
//       onReceiveProgress: onReceiveProgress,
//       cancelToken: cancelToken,
//     );
//   }
// }
