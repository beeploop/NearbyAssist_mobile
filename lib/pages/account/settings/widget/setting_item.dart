import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onPress,
    this.textColor,
    this.iconColor,
    this.fontSize,
    this.iconSize,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onPress;
  final Color? textColor;
  final double? fontSize;
  final double? iconSize;
  final Widget? trailing;

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
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: trailing ??
            Icon(
              Icons.chevron_right_sharp,
              size: iconSize,
              color: Colors.grey,
            ),
      ),
    );
  }
}
