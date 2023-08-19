import 'package:dio/dio.dart';

/// More examples see https://github.com/cfug/dio/blob/main/example
class ApiConnect {
  static Future<dynamic> hitApiPost(
      String url, Map<String, dynamic> params) async {
    final dio = Dio();
    final response = await dio.post(
      url,
      data: (params),
    );
    print(response.toString());
    print(response.data.toString());
    return response.data;
  }

  static Future<String> hitApiGet(url) async {
    final dio = Dio();
    final response = await dio.get(url);
    return response.data;
  }
}
