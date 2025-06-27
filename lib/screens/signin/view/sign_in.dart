import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traderview/api/auth_service.dart';
import 'package:traderview/core/utils/input.dart';
import 'package:traderview/core/utils/primary_btn.dart';
import 'package:traderview/providers/user_model.dart';
import 'package:go_router/go_router.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthService>(context, listen: false).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Cargar datos del usuario para el router
      // ignore: use_build_context_synchronously
      await Provider.of<UserModel>(context, listen: false).fetchUserData();

      if (!mounted) return;
      context.go('/');
    } catch (e) {
      debugPrint('Error de login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: ${e.toString()}'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(80, 100, 80, 100),
          width: isLargeScreen
              ? 500
              : isTablet
                  ? 350
                  : double.infinity,
          margin: isLargeScreen || isTablet
              ? const EdgeInsets.symmetric(vertical: 32)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Inicia sesión",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Correo electrónico',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Input(
                controller: _emailController,
                hintText: 'correo@email.com',
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Contraseña',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Input(
                controller: _passwordController,
                hintText: '*********',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: PrimaryBtn(
                    title: 'Iniciar sesión',
                    onPressed: _login,
                    isLoading: _isLoading,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
