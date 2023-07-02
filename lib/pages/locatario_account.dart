import 'package:flutter/material.dart';

class LocatarioAccount extends StatefulWidget {
  const LocatarioAccount({super.key});

  @override
  State<LocatarioAccount> createState() => _LocatarioAccountState();
}

class _LocatarioAccountState extends State<LocatarioAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('account'),
      ),
      body: Container(),
    );
  }
}
