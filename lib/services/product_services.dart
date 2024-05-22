import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/constant.dart';
import '../provider/product_provider.dart';
import '../model/prooductmodel.dart';

class ProductService {
  bool noData = false;

  Future getAll(int skip,String value) async {

    String url = apiURL + value + '?limit=10&skip=${skip.toString()}';
    print('nijnbi $url');
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonItems = json.decode(response.body);


      var data = jsonItems['products'];
      var total = jsonItems['total'];

        if (total == skip) {
          noData = true;
        } else {
          noData = false;
        }
       dynamic todos = data.map((e) {
        return Product(

          title: e['title'],
          description: e['description'],
          images: e['images']!! as List,
        );
      }).toList();
      return todos;
    }
    return [];
  }
}