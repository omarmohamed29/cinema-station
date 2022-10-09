import 'package:cinemastation/data/api/auth_webservice.dart';
import 'package:cinemastation/data/api/user_webservice.dart';
import 'package:cinemastation/data/repositories/auth_repo.dart';
import 'package:cinemastation/data/repositories/user_repository.dart';
import 'package:cinemastation/logic/cubit/global_tasks/auth_cubit.dart';
import 'package:cinemastation/logic/cubit/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cinemastation/global/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'data/repositories/shared_prefs.dart';
import 'global/app_theme.dart';
import 'logic/cubit/global_tasks/dynamic_theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());
  HydratedBlocOverrides.runZoned(
    () => runApp(MyApp(
      appRouter: AppRouter(),
    )),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final AuthCubit authCubit =
      AuthCubit(AuthRepo(AuthWebservice(Sharedprefs())), Sharedprefs());

  final UserCubit userCubit = UserCubit(
      UserRepo(UserWebservice(Sharedprefs())), UserWebservice(Sharedprefs()));
  MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DynamicThemeCubit>(
            create: (context) => DynamicThemeCubit(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => authCubit,
          ),
          BlocProvider<UserCubit>(
            create: (context) => userCubit,
          ),
        ],
        child: BlocBuilder<DynamicThemeCubit, DynamicThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Cinema Station',
              theme: appThemeData[state.theme],
              onGenerateRoute: appRouter.generateRoute,
            );
          },
        ));
  }
}
