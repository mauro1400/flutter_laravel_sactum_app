import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Cerrar Sesion",
      onPressed: onPressed,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      child: const Icon(Icons.logout),
    );
  }
}
