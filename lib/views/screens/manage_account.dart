import 'dart:io';

import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key? key}) : super(key: key);

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  File? image;
  bool isLoading = false;

  Future<void> getUser() async {
    await BlocProvider.of<UserCubit>(context).retrieveDietData();
  }

  Future pickImage(ImageSource source, context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
      Navigator.pop(context);
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).dialogBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 2,
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
                        pickImage(ImageSource.gallery, context);
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
                        pickImage(ImageSource.camera, context);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> personalInfoFill() async {
    if (_personalFormKey.currentState!.validate()) {
      _personalFormKey.currentState!.save();
      try {
        isLoading = true;
        await BlocProvider.of<UserCubit>(context)
            .editUserData(name.text, address.text, phoneNumber.text);
        await getUser();
      } catch (error) {
        isLoading = false;
        rethrow;
      }
      isLoading = false;
    }
  }

  Future<void> uploadPic(File newImage) async {
    if (image != null) {
      try {
        isLoading = true;
        await BlocProvider.of<UserCubit>(context).editUserPicture(newImage);
        await getUser();
      } catch (error) {
        isLoading = false;
        rethrow;
      }
    }
    isLoading = false;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(builder: (context, state) {
      if (state is UserRetrieved) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              "Manage your account ",
              style: TextStyle(
                color: Theme.of(context).textTheme.headline2?.color,
                fontFamily: "Montserrat-Light",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
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
                        "Manage your personal information",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline2!.color,
                            fontSize: 20,
                            fontFamily: mainFont),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Here you can change your personal information , change your profile picture",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: mainFont),
                      ),
                      const SizedBox(
                        height: 60,
                      ),

                      image != null
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
                                        image: FileImage(image!),
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
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.darken),
                                        image:
                                            NetworkImage((state).user.imageUrl),
                                        fit: BoxFit.contain),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 30,
                                    color: Color(mainColor),
                                  ),
                                ),
                              ),
                            ),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            image != null ? uploadPic(image!) : null;
                          },
                          child: isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: SpinKitChasingDots(
                                    color: Color(mainColor),
                                    size: 12,
                                  ),
                                )
                              : const Text(
                                  "Change profile picture",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: mainFont),
                                ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      //name
                      TextFormField(
                        initialValue: (state).user.name.toString(),
                        style: const TextStyle(
                          fontFamily: mainFont,
                        ),
                        keyboardType: TextInputType.name,
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
                              borderSide: BorderSide(
                                  width: 1, color: Color(mainColor))),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: Color(mainColor))),
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
                        initialValue: (state).user.phoneNumber.toString(),
                        style: const TextStyle(
                          fontFamily: mainFont,
                        ),
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
                              borderSide: BorderSide(
                                  width: 1, color: Color(mainColor))),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: Color(mainColor))),
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
                        initialValue: (state).user.address.toString(),
                        style: const TextStyle(
                          fontFamily: mainFont,
                        ),
                        keyboardType: TextInputType.text,
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
                              borderSide: BorderSide(
                                  width: 1, color: Color(mainColor))),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: Color(mainColor))),
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
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 60),
                        ),
                        onPressed: personalInfoFill,
                        child: isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: SpinKitChasingDots(
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : const Text(
                                'Save',
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
      } else if (state is UserInitial) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: const Center(
            child: SpinKitChasingDots(
              color: Color(mainColor),
              size: 20,
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: const Center(
            child: SpinKitChasingDots(
              color: Color(mainColor),
              size: 20,
            ),
          ),
        );
      }
    }, listener: (context, state) {
      if (state is UserEdited) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.6),
          content: Text(
            (state).response.toString(),
            style: TextStyle(
                color: Theme.of(context).textTheme.headline2?.color,
                fontSize: 15,
                fontFamily: mainFont),
          ),
        ));
      } else if (state is UserProfileEdited) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.6),
          content: Text(
            (state).response.toString(),
            style: TextStyle(
                color: Theme.of(context).textTheme.headline2?.color,
                fontSize: 15,
                fontFamily: mainFont),
          ),
        ));
      } else if (state is UserError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.6),
          content: Text(
            (state).response.toString(),
            style: TextStyle(
                color: Theme.of(context).textTheme.headline2?.color,
                fontSize: 15,
                fontFamily: mainFont),
          ),
        ));
      }
    });
  }
}
