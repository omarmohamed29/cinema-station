import 'package:cinemastation/global/constants.dart';
import 'package:flutter/material.dart';

Widget noFavourites(context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 70,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'you don\'t have any favourite movies yet , try adding some',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              fontFamily: titleFont,
              color: Theme.of(context).textTheme.headline2?.color),
        ),
      ],
    ),
  );
}
