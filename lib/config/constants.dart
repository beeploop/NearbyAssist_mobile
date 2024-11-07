import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/user_model.dart';

const appVersion = "v0.5.0-alpha";

const defaultLocation = LatLng(7.4470693031593225, 125.80932608954173);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

const serviceTags = [
  "category 1",
  "category 2",
  "category 3",
  "category 4",
  "category 5",
  "category 6",
  "category 7",
  "category 8",
  "category 9",
];

final fakeUser = UserModel(
  id: '1',
  name: 'John Doe',
  email: 'johndoe@email.com',
  imageUrl: 'https://via.placeholder.com/150',
  isVerified: false,
);

final List<ServiceModel> testLocations = [
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.422019231706401,
    longitude: 125.82501865685974,
  ),
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.425223742156417,
    longitude: 125.8271730554347,
  ),
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.422595157881033,
    longitude: 125.82907781658925,
  ),
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.418775764866215,
    longitude: 125.82487211291621,
  ),
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.419861667506528,
    longitude: 125.82343895651631,
  ),
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.424324762521772,
    longitude: 125.82533847326413,
  ),
  ServiceModel(
    id: Random().nextInt(1000).toString(),
    description: 'some service description',
    vendor: Random().nextInt(1000).toString(),
    latitude: 7.422929982012976,
    longitude: 125.82349787541021,
  ),
];
