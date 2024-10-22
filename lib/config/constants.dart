import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/model/request/facebook_login_response.dart';
import 'package:nearby_assist/model/tag_model.dart';

const defaultLocation = LatLng(7.422365, 125.825984);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const headingFontSize = 20.0;

final fakeUser = FacebookLoginResponse(
  name: "Adrian Juntilla",
  email: "ajuntilla@gmail.com",
  image: "https://graph.facebook.com/10219118101307344/picture",
);

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
