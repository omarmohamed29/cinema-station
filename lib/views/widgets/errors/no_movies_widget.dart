import 'package:cinemastation/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget noMovies(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Something went wrong please check your internet connection then try again ',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).textTheme.headline2?.color,
          fontFamily: mainFont,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      const SpinKitChasingDots(
        size: 25,
        color: Color(mainColor),
      )
    ],
  );
}
