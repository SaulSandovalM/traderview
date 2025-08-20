import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _currencyController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _companyController = TextEditingController();

  final _walletService = WalletService();

  bool _isLoading = false;
  bool _isSaving = false;

  bool get isEditing => widget.walletId != null;

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null && isEditing) {
      loadWalletData();
    }
  }

  Future<void> loadWalletData() async {
    setState(() => _isLoading = true);
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar la cartera: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final walletData = {
      'name': _nameController.text,
      'accountNumber': _accountNumberController.text,
      'currency': _currencyController.text,
      'accountType': _accountTypeController.text,
      'company': _companyController.text,
    };

    try {
      if (isEditing) {
        await _walletService.updateWallet(
          customerId: widget.customerId!,
          walletId: widget.walletId!,
          data: walletData,
        );
      } else {
        await _walletService.saveNewWallet(
          userId: widget.customerId!,
          data: walletData,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Cartera actualizada correctamente.'
                : 'Cartera creada exitosamente.',
          ),
        ),
      );

      context.go('/customers');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Breadcrumbs(
            backText: 'Clientes',
            onPressed: () => context.go('/customers'),
            text: isEditing ? 'Editar cartera' : 'Crear cartera',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInput(
                      controller: _nameController,
                      label: 'Nombre completo',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo requerido'
                          : null,
                      readOnly: true,
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomInput(
                            controller: _currencyController,
                            label: 'Moneda',
                            validator: (value) => value == null || value.isEmpty
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomInput(
                            controller: _companyController,
                            label: 'Compañía',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                          text: _isSaving
                              ? 'Guardando...'
                              : (isEditing ? 'Actualizar' : 'Crear'),
                          onPressed: () {
                            _isSaving ? null : _saveForm();
                          },
                          icon: _isSaving ? Icons.hourglass_top : Icons.save,
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
