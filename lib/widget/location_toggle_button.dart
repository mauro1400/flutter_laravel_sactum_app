import 'package:flutter/material.dart';

class LocationToggleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool liveUpdate;

  const LocationToggleButton({super.key, required this.onPressed, required this.liveUpdate});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Ubicacion",
      onPressed: onPressed,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      child: Icon(liveUpdate ? Icons.location_on : Icons.location_off),
    );
  }
}
