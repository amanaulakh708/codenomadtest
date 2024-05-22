import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/constant.dart';

class CategoryService {

  Future getCat() async {
    var jsonResponse = await http.get(Uri.parse(apiURL + '/categories'));

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);

      return jsonItems;
    }
    return [];
    }
}