class SelectedUser {
  static UserInfoModel? user;
}

class UserInfoModel {
  String uid;
  String phoneNumber;
  String name;
  String photo;
  List<dynamic> recommendedRestaurant;

  UserInfoModel({
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.uid,
    required this.recommendedRestaurant,
  });
}
