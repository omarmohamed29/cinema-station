import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../global/constants.dart';
import '../../logic/cubit/global_tasks/auth_cubit.dart';
import '../../logic/cubit/user_cubit.dart';

Widget menuDialog(context, String uid) {
  Future<void> getUser() async {
    BlocProvider.of<UserCubit>(context).retrieveDietData();
  }

  Future<void> refresh() async {
    await getUser();
  }

  return BlocBuilder<UserCubit, UserState>(
    builder: (context, state) {
      if (state is UserRetrieved) {
        return InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    alignment: Alignment.center,
                    elevation: 2.22,
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Transform.rotate(
                                angle: 40,
                                child: IconButton(
                                  splashRadius: 15,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.add,
                                      size: 30, color: Colors.grey),
                                ),
                              ),
                              const Spacer(flex: 1),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Main navigation",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: mainFont,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          ?.color),
                                ),
                              ),
                              IconButton(
                                splashRadius: 15,
                                onPressed: () async {
                                  await refresh();
                                },
                                icon: const Icon(Icons.refresh,
                                    size: 20, color: Colors.grey),
                              )
                            ],
                          ),
                          ExpansionTile(
                            iconColor: const Color(mainColor),
                            leading: CircleAvatar(
                              radius: 20.0,
                              backgroundImage: NetworkImage(
                                  (state).user.imageUrl.toString()),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(
                              (state).user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.color),
                            ),
                            subtitle: Text(
                              "id: $uid",
                              style: TextStyle(
                                  fontFamily: mainFont,
                                  fontSize: 8,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.color),
                            ),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: ListTile(
                                  leading: Icon(
                                    size: 18,
                                    Icons.phone_android_rounded,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  title: Text(
                                    "phone number: ${(state).user.phoneNumber}",
                                    style: TextStyle(
                                        fontFamily: mainFont,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            ?.color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: ListTile(
                                  leading: Icon(
                                    size: 18,
                                    Icons.location_city_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  title: Text(
                                    "address: ${(state).user.address}",
                                    style: TextStyle(
                                        fontFamily: mainFont,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            ?.color),
                                  ),
                                ),
                              )
                            ],
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.edit,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Manage your account",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.color),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, manageAccount);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.notifications,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Notifications",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.color),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.settings,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Settings",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.color),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, settingsScreen);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.help_center_rounded,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Help & feedback",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.color),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.logout,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Logout",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: mainFont,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.color),
                            ),
                            onTap: () {
                              BlocProvider.of<AuthCubit>(context).logout();
                              Navigator.pushReplacementNamed(
                                  context, splashScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 17.0,
              backgroundImage: NetworkImage((state).user.imageUrl.toString()),
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      } else {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 17.0,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png"),
            backgroundColor: Colors.transparent,
          ),
        );
      }
    },
  );
}
