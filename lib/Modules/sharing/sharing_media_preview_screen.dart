import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mlfaty_share/Data/Remot/Api/dio_helper.dart';
import 'package:mlfaty_share/Home/home_layout.dart';
import 'package:mlfaty_share/Models/UserModel/user_model.dart';
import 'package:mlfaty_share/Models/media_preview_item.dart';
import 'package:mlfaty_share/Models/user_detail_model.dart';
import 'package:mlfaty_share/Shared/Cubit/AppCubit/cubit.dart';
import 'package:mlfaty_share/Shared/componants/reusable/app_constants.dart';
import 'package:mlfaty_share/Shared/componants/reusable/reusable%20components.dart';
import 'package:mlfaty_share/Shared/constants/color_constants.dart';
import 'package:mlfaty_share/Shared/constants/dimens_constants.dart';
import 'package:mlfaty_share/Shared/constants/file_constants.dart';
import 'package:mlfaty_share/Shared/constants/font_size_constants.dart';
import 'package:mlfaty_share/Shared/extension/scaffold_extension.dart';
import 'package:mlfaty_share/widget/empty_view.dart';



class SharingMediaPreviewScreen extends StatefulWidget {
  final List<UserDetailModel>? userList;
  final List<File>? files;
  final String? text;
  SharingMediaPreviewScreen({this.userList, this.files, this.text = ""});
  @override
  _SharingMediaPreviewScreenState createState() =>
      _SharingMediaPreviewScreenState();
}

class _SharingMediaPreviewScreenState extends State<SharingMediaPreviewScreen> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.95, keepPage: false);
  final List<MediaPreviewItem> galleryItems = [];
  int _initialIndex = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        var i = 0;
        widget.files?.forEach((element) {
          galleryItems.add(MediaPreviewItem(
              id: i,
              resource: element,
              controller: TextEditingController(),
              isSelected: i == 0 ? true : false));
          i++;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return galleryItems.isNotEmpty
        ? Column(
            children: [
              SizedBox(height: DimensionConstants.sizedBoxHeight5),
              _fullMediaPreview(context),
              _fileName(context),
              _addCaptionPreview(context),
              _horizontalMediaFilesView(context)
            ],
          ).generalScaffold(
            context: context,
            appTitle: "Upload...",
            files: widget.files,
            userList: widget.userList)
        : widget.text!.isNotEmpty
            ? _sharedTextView(context).generalScaffold(
                context: context,
                appTitle: "Upload...",
                files: widget.files,
                userList: widget.userList)
            : EmptyView(
                topLine: "No files are here..",
                bottomLine: "Select files from gallery or file manager.",
              ).generalScaffold(
                context: context,
                appTitle: "Upload...",
                files: widget.files,
                userList: widget.userList);
  }

  Widget _fullMediaPreview(BuildContext context) => Expanded(
          child: PageView(
        controller: _pageController,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          _mediaPreviewChanged(value);
        },
        children: galleryItems
            .map((e) => AppConstants.imageExtensions
                    .contains(e.resource?.path.split('.').last.toLowerCase())
                ? Image.file(File(e.resource!.path))
                : Image.asset(
                    FileConstants.icFile,
                  ))
            .toList(),
      ));

  void _mediaPreviewChanged(int value) {
    _initialIndex = value;
    setState(() {
      var i = 0;
      galleryItems.forEach((element) {
        if (i == value) {
          galleryItems[i].isSelected = true;
        } else {
          galleryItems[i].isSelected = false;
        }
        i++;
      });
    });
  }

  Widget _fileName(BuildContext context) => Padding(
        padding: const EdgeInsets.all(DimensionConstants.padding8),
        child: Text(
            "${galleryItems[_initialIndex].resource!.path.split('/').last}"),
      );

  Widget _addCaptionPreview(BuildContext context) => Row(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: DimensionConstants.leftPadding15,
                    right: DimensionConstants.rightPadding20,
                    top: DimensionConstants.topPadding10),
                child: Text('Upload ....',style: TextStyle(
                  fontSize: 20
                ),))),
        GestureDetector(
            onTap: ()async {
              await _upload();
              Navto(context, HomeScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(29, 194, 95, 1),

                  child: Icon(Icons.upload_file,size: 30,color: Colors.white,)),
            ))
      ]);

  Widget _horizontalMediaFilesView(BuildContext context) =>
      (MediaQuery.of(context).viewInsets.bottom == 0)
          ? Container(
              height: DimensionConstants.containerHeight60,
              margin: const EdgeInsets.only(
                  left: DimensionConstants.leftPadding15,
                  bottom: DimensionConstants.bottomPadding10,
                  top: DimensionConstants.topPadding5),
              child: ListView.separated(
                  itemCount: galleryItems.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: DimensionConstants.sizedBoxWidth10);
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          _onTapHorizontalMedia(context, index);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: galleryItems[index].isSelected
                                        ? ColorConstants.greyColor
                                        : ColorConstants.whiteColor,
                                    width: 1.0)),
                            child: AppConstants.imageExtensions.contains(
                                    galleryItems[index]
                                        .resource
                                        ?.path
                                        .split('.')
                                        .last
                                        .toLowerCase())
                                ? Image.file(
                                    File(galleryItems[index].resource!.path))
                                : Image.asset(FileConstants.icFile)));
                  },
                  scrollDirection: Axis.horizontal))
          : SizedBox();

  void _onTapHorizontalMedia(BuildContext context, int index) {
    setState(() {
      var i = 0;
      galleryItems.forEach((element) {
        if (i == index) {
          galleryItems[i].isSelected = true;
        } else {
          galleryItems[i].isSelected = false;
        }
        i++;
      });
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Widget _sharedTextView(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text("Shared text here...",
            style: TextStyle(
                color: ColorConstants.greyColor,
                fontSize: FontSizeWeightConstants.fontSize20)),
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionConstants.horizontalPadding10),
            child: Row(children: [
              Text(widget.text!,
                  style:
                      TextStyle(fontSize: FontSizeWeightConstants.fontSize20)),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    _onSharingTap(context);
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: DimensionConstants.bottomPadding8),
                      child: Image.asset(FileConstants.icSend, scale: 2.7)))
            ]))
      ]);

  void _onSharingTap(BuildContext context) {
    //You can use this method to share media file or text based on your requirements
  }
  Future<void> _upload() async{
    final fileName = galleryItems[_initialIndex].resource!.path.split('/').last;
    // Uploading the selected image with some custom meta data
    File file=File(galleryItems[_initialIndex].resource!.path);
  await  FirebaseStorage.instance.ref(fileName).putFile(
        file,
        SettableMetadata(customMetadata: {
          'uploaded_by': 'A bad guy',
          'description': 'Some description...'
        }));
    AppCubit.get(context).loadImages();
    UserModel? userModel;
    await  DioHelper.postData(userModel!.name,fileName);

  }
}
