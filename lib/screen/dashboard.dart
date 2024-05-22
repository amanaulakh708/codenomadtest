import 'package:codenomadtest/model/prooductmodel.dart';
import 'package:codenomadtest/provider/category_provider.dart';
import 'package:codenomadtest/provider/product_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final fieldText = TextEditingController();
  ScrollController _scrollController = ScrollController();

  var categorydropdownvalue;
  int skip = 0;
  bool noData = false;

  @override
  void initState() {
    _scrollController.addListener(_loadMoreData);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).getAllTodos();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).loadCachedData();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context, listen: false).getALLCat();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        context.read<ProductProvider>().addMoreData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final methodA = Provider.of<ProductProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Container(
              margin: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Products',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      fieldText.clear();
                      context.read<ProductProvider>().clearData();
                      skip = 0;
                      methodA.getValue(skip, '');
                      context.read<ProductProvider>().getAllTodos();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 3.h, bottom: 3.h, right: 15.w, left: 15.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          border: Border.all()),
                      child: Text('All'),
                    ),
                  )
                ],
              )),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      TextField(
                        controller: fieldText,
                        textCapitalization: TextCapitalization.words,
                        onEditingComplete: () async {
                          setState(() {
                            context.read<ProductProvider>().clearData();
                            skip = 0;
                            methodA.getValue(
                                skip, '/search?q=' + fieldText.text + '&');
                            context.read<ProductProvider>().getAllTodos();
                          });
                        },
                        textInputAction: TextInputAction.go,
                        autofocus: false,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            hintText: 'Search Products',
                            suffixIcon:  IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  padding: EdgeInsets.all(0),
                                  icon: const Icon(
                                    Icons.search_rounded,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      context.read<ProductProvider>().clearData();
                                      skip = 0;
                                      methodA.getValue(
                                          skip, '/search?q=' + fieldText.text + '&');
                                      context.read<ProductProvider>().getAllTodos();
                                    });
                                  }),

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.r))),
                      ),
                    ],
                  )),
              SizedBox(
                height: 20.h,
              ),
              Consumer<CategoryProvider>(builder: (context, value, child) {
                final category = value.category;
                return Container(
                  height: 35.h,
                  padding: const EdgeInsets.only(left: 0, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.r)),
                  child: DropdownButton2(
                    dropdownStyleData: DropdownStyleData(
                        useSafeArea: false,
                        offset: Offset(5, -10),
                        maxHeight: 200.h,
                        scrollbarTheme: ScrollbarThemeData(
                            thumbVisibility: MaterialStateProperty.all(true)),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10.r))),
                    underline: Container(),
                    isExpanded: true,
                    // value: awardType,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                    hint: Text(
                      "Select Category",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),

                    items: category.map((item) {
                      return DropdownMenuItem(
                        value: item.toString(),
                        child: Text(item.toString(),
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),

                    onChanged: (newVal) {
                      setState(() {
                        categorydropdownvalue = newVal;
                        fieldText.clear();
                        context.read<ProductProvider>().clearData();
                        skip = 0;
                        methodA.getValue(
                            skip, '/category/' + categorydropdownvalue);
                        context.read<ProductProvider>().getAllTodos();
                      });
                    },
                    value: categorydropdownvalue,
                  ),
                );
              }),
              SizedBox(
                height: 20.h,
              ),
              Consumer<ProductProvider>(builder: (context, value, child) {
                // If the loading it true then it will show the circular progressbar
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final todos = value.todos;
                return Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: todos.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.r)),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          todos[index].images[0].toString()),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        todos[index].title,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp),
                                      ),
                                    ),
                                    Container(
                                      // width: 200.w,
                                      child: Text(
                                        todos[index].description,
                                        style: TextStyle(),
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                );
              }),
              Visibility(visible: noData, child: Text('No more Data'))
            ],
          ),
        ),
      ),
    );
  }
}
