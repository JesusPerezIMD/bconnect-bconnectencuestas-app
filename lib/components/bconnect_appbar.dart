import 'package:flutter/material.dart';

class BconnectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userInitials;
  final VoidCallback onPressed;

  const BconnectAppBar({
    Key? key,
    required this.userInitials,
    required this.onPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('BConnect - Encuestas Bconnect'),
      actions: [
        IconButton(
          padding: const EdgeInsets.all(0),
          icon: userInitials.isEmpty
              ? Container()
              : CircleAvatar(
                  backgroundColor: Colors.deepOrangeAccent,
                  radius: 18,
                  child: Text(
                    userInitials,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
          onPressed: onPressed,
        ),
        const SizedBox(
          width: 12,
        )
      ],
    );
  }
}
