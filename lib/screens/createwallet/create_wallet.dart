import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderview/api/customer_service.dart';
import 'package:traderview/api/wallet_service.dart';
import 'package:traderview/core/constants/colors.dart';
import 'package:traderview/core/widgets/breadcrumbs.dart';
import 'package:traderview/core/widgets/custom_button.dart';
import 'package:traderview/core/widgets/custom_card.dart';
import 'package:traderview/core/widgets/custom_input.dart';
import 'package:go_router/go_router.dart';

class CreateWallet extends StatefulWidget {
  final String? customerId;

  const CreateWallet({super.key, this.customerId});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  final _formKey = GlobalKey<FormState>();

  // bool _isLoading = false;

  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _currencyController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _companyController = TextEditingController();

  final customerService = CustomerService();
  final _investmentService = WalletService();

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null) {
      loadCustomerData();
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final createWallet = {
          'name': _nameController.text,
          'accountNumber': _accountNumberController.text,
          'currency': _currencyController.text,
          'accountType': _accountTypeController.text,
          'company': _companyController.text,
        };
        await _investmentService.saveNewWallet(
          userId: widget.customerId!,
          data: createWallet,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se ha creado la cartera correctamente.'),
          ),
        );
        context.go('/customers');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  Future<void> loadCustomerData() async {
    // setState(() => _isLoading = true);
    try {
      final data = await customerService.getCustomerById(widget.customerId!);

      if (!mounted) return;

      _nameController.text = data['name'] ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    } finally {
      // setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Breadcrumbs(
            backText: 'Billetera',
            onPressed: () => context.go('/customers'),
            text: 'Agregar inversiones',
          ),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        CustomInput(
                          controller: _nameController,
                          label: 'Nombre completo',
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInput(
                                controller: _accountNumberController,
                                label: 'Número de cuenta',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Campo requerido'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: CustomInput(
                                controller: _currencyController,
                                label: 'Moneda',
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Campo requerido'
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInput(
                                controller: _accountTypeController,
                                label: 'Tipo de cuenta',
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Campo requerido'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: CustomInput(
                                controller: _companyController,
                                label: 'Compañía',
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Campo requerido'
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          text: 'Guardar',
                          onPressed: () => _saveForm(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
