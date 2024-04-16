import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  const EmailTextField({super.key, required this.emailController});
  final TextEditingController emailController;

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        hintText: "Enter your email",
        prefixIcon: Icon(Icons.email),
      ),
    );
  }
}
