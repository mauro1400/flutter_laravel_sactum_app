part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String token;
  final String informacionChofer;

  const AuthenticationSuccess(this.token,this.informacionChofer);

  @override
  List<Object> get props => [token,informacionChofer];
}

class AuthenticationFailure extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  void get error => 'error';
}

class UbicacionFailure extends AuthenticationState {
  final String errorMessage;

  const UbicacionFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  void get error => 'error';
}

class UbicacionSuccess extends AuthenticationState {}
