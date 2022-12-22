class restaurantModel {
  String resId;
  List<dynamic> photos;
  String category;
  String description;
  String location;
  String phoneNumber;
  String name;
  String priceAvg;

  restaurantModel({
    required this.resId,
    required this.photos,
    required this.description,
    required this.category,
    required this.location,
    required this.phoneNumber,
    required this.name,
    required this.priceAvg,
  });
}
