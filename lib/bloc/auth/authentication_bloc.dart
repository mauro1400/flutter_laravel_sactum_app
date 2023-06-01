import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:ruta_bus/utils/constants.dart';

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
        var response = await http.wpost(
          Uri.parse('${url}login'),
          headers: {
            'Accept': 'application/json',
          },
          body: data,
        );
        if (response.statusCode == 200) {
          var token = json.decode(response.body)['token'];
          var idPersona = json.decode(response.body)['user']['id_persona'];
          box.write('token', token);
          box.write('id_persona', idPersona);
          var id = {
            'id_persona': idPersona.toString(),
          };
          var respuesta = await http.wpost(
            Uri.parse('${url}informacionChofer'),
            headers: {
              'Accept': 'application/json',
            },
            body: id,
          );
          if (respuesta.statusCode == 200) {
            var informacionChofer = json
                .decode(respuesta.body)['chofer'][0]['id_transporte']
                .toString();
            box.write('informacionChofer', informacionChofer);
            emit(AuthenticationSuccess(token, informacionChofer));
            print(AuthenticationSuccess(token, informacionChofer));
          }
        } else {
          emit(AuthenticationFailure(
              json.decode(response.body)['errorMessage']));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(
            const AuthenticationFailure('Algo salió mal. Inténtalo de nuevo.'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        var token = box.read('token');

        var response = await http.wpost(
          Uri.parse('${url}logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          // Eliminar los datos de autenticación guardados
          box.remove('token');
          box.remove('informacionChofer');
          emit(AuthenticationInitial());
        } else {
          emit(AuthenticationFailure(
              json.decode(response.body)['errorMessage']));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(
            const AuthenticationFailure('Algo salió mal. Inténtalo de nuevo.'));
      }
    });

    on<SendUbicacionEvent>((event, emit) async {
      var token = box.read('token');
      var idPersona = box.read('id_persona');
      print(idPersona);
      var data = {
        'latitud': event.latitud,
        'longitud': event.longitud,
        'id_persona': idPersona,
      };

      try {
        var response = await http.wpost(
          Uri.parse('${url}ubicacion'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          debugPrint('ubicacion enviada');
          print(data);
        } else {
          emit(UbicacionFailure(json.decode(response.body)['errorMessage']));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(const UbicacionFailure('Algo salió mal. Inténtalo de nuevo.'));
      }
    });
  }
}
