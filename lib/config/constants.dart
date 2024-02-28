import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/model/conversation.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/model/user_info.dart';

const defaultLocation = LatLng(7.422365, 125.825984);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

final mockUser = UserInfo(
  name: 'Juan Dela Cruz',
  email: 'mockUser@email.com',
  imageUrl: 'https://dummyimage.com/300',
);

final List<Conversation> mockConversations = [
  Conversation(name: 'Firstname Lastname', userId: '1'),
  Conversation(name: 'Firstname Lastname', userId: '2'),
  Conversation(name: 'Firstname Lastname', userId: '1237'),
];

final mockLocations = [
  Service(
    title: 'Hugo Bistro',
    description: 'pizza house',
    rate: 200,
    latitude: 7.424373,
    longitude: 125.829315,
    ownerId: 1,
  ),
  Service(
    title: '11:11 Cafe',
    description: 'cafe',
    rate: 100,
    latitude: 7.422427,
    longitude: 125.824767,
    ownerId: 1,
  ),
  Service(
    title: 'Cyan\'s Frozen foods',
    description: 'frozen foods',
    rate: 300,
    latitude: 7.419195,
    longitude: 125.824142,
    ownerId: 1,
  ),
];
