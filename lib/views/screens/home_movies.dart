import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/views/widgets/allmovies_widget.dart';
import 'package:cinemastation/views/widgets/story_widget.dart';
import 'package:cinemastation/views/widgets/top_rated_widget.dart';
import 'package:flutter/material.dart';

class HomeMovies extends StatefulWidget {
  const HomeMovies({Key? key}) : super(key: key);

  @override
  State<HomeMovies> createState() => _HomeMoviesState();
}

class _HomeMoviesState extends State<HomeMovies>
    with AutomaticKeepAliveClientMixin<HomeMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              "Stories",
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline2?.color,
                  fontFamily: mainFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Stories(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Top rated",
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline2?.color,
                  fontFamily: mainFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: const TopRated(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All movies",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline2?.color,
                      fontFamily: "Montserrat-Light",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: Theme.of(context).textTheme.headline2?.color,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).hoverColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: AllMovies(
                  moviesCustom: const {'scroll': Axis.horizontal, 'count': 5}),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
