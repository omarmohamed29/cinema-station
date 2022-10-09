import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../global/constants.dart';

class AllMovies extends StatefulWidget {
  Map<String, dynamic> moviesCustom;

  AllMovies({
    Key? key,
    required this.moviesCustom,
  }) : super(key: key);

  @override
  State<AllMovies> createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  Map<String, dynamic> movieSetting = {};
  @override
  void initState() {
    movieSetting = widget.moviesCustom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final moviesData =
        BlocProvider.of<MoviesCubit>(context, listen: false).getMovie();
    return movieSetting['count'] != 5
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              title: Text(
                "All movies",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2?.color,
                  fontFamily: "Montserrat-Light",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: movieSetting['scroll'] == Axis.horizontal
                      ? movieSetting['scroll']
                      : Axis.vertical,
                  itemCount: moviesData.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, movieDetailsScreen,
                              arguments: moviesData[i].id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            moviesData[i].imageName.toString()),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      moviesData[i].title.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat-Bold",
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.color,
                                          fontSize: 15),
                                    ),
                                    RatingBarIndicator(
                                      rating: double.parse(
                                          moviesData[i].rate.toString()),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 12.0,
                                      direction: Axis.horizontal,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 170,
                                          child: Text(
                                            moviesData[i]
                                                .description
                                                .toString(),
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat-Light",
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.color
                                                    ?.withOpacity(0.5),
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            i == 4 && movieSetting['count'] == 5
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Center(
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.chevron_right,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline2
                                                    ?.color,
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, allMovies,
                                                    arguments: {
                                                      'scroll': Axis.vertical,
                                                      'count': i
                                                    });
                                              }),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 0.1,
                                  )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: movieSetting['scroll'] == Axis.horizontal
                    ? movieSetting['scroll']
                    : Axis.vertical,
                itemCount: movieSetting['count'],
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, movieDetailsScreen,
                            arguments: moviesData[i].id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          moviesData[i].imageName.toString()),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    moviesData[i].title.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-Bold",
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            ?.color,
                                        fontSize: 15),
                                  ),
                                  RatingBarIndicator(
                                    rating: double.parse(
                                        moviesData[i].rate.toString()),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    direction: Axis.horizontal,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 170,
                                        child: Text(
                                          moviesData[i].description.toString(),
                                          maxLines: 5,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat-Light",
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.color
                                                  ?.withOpacity(0.5),
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          i == 4 && movieSetting['count'] == 5
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.chevron_right,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  ?.color,
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, allMovies,
                                                  arguments: {
                                                    'scroll': Axis.vertical,
                                                    'count': i
                                                  });
                                            }),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 0.1,
                                )
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}
