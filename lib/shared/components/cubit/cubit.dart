import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/components/cubit/states.dart';

import '../../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../../modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  int currentIndex = 0;
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottmNavBarrState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((e) {
        print('error when creating table ${e.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print('DataBase opened');
    }).then((value) {
      database = value;
      emit(AppCreateDataState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully ');

        emit(AppInsertDataState());
        getDataFromDataBase(database);
      }).catchError((e) {
        print('error when inserting new record ${e.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDataLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      print(newTasks);

      emit(AppGetDataState());
    });
  }

  void updateData({required String status, required int id}) async {
    await database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['${status}', id]).then((value) {
      emit(AppUdateDataState());
      getDataFromDataBase(database);
    });
  }

  void deleteData({required int id}) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?  ', [id]).then((value) {
      emit(AppDeleteDataState());
      getDataFromDataBase(database);
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottmSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottmSheetState());
  }
}
