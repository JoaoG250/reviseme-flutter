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
