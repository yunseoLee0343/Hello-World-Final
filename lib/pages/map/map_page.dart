import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello_world_final/router/app_router.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late double _latitude;
  late double _longitude;
  final Set<Marker> _markers = {};
  bool _mapReady = false;
  String _locationResult = "";

  @override
  void initState() {
    super.initState();
    _fetchNearestCenters();
  }

  Future<void> _fetchNearestCenters() async {
    // Dummy data
    const String response = '''
    {
      "status": "success",
      "data": [
        {
          "name": "상담센터 1",
          "road_address": "서울특별시 중구 을지로 281",
          "jibun_address": "서울특별시 중구 을지로7가 143",
          "latitude": 37.5675466,
          "longitude": 127.0099323,
          "distance": 1.2,
          "is_open": true,
          "closing_time": "18:00"
        },
        {
          "name": "상담센터 2",
          "road_address": "서울특별시 중구 을지로 282",
          "jibun_address": "서울특별시 중구 을지로7가 144",
          "latitude": 37.5675467,
          "longitude": 127.0099324,
          "distance": 2.5,
          "is_open": false,
          "closing_time": "18:00"
        },
        {
          "name": "상담센터 3",
          "road_address": "서울특별시 중구 을지로 283",
          "jibun_address": "서울특별시 중구 을지로7가 145",
          "latitude": 37.5675468,
          "longitude": 127.0099325,
          "distance": 3.0,
          "is_open": true,
          "closing_time": "18:00"
        }
      ]
    }
    ''';

    final data = jsonDecode(response);
    if (data['status'] == 'success') {
      final centers = data['data'] as List<dynamic>;
      for (var center in centers) {
        _addMarker(center);
      }

      setState(() {
        _locationResult = centers
            .map((center) =>
                'Name: ${center['name']}, Distance: ${center['distance']} km, Open: ${center['is_open']}, Closing Time: ${center['closing_time']}')
            .join('\n');
      });

      log('Centers: $_locationResult', name: 'GoogleMap');
    } else {
      setState(() {
        _locationResult = 'Failed to get centers';
      });
      log('Failed to get centers', name: 'GoogleMap');
    }
  }

  void _addMarker(Map<String, dynamic> center) async {
    final GoogleMapController controller = await _mapControllerCompleter.future;
    final Marker marker = Marker(
      markerId: MarkerId(center['name']),
      position: LatLng(center['latitude'], center['longitude']),
      infoWindow: InfoWindow(
        title: center['road_address'],
        snippet:
            '${center['jibun_address']}, Distance: ${center['distance']} km, Open: ${center['is_open']}, Closing Time: ${center['closing_time']}',
      ),
    );

    setState(() {
      _markers.add(marker);
    });

    if (!_mapReady) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(center['latitude'], center['longitude']), 15),
      );
      _mapReady = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('지도')),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapControllerCompleter.complete(controller);
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.5665, 126.9780), // Default position to Seoul
                zoom: 15,
              ),
              markers: _markers,
            ),
            DraggableScrollableSheet(
              // 화면 비율로 높이 조정
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                  const Text("용인시 외국인 복지센터"),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("운영 중"),
                                            Text("28km"),
                                            Text(
                                                "경기도 용인시 처인구 금령로 36, 거성빌딩 3층 301호(김량장동)"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.blue[200])
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                      itemCount: 25,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
            context.go(widgetNames[index].toLowerCase());
          },
        ),
      ),
    );
  }
}
