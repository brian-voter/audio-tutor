import 'package:audio_tutor/main.dart';
import 'package:flutter/material.dart';

class ATNavigationDrawer extends StatelessWidget {
  const ATNavigationDrawer({super.key});

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
                Navigator.popAndPushNamed(context, PageRoutes.home);
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
                Navigator.popAndPushNamed(context, PageRoutes.configEditor);
              },
            ),
          ],
        )
    );
  }
}