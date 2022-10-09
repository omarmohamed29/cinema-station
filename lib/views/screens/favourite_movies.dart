import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:cinemastation/views/widgets/errors/no_favourites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  Future<void> getFavourites() async {
    await BlocProvider.of<MoviesCubit>(context).retrieveProducts();
  }

  Future<String> refresh() async {
    getFavourites();

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Favourites",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline2?.color,
            fontFamily: "Montserrat-Light",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        color: const Color(mainColor),
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if (state is MoviesRetrieved) {
              final favourites = (state)
                  .movies
                  .where((element) => element.isFavourite == true)
                  .toList();
              if (favourites.isNotEmpty) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: favourites.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(cardColor)
                              : Theme.of(context)
                                  .bottomSheetTheme
                                  .backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(favourites[i].imageName.toString()),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                          favourites[i].title.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Bold",
                              color:
                                  Theme.of(context).textTheme.headline2?.color,
                              fontSize: 13),
                        ),
                        subtitle: RatingBarIndicator(
                          rating: double.parse(favourites[i].rate.toString()),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12.0,
                          direction: Axis.horizontal,
                        ),
                        trailing: TextButton(
                          child: const Text(
                            "Remove",
                            style: TextStyle(
                                fontFamily: "Montserrat-Light",
                                fontSize: 13,
                                color: Color(mainColor)),
                          ),
                          onPressed: () async {
                            BlocProvider.of<MoviesCubit>(context)
                                .removeFav(favourites[i].id.toString());

                            getFavourites();
                          },
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return noFavourites(context);
              }
            } else if (state is MoviesInitial) {
              return const Center(
                child: SpinKitChasingDots(
                  size: 25,
                  color: Color(mainColor),
                ),
              );
            } else if (state is FavRemoved) {
              return const Center(
                child: SpinKitChasingDots(
                  size: 25,
                  color: Color(mainColor),
                ),
              );
            } else {
              return noFavourites(context);
            }
          },
        ),
      ),
    );
  }
}
