import 'dart:io';

import 'package:cinemastation/data/repositories/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserWebservice {
  final Sharedprefs sharedprefs;

  UserWebservice(this.sharedprefs);

  Future<bool> addUser(
      String name, String address, String phoneNumber, File image) async {
    final prefs = await sharedprefs.retrieveData();
    final uid = prefs['userId'];
    final token = prefs['token'];
    final url =
        'https://cinema-station-default-rtdb.firebaseio.com//users/$uid.json?auth=$token';
    basename(image.path);
    try {
      final imageUrl = uploadPic(image);

      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'name': name,
            'address': address,
            'phoneNumber': phoneNumber,
            'imageUrl': imageUrl,
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> uploadPic(File image) async {
    final prefs = await sharedprefs.retrieveData();
    final uid = prefs['userId'];
    String fileName = basename(image.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('userProfile/$uid/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<bool> editUser(
    String name,
    String address,
    String phoneNumber,
  ) async {
    final prefs = await sharedprefs.retrieveData();
    final uid = prefs['userId'];
    final token = prefs['token'];
    try {
      final url =
          'https://cinema-station-default-rtdb.firebaseio.com/users/$uid.json?auth=$token';
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode(
            {'name': name, 'address': address, 'phoneNumber': phoneNumber}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> editUserPhoto(File image) async {
    final prefs = await sharedprefs.retrieveData();
    final uid = prefs['userId'];
    final token = prefs['token'];
    try {
      final String imageUrl = await uploadPic(image);
      final url =
          'https://cinema-station-default-rtdb.firebaseio.com/users/$uid.json?auth=$token';
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({'imageUrl': imageUrl}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> retrieveUser() async {
    final prefs = await sharedprefs.retrieveData();
    final uid = prefs['userId'];
    final token = prefs['token'];
    final url =
        'https://cinema-station-default-rtdb.firebaseio.com//users/$uid.json?auth=$token';

    try {
      final response = await http.get(Uri.parse(url));

      final data = json.decode(response.body);
      if (data != null) {
        return data;
      } else {
        return {};
      }
    } catch (error) {
      rethrow;
    }
  }
}
