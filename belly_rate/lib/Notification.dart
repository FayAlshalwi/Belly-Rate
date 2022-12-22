import 'package:awesome_notifications/awesome_notifications.dart';
import 'utilities.dart';

Future<void> createPlantFoodNotification(String notificationcontent , String resID  ) async {
  print('Dalalllllllll');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title:
          '${Emojis.money_money_bag + Emojis.plant_cactus} Belly Rate Recommendation!',
      body: '$notificationcontent',
      summary: resID,
      //bigPicture: 'asset://assets/notification_map.png',
      //notificationLayout: NotificationLayout.BigPicture,
    ),
    
  );
  print('Dalal2');
}

