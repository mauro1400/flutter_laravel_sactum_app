import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

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
  bool _permission = false;

  String? _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _liveUpdate = true;
    _mapController = MapController();
    initLocationService();
  }

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(0, 0);
    }

    final markers = <Marker>[
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
    ];

    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Ubicacion Actual',
          style: GoogleFonts.poppins(
            fontSize: size * 0.050,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: _serviceError!.isEmpty
                  ? Text('Ubicacion actual:  '
                      '(${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                  : Text(
                      'Ocurrió un error al adquirir la ubicación. Mensaje de error : '
                      '$_serviceError'),
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
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
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
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Añade esta propiedad para cambiar el color del icono
          child: _liveUpdate
              ? const Icon(Icons.location_on)
              : const Icon(Icons.location_off),
        );
      }),
    );
  }
}
