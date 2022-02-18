import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:reviseme/errors/http.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  final String baseUrl;
  final _logger = Logger('HttpClient');
  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=utf-8',
  };

  late Uri _uri;

  HttpClient({
    required this.baseUrl,
  }) {
    _uri = Uri.parse(baseUrl);
  }

  void setAuthorizationToken(String token) {
    _headers['Authorization'] = 'Token $token';
  }

  void removeAuthorizationToken() {
    _headers.remove('Authorization');
  }

  bool _hasError(http.Response response) {
    if (response.statusCode >= 400) {
      return true;
    }
    return false;
  }

  http.Response _checkRespose(http.Response response) {
    if (!_hasError(response)) {
      return response;
    }

    switch (response.statusCode) {
      case 400:
        _logger.severe('Bad request ${response.body}');
        throw BadRequestError(response);
      case 401:
        _logger.severe('Unauthorized ${response.body}');
        throw UnauthorizedError(response);
      case 403:
        _logger.severe('Forbidden ${response.body}');
        throw ForbiddenError(response);
      case 404:
        _logger.severe('Not found ${response.body}');
        throw NotFoundError(response);
      case 500:
        _logger.severe('Internal server error ${response.body}');
        throw InternalServerError(response);
      default:
        throw HttpError(response.statusCode, response);
    }
  }

  Map<String, String> _getHeaders(Map<String, String>? extraHeaders) {
    final headers = Map<String, String>.from(_headers);
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  Uri _encodeUrl(String path, Map<String, dynamic>? params) {
    final url = _uri.resolve(path);

    if (params == null) {
      return url;
    }

    return url.replace(queryParameters: params);
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final response = await http.get(
      _encodeUrl(path, params),
      headers: _getHeaders(headers),
    );
    return _checkRespose(response);
  }

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      _encodeUrl(path, params),
      body: json.encode(body),
      headers: _getHeaders(headers),
    );
    return _checkRespose(response);
  }

  Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final response = await http.put(
      _encodeUrl(path, params),
      body: json.encode(body),
      headers: _getHeaders(headers),
    );
    return _checkRespose(response);
  }

  Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final response = await http.delete(
      _encodeUrl(path, params),
      headers: _getHeaders(headers),
    );
    return _checkRespose(response);
  }
}
