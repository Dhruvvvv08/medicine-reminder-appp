import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewmodel>(context);  // Ensure this line is correct

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         
            const SizedBox(height: 20),
            TextField(controller: provider.passswordcontroller),
            const SizedBox(height: 20),
            provider.islogin
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => provider.loginn(context),
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
