import 'package:dartz/dartz.dart';
import 'package:gecw_lakx/domain/auth/auth_failures.dart';
import 'package:gecw_lakx/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailures, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
    required String role
  });

  Future<Either<AuthFailures, String>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailures, Unit>> postUserRoleDetailsToDb({
    required String userId,
    required String email,
    required String role,
    required String dispName
  });
}
