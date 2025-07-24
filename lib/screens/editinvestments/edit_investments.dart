// import 'package:flutter/material.dart';

// class EditInvestments extends StatefulWidget {
//   final String investmentId;

//   const EditInvestments({required this.investment});

//   @override
//   State<EditInvestments> createState() => _EditInvestmentsState();
// }

// class _EditInvestmentsState extends State<EditInvestments> {
//   late TextEditingController nameController;
//   late List<Movement> movements;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.investment.name);
//     movements = [...widget.investment.movements]; // Copia de los movimientos
//   }

//   void _editMovement(int index) async {
//     final edited = await showDialog(
//       context: context,
//       builder: (_) => EditMovementDialog(movement: movements[index]),
//     );

//     if (edited != null) {
//       setState(() {
//         movements[index] = edited;
//       });
//     }
//   }

//   void _deleteMovement(int index) {
//     setState(() {
//       movements.removeAt(index);
//     });
//   }

//   void _saveChanges() async {
//     final updatedInvestment = widget.investment.copyWith(
//       name: nameController.text,
//       movements: movements,
//     );
//     await InvestmentsService().updateInvestment(updatedInvestment);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Editar inversión')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(children: [
//           TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: "Nombre")),
//           const SizedBox(height: 20),
//           const Text("Movimientos",
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(
//             child: ListView.builder(
//               itemCount: movements.length,
//               itemBuilder: (_, index) {
//                 final m = movements[index];
//                 return ListTile(
//                   title: Text("${m.type} - \$${m.amount}"),
//                   subtitle: Text(m.comment),
//                   trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//                     IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () => _editMovement(index)),
//                     IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => _deleteMovement(index)),
//                   ]),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//               onPressed: _saveChanges, child: const Text("Guardar cambios")),
//         ]),
//       ),
//     );
//   }
// }
