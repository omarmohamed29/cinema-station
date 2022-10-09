import 'package:flutter/material.dart';

import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/views/screens/current_ticket.dart';
import 'package:cinemastation/views/screens/favourite_movies.dart';
import 'package:cinemastation/views/screens/home_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  var pages = [
    const HomePage(),
    const CurrentTicket(),
    const Favourites(),
  ];
  var pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        controller: pageController,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: BottomAppBar(
            elevation: 0.0,
            color: Colors.transparent,
            child: SizedBox(
              height: 75,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 5, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconBottomBar(
                        title: Text(
                          "Home",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: mainFont,
                              fontSize: 10,
                              color:
                                  Theme.of(context).textTheme.headline2?.color),
                        ),
                        icon: selectedIndex == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        selected: selectedIndex == 0,
                        onPressed: () {
                          setState(() {
                            selectedIndex = 0;
                            pageController.animateToPage(selectedIndex,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear);
                          });
                        },
                      ),
                      IconBottomBar(
                        title: Text(
                          "Ticket",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: mainFont,
                              fontSize: 10,
                              color:
                                  Theme.of(context).textTheme.headline2?.color),
                        ),
                        icon: selectedIndex == 1
                            ? Icons.local_movies_rounded
                            : Icons.local_movies_outlined,
                        selected: selectedIndex == 1,
                        onPressed: () {
                          setState(() {
                            selectedIndex = 1;
                            pageController.animateToPage(selectedIndex,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear);
                          });
                        },
                      ),
                      IconBottomBar(
                        title: Text(
                          "Favourite",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: mainFont,
                              fontSize: 10,
                              color:
                                  Theme.of(context).textTheme.headline2?.color),
                        ),
                        icon: selectedIndex == 2
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        selected: selectedIndex == 2,
                        onPressed: () {
                          setState(() {
                            selectedIndex = 21;
                            pageController.animateToPage(selectedIndex,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear);
                          });
                        },
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Text title;
  final Function() onPressed;

  const IconBottomBar({
    Key? key,
    required this.icon,
    required this.selected,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selected
                    ? Theme.of(context).cardColor.withOpacity(0.8)
                    : null),
            child: Center(
              child: Icon(
                icon,
                size: 30,
                color: selected
                    ? const Color(mainColor).withOpacity(0.6)
                    : Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          title,
        ],
      ),
    );
  }
}
