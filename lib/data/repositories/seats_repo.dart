import 'package:cinemastation/data/model/seats_model.dart';

class SeatsRepo {
  List<SeatModel> _seats = [];

  List<SeatModel> get seats {
    return [..._seats];
  }

  void addToList(int vertical, int horizontal, String seatName, bool status) {
    _seats.add(SeatModel(
        verticalPoint: vertical,
        horizontalPoint: horizontal,
        seatName: seatName,
        status: status));
  }

  void emptyList() {
    _seats.clear();
  }

  void removeItem(index) {
    _seats.removeAt(index);
  }
}
