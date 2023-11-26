import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_task/services/task_services.dart';
import 'add_page.dart';
import 'package:http/http.dart' as http;

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  @override
  void initState(){
    super.initState();
    fetchTask();
  }
  bool isLoading = true;
  List tasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTask,
          child: Visibility(
            visible : tasks.isNotEmpty,
            replacement: Center(
              child: Text(
                  'No tasks created',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            child: ListView.builder(
            itemCount: tasks.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final task = tasks[index] as Map;
              final id = task['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index+1}')),
                  title: Text(task['title']),
                  subtitle: Text(task['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value == 'edit'){
                        navigateToEditPage(task);
                        //Open Edit Page
                      }else if(value == 'delete'){
                        //delete and remove the selected task
                        deletebyId(id);
                      }
                    },
                    itemBuilder: (context){
                      return[
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: Text('Add Task')
      ),
    );
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(
      builder: (context) => AddTaskPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTask();
  }

  Future<void> navigateToEditPage(Map task) async{
    final route = MaterialPageRoute(
      builder: (context) => AddTaskPage(task:task),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTask();
  }

  Future<void> deletebyId(String id) async {
    final isSuccess = await TaskService.deleteById(id);
    if(isSuccess) {
      final filtered = tasks.where((element) => element['_id'] != id).toList();
      //remove the item from list
      setState(() {
        tasks = filtered;
      });
    }else {
      showErrorMessage('Deletion Failed');  //Show error
    }
  }

  Future<void> fetchTask() async {
    //Fetching the tasks
    final response = await TaskService.fetchTask();
    if(response != null){
      setState((){
        tasks = response;
      });
    }else {
      showErrorMessage('Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content : Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

