import 'dart:ui';

import 'package:cinemastation/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cinemastation/logic/cubit/movies_cubit.dart';

class StoryViewer extends StatefulWidget {
  final String storyId;

  const StoryViewer({
    Key? key,
    required this.storyId,
  }) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieStory =
        BlocProvider.of<MoviesCubit>(context).findByid(widget.storyId);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Builder(
          builder: (BuildContext context) {
            return SafeArea(
              child: Stack(
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
                              image:
                                  NetworkImage(movieStory.imageName.toString()),
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
                          const Color(0xCC000000).withOpacity(0.7),
                          const Color(0xCC000000).withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        IconButton(
                            icon: const Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context)),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  movieStory.imageName.toString(),
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: const Color(mainColor),
                                width: 1,
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Text(
                                movieStory.title.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat-Light",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 500,
                      width: 300,
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
                              image:
                                  NetworkImage(movieStory.imageName.toString()),
                              fit: BoxFit.cover)),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
