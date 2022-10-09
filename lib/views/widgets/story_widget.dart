import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Stories extends StatefulWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  Future<void> getMovies() async {
    await BlocProvider.of<MoviesCubit>(context).retrieveProducts();
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesCubit, MoviesState>(builder: (context, state) {
      if (state is MoviesRetrieved) {
        return SizedBox(
          height: 80,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: (state).movies.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, stroyViewer,
                        arguments: (state).movies[i].id.toString());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              (state).movies[i].imageName.toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color(mainColor),
                            width: 1,
                          )),
                    ),
                  ),
                );
              }),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
