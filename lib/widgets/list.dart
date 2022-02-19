import 'package:flutter/material.dart';

class PaddedListItem extends StatelessWidget {
  final Widget child;
  const PaddedListItem({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: child,
    );
  }
}

class ListLeadingIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const ListLeadingIcon({
    Key? key,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 30,
      ),
    );
  }
}

class DismissibleBackground extends StatelessWidget {
  const DismissibleBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          ListTile(
            leading: Icon(Icons.delete, color: Colors.white),
          )
        ],
      ),
    );
  }
}
