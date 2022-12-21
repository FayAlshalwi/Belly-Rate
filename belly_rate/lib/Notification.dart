import 'package:awesome_notifications/awesome_notifications.dart';
import 'utilities.dart';

Future<void> createPlantFoodNotification(String notificationcontent  ) async {
  print('Dalalllllllll');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title:
          '${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
      body: 'Florist at 123 Main St. has 2 in stock',
      //bigPicture: '/Users/dalalgheshiyan/Desktop/Belly-Rate/belly_rate/asset/notification_map.png',
      //notificationLayout: NotificationLayout.BigPicture,
    ),
  );
  print('Dalal2');
}

