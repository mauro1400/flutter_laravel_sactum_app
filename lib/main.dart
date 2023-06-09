import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/bloc/auth/authentication_bloc.dart';
import 'package:ruta_bus/bloc/lista/lista_bloc.dart';
import 'package:ruta_bus/screens/loading_screens.dart';
import 'package:ruta_bus/bloc/gps/gps_bloc.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => AuthenticationBloc()),
        BlocProvider(create: (context) => ListaBloc(context)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
