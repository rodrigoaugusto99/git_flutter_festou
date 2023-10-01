import 'package:flutter/material.dart';

class LocatarioSettings extends StatefulWidget {
  const LocatarioSettings({super.key});

  @override
  State<LocatarioSettings> createState() => _LocatarioSettingsState();
}

class _LocatarioSettingsState extends State<LocatarioSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
      ),
      body: Container(),
    );
  }
}
