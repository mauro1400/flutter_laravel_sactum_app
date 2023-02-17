import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/blocks/bloc/gps/gps_bloc.dart';
import 'package:ruta_bus/blocks/blocs.dart';

class GpsAccesScreen extends StatelessWidget {
  const GpsAccesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return !state.isGpsEnabled
              ? const _EnableGspMessage()
              : const _AccessButton();
        },
      )),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario Acceso al GPS'),
        MaterialButton(
            color: Colors.black,
            shape: const StadiumBorder(),
            splashColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);

              gpsBloc.askGpsAccess();
            },
            child: const Text('Solicitar Acceso',
                style: TextStyle(color: Colors.white)))
      ],
    );
  }
}

class _EnableGspMessage extends StatelessWidget {
  const _EnableGspMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Habilite el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}
