import 'package:awesome_notifications/awesome_notifications.dart';
import 'utilities.dart';

Future<void> createNotification(
    String notificationcontent, String resID, String photo, resName) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: 'New Recommendation!',
      //resName,
      body: '$notificationcontent',
      summary: resID,
      //bigPicture: 'asset://assets/notification_map.png',
      //notificationLayout: NotificationLayout.BigPicture,
    ),
  );
  print('Dalal2');
}
