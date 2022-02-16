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
  final Map<String, String>? headers;
  late Uri _uri;

  HttpClient({
    required this.baseUrl,
    this.headers,
  }) {
    _uri = Uri.parse(baseUrl);
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
        throw BadRequestError(response);
      case 401:
        throw UnauthorizedError(response);
      case 403:
        throw ForbiddenError(response);
      case 404:
        throw NotFoundError(response);
      case 500:
        throw InternalServerError(response);
      default:
        throw HttpError(response.statusCode, response);
    }
  }

  Map<String, String> _getHeaders(Map<String, String>? extraHeaders) {
    final allHeaders = Map<String, String>.from(headers ?? {});
    if (extraHeaders != null) {
      allHeaders.addAll(extraHeaders);
    }
    return allHeaders;
  }

  Future<http.Response> get(String path, [Map<String, String>? headers]) async {
    final response =
        await http.get(_uri.resolve(path), headers: _getHeaders(headers));
    return _checkRespose(response);
  }

  Future<http.Response> post(String path, Map<String, dynamic> body,
      [Map<String, String>? headers]) async {
    final response = await http.post(_uri.resolve(path),
        body: body, headers: _getHeaders(headers));
    return _checkRespose(response);
  }

  Future<http.Response> put(String path, Map<String, dynamic> body,
      [Map<String, String>? headers]) async {
    final response = await http.put(_uri.resolve(path),
        body: body, headers: _getHeaders(headers));
    return _checkRespose(response);
  }

  Future<http.Response> delete(String path,
      [Map<String, String>? headers]) async {
    final response =
        await http.delete(_uri.resolve(path), headers: _getHeaders(headers));
    return _checkRespose(response);
  }
}
