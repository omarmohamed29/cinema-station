class User {
  late final String name;
  late final String address;
  late final String phoneNumber;
  late final String imageUrl;

  User(
      {required this.name,
      required this.address,
      required this.phoneNumber,
      required this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    imageUrl = json['imageUrl'];
  }
}
