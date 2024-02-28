import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/model/conversation.dart';
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
