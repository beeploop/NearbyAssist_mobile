import 'package:flutter/material.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("route to ${widget.serviceId}"),
      ),
    );
  }
}
