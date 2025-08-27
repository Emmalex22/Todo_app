import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'package:get/get.dart';
import 'controller.dart';

/// A beautiful, colorful, and beginner-friendly todos list widget
class TodosList extends StatelessWidget {

  const TodosList({super.key});

  // Colorful gradient colors for todo cards
  final List<List<Color>> _gradientColors = const [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple-Blue
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink-Red
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue-Cyan
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green-Mint
    [Color(0xFFfa709a), Color(0xFFfee140)], // Pink-Yellow
    [Color(0xFFa8edea), Color(0xFFfed6e3)], // Mint-Pink
    [Color(0xFFffecd2), Color(0xFFfcb69f)], // Peach-Orange
    [Color(0xFFd299c2), Color(0xFFfef9d7)], // Purple-Cream
  ];
  Controller get controller => Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
      return const Center(child: CircularProgressIndicator());
      }
      final List<Todo> items = controller.todos.values.toList();
      items.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));

      if(items.isEmpty) {
        return _buildEmptyState();
      }

      return Container(
        width: 350,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final todo = items[index];
            final gradientIndex = index % _gradientColors.length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildTodoCard(todo, index, items.length, gradientIndex),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade200, Colors.purple.shade200],
                ),
              ),
              child: Icon(
                Icons.checklist_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '🎉 All caught up!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No todos yet. Add one to get started!',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard(
    Todo todo,
    int index,
    int totalLength,
    int gradientIndex,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientColors[gradientIndex],
          ),
          boxShadow: [
            BoxShadow(
              color: _gradientColors[gradientIndex][0].withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Number badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _gradientColors[gradientIndex],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Todo content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                          decoration: todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: Colors.grey.shade400,
                          decorationThickness: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                            todo.completed ? Colors.green.shade100 : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          todo.completed ? '✅ Completed' : '⏳ Pending',
                          style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: 
                          todo.completed ? Colors.green.shade700 : Colors.orange.shade700,
                          // ),
                        ),
                      ),
                    )
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkbox with animation
                    GestureDetector(
                      onTap: () {
                        if (todo.id == null) return;
                        controller.updateTodoStatus(todo.id!, todo.completed);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: todo.completed ? Colors.green.shade400 : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: todo.completed ? Colors.green.shade400 : Colors.transparent,
                        ),
                        
                        child: todo.completed
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Delete button
                    GestureDetector(
                      onTap: () {
                        _showDeleteConfirmation(todo);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Todo todo) {
    // You can implement a confirmation dialog here if needed OR
    // You can delete directly
    final id = todo.id;
    if(id == null) return;
    Get.defaultDialog(
      title: 'Delete Todo?',
      middleText: 'Are you sure you want to delete "${todo.title}"?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      //upon clicking delete, put in a delete request and wait for the result
      onConfirm: () async {
        try{
          Get.back();
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
          await controller.deleteTodo(id);
          Get.back();
          Get.snackbar('Deleted', 'Todo Deleted Successfully', snackPosition: SnackPosition.TOP);
        }
        catch (e) {
          Get.back();
          Get.snackbar(
            'Error',
            'Failed to Delete Todo $e',
            backgroundColor: Colors.red.shade300,
            colorText: Colors.white,
          );
        }
      },
      onCancel: () => Get.back()
    );
  }
}