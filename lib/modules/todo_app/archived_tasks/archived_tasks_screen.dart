import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/cubit/cubit.dart';
import '../../../shared/components/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).archivedTasks;
        return Center(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) =>
                buildTaskItem(tasks[index], context),
          ),
        );
      },
    );
  }
}
