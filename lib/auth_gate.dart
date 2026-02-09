import 'package:flutter/material.dart';
import 'package:localauth/locked_app.dart';
import 'package:localauth/singleton.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 🔥 THIS DELAY IS CRITICAL ON MOTO / SAMSUNG
      await Future.delayed(const Duration(milliseconds: 500));
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    final isAuthenticated = await PerformAppAuthentication.authenticate();

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
