import 'package:ruta_bus/blocks/auth/authentication_bloc.dart';
import 'package:ruta_bus/screens/widget/input_widget_e.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruta_bus/screens/widget/input_widget_p.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ACCESO TRANSPORTE',
                style: GoogleFonts.poppins(fontSize: size * 0.080),
              ),
              Text(
                '¡Por favor, introduce tu usuario y contraseña!',
                style: GoogleFonts.poppins(fontSize: size * 0.040),
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidgetEmail(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputWidgetPassword(
                hintText: 'Password',
                obscureText: _passwordObscure,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                      ),
                    );
                  } else if (state is AuthenticationSuccess) {
                    // navigate to home page or any other page
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        )),
                    onPressed: () async {
                      context.read<AuthenticationBloc>().add(LoginEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ));
                    },
                    child: state is AuthenticationLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Iniciar Sesion',
                            style: GoogleFonts.poppins(fontSize: size * 0.040),
                          ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
