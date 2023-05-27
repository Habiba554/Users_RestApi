import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/db_provider.dart';
import '../providers/user_api_provider.dart';
import '../shared/cubit.dart';
import '../shared/states.dart';
import '../widgets/custom_text_field.dart';



class HomePage extends StatelessWidget {
  var isLoading = false;
  final  name=TextEditingController();
  final email=TextEditingController();
  final gender=TextEditingController();
  final status=TextEditingController();
  var key=GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider( create: (BuildContext context)=>AppCubit(),
    child: BlocConsumer<AppCubit,AppStates>(
    listener:(BuildContext context,AppStates state){
    if(state is AppInsertToDataBaseState)
    {
    Navigator.pop(context);
    }
    } ,
     builder: (BuildContext context,AppStates state)
      {
      return Scaffold(
        key:  AppCubit.get(context).key,
        appBar: AppBar(
          title: Text('Task'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.settings_input_antenna),
                onPressed: () async {
                  await AppCubit.get(context).Future_loadFromApi();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await  AppCubit.get(context).Future_deleteData();
                },
              ),
            ),
          ],

        ),
        floatingActionButton: FloatingActionButton(onPressed: ()
        {
          if(AppCubit.get(context).flag)
          {
            if(formkey.currentState!.validate())
            {
              AppCubit.get(context).insertToDatabase(name: name.text, email: email.text,gender:  gender.text,status:status.text );
            }

          }
          else
            {
              AppCubit.get(context).gets()!.showBottomSheet((context) =>
              Container(
                height:300,
                width: double.infinity,
                 child: SingleChildScrollView(
                   child: Form(
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                     key: formkey,
                     child: Column(
                       mainAxisSize:MainAxisSize.min,
                        children: [

                          CustomTextField(
                              controller: name,
                              icon: Icons.person,
                              hintText: 'Enter your name',
                              labelText: 'Username',
                              validator: (value)
                              {
                                if (value!.isEmpty) {
                                  return 'name must not be empty';
                                }
                                return null;
                              },
                         ),
                          SizedBox(height: 10.0,),
                          CustomTextField(
                              controller: email,
                              icon: Icons.email,
                             hintText: 'Enter your Email',
                             labelText: 'Email',
                            validator: (value)
                            {
                              if (value!.isEmpty) {
                                return 'email must not be empty';
                              }
                              return null;
                            },),
                          SizedBox(height: 10.0,),
                          CustomTextField(
                              controller: gender,
                            hintText: 'gender',
                            labelText: 'gender',
                            validator: (value)
                            {
                              if (value!.isEmpty) {
                                return 'gender must not be empty';
                              }
                              return null;
                            },
                              ),
                          SizedBox(height: 10.0,),
                          CustomTextField(
                              controller: status,
                            hintText: 'status',
                            labelText: 'status',
                            validator: (value)
                            {
                              if (value!.isEmpty) {
                                return 'status must not be empty';
                              }
                              return null;
                            },
                              ),
                          SizedBox(height: 10.0,)

                        ],
                           //CustomTextField(controller: name.text,

                          // )
                     ),
                   ),
                 ),

              )).closed.then((value)
              {

                AppCubit.get(context).flag=false;
                AppCubit.get(context).changebottomsheetState(isShow: false, Icon: Icons.edit);
              });
              AppCubit.get(context).flag=true;
              AppCubit.get(context).changebottomsheetState(isShow: true, Icon: Icons.add);
              ;}
        },
          child: Icon(Icons.add,),
        ),
        body:  AppCubit.get(context).isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : AppCubit.get(context).Future_buildUsersListView(),
      );},
    ));
  }

}