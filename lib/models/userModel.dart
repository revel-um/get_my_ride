class UserModel {
  String userId = '';
  String profilePicture = '';
  String phoneNumber = '';
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String age = '';
  String gender = '';
  String latitude = '';
  String longitude = '';
  String address = '';


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
