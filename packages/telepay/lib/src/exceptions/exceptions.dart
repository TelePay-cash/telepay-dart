/// {@template telepay_excepction}
/// The exception is thrown when an unauthorized request is made.
///
/// {@endtemplate}
class TelePayException implements Exception {
  /// {@macro telepay_excepction}s
  const TelePayException(this.message);

  /// The message of the exception.
  final String message;

  @override
  String toString() => 'TelePayException(message: $message)';
}

/// {@template unauthorized_excepction}
/// The exception is thrown when an unauthorized request is made.
///
/// Response from the server:
/// ```json
/// {
///   "deatil": "Invalid secret key",
/// }
/// ```
/// {@endtemplate}
class UnauthorizedException extends TelePayException {
  /// {@macro unauthorized_excepction}
  const UnauthorizedException(String message) : super(message);

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

/// {@template not_found_exception}
/// The exception is thrown when the object is not found.
///
/// Response form the server:
/// ```json
/// {
///   "error": "not-found",
///   "message": "Invoice with number invoice_number does not exist"
/// }
/// ```
/// {@endtemplate}
class NotFoundException extends TelePayException {
  /// {@macro not_found_exception}
  const NotFoundException(String message) : super(message);

  @override
  String toString() => 'NotFoundException(message: $message)';
}

/// {@template insufficient_funds_error}
/// The exception is thrown when is insufficientt fonds.
///
/// Response form the server:
/// ```json
/// {
///   "error": "insufficient-funds",
///   "message": "Insufficient funds to transfer"
/// }
/// ```
/// {@endtemplate}
class InsufficienttFondsException extends TelePayException {
  /// {@macro insufficient_funds_error}
  const InsufficienttFondsException(String message) : super(message);

  @override
  String toString() => 'InsufficienttFondsException(message: $message)';
}
