import 'package:flutter/material.dart' hide AppBar;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/model/task_data.dart';
import 'package:todo_app/utilities/constants.dart';
import 'package:todo_app/widgets/appbar.dart';
import 'package:todo_app/widgets/task_tile.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TaskData taskData = Provider.of<TaskData>(context);
    ScrollController scrollController = ScrollController();

    Future<void> loadMoreItems() async {
      if (taskData.isLoading == false) {
        int nextPage = taskData.getNextPage();
        if (nextPage >= 0) {
          taskData.isLoading = true;
          taskData.setCurrentPage(nextPage);
          final dynamic data = await taskData.getTasksList(
            offset: nextPage,
            limit: 10,
          );
          taskData.add(data['tasks']);
          taskData.setTotalPages(data['totalPages']);

          Future.delayed(const Duration(milliseconds: 10), () {
            taskData.isLoading = false; // Reset the flag after loading
          });
        }
      }
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100.0) {
        loadMoreItems();
      }
    });

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: const <Widget>[
          AppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 20.0)),
          TaskList(),
          SliverToBoxAdapter(child: SizedBox(height: 16.0)),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TaskData taskData = Provider.of<TaskData>(context);

    taskData.getTasksList(offset: 0, limit: 10).then((data) {
      context.read<TaskData>().add(data['tasks']);
      taskData.setTotalPages(data['totalPages']);
    });
    final data = taskData.getGroupedTasks();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final date = data.keys.elementAt(index);
          final tasks = data[date]!;

          List<Widget> taskWidget = [];
          for (Task task in tasks) {
            taskWidget.add(TaskTile(task: task));
          }

          return Container(
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(date).toUpperCase(),
                  style: kTaskDateTextStyle,
                ),
                const SizedBox(height: 8.0),
                Column(
                  children: taskWidget,
                )
              ],
            ),
          );
        },
        childCount: data.length,
      ),
    );
  }
}
