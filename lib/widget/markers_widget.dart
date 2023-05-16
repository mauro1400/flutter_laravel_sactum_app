import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<Marker> getMarkers(LatLng currentLatLng) {
  return [
    Marker(
      width: 80,
      height: 80,
      point: currentLatLng,
      builder: (ctx) => CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue.withOpacity(0.3),
        child: const Icon(Icons.directions_car,
            color: Color.fromARGB(255, 0, 0, 0)),
      ),
    ),
    // Otros marcadores...
  ];
}
