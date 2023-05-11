import 'package:audio_tutor/main.dart';
import 'package:flutter/material.dart';

class ATNavigationDrawer extends StatelessWidget {
  const ATNavigationDrawer(this.pageController, {super.key});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
                child: Text("Header Here")
            ),
            ListTile(
              title: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Icon(Icons.headphones),
                  ),
                  Text('Player'),
                ],
              ),
              onTap: () {
                pageController.jumpToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Icon(Icons.settings),
                  ),
                  Text('Settings'),
                ],
              ),
              onTap: () {
                pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }
}