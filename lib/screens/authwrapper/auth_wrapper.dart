import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traderview/providers/user_model.dart';
import 'package:traderview/screens/clientdashboard/view/client_dashboard.dart';
import 'package:traderview/screens/dashboard/view/admin_dash.dart';
import 'package:traderview/screens/signin/sign_in.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();

    if (userModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userModel.userId == null) {
      return const SignIn();
    }

    if (userModel.role == 'admin') {
      return const AdminDash();
    } else if (userModel.role == 'client') {
      return const ClientDashboard();
    } else {
      return const SignIn();
    }
  }
}
