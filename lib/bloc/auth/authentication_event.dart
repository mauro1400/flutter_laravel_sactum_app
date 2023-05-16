part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthenticationEvent {
  const LogoutEvent();
  @override
  List<Object> get props => [];
}

class SendUbicacionEvent extends AuthenticationEvent {
  final String latitud;
  final String longitud;

  const SendUbicacionEvent({required this.latitud, required this.longitud});

  @override
  List<Object> get props => [latitud, longitud];
}
