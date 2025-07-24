import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderview/api/customer_service.dart';
import 'package:traderview/api/investments_service.dart';
import 'package:traderview/core/constants/colors.dart';
import 'package:traderview/core/widgets/breadcrumbs.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/core/widgets/custom_button.dart';
import 'package:traderview/core/widgets/custom_card.dart';
import 'package:traderview/core/widgets/custom_input.dart';

class AddInvestments extends StatefulWidget {
  final String? customerId;

  const AddInvestments({super.key, this.customerId});

  @override
  State<AddInvestments> createState() => _AddInvestmentsState();
}

class _AddInvestmentsState extends State<AddInvestments> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // bool _isLoading = false;

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

  final customerService = CustomerService();
  final _investmentService = InvestmentService();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final formatted =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _timeController.text = formatted;
    if (widget.customerId != null) {
      loadCustomerData();
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
            content: Text('Estado de cuenta guardado correctamente.'),
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
                              if (_currentStep == 1 ||
                                  _formKey.currentState!.validate()) {
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
            const SizedBox(height: 24),
          ],
        );
      case 1:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _timeController,
                    label: 'Hora',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _dealController,
                    label: 'Trato',
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
                const SizedBox(width: 24),
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
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _volumeController,
                    label: 'Volumen',
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _orderController,
                    label: 'Orden',
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _feeController,
                    label: 'Honorario',
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _profitController,
                    label: 'Beneficio',
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CustomInput(
                    controller: _commentController,
                    label: 'Comentario',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addMovement,
              child: const Text('Agregar Movimiento'),
            ),
            const SizedBox(height: 10),
            ...movements.map(
              (m) => ListTile(
                title: Text('Hora: ${m['time']} - Trato: ${m['deal']}'),
                subtitle: Text('${m['comment']} - ${m['balance']}'),
              ),
            ),
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
                    keyboardType: TextInputType.number,
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
                    controller: _grossProfitController,
                    label: 'Beneficio Bruto',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
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
                    keyboardType: TextInputType.number,
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
                    controller: _gainFactorController,
                    label: 'Factor de Ganancia',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 3:
        return const Text('Revise la información antes de guardar.');
      default:
        return const SizedBox.shrink();
    }
  }
}
