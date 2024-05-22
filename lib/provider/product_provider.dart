import 'dart:convert';

import 'package:codenomadtest/model/prooductmodel.dart';
import 'package:codenomadtest/services/category_service.dart';
import 'package:codenomadtest/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {


  final _service = ProductService();
  bool isLoading = false;
  List<dynamic> _todos = [];
  List<dynamic> get todos => _todos;
  String _value = '';
  get value => _value ;
  int _skip = 0;
  get skip => _skip;


  getValue(int skip,String value) {
    _skip = skip;
    _value = value ;
    notifyListeners();
  }

  clearData(){
    todos.clear();
    notifyListeners();
  }

  loadCachedData() async {
    final SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    List<String>? listString = sharedPreference.getStringList('list');
        _todos = listString!.map((item) => Product.fromMap(json.decode(item))).toList();
  }


  Future<void> getAllTodos() async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getAll(_skip,_value);
    _todos = response;
    isLoading = false;
    final SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    List<String> usrList = _todos.map((item) => jsonEncode(item.toMap())).toList();
    sharedPreference.setStringList("list",usrList);
    notifyListeners();
  }

  addMoreData() async {
    _skip = _skip + 10;
    final response = await _service.getAll(_skip,_value);
    _todos.addAll(response);
    notifyListeners();
  }
}