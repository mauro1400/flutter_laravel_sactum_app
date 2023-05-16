import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ruta_bus/bloc/auth/authentication_bloc.dart';
import 'package:ruta_bus/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;

part 'lista_event.dart';
part 'lista_state.dart';

class ListaBloc extends Bloc<ListaEvent, ListaState> {
  final box = GetStorage();
  final BuildContext context;

  ListaBloc(this.context) : super(const ListaInitial()) {
    on<ListaEstudiantesEvent>((event, emit) async {
      var authenticationState =
          BlocProvider.of<AuthenticationBloc>(context).state;
      if (authenticationState is AuthenticationSuccess) {
        var informacionChofer = authenticationState.informacionChofer;
        var idTransporte = informacionChofer;
        try {
          var data = {
            'id_transporte': idTransporte,
          };
          var respuesta = await http.wpost(
            Uri.parse('${url}estudiantes-transporte'),
            headers: {
              'Accept': 'application/json',
            },
            body: data,
          );
          if (respuesta.statusCode == 200) {
            var listaEstudianteJson =
                json.decode(respuesta.body)['datosTransportes'];

            box.write('id_estudiante_transporte', listaEstudianteJson);
            List<Estudiante> estudiantes = [];
            for (var estudianteJson in listaEstudianteJson) {
              Estudiante estudiante = Estudiante(
                id: estudianteJson['id_estudiante_transporte'],
                nombre:
                    '${estudianteJson['id_estudiante_transporte']} - ${estudianteJson['nombres']} ${estudianteJson['primer_apellido']} ${estudianteJson['segundo_apellido']}',
                datos:
                    '${estudianteJson['grado']} - ${estudianteJson['placa']} ${estudianteJson['descripcion']}',
              );
              estudiantes.add(estudiante);
            }
            listaEstudiante = estudiantes;
          } else {
            emit(ListaFailure(json.decode(respuesta.body)['errorMessage']));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit(const ListaFailure('Algo salió mal. Inténtalo de nuevo.'));
        }
      }
    });
    on<LlamarListaEvent>((event, emit) async {
      var listaEstudianteJson = box.read('id_estudiante_transporte');
       var idEstado = 5;
      for (var index = 0; index < listaEstudianteJson.length; index++) {
        var estudianteJson = listaEstudianteJson[index];
        var estado = event.estadosChecklist[index];
        if (estado == true) {
          idEstado = 4;
        }else{
          idEstado = 5;
        }
        try {
          var data = {
            'id_estudiante_transporte':
                estudianteJson['id_estudiante_transporte'].toString(),
            'id_estado': idEstado.toString(),
          };

          var respuesta = await http.wpost(
            Uri.parse('${url}llamar-lista'),
            headers: {
              'Accept': 'application/json',
            },
            body: data,
          );

          if (respuesta.statusCode == 200) {
            // Realiza las operaciones necesarias con la respuesta exitosa
            // ...
          } else {
            emit(ListaFailure(json.decode(respuesta.body)['errorMessage']));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit(const ListaFailure('Algo salió mal. Inténtalo de nuevo.'));
        }
      }
    });
  }
}

class Estudiante {
  final int id;
  final String nombre;
  final String datos;

  bool seleccionado = false;

  set valor(int valor) {}

  Estudiante({
    required this.id,
    required this.nombre,
    required this.datos,
  });

  // Rest of the class definition
}

List<Estudiante> listaEstudiante = [];
List<Estudiante> estudiantesSeleccionados = [];
