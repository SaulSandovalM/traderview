// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:traderview/api/auth_service.dart';
// import 'package:go_router/go_router.dart';
// import 'package:traderview/providers/user_model.dart';

// class SignIn extends StatelessWidget {
//   const SignIn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isLargeScreen = MediaQuery.of(context).size.width > 800;
//     final mediaQuery = MediaQuery.of(context);

//     final availableHeight = mediaQuery.size.height - 100;

//     return SizedBox(
//       height: availableHeight,
//       child: Center(
//         child: Container(
//           margin: const EdgeInsets.all(24),
//           constraints: const BoxConstraints(maxWidth: 1200),
//           child: isLargeScreen
//               ? const Row(
//                   children: [
//                     Expanded(flex: 2, child: _LoginForm()),
//                     SizedBox(width: 40),
//                     Expanded(flex: 3, child: _SideBanner()),
//                   ],
//                 )
//               : const SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _SideBanner(),
//                       SizedBox(height: 24),
//                       _LoginForm(),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

// class _LoginForm extends StatefulWidget {
//   const _LoginForm();

//   @override
//   State<_LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<_LoginForm> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _login() async {
//     setState(() => _isLoading = true);
//     try {
//       await Provider.of<AuthService>(context, listen: false).login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );

//       // Cargar datos del usuario para el router
//       // ignore: use_build_context_synchronously
//       await Provider.of<UserModel>(context, listen: false).fetchUserData();

//       if (!mounted) return;
//       context.go('/');
//     } catch (e) {
//       debugPrint('Error de login: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error al iniciar sesión: ${e.toString()}'),
//             backgroundColor: Colors.red[400],
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 32),
//               const Text('Inicia sesión',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 24),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Correo electrónico',
//                   hintText: 'hola@email.com',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Contraseña',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(Icons.visibility_off),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {},
//                   child: const Text('¿Olvidaste tu contraseña?'),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _login,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           height: 16,
//                           width: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Icon(Icons.arrow_forward),
//                   label: const Text('Iniciar sesión'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: Colors.grey[700],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('¿Aún no te registras? '),
//                     GestureDetector(
//                       onTap: () {
//                         // Aquí podría redirigir a su página de registro
//                       },
//                       child: const Text(
//                         'Abre tu cuenta',
//                         style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SideBanner extends StatelessWidget {
//   const _SideBanner();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             Image.asset(
//               'assets/images/image_login.jpg',
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//             Container(
//               width: double.infinity,
//               height: 500,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.black.withOpacity(0.4), Colors.transparent],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//             ),
//             const Positioned(
//               bottom: 40,
//               left: 24,
//               right: 24,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '¿Qué huella quiero dejar en el mundo?',
//                     style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Algunas preguntas las resuelves tú.\nPara otras, está GBM.\nInvierte con propósito.',
//                     style: TextStyle(color: Colors.white70),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
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
              const Text(
                'Correo electrónico',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              _buildTextField(),
              const SizedBox(height: 30),
              const Text(
                'Contraseña',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              _buildPasswordField(),
              const SizedBox(height: 12),
              const Text(
                'Olvidaste tu contraseña?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {},
                  child: const Text("Sign in"),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(15),
        ),
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
    );
  }
}
