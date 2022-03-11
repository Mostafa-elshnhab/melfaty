//import 'dart:io';
//import 'package:file_picker/file_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
//import 'package:mime/mime.dart';
//import 'package:mlfaty_share/Modules/sharing/sharing_media_preview_screen.dart';
//import 'package:mlfaty_share/Shared/componants/reusable/app_constants.dart';
//import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';
//import 'package:open_file/open_file.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:receive_sharing_intent/receive_sharing_intent.dart';
//
//class HomeScreen extends StatefulWidget {
//  const HomeScreen({Key? key}) : super(key: key);
//
//  @override
//  _MainPageState createState() => _MainPageState();
//}
//
//class _MainPageState extends State<HomeScreen> {
//  FirebaseStorage storage = FirebaseStorage.instance;
//  UploadTask? task;
//  File? file;
//  @override
//  void initState() {
//    super.initState();
//    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
//      listenShareMediaFiles(context);
//    });
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//        selectFile();
//        },
//        child: Icon(Icons.upload_file),
//        backgroundColor: Color.fromRGBO(29, 194, 95, 1),
//      ),
//      body: SafeArea(
//        child: Container(
//          padding: EdgeInsets.all(32),
//          child: Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//
//                task != null ? buildUploadStatus(task!) : Container(),
//                Expanded(
//                  child: FutureBuilder(
//                    future: _loadImages(),
//                    builder: (context,
//                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//                      if (snapshot.connectionState == ConnectionState.done) {
//                        return ListView.builder(
//                          itemCount: snapshot.data?.length ?? 0,
//                          itemBuilder: (context, index) {
//                            final Map<String, dynamic> file =
//                            snapshot.data![index];
//
//                            return Card(
//                              margin: const EdgeInsets.symmetric(vertical: 10),
//                              child: ListTile(
//                                dense: false,
//                                leading: Text('${file['path']}'),
//                                trailing: IconButton(
//                                  onPressed: () async{
//                                    print(file['path']);
//                                  await downloadFile(file['name']);
//                                    final snackBar = SnackBar(
//                                      content: Text('Downloaded ${file['name']}',overflow: TextOverflow.ellipsis,),
//                                    );
//                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                  },
//                                  icon: const Icon(
//                                    Icons.download,
//                                    color: Colors.teal  ,
//                                  ),
//                                ),
//                              ),
//                            );
//                          },
//                        );
//                      }
//
//                      return const Center(
//                        child: CircularProgressIndicator(),
//                      );
//                    },
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//


//

//
////  Future uploadFile() async {
////    if (file == null) return;
////
////    final fileName = basename(file!.path);
////    final destination = 'files/$fileName';
////
////    task = FirebaseApi.uploadFile(destination, file!);
////    setState(() {});
////
////    if (task == null) return;
////
////    final snapshot = await task!.whenComplete(() {});
////    final urlDownload = await snapshot.ref.getDownloadURL();
////
////    print('Download-Link: $urlDownload');
////  }


//  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//    stream: task.snapshotEvents,
//    builder: (context, snapshot) {
//      if (snapshot.hasData) {
//        final snap = snapshot.data!;
//        final progress = snap.bytesTransferred / snap.totalBytes;
//        final percentage = (progress * 100).toStringAsFixed(2);
//
//        return Text(
//          '$percentage %',
//          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//        );
//      } else {
//        return Container();
//      }
//    },
//  );
//  void listenShareMediaFiles(BuildContext context) {
//    // For sharing images coming from outside the app
//    // while the app is in the memory
//    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
//      navigateToShareMedia(context, value);
//    }, onError: (err) {
//      debugPrint("$err");
//    });
//
//    // For sharing images coming from outside the app while the app is closed
//    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
//      navigateToShareMedia(context, value);
//    });
//
//    // For sharing or opening urls/text coming from outside the app while the app is in the memory
//    ReceiveSharingIntent.getTextStream().listen((String value) {
//      navigateToShareText(context, value);
//    }, onError: (err) {
//      debugPrint("$err");
//    });
//
//    // For sharing or opening urls/text coming from outside the app while the app is closed
//    ReceiveSharingIntent.getInitialText().then((String? value) {
//      navigateToShareText(context, value);
//    });
//  }
//  void navigateToShareMedia(BuildContext context, List<SharedMediaFile> value) {
//    if (value.isNotEmpty) {
//      var newFiles = <File>[];
//      value.forEach((element) {
//        newFiles.add(File(
//          Platform.isIOS
//              ? element.type == SharedMediaType.FILE
//              ? element.path
//              .toString()
//              .replaceAll(AppConstants.replaceableText, "")
//              : element.path
//              : element.path,
//        ));
//      });
//      Navigator.of(context).push(MaterialPageRoute(
//          builder: (context) => SharingMediaPreviewScreen(
//            files: newFiles,
//            text: "",
//          )));
//    }
//  }
//
//  void navigateToShareText(BuildContext context, String? value) {
//    if (value != null && value.toString().isNotEmpty) {
//      Navigator.of(context).push(MaterialPageRoute(
//          builder: (context) => SharingMediaPreviewScreen(
//            files: [],
//            text: value,
//          )));
//    }
//  }
//}
//import 'dart:io';
//import 'package:file_picker/file_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
//import 'package:mime/mime.dart';
//import 'package:mlfaty_share/Modules/sharing/sharing_media_preview_screen.dart';
//import 'package:mlfaty_share/Shared/componants/reusable/app_constants.dart';
//import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';
//import 'package:open_file/open_file.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mime/mime.dart';
import 'package:mlfaty_share/Modules/sharing/sharing_media_preview_screen.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/cubit.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/states.dart';
import 'package:mlfaty_share/Shared/componants/reusable/app_constants.dart';
import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UploadTask? task;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      listenShareMediaFiles(context);
    });
  }

  @override

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cupit=AppCubit.get(context);
        return  Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
             cupit.selectFile();
            },
            child: Icon(Icons.upload_file),
            backgroundColor: Color.fromRGBO(29, 194, 95, 1),
          ),
          body: RefreshIndicator(
            onRefresh:cupit.onRefresh,

            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child:(state is! HomeLoadingState)?
                     Container(
                       child: cupit.files.isNotEmpty? ListView.builder(
                       itemCount: cupit.files.length,
                    itemBuilder: (context, index) {
                        final Map<String, dynamic> file =
                        cupit.files[index];

                        var type=  lookupMimeType(file['path']);
                        bool isImage=false;
                        if(type=='image/jpeg')
                        {
                          isImage=true;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Checkbox(value: checkBoxes[index],
                                  activeColor: Colors.green,
                                  onChanged:(newValue){
                                    cupit.changeCheckBox(newValue,index);
                                  }),
                              Expanded(
                                child: ListTile(
                                  dense: false,
                                  leading:isImage?Image.network('${file['url']}',width: 30.w,fit: BoxFit.cover,) :Image.asset('assets/images/ic_file.png',width: 30.w,fit: BoxFit.cover),
                                  title:GestureDetector(
                                      onTap:()async{
                                        print(file['path']);
                                        await downloadFile(file['name']);
                                        final snackBar = SnackBar(
                                          content: Text('Downloaded ${file['name']}',overflow: TextOverflow.ellipsis,),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                      ,child: Text('${file['path']}')) ,
                                  trailing:file['uploaded_by']==uId? IconButton(
                                    onPressed: () async{
                                      FirebaseStorage.instance.refFromURL(file['url']).delete();
                                      cupit.loadImages();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ):SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        );
                    },
                  ):Center(child: Text('No Files')),
                     )
                            :Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  //All listeners to listen Sharing media files & text
  void listenShareMediaFiles(BuildContext context) {
    // For sharing images coming from outside the app
    // while the app is in the memory
    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      navigateToShareMedia(context, value);
    }, onError: (err) {
      debugPrint("$err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      navigateToShareMedia(context, value);
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getTextStream().listen((String value) {
      navigateToShareText(context, value);
    }, onError: (err) {
      debugPrint("$err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      navigateToShareText(context, value);
    });
  }

  void navigateToShareMedia(BuildContext context, List<SharedMediaFile> value) {
    if (value.isNotEmpty) {
      var newFiles = <File>[];
      value.forEach((element) {
        newFiles.add(File(
          Platform.isIOS
              ? element.type == SharedMediaType.FILE
              ? element.path
              .toString()
              .replaceAll(AppConstants.replaceableText, "")
              : element.path
              : element.path,
        ));
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SharingMediaPreviewScreen(
            files: newFiles,
            text: "",
          )));
    }
  }

  void navigateToShareText(BuildContext context, String? value) {
    if (value != null && value.toString().isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SharingMediaPreviewScreen(
            files: [],
            text: value,
          )));
    }
  }


  void _openFile( path) {
    OpenFile.open(path);
  }

  Future<bool> downloadFile( String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/MlfatyApp";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");
        download(fileName,saveFile).then((value){
          _openFile(saveFile.path);
        } );
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  Future<void> download(url,downloadToFile) async {
    //First you get the documents folder location on the device...
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //Here you'll specify the file it should be saved as

    print(downloadToFile.toString());
    //Here you'll specify the file it should download from Cloud Storage

    //Now you can try to download the specified file, and write it to the downloadToFile.

    await FirebaseStorage.instance
        .ref(url)
        .writeToFile(downloadToFile).then((p0) => {
      print('done')
    });

  }


}
