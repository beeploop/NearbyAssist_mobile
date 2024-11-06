import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/user_model.dart';

const appVersion = "v0.5.0-alpha";

const defaultLocation = LatLng(7.4470693031593225, 125.80932608954173);
const testLocation = LatLng(7.422262088132875, 125.82481735474342);
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
