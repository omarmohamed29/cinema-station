import 'package:barcode_widget/barcode_widget.dart';
import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/reservation_cubit.dart';
import 'package:cinemastation/views/widgets/movie_reservation/reservation_chairs.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentTicket extends StatefulWidget {
  const CurrentTicket({Key? key}) : super(key: key);

  @override
  State<CurrentTicket> createState() => _CurrentTicketState();
}

class _CurrentTicketState extends State<CurrentTicket> {
  Future<void> getTicket() async {
    BlocProvider.of<ReservationCubit>(context).retrieveTicketData();
  }

  @override
  void initState() {
    getTicket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Current Ticket",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline2?.color,
            fontFamily: "Montserrat-Light",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<ReservationCubit, ReservationState>(
          builder: (context, state) {
        if (state is ReservationRetrieved) {
          ListView _seatsNames() {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: (state).reservation.last.reservedSeats.length,
                itemBuilder: (ctx, i) => Text(
                      "${(state).reservation.last.reservedSeats[i].seatName} - ",
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
                itemCount: (state).reservation.last.reservedSeats.length,
                itemBuilder: (ctx, i) => Text(
                      "${(state).reservation.last.reservedSeats[i].verticalPoint.toString()} - ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: mainFont,
                          color: Colors.black,
                          fontSize: 16),
                    ));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
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
                          Center(
                            child: ClipPath(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              clipper: TicketsClipper(),
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 3),
                                width: 300.0,
                                height: 540.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Theme.of(context)
                                          .bottomSheetTheme
                                          .backgroundColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 380,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20)),
                                          image: DecorationImage(
                                              image: NetworkImage((state)
                                                  .reservation
                                                  .last
                                                  .imageName),
                                              fit: BoxFit.cover)),
                                    ),
                                    const DottedLine(
                                        dashColor: Colors.grey,
                                        dashRadius: 2.0,
                                        lineThickness: 2),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                (state)
                                                    .reservation
                                                    .last
                                                    .movieDate,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: titleFont,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                (state)
                                                    .reservation
                                                    .last
                                                    .movieTime,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: titleFont,
                                                    color: Color(mainColor),
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 11),
                                                        ),
                                                        SizedBox(
                                                            height: 40,
                                                            width: 70,
                                                            child: _seatsRow())
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 11),
                                                        ),
                                                        SizedBox(
                                                            height: 40,
                                                            width: 70,
                                                            child:
                                                                _seatsNames())
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                  width: 200,
                                                  child: BarcodeWidget(
                                                    barcode: Barcode.code128(),
                                                    drawText: false,
                                                    data: (state)
                                                        .reservation
                                                        .last
                                                        .movieId
                                                        .toString(),
                                                    width: 200,
                                                    height: 50,
                                                  ),
                                                )
                                              ])
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
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "Use this barcode to enter cinema , drink coffee get your popcorn and get ready! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: mainFont,
                        color: Theme.of(context).textTheme.headline2?.color,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
