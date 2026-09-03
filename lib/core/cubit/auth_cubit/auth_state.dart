import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final Feature? features;
  AuthAuthenticated(this.user, this.features);
}

class AuthUnauthenticated extends AuthState {}
