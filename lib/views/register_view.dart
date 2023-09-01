import 'package:flutter/material.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/service/auth/auth_exception.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import '../utilities/dialog/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          Center(
              child: TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase()
                          .createUser(email: email, password: password);
                      AuthService.firebase().sendVerificationEmail();
                      // ignore: use_build_context_synchronously
                      await Navigator.of(context).pushNamed(verifyEmailRoute);
                    } on WeakPasswordAuthExceptions {
                      await showErrorDialog(
                        context,
                        'Weak Password',
                      );
                    } on EmailAlreadyInUseAuthExceptions {
                      await showErrorDialog(
                        context,
                        'Email already in use',
                      );
                    } on InvalidEmailAuthExceptions {
                      await showErrorDialog(
                        context,
                        'Invalid email',
                      );
                    } on GenericAuthExceptions {
                      await showErrorDialog(
                        context,
                        'Failed to register',
                      );
                    }
                  },
                  child: const Text("Register"))),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Click here to Login!!'))
        ],
      ),
    );
  }
}
