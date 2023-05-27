import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taski_intern/shared/states.dart';
import 'package:flutter/material.dart';

import '../providers/db_provider.dart';
import '../providers/user_api_provider.dart';



class AppCubit extends Cubit<AppStates> {

  AppCubit() :super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  late int currind = 0;
  bool flag = false;
  IconData icon = Icons.edit;

  void changeindex(int index) {
    currind = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;

  insertToDatabase({required String name,
    required String email,
    required String gender, required String status,
  }) async
  {
    await database?.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Users(name,email,gender,status) VALUES("$name","$email","$gender","$status")')
          .then((value) {
        print('$value Inserted successfully');
        emit(AppInsertToDataBaseState());
        //getFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting database ${error.toString()}');
      });
      return null;
    });
  }

/*
  void updateData({required String status,required int id})
  {
    database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, '$id']).then((value) {
      getFromDatabase(database);
      emit(AppUpdateStatus());

    }).catchError((error)
    {
      print('Error when updating database ${error.toString()}');
    }
    );

  }

 */
  void changebottomsheetState({required bool isShow, required IconData Icon}) {
    flag = isShow;
    icon = Icon;
    emit(AppChangeBottomSheetState());
  }

  var key = GlobalKey<ScaffoldState>();

  ScaffoldState? gets() {
    return key.currentState;
  }

  var isLoading = false;

  Future_deleteData() async {
    isLoading = true;
    emit(AppdeleteApi());
    await DBProvider.db.deleteAllUsers();
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    print('All Users deleted');
  }


  Future_loadFromApi() async {
    isLoading = true;
    emit(AppLoadApi());
    var apiProvider = UsersApiProvider();
    await apiProvider.getAllUser();
    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    emit(AppLoadApiagain());
  }


  Future_buildUsersListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                    "Name: ${snapshot.data[index].name}"),
                subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
              );
            },
          );
        }
      },
    );
  }
}

