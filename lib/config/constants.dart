import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/login_payload_model.dart';

const appVersion = "v0.7.0-alpha";
const appName = "NearbyAssist";
const appLegalese = "© 2024 NearbyAssist";

const defaultLocation = LatLng(7.4470693031593225, 125.80932608954173);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

const serviceTags = [
  'computer repair',
  'carpentry',
  'electric',
  'plumbing',
  'cuddle',
];

final fakeUser = LoginPayloadModel(
  name: 'John Doe',
  email: 'johndoe@email.com',
  imageUrl: 'assets/images/profile.png',
);
