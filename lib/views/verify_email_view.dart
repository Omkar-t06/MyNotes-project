// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/service/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Email',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent a verification email please check it and verify yourself"),
          const Text(
              'If you haven\'t received a verification email click below'),
          TextButton(
              onPressed: () async {
                AuthService.firebase().sendVerificationEmail();
              },
              child: const Text('Verify Your email Here')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Restart"))
        ],
      ),
    );
  }
}
