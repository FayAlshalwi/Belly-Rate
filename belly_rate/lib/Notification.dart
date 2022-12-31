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
      bigPicture: 'https://firebasestorage.googleapis.com/v0/b/bellyrate.appspot.com/o/images%2Fimage_picker_D134AFF8-A945-48BB-B7B3-9783A7E1F12A-502-000001762F2BACB5.jpg?alt=media&token=2c80c690-eaaa-476d-92ee-e9ba49a04818',
      //bigPicture: 'asset://assets/notification_map.png',
      notificationLayout: NotificationLayout.BigPicture,
    ),
    
  );
  print('Dalal2');
}

