import 'package:codenomadtest/screen/dashboard.dart';
import 'package:codenomadtest/provider/category_provider.dart';
import 'package:codenomadtest/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    Size size = WidgetsBinding.instance.window.physicalSize;
    double width = size.width / 2;
    double height = size.height / 2;
    if (width < 650) {
      width = 390;
      print(size.width);
      height = 800;
      print(size.height);
    } else {
      width = size.width / 2.95;
      print(size.width);
      height = size.height / 2.65;
      print(size.height);
    }
    return ScreenUtilInit(
      designSize: Size(width, height),
      builder: (BuildContext context, child) => GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(
              backgroundColor: Colors.white,
              useMaterial3: false,
              fontFamily: 'DmSans',
            ),
            debugShowCheckedModeBanner: false,
            home: Dashboard(),
          
          ),
        ),
      ),
    );
  }
}

