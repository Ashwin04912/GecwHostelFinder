part of 'create_hostel_bloc.dart';

@freezed
class CreateHostelEvent with _$CreateHostelEvent {
  const factory CreateHostelEvent.findLocationButtonPressed() =
      _findLocationButtonPressed;

  const factory CreateHostelEvent.submitButtonPressed({
    required String hostelName,
    required String ownerName,
    required String phoneNumber,
    required String rent,
    required String rooms,
    required Position location,
    // required String personsPerRoom,
    required String vacancy,
    required String description,
    required String distFromCollege,
    required String isMessAvailable,
    required List<XFile> hostelImages,
  }) = _submitButtonPressed;
}


  // const factory CreateHostelEvent.hostelNameChangedEvent() = _hostelNameChangedEvent;
  // const factory CreateHostelEvent.ownerNameChangedEvent() = _ownerNameChangedEvent;
  // const factory CreateHostelEvent.phoneNumberChangedEvent() = _phoneNumberChangedEvent;
  // const factory CreateHostelEvent.rentChangedEvent() = _rentChangedEvent;
  // const factory CreateHostelEvent.roomsChangedEvent() = _roomsChangedEvent;
  // const factory CreateHostelEvent.personsPerRoomChangedEvent() = _PersonsPerRoomChangedEvent;
  // const factory CreateHostelEvent.vacancyChangedEvent() = _vacancyChangedEvent;
  // const factory CreateHostelEvent.discriptionChangedEvent() = _discriptionChangedEvent;

