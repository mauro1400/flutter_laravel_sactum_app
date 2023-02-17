import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/screens/screens.dart';
import 'blocks/bloc/gps/gps_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (context) => GpsBloc())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MapsAPP',
        home: LoadingScreen());
  }
}
