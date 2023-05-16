import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/bloc/lista/lista_bloc.dart';

List<bool> estadosChecklist = [];

class ListaEstudiantesDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lista de estudiantes'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listaEstudiante.length,
              itemBuilder: (BuildContext context, int index) {
                final estudiante = listaEstudiante[index];
                if (estadosChecklist.length <= index) {
                  // Si no hay un valor en la lista para este índice, asigna el valor inicial como false
                  estadosChecklist.add(false);
                }
                return StatefulBuilder(
                  builder: (context, setState) => CheckboxListTile(
                    title: Text(estudiante.nombre),
                    subtitle: Text(estudiante.datos),
                    value: estadosChecklist[index],
                    onChanged: (value) {
                      setState(() {
                        estadosChecklist[index] = value!;
                        if (value) {
                          estudiantesSeleccionados.add(estudiante);
                        } else {
                          estudiantesSeleccionados.remove(estudiante);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            BlocBuilder<ListaBloc, ListaState>(builder: (context, state) {
              return TextButton(
                onPressed: () async {
                  context.read<ListaBloc>().add(
                      LlamarListaEvent(estadosChecklist: estadosChecklist));
                  Navigator.of(context).pop();
                },
                child: const Text('Enviar lista'),
              );
            })
          ],
        );
      },
    );
  }
}
