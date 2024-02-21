import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/model/user_info.dart';

const defaultLocation = LatLng(7.422365, 125.825984);
const tileMapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

const backendServer = 'http://192.168.175.87:8080';

final mockUser = UserInfo(
  name: 'Juan Dela Cruz',
  email: 'mockUser@email.com',
  imageUrl: 'https://dummyimage.com/300',
);

final List<Message> mockConversations = [
  Message(name: 'Firstname Lastname', userId: '1235'),
  Message(name: 'Firstname Lastname', userId: '1236'),
  Message(name: 'Firstname Lastname', userId: '1237'),
];
