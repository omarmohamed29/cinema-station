import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/global_tasks/auth_cubit.dart';
import 'package:cinemastation/logic/cubit/user_cubit.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  Map<String, dynamic> personalData;
  SignUp({
    Key? key,
    required this.personalData,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map<String, String> authData = {'email': '', 'password': ''};
  Map<String, dynamic> personalData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passLook = true;
  bool isLoading = false;
  @override
  void initState() {
    personalData = widget.personalData;
    super.initState();
  }

  Future<void> _authSignUp(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await BlocProvider.of<AuthCubit>(context).authenticate(
            authData['email'].toString(),
            authData['password'].toString(),
            'signUp');

        await BlocProvider.of<UserCubit>(context).addUser(
            personalData['name'],
            personalData['address'],
            personalData['phoneNumber'],
            personalData['image']);
      } catch (error) {
        rethrow;
      }
    } else {
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text(
                      'An error Occured!',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline2?.color,
                        fontFamily: titleFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    content: Text(
                      (state).error,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline2?.color,
                        fontFamily: mainFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Okay',
                          style: TextStyle(
                            color: Color(mainColor),
                            fontFamily: mainFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        } else if (state is AuthSucceed) {
          Navigator.pushReplacementNamed(context, homeScreen);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cinema",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2?.color,
                  fontFamily: mainFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const Text(
                "Station",
                style: TextStyle(
                  color: Color(mainColor),
                  fontFamily: mainFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registration",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline2!.color,
                      fontSize: 25,
                      fontFamily: mainFont),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "let's get some basic info. then we will send OTP to verify",
                  style: TextStyle(
                      color: Colors.grey, fontSize: 15, fontFamily: mainFont),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: mainFont,
                    color: Theme.of(context).textTheme.headline2?.color,
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'this is an Invalid Email  ';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    authData['email'] = input.toString();
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
                        borderSide: BorderSide(width: 0.5, color: Colors.grey)),
                    hintText: "Email ",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: mainFont,
                    color: Theme.of(context).textTheme.headline2?.color,
                  ),
                  // ignore: missing_return
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password cannot be empty ';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    authData['password'] = input.toString();
                  },
                  obscureText: _passLook,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passLook = !_passLook;
                        });
                      },
                      child: Icon(
                        _passLook ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                        color: const Color(mainColor),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(mainColor))),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.0, color: Color(mainColor))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5, color: Colors.grey)),
                    hintText: "Password ",
                  ),
                ),
                const SizedBox(
                  height: 230,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't Have an Account ?   ",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline2?.color,
                        fontFamily: mainFont,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signUp');
                      },
                      child: const Text("SignUp",
                          style: TextStyle(
                            color: Color(mainColor),
                            fontFamily: mainFont,
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  onPressed: () {
                    _authSignUp(context);
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  height: 65,
                  color: const Color(mainColor),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: SpinKitChasingDots(
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : const Text(
                          "Welcome Back !",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: mainFont,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
