import 'package:cinemastation/global/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'dynamic_theme_state.dart';

class DynamicThemeCubit extends HydratedCubit<DynamicThemeState> {
  DynamicThemeCubit()
      : super(const DynamicThemeState(theme: AppTheme.darkMode));

  void changeTheme(AppTheme theme) => emit(DynamicThemeState(theme: theme));

  @override
  DynamicThemeState? fromJson(Map<String, dynamic> json) {
    final theme = json['theme'];
    final currentTheme =
        AppTheme.values.firstWhere((element) => element.toString() == theme);
    return DynamicThemeState(theme: currentTheme);
  }

  @override
  Map<String, dynamic>? toJson(state) {
    final theme = {'theme': state.theme.toString()};
    return theme;
  }
}
