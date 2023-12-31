import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/model/task_provider.dart';
import 'package:todo_app/utilities/constants.dart';
import 'package:todo_app/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = context.read<TaskProvider>();
    if (!taskProvider.taskStatus[0].initiated) {
      taskProvider.loadTasks(offset: 0, limit: 10);
    }

    final TaskProvider taskData =
        Provider.of<TaskProvider>(context, listen: true);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (taskData.groupedTasks.isNotEmpty) {
            final DateTime date = taskData.groupedTasks.keys.elementAt(index);
            final List<Task> tasks = taskData.groupedTasks[date] ?? [];

            List<Widget> taskWidget = [];
            for (Task task in tasks) {
              taskWidget.add(TaskTile(task: task));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 32.0),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(date).toUpperCase(),
                    style: kTaskDateTextStyle,
                  ),
                ),
                const SizedBox(height: 8.0),
                Column(children: taskWidget),
              ],
            );
          } else {
            return const Center(
              child: Text('No data.', style: kTaskTitleTextStyle),
            );
          }
        },
        childCount:
            taskData.groupedTasks.isNotEmpty ? taskData.groupedTasks.length : 1,
      ),
    );
  }
}
