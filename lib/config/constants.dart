import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/login_payload_model.dart';
import 'package:nearby_assist/models/search_result_model.dart';

const appVersion = "v0.5.0-alpha";

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

final List<SearchResultModel> testLocations = [
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.422019231706401,
    longitude: 125.82501865685974,
  ),
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.425223742156417,
    longitude: 125.8271730554347,
  ),
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.422595157881033,
    longitude: 125.82907781658925,
  ),
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.418775764866215,
    longitude: 125.82487211291621,
  ),
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.419861667506528,
    longitude: 125.82343895651631,
  ),
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.424324762521772,
    longitude: 125.82533847326413,
  ),
  SearchResultModel(
    id: Random().nextInt(1000).toString(),
    rank: 1,
    score: 1,
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.422929982012976,
    longitude: 125.82349787541021,
  ),
];
