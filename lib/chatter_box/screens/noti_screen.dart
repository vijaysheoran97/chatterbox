import 'package:chatterbox/services/notification_service.dart';

class Noti {
  static imageNotification() async {
    await LocalNotification.showNotification(
        id: 0, title: "Check new message", body: "CINLINE", payload: 'payload');
  }

  static mesNotification() async {
    await LocalNotification.showNotification(
        id: 0, title: "Check new message", body: "CINLINE", payload: 'payload');
  }

  static contactNotification() async {
    await LocalNotification.showNotification(
        id: 0, title: "Check new message", body: "CINLINE", payload: 'payload');
  }

  static audioNotification() async {
    await LocalNotification.showNotification(
        id: 0, title: "Check new message", body: "CINLINE", payload: 'payload');
  }

  static videoNotification() async {
    await LocalNotification.showNotification(
        id: 0, title: "Check new message", body: "CINLINE", payload: 'payload');
  }
}
