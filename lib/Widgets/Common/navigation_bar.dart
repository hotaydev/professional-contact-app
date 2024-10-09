import 'package:flutter/material.dart';
import 'package:professional_contact/views/settings.dart';

class NavBar extends StatefulWidget {
  final bool onMainView;
  const NavBar({
    super.key,
    this.onMainView = true,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          padding: EdgeInsets.all(20),
          onPressed: () {
            if (!widget.onMainView) {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Icons.qr_code,
            color:
                widget.onMainView ? Colors.blue.shade600 : Colors.grey.shade500,
            size: 48,
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(20),
          onPressed: () {
            if (widget.onMainView) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            }
          },
          icon: Icon(
            Icons.settings,
            color:
                widget.onMainView ? Colors.grey.shade500 : Colors.blue.shade600,
            size: 48,
          ),
        ),
      ],
    );
  }
}
