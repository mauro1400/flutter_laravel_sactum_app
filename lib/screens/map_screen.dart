import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:ruta_bus/bloc/auth/authentication_bloc.dart';
import 'package:ruta_bus/bloc/lista/lista_bloc.dart';
import 'package:ruta_bus/main.dart';
import 'package:ruta_bus/services/ubicacion_servicio.dart';
import 'package:ruta_bus/utils/constants.dart';
import 'package:ruta_bus/widget/lista_widget.dart';
import 'package:ruta_bus/widget/location_toggle_button.dart';
import 'package:ruta_bus/widget/logout_button_widget.dart';
import 'package:ruta_bus/widget/markers_widget.dart';

// ignore: constant_identifier_names
const MAPBOX_DOWNLOADS_TOKEN =
    'sk.eyJ1IjoiaGFtZXItMSIsImEiOiJjbGR2MnUzMmwwYndlNDBtcHgzM2w2ZHRnIn0.piOLEAUk86Kpm_7a4YAoAg';

class LiveLocationPage extends StatefulWidget {
  const LiveLocationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  LocationData? _currentLocation;
  late final MapController _mapController;

  final satelite = '/hamer-1/cldvc6hyn007a01o3dp4i26fh';
  final claro = 'hamer-1/cldvbrb05000401lbc4pddtpo';

  bool _liveUpdate = true;

  final String _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  // obtener referencia al Bloc
  late final ListaBloc listaBloc = ListaBloc(context);
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    listaBloc.add(const ListaEstudiantesEvent());
    _liveUpdate = true;
    _mapController = MapController();
    _timer = Timer.periodic(Duration(seconds: tiempo), (timer) {
      context.read<AuthenticationBloc>().add(SendUbicacionEvent(
            latitud: '${_currentLocation?.latitude ?? ''}',
            longitud: '${_currentLocation?.longitude ?? ''}',
          ));
    });

    LocationService.initLocationService((LocationData? location) {
      if (mounted) {
        setState(() {
          _currentLocation = location;
          // If Live Update is enabled, move map center
          if (_liveUpdate && location != null) {
            _mapController.move(LatLng(location.latitude!, location.longitude!),
                _mapController.zoom);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<bool> estadosChecklist = [];

  void _mostrarListaEstudiantes(BuildContext context) {
    ListaEstudiantesDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(0, 0);
    }

    final markers = getMarkers(currentLatLng);

    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubicacion Actual',
          style: GoogleFonts.poppins(
            fontSize: size * 0.050,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _serviceError.isEmpty
                      ? Text(
                          'Ubicacion actual: (${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                      : Text(
                          'Ocurrió un error al adquirir la ubicación. Mensaje de error: $_serviceError'),
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center:
                      LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  minZoom: 5,
                  maxZoom: 25,
                  zoom: 18,
                  interactiveFlags: interActiveFlags,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: const {
                      'accessToken': MAPBOX_DOWNLOADS_TOKEN,
                      'id': 'hamer-1/cldvbrb05000401lbc4pddtpo'
                    },
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LogoutButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(const LogoutEvent());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          ),
          const SizedBox(width: 16),
          LocationToggleButton(
            onPressed: () {
              setState(() {
                _liveUpdate = !_liveUpdate;

                if (_liveUpdate) {
                  interActiveFlags = InteractiveFlag.rotate |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom;

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Ubicacion...'),
                  ));
                } else {
                  interActiveFlags = InteractiveFlag.all;
                }
              });
            },
            liveUpdate: _liveUpdate,
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "lista",
            onPressed: () {
              _mostrarListaEstudiantes(context);
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
