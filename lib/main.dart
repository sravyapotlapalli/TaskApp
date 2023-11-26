import 'package:flutter/material.dart';
import 'package:flutter_task/screens/task_list.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'QSGuW2DfBV0XUAxNZ1vziiJFURY7Vab75RJXbcsn9';
  final keyClientKey = 'XoVilr0qomHzBF5bTMSXJVOKvK1rbOv9Ta17zNWG';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
     //code for Home Page
     home: TasksListPage(),
    );
  }
}



