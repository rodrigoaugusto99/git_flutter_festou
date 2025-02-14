import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/help/widgets/help_center_page.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/help/widgets/report_bug_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajuda"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text("Central de Ajuda"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpCenterPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Relatar Bugs"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportBugPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
