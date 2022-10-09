import 'dart:io';

import 'package:cinemastation/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  File? image;
  bool noImage = false;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future selectImage() async {
    return await showModalBottomSheet<void>(
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black38,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.upload_file,
                          size: 25,
                          color: Colors.grey,
                        ),
                        title: const Text(
                          'Pick from gallery',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 25,
                              fontFamily: mainFont),
                        ),
                        onTap: () {
                          pickImage(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.camera_alt_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                        title: const Text(
                          'Capture using camera',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 25,
                              fontFamily: mainFont),
                        ),
                        onTap: () {
                          pickImage(ImageSource.camera);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> personalInfoFill() async {
    if (_personalFormKey.currentState!.validate()) {
      _personalFormKey.currentState!.save();

      Navigator.pushNamed(context, signUpScreen, arguments: {
        'name': name.text,
        'phoneNumber': phoneNumber.text,
        'address': address.text,
        'image': image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _personalFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal information",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline2!.color,
                        fontSize: 25,
                        fontFamily: mainFont),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Let's know you better , this basic information is used to improve youre experience",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 15, fontFamily: mainFont),
                  ),
                  const SizedBox(
                    height: 60,
                  ),

                  image == null
                      ? GestureDetector(
                          onTap: selectImage,
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: image == null
                                        ? Colors.red
                                        : Colors.grey,
                                    width: 1),
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.7),
                                        BlendMode.darken),
                                    image: const AssetImage(
                                        'assets/images/no_profile.jpg'),
                                    fit: BoxFit.contain),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: selectImage,
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: image == null
                                        ? Colors.red
                                        : Colors.grey,
                                    width: 1),
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: FileImage(image!),
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(
                    height: 30,
                  ),
                  //name
                  TextFormField(
                    style: const TextStyle(
                      fontFamily: mainFont,
                    ),
                    keyboardType: TextInputType.name,
                    controller: name,
                    validator: (value) {
                      if (value!.isEmpty || value.contains('@')) {
                        return 'this is not a valid name';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      name.text = input.toString();
                    },
                    decoration: const InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(mainColor))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: Color(mainColor))),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Colors.grey)),
                      hintText: "Name ",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //phone
                  TextFormField(
                    style: const TextStyle(
                      fontFamily: mainFont,
                    ),
                    controller: phoneNumber,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 11) {
                        return 'This is not  a valid phone number ';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      phoneNumber.text = input.toString();
                    },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(mainColor))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: Color(mainColor))),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Colors.grey)),
                      hintText: "Phone Number",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //address
                  TextFormField(
                    style: const TextStyle(
                      fontFamily: mainFont,
                    ),
                    keyboardType: TextInputType.text,
                    controller: address,
                    validator: (value) {
                      if (value!.isEmpty || value.contains('@')) {
                        return 'Address cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      address.text = input.toString();
                    },
                    decoration: const InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(mainColor))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: Color(mainColor))),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Colors.grey)),
                      hintText: "Address ",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shadowColor: const Color(mainColor),
                      backgroundColor: const Color(mainColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(MediaQuery.of(context).size.width, 60),
                    ),
                    onPressed: personalInfoFill,
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: mainFont),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
