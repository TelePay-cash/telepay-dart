import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:telepay/telepay.dart';

/// Http [Client] extensions for telepay
extension BaseClientX on Client {
  /// Get telepay [Uri] from an url
  Uri _getUri(String url) => Uri.parse('${TelePay.baseUrl}$url');

  // ignore: public_member_api_docs
  Future<TelepayResponse> telepayGet(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _getUri(url);

      // TODO(luisciber): check and remove this log
      log(uri.toString());

      final response = await get(
        uri,
        headers: headers,
      );

      // TODO(luisciber): check and remove this log
      final res = TelepayResponse.from(response);
      log(res.toString());
      return res;
    } catch (e) {
      // TODO(luisciber): check and remove this log
      log(e.toString());
      rethrow;
    }
  }

  // ignore: public_member_api_docs
  Future<TelepayResponse> telepayPost(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _getUri(url);

      final response = await post(
        uri,
        headers: headers,
        body: body,
      );

      return TelepayResponse.from(response);
    } catch (e) {
      // TODO(luisciber): check and remove this log
      log(e.toString());
      rethrow;
    }
  }
}

/// [TelepayResponse] is an extension to [Response]
class TelepayResponse extends Response with EquatableMixin {
  /// [TelepayResponse] is an extension to [Response]
  /// use this constructor for testing purposes only
  TelepayResponse({
    required int statusCode,
    Map<String, dynamic>? data,
  })  : _data = data,
        super('', statusCode);

  /// [TelepayResponse] is an extension to [Response]
  TelepayResponse.bytes(List<int> bodyBytes, int statusCode)
      : super.bytes(bodyBytes, statusCode) {
    try {
      _data = json.decode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      // TODO(luisciber): check and remove this log
      log(e.toString());
    }
  }

  /// Build [TelepayResponse] from [Response]
  factory TelepayResponse.from(Response response) => TelepayResponse.bytes(
        response.bodyBytes,
        response.statusCode,
      );

  /// [body] in json format
  Map<String, dynamic>? get data => _data;

  Map<String, dynamic>? _data;

  @override
  List<Object?> get props => [
        statusCode,
        body,
        data,
      ];
}
