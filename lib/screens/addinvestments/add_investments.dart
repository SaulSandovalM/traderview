import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderview/api/investments_service.dart';
import 'package:traderview/api/wallet_service.dart';
import 'package:traderview/core/constants/colors.dart';
import 'package:traderview/core/formatters/decimal_text_input.dart';
import 'package:traderview/core/helpers/generate_pdf.dart';
import 'package:traderview/core/widgets/breadcrumbs.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/core/widgets/custom_button.dart';
import 'package:traderview/core/widgets/custom_card.dart';
import 'package:traderview/core/widgets/custom_input.dart';
import 'package:traderview/core/widgets/paginated_table.dart';

class AddInvestments extends StatefulWidget {
  final String? customerId;
  final String? walletId;
  final String? investmentId;

  const AddInvestments(
      {super.key, this.customerId, this.walletId, this.investmentId});

  @override
  State<AddInvestments> createState() => _AddInvestmentsState();
}

class _AddInvestmentsState extends State<AddInvestments> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _currencyController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _companyController = TextEditingController();

  List<Map<String, dynamic>> movements = [];

  final _netProfitController = TextEditingController();
  final _grossProfitController = TextEditingController();
  final _grossLossController = TextEditingController();
  final _gainFactorController = TextEditingController();
  final _expectedPaymentController = TextEditingController();

  final _timeController = TextEditingController();
  final _dealController = TextEditingController();
  final _symbolController = TextEditingController();
  final _typeController = TextEditingController();
  final _directionController = TextEditingController();
  final _volumeController = TextEditingController();
  final _priceController = TextEditingController();
  final _orderController = TextEditingController();
  final _commissionController = TextEditingController();
  final _feeController = TextEditingController();
  final _swapController = TextEditingController();
  final _profitController = TextEditingController();
  final _balanceController = TextEditingController();
  final _commentController = TextEditingController();

  final _investmentService = InvestmentService();
  final _walletService = WalletService();

  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var controller in [
      _timeController,
      _dealController,
      _symbolController,
      _typeController,
      _directionController,
      _volumeController,
      _priceController,
      _orderController,
      _commissionController,
      _feeController,
      _swapController,
      _profitController,
      _balanceController,
      _commentController,
    ]) {
      controller.addListener(_validateForm);
    }
    if (widget.customerId != null && widget.walletId != null) {
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

  void _validateForm() {
    final isValid = _timeController.text.isNotEmpty &&
        _dealController.text.isNotEmpty &&
        _symbolController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _directionController.text.isNotEmpty &&
        _volumeController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _orderController.text.isNotEmpty &&
        _commissionController.text.isNotEmpty &&
        _feeController.text.isNotEmpty &&
        _swapController.text.isNotEmpty &&
        _profitController.text.isNotEmpty &&
        _balanceController.text.isNotEmpty &&
        _commentController.text.isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _addMovement() {
    setState(() {
      movements.add({
        'time': _timeController.text,
        'deal': _dealController.text,
        'symbol': _symbolController.text,
        'type': _typeController.text,
        'direction': _directionController.text,
        'volume': _volumeController.text,
        'price': _priceController.text,
        'order': _orderController.text,
        'commission': _commissionController.text,
        'fee': _feeController.text,
        'swap': _swapController.text,
        'profit': _profitController.text,
        'balance': _balanceController.text,
        'comment': _commentController.text,
      });
      _timeController.clear();
      _dealController.clear();
      _symbolController.clear();
      _typeController.clear();
      _directionController.clear();
      _volumeController.clear();
      _priceController.clear();
      _orderController.clear();
      _commissionController.clear();
      _feeController.clear();
      _swapController.clear();
      _profitController.clear();
      _balanceController.clear();
      _commentController.clear();
    });
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final investmentData = {
          'name': _nameController.text,
          'accountNumber': _accountNumberController.text,
          'currency': _currencyController.text,
          'accountType': _accountTypeController.text,
          'company': _companyController.text,
          'movements': movements,
          'netProfit': _netProfitController.text,
          'grossProfit': _grossProfitController.text,
          'grossLoss': _grossLossController.text,
          'gainFactor': _gainFactorController.text,
          'expectedPayment': _expectedPaymentController.text,
        };

        await _investmentService.saveMonthlyInvestment(
          userId: widget.customerId!,
          data: investmentData,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inversiones guardadas correctamente.'),
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
            text: 'Agregar inversiones',
          ),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildStepperHeader(),
                    const SizedBox(height: 16),
                    _buildStepContent(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          CustomButton(
                            text: 'Regresar',
                            onPressed: () => setState(() => _currentStep--),
                            icon: Icons.arrow_back,
                            color: CustomColor.bgButtonTableSecond,
                            colorText: Colors.black,
                          ),
                        CustomButton(
                          text: _currentStep < 3 ? 'Siguiente' : 'Guardar',
                          onPressed: () {
                            if (_currentStep < 3) {
                              bool canProceed = false;
                              switch (_currentStep) {
                                case 0:
                                  canProceed =
                                      _formKey.currentState!.validate();
                                  break;
                                case 1:
                                  if (movements.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Debe agregar al menos un movimiento',
                                        ),
                                      ),
                                    );
                                  } else {
                                    canProceed = true;
                                  }
                                  break;
                                case 2:
                                  canProceed =
                                      _formKey.currentState!.validate();
                                  break;
                              }
                              if (canProceed) {
                                setState(() => _currentStep++);
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                _saveForm();
                              }
                            }
                          },
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

  Widget _buildStepperHeader() {
    final steps = [
      {'label': 'Datos'},
      {'label': 'Movimientos'},
      {'label': 'Resumen'},
      {'label': 'Confirmar'},
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isActive
                        ? Colors.deepPurple
                        : isCompleted
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (index != steps.length)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    steps[index]['label']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? Colors.deepPurple
                          : isCompleted
                              ? Colors.deepPurple
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            CustomInput(
              controller: _nameController,
              label: 'Nombre completo',
              readOnly: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _accountNumberController,
                    label: 'Número de cuenta',
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _currencyController,
                    label: 'Moneda',
                    readOnly: true,
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
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _companyController,
                    label: 'Compañía',
                    readOnly: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _timeController,
                    label: 'Hora',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _dealController,
                    label: 'Trato',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _symbolController,
                    label: 'Símbolo',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _typeController,
                    label: 'Tipo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _directionController,
                    label: 'Dirección',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _volumeController,
                    label: 'Volumen',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _priceController,
                    label: 'Precio',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _orderController,
                    label: 'Orden',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _commissionController,
                    label: 'Comisión',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _feeController,
                    label: 'Honorario',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _swapController,
                    label: 'Intercambio',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _profitController,
                    label: 'Beneficio',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _balanceController,
                    label: 'Equilibrar',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomInput(
                    controller: _commentController,
                    label: 'Comentario',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Agregar movimiento',
              onPressed: _isFormValid ? _addMovement : () {},
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
            PaginatedTable<Map<String, dynamic>>(
              title: '',
              showTitle: false,
              headers: const [
                'Trato',
                'Beneficio',
                'Equilibrar',
                'Comentario',
                'Acciones'
              ],
              items: movements,
              rowBuilder: (movimiento) {
                final index = movements.indexOf(movimiento);
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(movimiento['deal']),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(movimiento['profit']),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(movimiento['balance']),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(movimiento['comment']),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    movements.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            )
          ],
        );
      case 2:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _netProfitController,
                    label: 'Beneficio Neto Total',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
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
                    controller: _grossProfitController,
                    label: 'Beneficio Bruto',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
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
                    controller: _grossLossController,
                    label: 'Pérdida Bruta',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
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
                    controller: _gainFactorController,
                    label: 'Factor de Ganancia',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      DecimalTextInputFormatter(decimalRange: 2),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomInput(
              controller: _expectedPaymentController,
              label: 'Pago Esperado',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                DecimalTextInputFormatter(decimalRange: 2),
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 3:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await generatePdf(
                filename: 'inversion.pdf',
                name: _nameController.text,
                accountNumber: _accountNumberController.text,
                currencyController: _currencyController.text,
                accountType: _accountTypeController.text,
                company: _companyController.text,
                movements: movements,
                netProfit: _netProfitController.text,
                grossProfit: _grossProfitController.text,
                grossLoss: _grossLossController.text,
                gainFactor: _gainFactorController.text,
                expectedPayment: _expectedPaymentController.text,
                time: _timeController.text,
                deal: _dealController.text,
                symbol: _symbolController.text,
                type: _typeController.text,
                direction: _directionController.text,
                volume: _volumeController.text,
                price: _priceController.text,
                order: _orderController.text,
                commission: _commissionController.text,
                fee: _feeController.text,
                swap: _swapController.text,
                profit: _profitController.text,
                balance: _balanceController.text,
                comment: _commentController.text,
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF generado correctamente')),
              );
            },
            child: const Text('Generar PDF simple'),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
