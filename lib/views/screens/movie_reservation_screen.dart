import 'dart:ui';

import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:cinemastation/views/widgets/movie_reservation/reservation_chairs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieReservation extends StatefulWidget {
  final String movieId;
  const MovieReservation({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieReservation> createState() => _MovieReservationState();
}

class _MovieReservationState extends State<MovieReservation> {
  @override
  Widget build(BuildContext context) {
    final movieDetails =
        BlocProvider.of<MoviesCubit>(context).findByid(widget.movieId);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            movieDetails.title.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: mainFont,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xCC000000).withOpacity(0.9),
                        const Color(0xCC000000).withOpacity(0.9),
                      ],
                    ),
                    image: DecorationImage(
                        image: NetworkImage(movieDetails.imageName.toString()),
                        fit: BoxFit.cover)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withOpacity(0)),
                )),
            Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xCC000000).withOpacity(0.6),
                  const Color(0xCC000000).withOpacity(0.6),
                ],
              ),
            )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100, left: 10),
                      child: const Text(
                        "Make a Reservation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: titleFont,
                            color: Colors.white,
                            fontSize: 22),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.movie_filter_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                movieDetails.title.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: mainFont,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.event_seat,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${movieDetails.numOfSeats} seats",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: mainFont,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReservationWidget(
                      movieId: widget.movieId,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              "Reserved",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              "Selected",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}
