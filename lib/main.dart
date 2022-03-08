import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';


import 'Data/Cash/cashHelper.dart';
import 'Home/home_layout.dart';
import 'Modules/Login/login.dart';
import 'Shared/Cubit/AppCubit/cubit.dart';
import 'Shared/Cubit/AppCubit/states.dart';
import 'Shared/Cubit/cubit_observe.dart';
import 'Shared/componants/reusable/constants.dart';
import 'Style/Themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });
  Bloc.observer = MyBlocObserver();
  await CashHelper.init();
  uId = CashHelper.getuId('uId') ?? '';
  Widget startWidget;

  if (uId != '') {
    startWidget = HomeScreen();
  } else {
    startWidget = Login();
  }
  runApp(MyApp(startWidget));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  Widget? startWidget;
  MyApp(
      this.startWidget,
      );


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;

  String? _sharedText;
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        path=(_sharedFiles?.map((f) => f.path).join(",") ?? "");
        print("Shared1:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        path=(_sharedFiles?.map((f) => f.path).join(",") ?? "");
        print("Shared2:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          setState(() {
            _sharedText = value;
            path=(_sharedText);
            print("Shared3: $_sharedText");
          });
        }, onError: (err) {
          print("getLinkStream error: $err");
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
        path=(_sharedText);
        print("Shared4: $_sharedText");
      });
    });



  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:const  Size(375, 812),
      builder: ()=> MultiBlocProvider(
        providers: [
          BlocProvider  (
              create: (context) => AppCubit()
                ..getData()

                ..getMode())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social App',
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: ThemeMode.light,
//            AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
          home: widget.startWidget,
        ),
      ),
    );
  }
}
