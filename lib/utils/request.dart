import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureRequest {
  final Dio api = Dio();
  String? access;

  final _storage = const FlutterSecureStorage();

  SecureRequest() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers['Authorization'] = 'Bearer $access';
      return handler.next(options);
    }, onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        if (await _storage.containsKey(key: 'refresh')) {
          if (await refresh()) {
            return handler.resolve(await _retry(error.requestOptions));
          }
        }
      }
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refresh() async {
    final response = await api.post(
      '/api/auth/refresh',
      data: {
        'refresh': await _storage.read(key: 'refresh'),
      },
    );

    if (response.statusCode == 201) {
      final results = response.data;
      access = results['access'];
      _storage.write(key: 'refresh', value: results['refresh']);
      _storage.write(key: 'access', value: results['access']);
      return true;
    } else {
      // refresh token is wrong
      access = null;
      _storage.deleteAll();
      return false;
    }
  }
}
