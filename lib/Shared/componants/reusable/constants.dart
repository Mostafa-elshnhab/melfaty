

import 'dart:io';

import 'package:mlfaty_share/Data/Cash/cashHelper.dart';
import 'package:mlfaty_share/Modules/Login/login.dart';
import 'package:mlfaty_share/Shared/componants/reusable/reusable%20components.dart';

void logout(context) {
  CashHelper.removeData(key: 'uId')
      .then((value) => NavtoAndFinsh(context, Login()));
}

String? uId;
String? path;