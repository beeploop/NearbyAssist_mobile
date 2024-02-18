import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/model/message.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _Conversations();
}

class _Conversations extends State<Conversations> {
  List<Message> contacts = [
    Message(name: 'Firstname Lastname', userId: '1235'),
    Message(name: 'Firstname Lastname', userId: '1236'),
    Message(name: 'Firstname Lastname', userId: '1237'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: contacts.isNotEmpty
            ? ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      debugPrint('clicked ${contacts[index].name}');
                      context.goNamed(
                        'chat',
                        pathParameters: {'userId': contacts[index].userId},
                      );
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.person, size: 20),
                    ),
                    title: Text(contacts[index].name),
                  );
                },
              )
            : const Text('No messages'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed('new-message');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Message'),
      ),
    );
  }
}
