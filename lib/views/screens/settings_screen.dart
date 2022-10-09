import 'package:cinemastation/global/app_theme.dart';
import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/global_tasks/dynamic_theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool system = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline2?.color,
            fontFamily: "Montserrat-Light",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ExpansionTile(
            iconColor: Colors.grey,
            collapsedIconColor: Colors.grey,
            title: Text(
              'General',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: titleFont,
                  color: Theme.of(context).textTheme.headline2?.color),
            ),
            subtitle: Text(
              "Personalize your experience",
              style: TextStyle(
                  fontFamily: mainFont,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.headline6?.color),
            ),
            children: [
              BlocBuilder<DynamicThemeCubit, DynamicThemeState>(
                  builder: (context, state) {
                return ListTile(
                  title: Text(
                    'Theme',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: mainFont,
                        color: Theme.of(context).textTheme.headline2?.color),
                  ),
                  subtitle: Text(
                    state.theme.toString(),
                    style: TextStyle(
                        fontFamily: mainFont,
                        fontSize: 12,
                        color: Theme.of(context).textTheme.headline6?.color),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                              insetPadding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              alignment: Alignment.center,
                              elevation: 2.22,
                              backgroundColor:
                                  Theme.of(context).dialogBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                        title: Text(
                                          'Light',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: mainFont,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  ?.color),
                                        ),
                                        trailing: state.theme.toString() ==
                                                'AppTheme.lightMode'
                                            ? system == false
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Color(mainColor),
                                                    size: 25,
                                                  )
                                                : null
                                            : null,
                                        onTap: () {
                                          context
                                              .read<DynamicThemeCubit>()
                                              .changeTheme(AppTheme.lightMode);

                                          setState(() {
                                            system = false;
                                          });
                                        }),
                                    const Divider(
                                      thickness: 1.0,
                                      height: 8,
                                    ),
                                    ListTile(
                                        title: Text(
                                          'Dark',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: mainFont,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  ?.color),
                                        ),
                                        trailing: state.theme.toString() ==
                                                'AppTheme.darkMode'
                                            ? system == false
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Color(mainColor),
                                                    size: 25,
                                                  )
                                                : null
                                            : null,
                                        onTap: () {
                                          context
                                              .read<DynamicThemeCubit>()
                                              .changeTheme(AppTheme.darkMode);
                                          setState(() {
                                            system = false;
                                          });
                                        }),
                                    // const Divider(
                                    //   thickness: 1.0,
                                    //   height: 8,
                                    // ),
                                    // ListTile(
                                    //     title: Text(
                                    //       'System default',
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontFamily: mainFont,
                                    //           color: Theme.of(context)
                                    //               .textTheme
                                    //               .headline2
                                    //               ?.color),
                                    //     ),
                                    //     trailing: system == true
                                    //         ? const Icon(
                                    //             Icons.check,
                                    //             color: Color(mainColor),
                                    //             size: 25,
                                    //           )
                                    //         : null,
                                    //     onTap: () {
                                    //       ThemeMode.system == ThemeMode.light
                                    //           ? context
                                    //               .read<DynamicThemeCubit>()
                                    //               .changeTheme(
                                    //                   AppTheme.lightMode)
                                    //           : context
                                    //               .read<DynamicThemeCubit>()
                                    //               .changeTheme(
                                    //                   AppTheme.darkMode);

                                    //       setState(() {
                                    //         system = true;
                                    //       });
                                    //     }),
                                  ],
                                ),
                              ),
                            ));
                  },
                );
              }),
              ListTile(
                title: Text(
                  'notifications',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: mainFont,
                      color: Theme.of(context).textTheme.headline2?.color),
                ),
                subtitle: Text(
                  "Manage notifications settings",
                  style: TextStyle(
                      fontFamily: mainFont,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
                onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            iconColor: Colors.grey,
            collapsedIconColor: Colors.grey,
            title: Text(
              'About',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: titleFont,
                  color: Theme.of(context).textTheme.headline2?.color),
            ),
            subtitle: Text(
              "Cinema station, version,rate us , contact us ",
              style: TextStyle(
                  fontFamily: mainFont,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.headline6?.color),
            ),
            children: [
              ListTile(
                leading: Icon(
                  size: 25,
                  Icons.info,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'About cinema station',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: mainFont,
                      color: Theme.of(context).textTheme.headline2?.color),
                ),
                subtitle: Text(
                  "Learn more about our application",
                  style: TextStyle(
                      fontFamily: mainFont,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  size: 25,
                  Icons.rate_review,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Rate us',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: mainFont,
                      color: Theme.of(context).textTheme.headline2?.color),
                ),
                subtitle: Text(
                  "Let us know your feedback",
                  style: TextStyle(
                      fontFamily: mainFont,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  size: 25,
                  Icons.contact_mail,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Contact us',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: mainFont,
                      color: Theme.of(context).textTheme.headline2?.color),
                ),
                subtitle: Text(
                  "contact us any time",
                  style: TextStyle(
                      fontFamily: mainFont,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
                onTap: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Version: 1.0.0',
                  style: TextStyle(
                      fontFamily: mainFont,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
