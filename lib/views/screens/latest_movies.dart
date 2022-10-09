import 'dart:async';

import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:cinemastation/logic/cubit/user_cubit.dart';
import 'package:cinemastation/views/widgets/errors/no_movies_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LatestMovies extends StatefulWidget {
  const LatestMovies({Key? key}) : super(key: key);

  @override
  State<LatestMovies> createState() => _LatestMoviesState();
}

class _LatestMoviesState extends State<LatestMovies>
    with AutomaticKeepAliveClientMixin<LatestMovies> {
  Future<void> getMovies() async {
    await BlocProvider.of<MoviesCubit>(context).retrieveProducts();
  }

  Future<void> getUser() async {
    BlocProvider.of<UserCubit>(context).retrieveDietData();
  }

  final PageController ctrl = PageController(viewportFraction: 0.8);

  String activeTag = "Latest";

  int currentPage = 0;
  double _width = 180;

  void time() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _width = 0.0;
      });
    });
  }

  @override
  void initState() {
    getMovies();
    getUser();
    time();
    ctrl.addListener(() {
      int next = ctrl.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        if (state is MoviesRetrieved) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  if (state is UserRetrieved) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 34, right: 35),
                      child: Row(
                        children: [
                          Text(
                            "Welcome ${(state).user.name}",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.color,
                                fontFamily: mainFont,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.wine_bar_rounded,
                            color: Color(mainColor),
                            size: 20,
                          )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, top: 5, right: 35),
                  child: Text(
                    "What would you like to see tonight ? ",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline2?.color,
                        fontFamily: titleFont,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: ctrl,
                        itemCount: 4,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool active = index == currentPage;
                          final double top = active ? 50 : 100;
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, movieDetailsScreen,
                                  arguments: (state).movies[index].id);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubicEmphasized,
                                    margin: EdgeInsets.only(
                                        top: top, bottom: 30, right: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            (state)
                                                .movies[index]
                                                .imageName
                                                .toString(),
                                          )),
                                    ),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Card(
                                              elevation: 0.0,
                                              color: Colors.transparent,
                                              child: IconButton(
                                                icon: Icon(
                                                  (state)
                                                          .movies[index]
                                                          .isFavourite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  BlocProvider.of<MoviesCubit>(
                                                          context)
                                                      .toogleFav(
                                                          (state)
                                                              .movies[index]
                                                              .id
                                                              .toString(),
                                                          (state)
                                                              .movies[index]
                                                              .isFavourite);
                                                  getMovies();
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AnimatedContainer(
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeInOutQuint,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                                height: 30,
                                                width: _width,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Add to favourite",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      RatingBarIndicator(
                                        rating: double.parse((state)
                                            .movies[index]
                                            .rate
                                            .toString()),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 12.0,
                                        direction: Axis.horizontal,
                                      ),
                                      Text(
                                        (state).movies[index].title.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat-Bold",
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                ?.color,
                                            fontSize: 20),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, left: 10, right: 10),
                                        child: Text(
                                          (state)
                                              .movies[index]
                                              .description
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat-Light",
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.color
                                                ?.withOpacity(0.5),
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))
              ],
            ),
          );
        } else if (state is MoviesInitial) {
          return const Center(
            child: SpinKitChasingDots(
              size: 25,
              color: Color(mainColor),
            ),
          );
        } else if (state is FavToggled) {
          return const Center(
            child: SpinKitChasingDots(
              size: 25,
              color: Color(mainColor),
            ),
          );
        } else {
          return noMovies(context);
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
