import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mlfaty_share/Data/firebase_api/firebase_api.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/cubit.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/states.dart';
import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomeScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  UploadTask? task;
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print ('$path! '+"mostaaf");
    _loadImages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        selectFile();
        },
        child: Icon(Icons.upload_file),
        backgroundColor: Color.fromRGBO(29, 194, 95, 1),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                task != null ? buildUploadStatus(task!) : Container(),
                Expanded(
                  child: FutureBuilder(
                    future: _loadImages(),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> file =
                            snapshot.data![index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                dense: false,
                                leading: Text('${file['path']}'),
                                trailing: IconButton(
                                  onPressed: () async{
                                    print(file['path']);
                                  await download(file['path']);
                                    final snackBar = SnackBar(
                                      content: Text('Downloaded ${file['name']}'),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.teal  ,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
     path = result.files.single.path!;
      print(path!+'sasasas');
    setState(() => file = File(path!));
    _upload();
  }
  Future<void> _upload() async {
    final fileName = basename(file!.path);
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            file!,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'A bad guy',
              'description': 'Some description...'
            }));

        // Refresh the UI
        setState(() {});

  }


  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];
   print('here1');
    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      print('here2');
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "name":file.name,
      });

    });

    return files;
  }

//  Future uploadFile() async {
//    if (file == null) return;
//
//    final fileName = basename(file!.path);
//    final destination = 'files/$fileName';
//
//    task = FirebaseApi.uploadFile(destination, file!);
//    setState(() {});
//
//    if (task == null) return;
//
//    final snapshot = await task!.whenComplete(() {});
//    final urlDownload = await snapshot.ref.getDownloadURL();
//
//    print('Download-Link: $urlDownload');
//  }
  Future<void> download(url) async {
    //First you get the documents folder location on the device...
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //Here you'll specify the file it should be saved as
    File downloadToFile = File('${appDocDir.path}/$url');
    print(downloadToFile.toString());
    //Here you'll specify the file it should download from Cloud Storage

    //Now you can try to download the specified file, and write it to the downloadToFile.

      await FirebaseStorage.instance
          .ref(url)
          .writeToFile(downloadToFile).then((p0) => {
            print('done')
      });

  }
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}