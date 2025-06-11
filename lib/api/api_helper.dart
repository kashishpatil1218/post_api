import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static ApiHelper apiHelper = ApiHelper._();

  Future<Map> fetchData() async {
    String api = "https://dummyjson.com/posts";
    Uri uri = Uri.parse(api);
    Response response = await http.get(uri);
    if (response.statusCode == 200) {
      String data = response.body;

      Map json = jsonDecode(data);
      return json;
    }
    return {};
  }
}
