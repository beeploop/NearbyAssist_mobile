import 'package:flutter/material.dart';

class AccountTileWidget extends StatelessWidget {
  const AccountTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.iconColor,
    this.fontSize,
    this.iconSize,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final double? fontSize;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(icon, color: iconColor ?? Colors.black54),
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(
                Icons.chevron_right_sharp,
                size: iconSize,
                color: Colors.grey,
              ))
          : null,
    );
  }
}
