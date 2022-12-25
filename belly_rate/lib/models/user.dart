class SelectedUser {
  static UserInfoModel? user;
}

class UserInfoModel {
  String uid;
  String phoneNumber;
  String firstName;
  String lastName;
  String photo;
  List<dynamic> recommendedRestaurant;

  UserInfoModel({
    required this.phoneNumber,
    required this.photo,
    required this.firstName,
    required this.lastName,
    required this.uid,
    required this.recommendedRestaurant,
  });
}
