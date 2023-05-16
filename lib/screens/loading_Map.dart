
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/bloc/blocs.dart';
import 'package:ruta_bus/screens/screens.dart';

class LoadingMap extends StatelessWidget {
  const LoadingMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        if (state.isAllGranted) {
          return const LiveLocationPage();
        } else {
          return const GpsAccesScreen();
        }
      },
    ));
  }
}
