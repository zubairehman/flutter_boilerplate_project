import 'dart:io';

import 'package:flutter/material.dart';

class DynamicNavigation extends StatefulWidget {
  DynamicNavigation({
    @required this.children,
    this.type = NavigationType.bottomTabs,
  });

  final List<Screen> children;
  final NavigationType type;

  @override
  _DynamicNavigationState createState() => _DynamicNavigationState();
}

class _DynamicNavigationState extends State<DynamicNavigation> {
  int _currentIndex = 0;

  void tabSelected(val) {
    if (mounted)
      setState(() {
        _currentIndex = val;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == NavigationType.sideDrawer) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.children[_currentIndex].title),
          actions: widget.children[_currentIndex]?.actions,
        ),
        drawer: Container(
          child: Drawer(
              child: SingleChildScrollView(
            child: SafeArea(
              child: Column(children: <Widget>[
                for (var tab in widget.children) ...[
                  ListTile(
                    selected: _currentIndex == widget.children.indexOf(tab),
                    leading: Icon(tab.icon),
                    title: Text(tab.title),
                    subtitle:
                        tab?.description != null ? Text(tab.description) : null,
                    onTap: () => tabSelected(widget.children.indexOf(tab)),
                  ),
                ],
              ]),
            ),
          )),
        ),
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
      );
    }
    if (widget.type == NavigationType.bottomTabs) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.children[_currentIndex].title),
          actions: widget.children[_currentIndex]?.actions,
        ),
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

    if (widget.type == NavigationType.pages) {
      return DefaultTabController(
        initialIndex: _currentIndex,
        length: widget.children.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.children[_currentIndex].title),
            actions: widget.children[_currentIndex]?.actions,
            bottom: TabBar(
              onTap: tabSelected,
              tabs: <Widget>[
                for (var tab in widget.children) ...[tab.tab],
              ],
            ),
          ),
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
        ),
      );
    }

    return Container();
  }
}

enum NavigationType {
  bottomTabs,
  sideDrawer,
  pages,
}

class Screen {
  const Screen({
    @required this.title,
    @required this.iconData,
    @required this.child,
    this.description,
    this.iosIconData,
    this.pageTab,
    this.actions,
  });

  final List<Widget> actions;
  final Widget child;
  final String title, description;
  final IconData iconData, iosIconData;
  final Tab pageTab;

  IconData get icon {
    if (Platform.isIOS || Platform.isMacOS) {
      return iosIconData ?? iconData;
    }
    return iconData;
  }

  Tab get tab => pageTab ?? Tab(text: title);
}
