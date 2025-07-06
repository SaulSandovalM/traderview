import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderview/api/customer_service.dart';
import 'package:traderview/core/constants/colors.dart';
import 'package:traderview/core/widgets/breadcrumbs.dart';
import 'package:traderview/core/widgets/custom_button.dart';
import 'package:traderview/core/widgets/custom_card.dart';
import 'package:traderview/core/widgets/custom_input.dart';
import 'package:go_router/go_router.dart';

class EditCustomer extends StatefulWidget {
  final String? customerId;

  const EditCustomer({super.key, this.customerId});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  final customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null) {
      loadCustomerData();
    }
  }

  Future<void> loadCustomerData() async {
    setState(() => _isLoading = true);
    try {
      final data = await customerService.getCustomerById(widget.customerId!);

      if (!mounted) return;

      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await customerService.updateCustomer(
          id: widget.customerId!,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente actualizado exitosamente')),
        );

        context.go('/customers');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Breadcrumbs(
          backText: 'Clientes',
          onPressed: () => context.go('/customers'),
          text: 'Editar cliente',
        ),
        SizedBox(
          width: double.infinity,
          child: CustomCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar cliente',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomInput(
                    controller: _nameController,
                    label: 'Nombre completo',
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      if (!value.contains('@')) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    controller: _phoneController,
                    label: 'Teléfono',
                    keyboardType: TextInputType.number,
                    minLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: 'Regresar',
                        onPressed: () => context.go('/customers'),
                        icon: Icons.arrow_back,
                        color: CustomColor.bgButtonTableSecond,
                        colorText: Colors.black,
                      ),
                      CustomButton(
                        text: 'Actualizar cliente',
                        onPressed: updateCustomer,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
