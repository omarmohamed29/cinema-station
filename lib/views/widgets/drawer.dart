import 'package:cinemastation/global/constants.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<String> titles = [
    'Home',
    'Favourites',
    'History',
    'Current Ticket',
    'Setting',
  ];
  List<bool> isHighLighted = [
    true,
    false,
    false,
    false,
    false,
  ];
  bool isRouteSame = false;
  List<Icon> icon = [
    const Icon(
      Icons.home_outlined,
      color: Color(mainColor),
    ),
    const Icon(
      Icons.favorite_border,
      color: Colors.grey,
    ),
    const Icon(
      Icons.history,
      color: Colors.grey,
    ),
    const Icon(
      Icons.theaters,
      color: Colors.grey,
    ),
    const Icon(
      Icons.settings,
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List drawerFunctions = [
      () {
        Navigator.popUntil(context, (route) {
          if (route.settings.name == homeScreen) {
            isRouteSame = true;
          }
          return true;
        });
        if (!isRouteSame) {
          Navigator.pop(context);
        }
      },
      () {},
      () {},
      () {},
      () {},
    ];
    return SafeArea(
      child: Drawer(
          backgroundColor: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 4),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Transform.rotate(
                      angle: 40,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:
                            const Icon(Icons.add, size: 30, color: Colors.grey),
                      ),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 83,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: titles.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          for (int i = 0; i < isHighLighted.length; i++) {
                            if (index == i) {
                              setState(() {
                                isHighLighted[index] = true;
                              });
                            } else {
                              isHighLighted[index] = false;
                            }
                          }
                        },
                        child: ListTile(
                          leading: icon[index],
                          title: Text(
                            titles[index],
                            style: TextStyle(
                                fontSize: 18,
                                color: isHighLighted[index]
                                    ? const Color(mainColor)
                                    : Colors.grey),
                          ),
                          onTap: drawerFunctions[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
