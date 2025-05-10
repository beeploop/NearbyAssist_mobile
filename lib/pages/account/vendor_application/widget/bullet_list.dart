import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  const BulletList({super.key, required this.list});

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Text('\u2022 ${list[index]}');
      },
    );
  }
}
