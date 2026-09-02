/// Generic API response wrapper.
///
/// Example:
/// {
///   "success": true,
///   "message": "Login successful",
///   "data": { ... },
///   "correlationId": "xxxx"
///   "statusCode": 200 // for easy use as server doesnot send it in the json
///
/// }
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  required this.statusCode,
    this.correlationId,
  });

  final bool success;

  final String message;

  final T? data;

  // Keep this because your Flutter layer already uses it
  final int statusCode;

  // Add this because backend sends it
  final String? correlationId;
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final parsed = fromJsonT != null ? fromJsonT(json["data"]) : null;

    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: parsed,
      statusCode: json['statusCode'] as int? ?? 200,
      correlationId: json['correlationId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,

      'message': message,

      'data': data,

      'statusCode': statusCode,

      'correlationId': correlationId,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode, correlationId: $correlationId, data: $data)';
  }
}
