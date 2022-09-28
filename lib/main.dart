import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final Connectivity _connectivity;
  late final StreamSubscription<ConnectivityResult> _subscription;


  bool isOffline = false;

  late Future<pos> listUsers;
  pos posobj = new pos();


  @override
  initState() {
    super.initState();

    listUsers = fetchUsers();

    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    setState(() {
      
    });
  }

  void onConnectivityChange(ConnectivityResult result) {
    // TODO: Show snackbar, etc if no connectivity

    print('interrr ${result.toString()}');
  }

  void dispose() {
    // Always remember to cancel your subscriptions when you're done.
    _subscription.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
        return snapshot.data == ConnectivityResult.mobile ||
            snapshot.data == ConnectivityResult.wifi
            ?AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.grey,
            systemNavigationBarColor: Colors.white, // Change Background color
            systemNavigationBarIconBrightness: Brightness.dark,  // Change Icon color
          ),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () => print('TAPPED!'),
                          child: Container(
                            width: 80,
                            height: 40,
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://assets.stickpng.com/images/5a951939c4ffc33e8c148af2.png",
                              placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 25.0,
                          child: Text(
                            'Google Search Engine',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body:
            Center(
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Text('Got feedback?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 10.0),
                  Text('take 1 minute survey',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),),
                  SizedBox(height: 10.0),
                  Text('Click to start',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 200.0,
                    child: FutureBuilder<pos>(
                      future: listUsers,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          posobj = snapshot.data!;


                          print('yes present');

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                                child: Container(
                                  height: 100,
                                  width: double.maxFinite,
                                  child:  GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                    itemCount: posobj.data?[0].language?.length,
                                    itemBuilder: (context, index) {
                                      if (posobj.data?.length != 0) {
                                        return GestureDetector(
                                          onTap: () async {
                                            },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                                            child: Column(
                                              children: [
                                                TextButton(
                                                  child: Text(
                                                    posobj.data![0].language![index].lang.toString(),
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                      elevation: 2,
                                                      backgroundColor: Colors.white),
                                                ),
                                                Container(
                                                  width: 20,
                                                  height: 10,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    "https://img.favpng.com/23/7/11/abu-dhabi-dubai-flag-of-the-united-arab-emirates-national-flag-png-favpng-PiKxGp531xvY3D5PsBj5qfwh9.jpg",
                                                    placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) =>
                                                    new Icon(Icons.error),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else
                                        return Container();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center( child: Text('${snapshot.error}'));
                        }
                        return Center(
                          child: CircularProgressIndicator(backgroundColor: Colors.green),
                        );
                      },
                    ),
                  )
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        )
            :AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.grey,
            systemNavigationBarColor: Colors.white, // Change Background color
            systemNavigationBarIconBrightness: Brightness.dark,  // Change Icon color
          ),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () => print('TAPPED!'),
                          child: Container(
                            width: 80,
                            height: 40,
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://assets.stickpng.com/images/5a951939c4ffc33e8c148af2.png",
                              placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 25.0,
                          child: Text(
                            'Google Search Engine',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body:
            Center(
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Text('Got feedback?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 10.0),
                  Text('take 1 minute survey',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),),
                  SizedBox(height: 10.0),
                  Text('Click to start',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),),
                  SizedBox(height: 20.0),
                  Container(
                    height: 200.0,
                    child: FutureBuilder<pos>(
                      future: listUsers,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          posobj = snapshot.data!;


                          print('yes present');

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: Container(
                                  height: 100,
                                  width: double.maxFinite,
                                  child:  GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                    itemCount: posobj.data?[0].language?.length,
                                    itemBuilder: (context, index) {
                                      if (posobj.data?.length != 0) {
                                        return GestureDetector(
                                            onTap: () async {
                                            },
                                            child: Text(posobj.data![0].language![index].lang.toString())
                                        );
                                      } else
                                        return Container();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center( child: Text('${snapshot.error}'));
                        }
                        return Center(
                          child: CircularProgressIndicator(backgroundColor: Colors.green),
                        );
                      },
                    ),
                  )
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        );
      },
    );
  }
}



Future<pos> fetchUsers() async {
  try {
    Response response = await Dio().get('https://api.jsonserve.com/0bSq_-');
    if (response.statusCode == 200) {
      print(response.data.toString());

      return pos.fromJson(response.data);;
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load users');
  }
}




class pos {
  final List<Data>? data;

  pos({this.data});

  factory pos.fromJson(List<dynamic> parsedJson){

    List<Data> data = <Data>[];
    print(data.runtimeType);
    data = parsedJson.map((i)=>Data.fromJson(i)).toList();


    return pos(
        data: data

    );
  }
}


class Data{
  final List<Language>? language;

  Data({this.language});

  factory Data.fromJson(Map<String, dynamic> parsedJson){

    var list2 = parsedJson['languages'] as List;
    print(list2.runtimeType);
    List<Language> dataList2 = list2.map((i) => Language.fromJson(i)).toList();


    return Data(
        language: dataList2

    );
  }
}


class Language {
  final String? lang;

  Language({this.lang});

  factory Language.fromJson(Map<String, dynamic> parsedJson){
    return Language(
        lang:parsedJson['lang'].toString(),
    );
  }


}

