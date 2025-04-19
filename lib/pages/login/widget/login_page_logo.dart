import 'package:flutter/material.dart';
import 'package:nearby_assist/config/assets.dart';

class LoginPageLogo extends StatelessWidget {
  const LoginPageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Column(
          children: [
            Image.asset(Assets.appIconTransparent),
            Text(
              "NearbyAssist",
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 90,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
