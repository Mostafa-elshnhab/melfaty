import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mlfaty_share/Data/Cash/cashHelper.dart';
import 'package:mlfaty_share/Home/home_layout.dart';
import 'package:mlfaty_share/Modules/Register/register.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/cubit.dart';
import 'package:mlfaty_share/Shared/componants/reusable/reusable%20components.dart';


import 'Cubit/States.dart';
import 'Cubit/cubit.dart';

class Login extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LogiStates>(
        listener: (context, state) {
          if (state is LoginErorrState) {
            Fluttertoast.showToast(
                msg: state.error!,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is LoginScssesState){

            CashHelper.saveData(key: 'uId', value: state.uId);
//            AppCubit.get(context).getData();
            NavtoAndFinsh(context, HomeScreen());
          }
          if(state is LoginGoogleScssesState)
          {
            CashHelper.saveData(key: 'uId', value: state.uId);
            NavtoAndFinsh(context, HomeScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.all(20.0.sp),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Login To Join to Us',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'email can\'t be empty';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: LoginCubit.get(context).isShow,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  LoginCubit.get(context).ChangePasswordIcon();
                                },
                                icon: Icon(Icons.remove_red_eye)),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password can\'t be empty';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        (state is! LoginLodaingState)
                            ? MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).Login(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                color: Colors.lightBlueAccent,
                                minWidth: double.infinity,
                                height: 50.h,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 17.h,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have account ?'),
                            TextButton(
                                onPressed: () {
                                  Navto(context, Register());
                                },
                                child: Text('REGISTER')),
                          ],
                        ),
                        Center(child: Text('Or',style: TextStyle(color: Colors.lightBlue),)),
                      Center(child: GestureDetector(
                        onTap: (){
                          LoginCubit.get(context).signInWithGoogle();
                        },
                        child: Container(
                            height: 90.h,
                            width: 200.w,
                            child: Image.asset('assets/images/google.png')),
                      )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
