class UserModel {
  late String userId;
  late String profilePicture;
  late String phoneNumber;
  late String firstName;
  late String middleName;
  late String lastName;
  late String age;
  late String gender;
  late String latitude;
  late String longitude;
  late String address;

  void setUserModelFromJsonBody(user) {
    print(user);
    userId = user['_id'] ?? '';
    profilePicture = user['profilePicture'] ?? '';
    phoneNumber = user['phoneNumber'] ?? '';
    firstName = user['firstName'] ?? '';
    middleName = user['middleName'] ?? '';
    lastName = user['lastName'] ?? '';
    age = user['age'] ?? '';
    gender = user['gender'] ?? '';
    latitude = user['latitude'] ?? '';
    longitude = user['longitude'] ?? '';
    address = user['address'] ?? '';
  }
}
