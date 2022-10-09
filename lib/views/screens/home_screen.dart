import 'package:cinemastation/data/repositories/shared_prefs.dart';
import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/user_cubit.dart';
import 'package:cinemastation/views/screens/home_movies.dart';
import 'package:cinemastation/views/screens/latest_movies.dart';
import 'package:cinemastation/views/widgets/menu_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Sharedprefs sharedprefs = Sharedprefs();
  String uid = '';
  Future<void> getUser() async {
    BlocProvider.of<UserCubit>(context).retrieveDietData();
  }

  Future<void> getShared() async {
    final allPrefs = await sharedprefs.retrieveData();
    setState(() {
      uid = allPrefs['userId'];
    });
  }

  @override
  void initState() {
    getShared();
    getUser();
    super.initState();
  }

  Future<void> refresh() async {
    await getUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.headline2?.color),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Cinema",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2?.color,
                    fontFamily: "Montserrat-Light",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Text(
                  "Station",
                  style: TextStyle(
                    color: Color(mainColor),
                    fontFamily: "Montserrat-Light",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            actions: [
              // IconButton(
              //     splashRadius: 25.0,
              //     onPressed: () {
              //       Navigator.pushNamed(context, searchScreen);
              //     },
              //     icon: Icon(
              //       Icons.search_rounded,
              //       size: 30,
              //       color: Theme.of(context).iconTheme.color,
              //     )),
              const SizedBox(
                width: 10,
              ),
              menuDialog(context, uid)
            ],
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
              ),
              indicatorColor: const Color(mainColor),
              dragStartBehavior: DragStartBehavior.start,
              tabs: [
                Tab(
                  child: Text(
                    "Recent",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: mainFont,
                        color: Theme.of(context).textTheme.headline2?.color),
                  ),
                ),
                Tab(
                  child: Text(
                    "Home",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: mainFont,
                        color: Theme.of(context).textTheme.headline2?.color),
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [LatestMovies(), HomeMovies()],
          ),
        ));
  }
}
