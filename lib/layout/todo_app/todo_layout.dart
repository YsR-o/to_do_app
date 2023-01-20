import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/components/components.dart';
import '../../shared/components/cubit/cubit.dart';
import '../../shared/components/cubit/states.dart';
class HomeLayout extends StatelessWidget {
  
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController =  TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {     
          if (state is AppInsertDataState )
         {
           Navigator.pop(context);
          }
           },
        builder: (context, state) {  

          AppCubit cubit = AppCubit.get(context);
          
          return Scaffold(          
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.title[cubit.currentIndex]),
          ),
          body: Center(child:state == AppGetDataLoadingState ? const CircularProgressIndicator() :cubit.screens[cubit.currentIndex]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cubit.isBottomSheetShown
                  ? {
                    if (formkey.currentState!.validate()){
                      cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                      ).then((value) {

                      } )
                    }
                    }
                  : {
                      scaffoldKey.currentState!
                          .showBottomSheet((context) => Container(
                                padding: const EdgeInsets.all(20),
                                width: double.infinity,
                                color: Colors.white,
                                child: Form (
                                key:formkey ,
                                autovalidateMode: AutovalidateMode.always,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultTextFormField(
                                        controller: titleController ,
                                        type: TextInputType.text ,
                                        label: 'Title',
                                        prefix: Icons.title_rounded,
                                        onTap: (){
                                        },
                                        validate: (value){
                                          if (value == null||value.isEmpty)
                                              {
                                            return 'Title must not be empty';
                                                }
                                                return null;
                                         }
                                        ),
                                        const SizedBox(height: 15,),
                                        defaultTextFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        label: "Task Time", 
                                        prefix: Icons.timer_outlined,
                                        onTap: (){
                                          showTimePicker(
                                            context: context,
                                           initialTime: TimeOfDay.now(), 
                                           ).then((value) { 
                                            timeController.text = value!.format(context).toString();
                                           print (value.format(context));
                                         } );
                                        },
                                        validate: (value){
                                          if (value!.isEmpty )
                                              {
                                            return 'Time must not be empty';
                                                }
                                         }
                                          ),
                                          const SizedBox(height: 15,),
                                          defaultTextFormField(controller: dateController,
                                         type: TextInputType.datetime,
                                          label: "Task Date", 
                                          prefix: Icons.calendar_month_outlined,
                                        onTap: (){
                                          showDatePicker(context: context,
                                           initialDate: DateTime.now(),
                                            firstDate:  DateTime.now(),
                                             lastDate: DateTime.parse('2022-12-20'),
                                             ).then((value) {
                                              dateController.text = DateFormat.yMMMd().format(value!);
                                             });
                                        },
                                  validate: (value){
                                          if (value!.isEmpty )
                                              {
                                            return 'Date must not be empty';
                                                }
                                         }
                                        ),
                                        const SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                ),
                               )).closed.then((value) {
          
                      cubit.changeBottmSheetState(isShow: false, icon: Icons.edit);
          
                               }),

                      cubit.changeBottmSheetState(isShow: true, icon: Icons.check),
                     
                    };
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.ChangeIndex(value);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archived'),
            ],
          ),
        );}
      ),
    );
  }



}



