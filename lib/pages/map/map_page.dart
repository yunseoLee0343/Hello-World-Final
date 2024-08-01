import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello_world_final/api_models/map_api_model.dart';
import 'package:http/http.dart' as http;

class CenterDetails {
  final String centerID;
  final String centerName;

  CenterDetails({
    required this.centerID,
    required this.centerName,
  });
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late double _latitude = 37.5665;
  late double _longitude = 126.9780;
  final Set<Marker> _markers = {};
  late final bool _mapReady = false;
  final String _locationResult = "";

  List<CenterMap> _getDummyCenterMapData() {
    return [
      CenterMap(
        centerID: '1',
        name: "Central Park Center",
        status: "Open",
        closed: "No",
        address: "123 Central Park, New York, NY",
        image: "assets/images/chatbot.png",
        latitude: 40.785091,
        longitude: -73.968285,
      ),
      CenterMap(
        centerID: '2',
        name: "Brooklyn Center",
        status: "Closed",
        closed: "Yes",
        address: "456 Brooklyn Ave, Brooklyn, NY",
        image: "assets/images/chatbot.png",
        latitude: 40.678178,
        longitude: -73.944158,
      ),
      CenterMap(
        centerID: '3',
        name: "Queens Center",
        status: "Open",
        closed: "No",
        address: "789 Queens Blvd, Queens, NY",
        image: "assets/images/chatbot.png",
        latitude: 40.728224,
        longitude: -73.794852,
      ),
      // Add more dummy data as needed
    ];
  }

  var searchedCenterInfo =
      ApiResponse(isSuccess: false, code: '', message: '', centerMapList: []);

  @override
  void initState() {
    super.initState();
    _fetchNearestCenters();
  }

  Future<void> _getCurrentLocation() async {
    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case when permissions are permanently denied
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });

    log('Current location: $_latitude, $_longitude', name: 'GoogleMap');
  }

  Future<void> _fetchNearestCenters() async {
    final response = await http.get(Uri.parse('http://localhost:8082/center'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(jsonMap);
      searchedCenterInfo = apiResponse;

      setState(() {
        _markers.clear();
        for (var center in apiResponse.centerMapList) {
          _markers.add(
            Marker(
              markerId: MarkerId(center.name),
              position: LatLng(center.latitude, center.longitude),
              infoWindow: InfoWindow(
                title: center.name,
                snippet: center.address,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                center.status == 'OPEN'
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueRed,
              ),
            ),
          );
        }
      });
    } else {
      throw Exception('Failed to load centers');
    }
  }

  @override
  Widget build(BuildContext context) {
    searchedCenterInfo = ApiResponse(
        isSuccess: false,
        code: '',
        message: '',
        centerMapList: _getDummyCenterMapData());

    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Centers')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_latitude, _longitude),
              zoom: 15,
            ),
            markers: _markers,
          ),
          DraggableScrollableSheet(
            // 화면 비율로 높이 조정
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color(0xffEBEBEB)),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: searchedCenterInfo.centerMapList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                    offset: Offset(0, 4),
                                    blurRadius: 1)
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(searchedCenterInfo
                                    .centerMapList[index].name),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(searchedCenterInfo
                                              .centerMapList[index].status),
                                          const Text("28km"),
                                          Text(searchedCenterInfo
                                              .centerMapList[index].address),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.blue[200])
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/reservation',
                                      extra: CenterDetails(
                                          centerID: searchedCenterInfo
                                              .centerMapList[index].centerID,
                                          centerName: searchedCenterInfo
                                              .centerMapList[index].name),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.calendar_month_rounded),
                                        onPressed: () {},
                                      ),
                                      const Text("예약")
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
