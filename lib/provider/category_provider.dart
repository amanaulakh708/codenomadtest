import 'package:codenomadtest/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {


  final _category = CategoryService();
  List<dynamic> _cat = [];
  List<dynamic> get category => _cat;


  getALLCat() async {
    final response = await _category.getCat();
    _cat = response;
    notifyListeners();
  }

}