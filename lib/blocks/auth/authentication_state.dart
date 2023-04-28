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

  const AuthenticationSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class AuthenticationFailure extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  void get error => 'error';
}
