import 'package:awesome_notifications/awesome_notifications.dart';
import 'utilities.dart';

Future<void> createNotification(String notificationcontent , String resID , String photo  ) async {
  print('Dalalllllllll');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title:
          'New Recommendation!',
      body: '$notificationcontent',
      summary: resID,
      bigPicture: photo,
      notificationLayout: NotificationLayout.BigPicture,
    ),
    
  );
  print('Dalal2');
}

