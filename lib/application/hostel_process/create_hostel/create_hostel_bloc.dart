import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gecw_lakx/domain/core/formfailures.dart';
import 'package:gecw_lakx/domain/core/location_fetch_failures.dart';
import 'package:gecw_lakx/domain/hostel_process/i_hostel_process_facade.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'create_hostel_event.dart';
part 'create_hostel_state.dart';
part 'create_hostel_bloc.freezed.dart';

@injectable
class CreateHostelBloc extends Bloc<CreateHostelEvent, CreateHostelState> {
  final IHostelProcessFacade iHostelFacade;
  CreateHostelBloc(this.iHostelFacade) : super(CreateHostelState.initial()) {
    on<CreateHostelEvent>((event, emit) async {
      await event.map(findLocationButtonPressed: (value) async {
        emit(state.copyWith(isSubmitting: true, locationOption: none()));

        final location = await iHostelFacade.getCurrentLocation();

        location.fold((f) {
          emit(state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            locationOption: some(left(f)),
            submitFailureOrSuccessOption: none(),
          ));
        }, (s) {
          emit(state.copyWith(
              locationFetched: true,
              location: s,
              isSubmitting: false,
              submitFailureOrSuccessOption: none(),
              locationOption: some(right(s))));
        });
      }, submitButtonPressed: (value) async {
        emit(state.copyWith(
          isSubmitting: true,
          submitFailureOrSuccessOption: none(),
        ));

        print(
            "in bloc call : ${value.distFromCollege} and ${value.isMessAvailable}");
        final resp = await iHostelFacade.saveDataToDb(
          hostelName: value.hostelName,
          ownerName: value.ownerName,
          phoneNumber: value.phoneNumber,
          rent: value.rent,
          rooms: value.rooms,
          location: value.location,
          // personsPerRoom: value.personsPerRoom,
          vacancy: value.vacancy,
          description: value.description,
          distFromCollege: value.distFromCollege,
          isMessAvailable: value.isMessAvailable,
          hostelImages: value.hostelImages,
        );

        resp.fold((f) {
          emit(state.copyWith(
              showErrorMessages: true,
              isSubmitting: false,
              submitFailureOrSuccessOption: some(left(f))));
        }, (s) {
          emit(state.copyWith(
              isSubmitting: false,
              submitFailureOrSuccessOption: some(right(s))));
        });
      });
    });
  }
}



// hostelNameChangedEvent: (value) {},
      // ownerNameChangedEvent: (value) {},
      // phoneNumberChangedEvent: (value) {},
      // rentChangedEvent: (value) {},
      // roomsChangedEvent: (value) {},
      // personsPerRoomChangedEvent: (value) {},
      // vacancyChangedEvent: (value) {},
      // discriptionChangedEvent: (value) {});