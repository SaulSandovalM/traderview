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

class EditWallet extends StatefulWidget {
  final String? customerId;
  final String? walletId;

  const EditWallet({super.key, this.customerId, this.walletId});

  @override
  State<EditWallet> createState() => _EditWalletState();
}

class _EditWalletState extends State<EditWallet> {
  final _formKey = GlobalKey<FormState>();

  // bool _isLoading = false;

  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _currencyController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _companyController = TextEditingController();

  final customerService = CustomerService();
  final _walletService = WalletService();

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null && widget.walletId != null) {
      loadWalletData();
    }
  }

  Future<void> loadWalletData() async {
    try {
      final data = await _walletService.getWalletById(
        widget.customerId!,
        widget.walletId!,
      );
      if (!mounted) return;
      _nameController.text = data['name'] ?? '';
      _accountNumberController.text = data['accountNumber'] ?? '';
      _currencyController.text = data['currency'] ?? '';
      _accountTypeController.text = data['accountType'] ?? '';
      _companyController.text = data['company'] ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar cartera: $e')),
      );
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final walletData = {
          'name': _nameController.text,
          'accountNumber': _accountNumberController.text,
          'currency': _currencyController.text,
          'accountType': _accountTypeController.text,
          'company': _companyController.text,
          // 'updatedAt': FieldValue.serverTimestamp(),
        };

        if (widget.walletId != null) {
          await _walletService.updateWallet(
              customerId: widget.customerId!,
              walletId: widget.walletId!,
              data: walletData);
        } else {
          // Creación nueva
          await _walletService.saveNewWallet(
            userId: widget.customerId!,
            data: walletData,
          );
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.walletId != null
                ? 'Cartera actualizada correctamente.'
                : 'Se ha creado la cartera correctamente.'),
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
