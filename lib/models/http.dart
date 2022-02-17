import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class HttpError extends Error {
  final int code;
  final http.Response response;

  HttpError(this.code, this.response);
}

class BadRequestError extends HttpError {
  BadRequestError(http.Response response) : super(400, response);
}

class UnauthorizedError extends HttpError {
  UnauthorizedError(http.Response response) : super(401, response);
}

class ForbiddenError extends HttpError {
  ForbiddenError(http.Response response) : super(403, response);
}

class NotFoundError extends HttpError {
  NotFoundError(http.Response response) : super(404, response);
}

class InternalServerError extends HttpError {
  InternalServerError(http.Response response) : super(500, response);
}

class HttpClient {
  final String baseUrl;
  late Map<String, String> headers;
  late Uri _uri;
  final _logger = Logger('HttpClient');

  HttpClient({
    required this.baseUrl,
    this.headers = const {},
  }) {
    _uri = Uri.parse(baseUrl);
    headers.putIfAbsent(
      'Content-Type',
      () => 'application/json; charset=utf-8',
    );
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
    final allHeaders = Map<String, String>.from(headers);
    if (extraHeaders != null) {
      allHeaders.addAll(extraHeaders);
    }
    return allHeaders;
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
