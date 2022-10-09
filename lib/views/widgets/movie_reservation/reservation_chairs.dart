import 'package:cinemastation/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:cinemastation/logic/cubit/movie_status_cubit.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:cinemastation/logic/cubit/seats_cubit.dart';

import 'reservation_bottomsheet.dart';

class ReservationWidget extends StatefulWidget {
  final String movieId;
  const ReservationWidget({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  int dateIndexSelected = 1;
  int timeIndexSelected = 1;
  String selectedDate = '';
  String selectedTime = '';
  var _statusIndex;
  var _statusIndexes;
  String _seatName = '';
  bool isLoading = false;

  Future<void> getStatus() async {
    await BlocProvider.of<MovieStatusCubit>(context)
        .retrieveMovieStatus(widget.movieId);
  }

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  Widget movieStatusBuilder() {
    Size size = MediaQuery.of(context).size;
    final seats = BlocProvider.of<SeatsCubit>(context);
    final getSeats = BlocProvider.of<SeatsCubit>(context).getlocalSeats();

    //Render the Chairs color 'GREEN - GREY  - WHITE'
    Color chairColor(i, x) {
      for (int a = 0; a < getSeats.length; a++) {
        if (seats.seatsRepo.seats[a].verticalPoint == i &&
            seats.seatsRepo.seats[a].horizontalPoint == x) return Colors.green;
      }
      return Colors.white;
    }

    //REMOVE A SELECTED CHAIR FROM THE LIST
    removeItem(i, x) {
      for (int a = 0; a < getSeats.length; a++) {
        if (getSeats[a].verticalPoint == i &&
            getSeats[a].horizontalPoint == x) {
          seats.removeItem(a);
        }
      }
    }

    //moviesStatus that builds the container based on the data come from web
    Widget seatsContainer(i, x) {
      return BlocBuilder<MovieStatusCubit, MovieStatusState>(
          builder: (context, state) {
        if (state is MovieStatusRetrieved) {
          for (int w = 0; w < (state).movieStatus.length; w++) {
            for (int a = 0;
                a < (state).movieStatus[w].returnedSeats.length;
                a++) {
              if ((state).movieStatus[w].returnedSeats[a].verticalPoint == i &&
                  (state).movieStatus[w].returnedSeats[a].horizontalPoint ==
                      x) {
                return Container(
                    height: size.width / 11 - 15,
                    margin: const EdgeInsets.all(5),
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6.0))));
              }
            }
          }
        }
        return Container(
            height: size.width / 11 - 15,
            margin: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  setState(() {
                    _statusIndex = i;
                    _statusIndexes = x;
                    _seatName = 'a$x$i';
                    seats.addToList(
                        _statusIndex, _statusIndexes, _seatName, false);
                  });
                });
              },
              onDoubleTap: () {
                setState(() {
                  removeItem(i, x);
                });
              },
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: chairColor(i, x),
                      borderRadius: BorderRadius.circular(6.0))),
            ));
      });
    }

    return BlocConsumer<MovieStatusCubit, MovieStatusState>(
        listener: (context, state) {
      if (state is MovieStatusAdded) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: const Text(
            "Ticket added to your ticket list ",
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black.withOpacity(0.8),
          action: SnackBarAction(
            label: "Go to",
            textColor: Colors.white,
            onPressed: () {
              seats.emptyList();
              Navigator.pushNamed(context, currentTicket);
            },
          ),
        ));
        getStatus();
      }
    }, builder: (context, state) {
      if (state is MovieStatusRetrieved) {
        return SizedBox(
          child: Column(
            children: [
              for (int i = 0; i < 5; i++)
                SizedBox(
                  child: Row(
                    children: [
                      for (int x = 0; x < 11; x++)
                        Expanded(
                          flex: x == 0 || x == 10 ? 2 : 2,
                          child: (i != 4 && x == 4) || (i != 4 && x == 5)
                              ? Container()
                              : seatsContainer(i, x),
                        )
                    ],
                  ),
                )
            ],
          ),
        );
      } else if (state is MovieStatusInitial) {
        return const Center(
          child: SpinKitChasingDots(
            size: 25,
            color: Color(mainColor),
          ),
        );
      } else {
        return SizedBox(
          child: Column(
            children: [
              for (int i = 0; i < 5; i++)
                SizedBox(
                  child: Row(
                    children: [
                      for (int x = 0; x < 11; x++)
                        Expanded(
                          flex: x == 0 || x == 10 ? 2 : 2,
                          child: (i != 4 && x == 4) || (i != 4 && x == 5)
                              ? Container()
                              : seatsContainer(i, x),
                        )
                    ],
                  ),
                )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        BlocProvider.of<MoviesCubit>(context).findByid(widget.movieId);
    final seats = BlocProvider.of<SeatsCubit>(context);

    setState(() {
      selectedDate = DateFormat.yMMMMEEEEd()
          .format(DateTime.parse(movieDetails.movieDate![0].first));
      selectedTime = DateFormat()
          .add_jm()
          .format(DateTime.parse(movieDetails.movieDate![0].first));
    });
    List<Widget> date = [
      Column(
        children: [
          Text(
            DateFormat('dd')
                .format(DateTime.parse(movieDetails.movieDate![0].first)),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            DateFormat('EEEE')
                .format(DateTime.parse(movieDetails.movieDate![0].first))
                .substring(0, 2),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
        ],
      ),
      Column(
        children: [
          Text(
            DateFormat('dd')
                .format(DateTime.parse(movieDetails.movieDate![0].second)),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            DateFormat('EEEE')
                .format(DateTime.parse(movieDetails.movieDate![0].second))
                .substring(0, 2),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
        ],
      ),
      Column(
        children: [
          Text(
            DateFormat('dd')
                .format(DateTime.parse(movieDetails.movieDate![0].third)),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            DateFormat('EEEE')
                .format(DateTime.parse(movieDetails.movieDate![0].third))
                .substring(0, 2),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
        ],
      ),
      Column(
        children: [
          Text(
            DateFormat('dd')
                .format(DateTime.parse(movieDetails.movieDate![0].fourth)),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            DateFormat('EEEE')
                .format(DateTime.parse(movieDetails.movieDate![0].fourth))
                .substring(0, 2),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
        ],
      ),
    ];
    List<Widget> time = [
      Text(
        DateFormat()
            .add_jm()
            .format(DateTime.parse(movieDetails.movieDate![0].first)),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: mainFont,
            color: Colors.white,
            fontSize: 12),
      ),
      Text(
        DateFormat()
            .add_jm()
            .format(DateTime.parse(movieDetails.movieDate![0].second)),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: mainFont,
            color: Colors.white,
            fontSize: 12),
      ),
      Text(
        DateFormat()
            .add_jm()
            .format(DateTime.parse(movieDetails.movieDate![0].third)),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: mainFont,
            color: Colors.white,
            fontSize: 12),
      ),
      Text(
        DateFormat()
            .add_jm()
            .format(DateTime.parse(movieDetails.movieDate![0].fourth)),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: mainFont,
            color: Colors.white,
            fontSize: 12),
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            dateIndexSelected = i;
                            selectedDate = dateIndexSelected == 0
                                ? selectedDate = DateFormat('dd').format(DateTime.parse(
                                    movieDetails.movieDate![0].first))
                                : dateIndexSelected == 1
                                    ? selectedDate = DateFormat('dd').format(
                                        DateTime.parse(
                                            movieDetails.movieDate![0].second))
                                    : dateIndexSelected == 2
                                        ? selectedDate = DateFormat('dd')
                                            .format(DateTime.parse(movieDetails
                                                .movieDate![0].third))
                                        : selectedDate = DateFormat('dd')
                                            .format(DateTime.parse(
                                                movieDetails.movieDate![0].fourth));
                          });
                        },
                        child: Container(
                            width: 50,
                            height: 60,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: dateIndexSelected == i
                                    ? const Color(mainColor)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: date[i],
                            )),
                      );
                    }),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        timeIndexSelected = i;
                        selectedTime = timeIndexSelected == 0
                            ? DateFormat().add_jm().format(DateTime.parse(
                                movieDetails.movieDate![0].first))
                            : timeIndexSelected == 1
                                ? DateFormat().add_jm().format(DateTime.parse(
                                    movieDetails.movieDate![0].second))
                                : timeIndexSelected == 2
                                    ? DateFormat().add_jm().format(
                                        DateTime.parse(
                                            movieDetails.movieDate![0].third))
                                    : DateFormat().add_jm().format(
                                        DateTime.parse(
                                            movieDetails.movieDate![0].fourth));
                      });
                    },
                    child: Container(
                        width: 100,
                        height: 60,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: timeIndexSelected == i
                                    ? const Color(mainColor)
                                    : Colors.grey),
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: time[i]),
                        )),
                  );
                }),
          ),
        ),
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
            width: MediaQuery.of(context).size.width - 45,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(70.0),
                topLeft: Radius.circular(70.0),
              ),
              gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0, 1]),
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(width: 6.8, color: Colors.white))),
          ),
        ]),
        const SizedBox(
          height: 10,
        ),
        movieStatusBuilder(),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Align(
            alignment: Alignment.center,
            child: MaterialButton(
                color: const Color(mainColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: seats.seatsRepo.seats.isNotEmpty
                    ? () async {
                        reservationBottomSheet(
                            context, movieDetails, selectedDate, selectedTime);
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: seats.seatsRepo.seats.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Get Your Ticket",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: mainFont,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.navigate_next,
                                size: 20, color: Colors.white),
                          ],
                        )
                      : const Text(
                          "Choose seats first",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: mainFont,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                )),
          ),
        )
      ],
    );
  }
}

class TicketsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height / 1.4), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 1.4), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
