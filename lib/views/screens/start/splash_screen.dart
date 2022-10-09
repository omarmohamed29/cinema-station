import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/global_tasks/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> autoLogin() async {
    await BlocProvider.of<AuthCubit>(context).tryAutoLogin();
  }

  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
              const SizedBox(
                height: 20,
              ),
              const Center(
                  child: SpinKitCircle(
                color: Color(mainColor),
                size: 25,
              ))
            ],
          )),
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed(onBoard);
        } else if (state is AuthSucceed) {
          Navigator.of(context).pushReplacementNamed(bottomBar);
        }
      },
    );
  }
}
