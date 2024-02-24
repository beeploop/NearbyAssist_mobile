import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/search_service.dart';

class RadiusSlider extends StatefulWidget {
  const RadiusSlider({super.key});

  @override
  State<RadiusSlider> createState() => _RadiusSlider();
}

class _RadiusSlider extends State<RadiusSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Slider(
        value: getIt.get<SearchingService>().getRadius(),
        max: 1000,
        label: '${getIt.get<SearchingService>().getRadius()} meter',
        divisions: 10,
        onChanged: (double val) {
          setState(() {
            getIt.get<SearchingService>().setRadius(val);
          });
        },
      ),
    );
  }
}
