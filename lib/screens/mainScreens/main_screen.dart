// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tunctaxidriver/controllers/app_info.dart';
import 'package:tunctaxidriver/repositories/assistants_methods.dart';
import 'package:tunctaxidriver/global/global.dart';
import 'package:tunctaxidriver/screens/mainScreens/search_places_screen.dart';
import 'package:tunctaxidriver/widgets/my_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controllerGM =
      Completer<GoogleMapController>();
  GoogleMapController? googleMapController;
  Position? position;
  Geolocator geolocator = Geolocator();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(
          name: userModelCurrentInfo?.name ?? "Name",
          email: userModelCurrentInfo?.email ?? "Mail",
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            _map(),
            //custom hamburger button for drawer
            _callDrawer(),
            //ui for searching location
            _searchLocation(),
          ],
        ),
      ),
    );
  }

  Positioned _searchLocation() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 220,
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              children: [
                //from
                Row(
                  children: [
                    const Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "From",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          Provider.of<AppInfo>(context).userPickUpLocation !=
                                  null
                              ? "${(Provider.of<AppInfo>(context, listen: false).userPickUpLocation!.locationName!).substring(0, 24)}..."
                              : "Not getting address",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16.0),
                //to
                GestureDetector(
                  onTap: () {
                    //-->Search Places
                    var responseFromSearchScreen = Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SearchPlacesScreen()));

                    if (responseFromSearchScreen == "obtainedDropoff") {
                      //Draw Polylines
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "To",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            Provider.of<AppInfo>(context).userDropOffLocation !=
                                    null
                                ? "${(Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationName!)}..."
                                : "Not getting address",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  child: const Text(
                    "Request a Ride",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GoogleMap _map() {
    return GoogleMap(
      padding: const EdgeInsets.only(bottom: 220),
      mapType: MapType.hybrid,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controllerGM.complete(controller);
        googleMapController = controller;
        blackTheme();
        locateUserPosition();
      },
    );
  }

  Builder _callDrawer() {
    return Builder(
      builder: (context) => Positioned(
        top: 30,
        left: 14,
        child: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.menu,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  void blackTheme() {
    googleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    position = cPosition;
    LatLng coordinates = LatLng(position!.latitude, position!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: coordinates, zoom: 14);
    googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
    String humanReadAbleAdress =
        await AssistantMethods.searchAddressForGeographicCoordinates(
            position!, context);
    //         .catchError((error) {
    //   log("Error $error");
    // });
    log("This is your address: $humanReadAbleAdress");
  }
}
