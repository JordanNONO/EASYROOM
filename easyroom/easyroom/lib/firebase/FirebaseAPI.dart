
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification(handler)async{
    await _firebaseMessaging.requestPermission(alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,);
    final FCMtoken = await _firebaseMessaging.getToken();
    print("token $FCMtoken");
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
      handler();
    });

  }
  void _handleMessage(RemoteMessage? message) {
    if(message==null) return;

  }

}