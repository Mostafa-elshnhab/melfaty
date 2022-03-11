import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mlfaty_share/Data/Cash/cashHelper.dart';
import 'package:mlfaty_share/Data/Remot/Api/dio_helper.dart';
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
  FirebaseStorage storage = FirebaseStorage.instance;
  List<Map<String, dynamic>> files = [];
  File? file;

  void changeCheckBox( value,index)
    {
      checkBoxes[index]=value;
      CashHelper.saveData(key: 'checkBoxes', value: checkBoxes.toString(),isList: true);
      emit(CheckBocChangeState());
    }
  Future<List<Map<String, dynamic>>> loadImages() async {
    files=[];
    emit(HomeLoadingState());
     await storage.ref().list().then((value)async {
       final List<Reference> allFiles = value.items;
       print(allFiles);
       await Future.forEach<Reference>(allFiles, (file) async {
         final String fileUrl = await file.getDownloadURL();
         final FullMetadata fileMeta = await file.getMetadata();
       
         files.add({
           "url": fileUrl,
           "path": file.fullPath,
           "name": file.name,
           "uploaded_by":fileMeta.customMetadata!['uploaded_by'],
         });
         checkBoxes=List.filled(files.length, false);
       });
       emit(HomeSuccessState());
     }
    ).catchError((error){
       print(error.toString());
       emit(HomeErrorState());
     });

    return files;
  }
  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result == null) return;

    path = '${result.files.first.path}';

    print(path!+'sasasas');

     file = File(path!);
     emit(SelectFileSuccessState());
    upload();
  }
  Future<void> upload() async {

    final fileName = file!.path.split('/').last;
    // Uploading the selected image with some custom meta data

    await storage.ref(fileName).putFile(
        file!,
        SettableMetadata(customMetadata: {
          'uploaded_by': '${userModel!.uId}',
          'description': 'Some description...'
        })).then((p0)async
    {
      loadImages();
    await  DioHelper.postData(userModel!.name,fileName);
    });

  }
  Future<void> onRefresh() async{
   loadImages();

  }








  UserModel? userModel;
  void getData() {
    emit(HomeLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(HomeSuccessState());
    }).catchError((error) {

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



}




