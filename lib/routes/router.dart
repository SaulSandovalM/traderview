import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/screens/authwrapper/auth_wrapper.dart';
import 'package:traderview/screens/clientdashboard/view/client_dashboard.dart';
import 'package:traderview/screens/dashboard/view/dashboard.dart';
import 'package:traderview/screens/signin/view/sign_in.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isPublic = [
      '/signin',
    ].contains(state.uri.path);

    if (user == null && !isPublic) {
      return '/signin';
    }
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final user = FirebaseAuth.instance.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xFFedeef1),
          appBar: AppBar(
            backgroundColor: const Color(0xFFedeef1),
            elevation: 0,
            leading: user != null
                ? Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  )
                : null,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (user != null)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.person),
                    offset: const Offset(0, 50),
                    onSelected: (String result) async {
                      switch (result) {
                        case 'signin':
                          context.go('/signin');
                          break;
                        case 'profile':
                          context.go('/profile');
                          break;
                        case 'signout':
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            context.go('/signin');
                          }
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: Text('Perfil'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'signout',
                        child: Text('Cerrar sesión'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          drawer: user != null
              ? Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(child: Text('Menú')),
                      ListTile(
                        leading: const Icon(Icons.dashboard),
                        title: const Text('Inicio'),
                        selected:
                            GoRouterState.of(context).uri.path == '/dashboard',
                        selectedTileColor: Colors.blue,
                        onTap: () => context.go('/dashboard'),
                      ),
                    ],
                  ),
                )
              : null,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        child,
                        // Footer puede ir aquí si lo deseas
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthWrapper(),
        ),
        GoRoute(
          path: '/signin',
          builder: (context, state) => const SignIn(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Dashboard(),
        ),
        GoRoute(
          path: '/client-dashboard',
          builder: (context, state) => const ClientDashboard(),
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('Página no encontrada: ${state.uri}'),
      ),
    ),
  ),
);
