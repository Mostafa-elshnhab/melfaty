import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mlfaty_share/Data/firebase_api/firebase_api.dart';
import 'package:mlfaty_share/Models/Messages/message_model.dart';
import 'package:mlfaty_share/Models/UserModel/user_model.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/states.dart';
import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'package:path/path.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<String> titles = ['Home', 'Chats', 'Posts', 'User', 'Settings'];
  List<Widget> pages = [

  ];
  void changeIndex(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(AddPostState());
    } else {
      currentIndex = index;
      emit(BottomNaveChange());
    }
  }

  UserModel? userModel;
  void getData() {
    emit(HomeLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(HomeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorState());
    });
  }

  bool isDark = false;

  void onStateChanged(bool isDarkModeEnabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = isDarkModeEnabled;
    prefs.setBool('idDark', isDark);
    print(isDark);

    emit(ChangeModeState());
  }

  void getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('idDark') ?? false;
    emit(GetModeState());
  }


  List<UserModel> users = [];
  void getUsers() {
    emit(GetUsersLoadingState());
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.id != userModel!.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(GetUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetUsersErrorState());
      });
  }

  final TextEditingController messageController = TextEditingController();
  void sendMessage({receiverId, text, timeDate, imageUrl}) {
    MessageModel model = MessageModel(
        timeDate: timeDate,
        text: text,
        receiverId: receiverId,
        senderId: userModel!.uId,
        image: imageUrl);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
      messageController.text = '';
      emit(ClearTextBoxState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel>? messages = [];
  void getMessages(receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeDate')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages!.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
      print(messages!.length);
    });
  }



  File? file;
  UploadTask? task;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false).then((value) {
      emit(SelectFileSuccessState());
    }).catchError((error){
      emit(SelectFileErrorState());
    });

    if (result == null) return;
    final path = result.files.single.path!;

     file = File(path);
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
emit(UploadFileSuccessState());

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }
}



class ImageSource {
}
