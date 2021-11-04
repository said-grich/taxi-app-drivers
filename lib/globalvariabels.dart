
import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cabdriver/datamodels/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseAuth currentFirebaseUser = FirebaseAuth.instance;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

String mapKey = 'AIzaSyDu4WqSIFIedm75SbBEI6qQ2czq4r5yO_0';


StreamSubscription<Position> homeTabPositionStream;

StreamSubscription<Position> ridePositionStream;

final assetsAudioPlayer = AssetsAudioPlayer();


Position currentPosition;

DatabaseReference rideRef, saveTrip;

Driver currentDriverInfo;

int tripCost;

