import 'package:awesome_notifications/awesome_notifications.dart';
import 'utilities.dart';

Future<void> createPlantFoodNotification(String notificationcontent , String resID  ) async {
  print('Dalalllllllll');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title:
          'New Recommendation!',
      body: '$notificationcontent',
      summary: resID,
      //bigPicture: 'asset://assets/notification_map.png',
      //notificationLayout: NotificationLayout.BigPicture,
    ),
    
  );
  print('Dalal2');
}

