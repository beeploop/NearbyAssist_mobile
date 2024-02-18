import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessage();
}

class _NewMessage extends State<NewMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'recipient'),
              ),
            ),
            Form(
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'Write message'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }
}
