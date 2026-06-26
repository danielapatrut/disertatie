import 'package:flutter/material.dart';

import 'common_needs.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Themis-ML Fairness Tool",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
            color: Colors.white,
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            itemBuilder: (_) {
              return menuOptions.map((choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            })
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}
