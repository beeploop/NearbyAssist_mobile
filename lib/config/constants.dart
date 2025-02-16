import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/login_payload_model.dart';
import 'package:nearby_assist/models/user_model.dart';

const appVersion = "v0.10.1-alpha";
const appName = "NearbyAssist";
const appLegalese = "© 2024 NearbyAssist";

const defaultLocation = LatLng(7.4470693031593225, 125.80932608954173);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

const fallbackUserImage =
    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

final placeHolderUser = UserModel(
  id: '',
  name: '',
  email: '',
  imageUrl: '',
  isVendor: false,
  isVerified: false,
  expertise: [],
);

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
