import 'package:barcode_widget/barcode_widget.dart';
import 'package:cinemastation/data/model/movie_model.dart';
import 'package:cinemastation/data/model/seats_model.dart';
import 'package:cinemastation/logic/cubit/movie_status_cubit.dart';
import 'package:cinemastation/logic/cubit/reservation_cubit.dart';
import 'package:cinemastation/logic/cubit/seats_cubit.dart';
import 'package:cinemastation/views/widgets/movie_reservation/reservation_chairs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../global/constants.dart';

Future<Widget> reservationBottomSheet(
  context,
  MovieModel movie,
  String selectedDate,
  String selectedTime,
) async {
  final seats = BlocProvider.of<SeatsCubit>(context);
  bool isLoading = false;

  Future<void> _confirmReservation(String title, List<SeatModel> localSeats,
      String image, String ticketId) async {
    try {
      isLoading = true;
      await BlocProvider.of<MovieStatusCubit>(context).addMovieStatus(
          movie.id.toString(), title, selectedDate, selectedTime, localSeats);
      await BlocProvider.of<ReservationCubit>(context).addReservation(
          movie.id.toString(),
          title,
          selectedDate,
          selectedTime,
          localSeats,
          image,
          ticketId);
    } catch (e) {
      rethrow;
    }

    isLoading = false;
  }

  ListView _seatsNames() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: seats.seatsRepo.seats.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, i) => Text(
              "${seats.seatsRepo.seats[i].seatName} - ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: mainFont,
                  color: Colors.black,
                  fontSize: 16),
            ));
  }

  ListView _seatsRow() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: seats.seatsRepo.seats.length,
        itemBuilder: (ctx, i) => Text(
              "${seats.seatsRepo.seats[i].verticalPoint.toString()} - ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: mainFont,
                  color: Colors.black,
                  fontSize: 16),
            ));
  }

  return await showModalBottomSheet(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            snap: true,
            expand: false,
            maxChildSize: 0.8,
            builder: (context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  controller: scrollController,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "My Ticket",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: mainFont,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .color,
                                    fontSize: 25),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: ClipPath(
                                  clipper: TicketsClipper(),
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 3),
                                    width: 250.0,
                                    height: 430.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 180,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(movie
                                                      .imageName
                                                      .toString()),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    Text(
                                                      movie.title.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: titleFont,
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                    const Text(
                                                      "50 EGP",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: titleFont,
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Date :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: titleFont,
                                                        color: Colors.black,
                                                        fontSize: 11),
                                                  ),
                                                  Text(
                                                    selectedDate,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: mainFont,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Time :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: titleFont,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    selectedTime,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: mainFont,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Builder(
                                                builder: (context) => Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            10,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                const Text(
                                                                  "Row",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          titleFont,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          11),
                                                                ),
                                                                SizedBox(
                                                                    height: 50,
                                                                    width: 70,
                                                                    child:
                                                                        _seatsRow())
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                const Text(
                                                                  "Seats",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          titleFont,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          11),
                                                                ),
                                                                SizedBox(
                                                                    height: 50,
                                                                    width: 70,
                                                                    child:
                                                                        _seatsNames())
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          width: 100,
                                                          child: BarcodeWidget(
                                                            barcode: Barcode
                                                                .code128(),
                                                            data: movie.id
                                                                .toString(),
                                                            width: 200,
                                                            height: 50,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: isLoading == false
                                        ? () async {
                                            _confirmReservation(
                                              movie.title.toString(),
                                              seats.seatsRepo.seats,
                                              movie.imageName.toString(),
                                              movie.id.toString(),
                                            );
                                            Navigator.pop(context);
                                          }
                                        : null,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                      child: const Center(
                                          child: Icon(Icons.payment,
                                              size: 25, color: Colors.black)),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                      child: const Center(
                                          child: Icon(
                                        Icons.arrow_upward_outlined,
                                        size: 25,
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      seats.seatsRepo.emptyList();
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                      child: const Center(
                                          child: Icon(
                                        Icons.delete,
                                        size: 25,
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      });
}
