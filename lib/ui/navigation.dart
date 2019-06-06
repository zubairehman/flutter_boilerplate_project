import 'dart:io';

import 'package:flutter/material.dart';

class AppNavigation extends StatefulWidget {
  AppNavigation({
    @required this.children,
  });
  final List<Screen> children;
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          for (int i = 0; i < widget.children.length; i++) ...[
            Offstage(
              offstage: _currentIndex != i,
              child: widget.children[i].child,
            ),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: tabSelected,
        items: [
          for (var tab in widget.children) ...[
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              title: Text(tab.title),
            ),
          ],
        ],
      ),
    );
  }

  void tabSelected(val) {
    if (mounted)
      setState(() {
        _currentIndex = val;
      });
  }
}

class Screen {
  const Screen({
    @required this.title,
    @required this.iconData,
    @required this.child,
    this.description,
    this.iosIconData,
  });
  final Widget child;
  final String title, description;
  final IconData iconData, iosIconData;
  IconData get icon {
    if (Platform.isIOS || Platform.isMacOS) {
      return iosIconData ?? iconData;
    }
    return iconData;
  }
}
