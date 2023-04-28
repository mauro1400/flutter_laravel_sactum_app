import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ruta_bus/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final box = GetStorage();
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        var data = {
          'email': event.email,
          'password': event.password,
        };
        var response = await http.post(
          Uri.parse('${url}login'),
          headers: {
            'Accept': 'application/json',
          },
          body: data,
        );
        if (response.statusCode == 200) {
          var token = json.decode(response.body)['token'];
          box.write('token', token);
          emit(AuthenticationSuccess(token));
          print(token);
        } else {
          AuthenticationFailure(json.decode(response.body)['message']);
        }
      } catch (e) {
        debugPrint(e.toString());
        const AuthenticationFailure('Something went wrong. Please try again.');
      }
    });
    on<LogoutEvent>((event, emit) async {
      var token = box.read('token');
      print(token);
      var response = await http.post(
        Uri.parse('${url}logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        box.remove('token');
        emit(AuthenticationInitial());
        print(token);
      } else {
        emit(AuthenticationFailure(json.decode(response.body)['message']));
      }
    });
  }
}
