import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:cinemastation/data/model/seats_model.dart';
import 'package:cinemastation/data/repositories/seats_repo.dart';

part 'seats_state.dart';

class SeatsCubit extends Cubit<SeatsState> {
  final SeatsRepo seatsRepo;
  SeatsCubit(
    this.seatsRepo,
  ) : super(SeatsInitial());

  void addToList(int vertical, int horizontal, String seatName, bool status) {
    seatsRepo.addToList(vertical, horizontal, seatName, status);
  }

  void emptyList() {
    seatsRepo.emptyList();
  }

  void removeItem(index) {
    seatsRepo.removeItem(index);
  }

  List<SeatModel> getlocalSeats() {
    return seatsRepo.seats;
  }
}
