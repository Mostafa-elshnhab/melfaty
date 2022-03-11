import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':'key=AAAAjKncAbo:APA91bHaTfmdijQ7lQRxxO1sxatGkRuT-nlCMjzup6OIL3JQmAgTWuCQ-52EMvNw7rZSAZ3dkMXr2e4qiHCk00Iv5aikRwwX0_YSjWpWwSwp30UiGOt2NO1sdyvbOnImx6riDg4O7Wob',
          },
          receiveDataWhenStatusError: true,
        ));
  }

//  static Future<Response> postData() {
//    Map<String, dynamic> data = {
//      "to": "/topics/all",
//      "notification": {
//        "body": "Body of Your Notification",
//        "title": "Title of Your Notification"
//      }
//    };
//    return dio!.post('send',data: data);
//  }

  static Future<bool> postData(person,fileName) async {

    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to" :"/topics/all",
      "notification" : {
        "title": '${person} Added New File',
        "body" : '${fileName}',
      },
      "android":{
        "priority":'HIGH',
        "notification":{
          "notification_priority":'PRIORITY_MAX',
          "sound":'default',
          "default_sound":true,
          "default_vibrate_timings":true,
          "default_light_settings":true,
        },
      },
      "data":{
        "type":'order',
        "id":"87",
        "click_action":'FLUTTER_NOTIFICATION_CLICK'
      }
    };

//    final headers = {
//      'content-type': 'application/json',
//      'Authorization': 'key=AAAAjKncAbo:APA91bHaTfmdijQ7lQRxxO1sxatGkRuT-nlCMjzup6OIL3JQmAgTWuCQ-52EMvNw7rZSAZ3dkMXr2e4qiHCk00Iv5aikRwwX0_YSjWpWwSwp30UiGOt2NO1sdyvbOnImx6riDg4O7Wob' // 'key=YOUR_SERVER_KEY'
//    };

    final response = await dio!.post(postUrl,
        data:data);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}