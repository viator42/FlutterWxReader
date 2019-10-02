import 'package:dio/dio.dart';
import 'static_values.dart';

class HttpUtils {
  static Dio http;
  String baseApi = serverPath;

  HttpUtils() {
    BaseOptions options = new BaseOptions(
      baseUrl: baseApi,
    );
    http = new Dio(options);
    // 添加拦截器
    http.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError e) {
      print(e);
      return null;
    }));
  }

  Future get(String url, [Map<String, dynamic> params]) {
    return http.get(url, queryParameters: params == null ? {} : params);
  }

  Future post(String url, [Map<String, dynamic> params]) {
    return http.post(url, data: params == null ? {} : params);
  }
}
