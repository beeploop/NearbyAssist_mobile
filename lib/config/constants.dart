import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/user_model.dart';

const appVersion = "v0.17.0-rc5";
const appName = "NearbyAssist";
const appLegalese = "© 2024 NearbyAssist";

const phoneNumberLength = 11;

const defaultLocation = LatLng(7.4470693031593225, 125.80932608954173);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

const fallbackUserImage =
    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

final placeHolderUser = UserModel(
  id: '',
  name: '',
  email: '',
  imageUrl: '',
  phone: '09123456789',
  address: '',
  isVendor: false,
  isVerified: false,
  isRestricted: false,
  expertise: [],
  socials: [],
  dbl: 0,
  hasPendingVerification: false,
  hasPendingApplication: false,
);
