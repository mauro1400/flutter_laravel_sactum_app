import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/blocks/auth/authentication_bloc.dart';
import 'package:ruta_bus/screens/login_screen.dart';
import 'package:ruta_bus/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            return const LoadingMap(); // Si el estado es AuthenticationSuccess, navegar a la HomePage.
          } else {
            return const LoginScreen(); // Si el estado no es AuthenticationSuccess, mostrar la pantalla de inicio de sesión.
          }
        },
      ),
    );
  }
}
