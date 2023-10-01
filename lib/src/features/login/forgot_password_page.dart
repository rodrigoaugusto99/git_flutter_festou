import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailEC = TextEditingController();

  //send password method
  Future passwordReset() async {
    try {
      //metodo do firebase p/ enviar link no email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEC.text);
      //mensagem de feedback
      return const AlertDialog(
        content: Text('Password reset link sent! Check your email'),
      );
    } on FirebaseAuthException catch (e) {
      //erro no console
      print(e);
      //feedback to user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Text(
              'Enter your email and we will send you a password reset link',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextFormField(
            controller: emailEC,
            decoration: const InputDecoration(
              hintText: 'Username',
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: passwordReset,
            color: Colors.blueGrey,
            child: const Text('Reset password'),
          )
        ],
      ),
    );
  }
}
