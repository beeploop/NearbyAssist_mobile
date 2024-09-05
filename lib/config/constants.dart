import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/model/request/facebook_login_response.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/model/tag_model.dart';

const defaultLocation = LatLng(7.422365, 125.825984);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const headingFontSize = 20.0;

final fakeUser = FacebookLoginResponse(
  name: "John Loyd Mulit",
  email: "jlmulit68@gmail.com",
  image: "https://graph.facebook.com/10219118101307344/picture",
);

final mockLocations = [
  Service(
    id: "1",
    suggestability: 0.0,
    rank: 200,
    vendor: 'Hugo',
    latitude: 7.424373,
    longitude: 125.829315,
  ),
  Service(
    id: "2",
    suggestability: 0.0,
    rank: 100,
    vendor: '11:11',
    latitude: 7.422427,
    longitude: 125.824767,
  ),
  Service(
    id: "3",
    suggestability: 0.0,
    rank: 300,
    vendor: 'Cyan',
    latitude: 7.419195,
    longitude: 125.824142,
  ),
];

final validId = [
  "Driver's License",
  "UMID",
  "Postal ID",
  "PhilSys ID",
];

final initialTags = [
  TagModel(title: "computer repair"),
  TagModel(title: "electric"),
  TagModel(title: "plumbing"),
];
