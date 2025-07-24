import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/core/constants/colors.dart';
import 'package:traderview/core/widgets/custom_list_tile.dart';
import 'package:traderview/providers/user_model.dart';
import 'package:traderview/screens/addinvestments/add_investments.dart';
import 'package:traderview/screens/authwrapper/auth_wrapper.dart';
import 'package:traderview/screens/clientdashboard/view/client_dashboard.dart';
import 'package:traderview/screens/createcustomer/create_customer.dart';
import 'package:traderview/screens/customers/customers.dart';
import 'package:traderview/screens/dashboard/view/admin_dash.dart';
import 'package:traderview/screens/editcustomer/edit_customer.dart';
import 'package:traderview/screens/investments/view/investments.dart';
import 'package:traderview/screens/accountstatements/account_statements.dart';
import 'package:traderview/screens/signin/sign_in.dart';
import 'package:provider/provider.dart';

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
        final userModel = context.watch<UserModel>();

        return Scaffold(
          backgroundColor: CustomColor.backgroundBase,
          appBar: AppBar(
            backgroundColor: CustomColor.backgroundBase,
            leading: (userModel.role == 'admin' || userModel.role == 'client')
                ? Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  )
                : null,
            title: userModel.role == 'admin' || userModel.role == 'client'
                ? const Text('TraderView')
                : null,
            centerTitle: false,
            actions: [
              if (userModel.role == 'admin' || userModel.role == 'client')
                IconButton(
                  icon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.logout),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    userModel.clear();
                    if (context.mounted) context.go('/signin');
                  },
                ),
            ],
          ),
          drawer: userModel.role == 'admin' || userModel.role == 'client'
              ? Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(child: Text('Menú')),
                      if (userModel.role == 'admin') ...[
                        const CustomListTile(
                          route: '/dashboard',
                          text: 'Inicio',
                          icon: Icons.dashboard,
                        ),
                        const CustomListTile(
                          route: '/customers',
                          text: 'Clientes',
                          icon: Icons.group,
                        ),
                      ],
                      if (userModel.role == 'client') ...[
                        const CustomListTile(
                          route: '/account_statements',
                          text: 'Estados de cuenta',
                          icon: Icons.file_download,
                        ),
                      ],
                    ],
                  ),
                )
              : null,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _centerContainer(child),
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
          builder: (context, state) => const AdminDash(),
        ),
        GoRoute(
          path: '/client-dashboard',
          builder: (context, state) => const ClientDashboard(),
        ),
        GoRoute(
          path: '/customers',
          builder: (context, state) => const Customers(),
        ),
        GoRoute(
          path: '/create-customer',
          builder: (context, state) => const CreateCustomer(),
        ),
        GoRoute(
          path: '/edit-customer/:customerId',
          name: 'edit-customer',
          builder: (context, state) {
            final customerId = state.pathParameters['customerId']!;
            return EditCustomer(customerId: customerId);
          },
        ),
        GoRoute(
          path: '/add-investments/:customerId',
          name: 'add-investments',
          builder: (context, state) {
            final customerId = state.pathParameters['customerId']!;
            return AddInvestments(customerId: customerId);
          },
        ),
        GoRoute(
          path: '/account_statements',
          builder: (context, state) => const AccountStatements(),
        ),
        GoRoute(
          path: '/investments',
          builder: (context, state) => const Investments(),
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

Widget _centerContainer(Widget child) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: child,
    ),
  );
}
