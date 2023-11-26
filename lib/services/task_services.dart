import 'dart:convert';

import 'package:http/http.dart' as http;


//All Task api calls will be here
class TaskService {
  static Future<bool> deleteById(String id)async{
    //delete the Task
    final url = 'https://parseapi.back4app.com/classes/Task/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTask() async{
    final url = 'https://parseapi.back4app.com/classes/Task';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['tasks'] as List;
      return result;
    }else {
      return null;
    }
  }
}