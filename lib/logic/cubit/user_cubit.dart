import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cinemastation/data/api/user_webservice.dart';
import 'package:cinemastation/data/model/user_model.dart';
import 'package:cinemastation/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;
  final UserWebservice userWebservice;
  UserCubit(
    this.userRepo,
    this.userWebservice,
  ) : super(UserInitial());

  Future<void> addUser(
      String name, String address, String phoneNumber, File imageUrl) async {
    await userWebservice
        .addUser(name, address, phoneNumber, imageUrl)
        .then((response) {
      if (response) {
        emit(UserAdded('your data has been added successfully'));
      } else {
        emit(UserError(response.toString()));
      }
    });
  }

  Future<void> retrieveDietData() async {
    await userRepo.retrieveData().then((data) {
      if (data.toString() == {}.toString()) {
        emit(UserError('Something went wrong please try again later'));
      } else {
        emit(UserInitial());
        emit(UserRetrieved(data));
      }
    });
  }

  Future<void> editUserData(
      String name, String address, String phoneNumber) async {
    await userWebservice.editUser(name, address, phoneNumber).then((response) {
      if (response) {
        emit(UserEdited('your data has been added successfully'));
      } else {
        emit(UserError(response.toString()));
      }
    });
  }

  Future<void> editUserPicture(File image) async {
    await userWebservice.editUserPhoto(image).then((response) {
      if (response) {
        emit(UserProfileEdited('your image has been changed successfully'));
      } else {
        emit(UserError(response.toString()));
      }
    });
  }
}
