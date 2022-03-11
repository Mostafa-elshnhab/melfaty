import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'Data/Cash/cashHelper.dart';
import 'Data/Remot/Api/dio_helper.dart';
import 'Home/home_layout.dart';
import 'Modules/Login/login.dart';
import 'Shared/Cubit/AppCubit/cubit.dart';
import 'Shared/Cubit/AppCubit/states.dart';
import 'Shared/Cubit/cubit_observe.dart';
import 'Shared/componants/reusable/constants.dart';
import 'Style/Themes/themes.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DioHelper.init();
  var token = FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });
  Bloc.observer = MyBlocObserver();
  await CashHelper.init();
  uId = CashHelper.getuId('uId') ?? '';
//String checkBoxes= CashHelper.getuId('checkBoxes')??[];
print(checkBoxes);
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
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,

                color: Colors.blue,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
           context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });

    getToken();
  }


  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:const  Size(375, 812),
      builder: ()=> MultiBlocProvider(
        providers: [
          BlocProvider  (
              create: (context) => AppCubit()..loadImages()..getData(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mlfaty App',
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

