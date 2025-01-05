import 'package:freezed_annotation/freezed_annotation.dart';

 part 'formfailures.freezed.dart';
 
@freezed
abstract class FormFailures with _$FormFailures {
  const factory FormFailures.serverError() = _ServerError;
  const factory FormFailures.serviceUnavailable() = _serviceUnavailable;
  
  
}
