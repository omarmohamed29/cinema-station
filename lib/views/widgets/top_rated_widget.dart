import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopRated extends StatefulWidget {
  const TopRated({Key? key}) : super(key: key);

  @override
  State<TopRated> createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator(int numPages) {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 15.0 : 10.0,
      width: isActive ? 15.0 : 10.0,
      decoration: BoxDecoration(
          color: isActive
              ? const Color(mainColor).withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(100))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moviesData = BlocProvider.of<MoviesCubit>(context, listen: false)
        .getMovie()
        .where((element) => double.parse(element.rate.toString()) > 4.0)
        .toList();
    return PageView.builder(
      itemCount: moviesData.length,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      itemBuilder: (context, i) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, movieDetailsScreen,
              arguments: moviesData[i].id);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xCC000000).withOpacity(0.9),
                      const Color(0xCC000000).withOpacity(0.9),
                    ],
                  ),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        moviesData[i].imageName.toString(),
                      ))),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xCC000000).withOpacity(0.4),
                    const Color(0xCC000000).withOpacity(0.4),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        moviesData[i].title.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: mainFont,
                            color: Colors.white,
                            fontSize: 25),
                      ),
                      RatingBarIndicator(
                        rating: double.parse(moviesData[i].rate.toString()),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 12.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(moviesData.length),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
