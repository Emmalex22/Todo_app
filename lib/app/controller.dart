import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:rest_api/todos_model.dart';

import 'todo_model.dart';
import 'dart:convert';

/// The controller class responsible for fetching and maintaining the list of
/// todos. It allows CRUD operations of creating a new todo, updating its
/// status, and deleting it.
class Controller extends GetxController {
  /// Instance of [GetConnect] to make HTTP requests. optonal
  final GetConnect connect = GetConnect();

  /// Controller for todo's title input field. Used in the todo creation dialog.
  final TextEditingController titleController = TextEditingController();

  /// A map to store the list of todos fetched from the API.
  /// The key is the todo ID, and the value is the todo object.
  final RxMap<int, Todo> todos = <int, Todo>{}.obs;

  /// A boolean to indicate if the controller is saving a todo.
  /// Used to show a saving indicator in the app bar whenever a CRUD operation
  /// is in progress.
  final RxBool saving = false.obs;
  final RxBool loading = false.obs;
  final String baseUrl = 'https://jsonplaceholder.typicode.com/Todos';

  @override
  void onInit() {
    // Fetch todos when the controller is initialized.
    fetchTodos();
    
    super.onInit();
  }

  @override
  onClose() {
    // Dispose the title controller when the controller is closed.
    titleController.dispose();
    
    super.onClose();
  }

  // GET request to fetch todos.
  Future<void> fetchTodos() async{
    try {
      loading.value = true;
      final response = await connect.get(baseUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final mapped = <int, Todo> {
          for(final item in data)
            item['id'] as int: Todo.fromJson(item)
        };
        todos.assignAll(mapped);
      }
    }
    catch (e) {
      Get.snackbar('Error', 'Unable to load todos: $e');
    }
    finally {
      loading.value = false;
    }
  }
  /// POST request to create a new todo.
  Future<void> createTodos() async{
    final title = titleController.text.trim();
    if(title.isEmpty){
      Get.snackbar('Empty Title', 'Please enter a Todo title');
      return;
    }
    try {
      saving.value = true;
      final response = await connect.post(
        baseUrl,
        {
          'title': title,
          'completed': false,
        }
      );
      if (response.statusCode == 201) {
        final Todo created = Todo.fromJson(response.body);
        final id = created.id ?? DateTime.now().millisecondsSinceEpoch;
        todos[id] = created.copyWith(id: id);
        titleController.clear();
        Get.snackbar('Success', 'Todo created successfully');
      }
    }
    catch (e) {
      Get.snackbar('Error', "Couldn't create Todo: $e");
    }
    finally {
      saving.value = false;
    }
  }
  /// PUT request to update todo status.
  Future<void> updateTodoStatus(int id, bool completed) async{
    try {
      saving.value = true;
      final response = await connect.put('$baseUrl/$id', {'completed': completed});
      if (response.statusCode == 200){
        final current = todos[id];
        if(current != null){
          todos[id] = current.copyWith(completed: completed);
        }
        Get.snackbar('Success', 'Todo updated successfully');
      }
    }
    catch (e) {
      Get.snackbar('Error', 'Could not update todo $e');
    }
    finally{
      saving.value = false;
    }
  }
  /// DELETE request to delete a todo.
  Future<void> deleteTodo(int id) async{
    try{
      saving.value = true;
      final response = await connect.delete('$baseUrl/$id');
      if(response.statusCode == 200 || response.statusCode == 204){
        todos.remove(id);
      }
    }
    catch (e) {
      Get.snackbar('Error', 'Could not delete todo $e');
    }
    finally{
      saving.value = false;
    }
  }
}
