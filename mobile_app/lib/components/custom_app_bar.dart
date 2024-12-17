import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String pageName;

  const CustomAppBar({
    required this.pageName,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
          '$pageName',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
                Icons.account_circle_rounded,
                size: 35,
                color: Colors.white,
            ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
