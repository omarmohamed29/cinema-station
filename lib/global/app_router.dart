import 'package:cinemastation/data/api/movie_status_webservice.dart';
import 'package:cinemastation/data/api/movies_webservice.dart';
import 'package:cinemastation/data/api/reservation_webservice.dart';
import 'package:cinemastation/data/api/user_webservice.dart';
import 'package:cinemastation/data/repositories/movie_status_repo.dart';
import 'package:cinemastation/data/repositories/movies_repo.dart';
import 'package:cinemastation/data/repositories/reservation_repo.dart';
import 'package:cinemastation/data/repositories/seats_repo.dart';
import 'package:cinemastation/data/repositories/shared_prefs.dart';
import 'package:cinemastation/data/repositories/user_repository.dart';
import 'package:cinemastation/global/constants.dart';
import 'package:cinemastation/logic/cubit/global_tasks/dynamic_theme_cubit.dart';
import 'package:cinemastation/logic/cubit/movie_status_cubit.dart';
import 'package:cinemastation/logic/cubit/movies_cubit.dart';
import 'package:cinemastation/logic/cubit/reservation_cubit.dart';
import 'package:cinemastation/logic/cubit/seats_cubit.dart';
import 'package:cinemastation/logic/cubit/user_cubit.dart';
import 'package:cinemastation/views/screens/current_ticket.dart';
import 'package:cinemastation/views/screens/home_movies.dart';
import 'package:cinemastation/views/screens/home_screen.dart';
import 'package:cinemastation/views/screens/latest_movies.dart';
import 'package:cinemastation/views/screens/manage_account.dart';
import 'package:cinemastation/views/screens/movie_details_screen.dart';
import 'package:cinemastation/views/screens/movie_reservation_screen.dart';
import 'package:cinemastation/views/screens/settings_screen.dart';
import 'package:cinemastation/views/screens/start/personal_info_screen.dart';
import 'package:cinemastation/views/widgets/allmovies_widget.dart';
import 'package:cinemastation/views/widgets/bottom_bar.dart';
import 'package:cinemastation/views/widgets/movie_reservation/reservation_chairs.dart';
import 'package:cinemastation/views/widgets/stories_viewer_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/screens/start/onboard.dart';
import '../views/screens/start/signin_screen.dart';
import '../views/screens/start/signup_screen.dart';
import '../views/screens/start/splash_screen.dart';

class AppRouter {
  final MoviesCubit moviesCubit = MoviesCubit(
      MoviesRepo(MoviesWebService(Sharedprefs())),
      MoviesWebService(Sharedprefs()));
  final UserCubit userCubit = UserCubit(
      UserRepo(UserWebservice(Sharedprefs())), UserWebservice(Sharedprefs()));
  final MovieStatusCubit movieStatusCubit = MovieStatusCubit(
      MovieStatusWebService(Sharedprefs()),
      MovieStatusRepo(MovieStatusWebService(Sharedprefs())));
  final SeatsCubit seatsCubit = SeatsCubit(SeatsRepo());

  final ReservationCubit reservationCubit = ReservationCubit(
      ReservationWebservice(Sharedprefs()),
      ReservationRepo(ReservationWebservice(Sharedprefs())));

  Route? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case onBoard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnBoarding());

      case signInScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignIn());

      case personalInfo:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PersonalInfo());

      case signUpScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (BuildContext context) => SignUp(
                    personalData: args,
                  ));
        } else {
          return MaterialPageRoute(
              builder: (BuildContext context) => const PersonalInfo());
        }

      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: moviesCubit,
            child: const HomePage(),
          ),
        );

      case bottomBar:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: moviesCubit,
                    ),
                    BlocProvider.value(
                      value: reservationCubit,
                    ),
                    BlocProvider.value(
                      value: seatsCubit,
                    ),
                  ],
                  child: const BottomBar(),
                ));

      case latestMovies:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LatestMovies());

      case allMovies:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: moviesCubit,
              child: AllMovies(
                moviesCustom: args,
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (BuildContext context) => const HomeMovies());
        }

      case stroyViewer:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: moviesCubit,
              child: StoryViewer(
                storyId: args,
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (BuildContext context) => const HomeMovies());
        }

      case manageAccount:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: userCubit,
            child: const ManageAccount(),
          ),
        );

      case settingsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: DynamicThemeCubit(),
            child: const SettingsScreen(),
          ),
        );

      case movieDetailsScreen:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: moviesCubit,
              child: MovieDetailsScreen(
                movieId: args,
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (BuildContext context) => const HomeMovies());
        }

      case movieReservationScreen:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: movieStatusCubit,
                ),
                BlocProvider.value(
                  value: moviesCubit,
                ),
                BlocProvider.value(
                  value: seatsCubit,
                ),
                BlocProvider.value(
                  value: reservationCubit,
                ),
              ],
              child: MovieReservation(
                movieId: args,
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (BuildContext context) => const HomeMovies());
        }

      case reservationWidget:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: movieStatusCubit,
                      ),
                      BlocProvider.value(
                        value: moviesCubit,
                      ),
                      BlocProvider.value(
                        value: seatsCubit,
                      ),
                      BlocProvider.value(
                        value: reservationCubit,
                      ),
                    ],
                    child: ReservationWidget(
                      movieId: args,
                    ),
                  ));
        } else {
          return MaterialPageRoute(
              builder: (BuildContext context) => const HomeMovies());
        }

      case currentTicket:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: reservationCubit,
            child: const CurrentTicket(),
          ),
        );
      default:
        return null;
    }
  }
}
