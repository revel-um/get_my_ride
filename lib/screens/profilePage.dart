import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_bite/components/networkAndFileImage.dart';
import 'package:quick_bite/components/profilePictureListTile.dart';
import 'package:quick_bite/components/profilePictureTextField.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/screens/verification/checkNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController firstNameController = TextEditingController(),
      middleNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      phoneNumberController = TextEditingController();

  var image;


  @override
  void initState() {
    super.initState();
    firstNameController.text = AllData.userModel.firstName;
    middleNameController.text = AllData.userModel.middleName;
    lastNameController.text = AllData.userModel.lastName;
    phoneNumberController.text = AllData.userModel.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: NetworkAndFileImage(
                    imageData: AllData.userModel.profilePicture,
                    height: 80,
                    borderRadius: BorderRadius.circular(100),
                    fit: BoxFit.cover,
                    icon: Icons.person,
                    iconColor: Colors.grey,
                  )),
            ),
            TextButton(
              onPressed: () async{
                await ImagePicker().pickImage(source: ImageSource.gallery);
              },
              child: Text(
                'Remove Profile Picture',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ProfilePictureTextField(
              hint: 'First Name',
              controller: firstNameController,
            ),
            ProfilePictureTextField(
              hint: 'Middle Name',
              controller: middleNameController,
            ),
            ProfilePictureTextField(
              hint: 'Last Name',
              controller: lastNameController,
            ),
            ProfilePictureTextField(
              hint: 'Phone Number',
              controller: phoneNumberController,
              enabled: false,
            ),
            ProfilePictureListTile(
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: Text('Update Phone Number',
                  style: TextStyle(fontSize: 20, fontFamily: 'ZenKurenaido')),
              onPressed: () {},
            ),
            ProfilePictureListTile(
              icon: Icon(
                Icons.location_on_outlined,
                color: Colors.blue,
              ),
              title: Text('Address',
                  style: TextStyle(fontSize: 20, fontFamily: 'ZenKurenaido')),
              onPressed: () {},
            ),
            ProfilePictureListTile(
              icon: Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              title: Text('Logout',
                  style: TextStyle(fontSize: 20, fontFamily: 'ZenKurenaido')),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                pref.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckNumber(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
