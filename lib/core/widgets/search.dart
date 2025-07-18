import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const Search({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: "Buscar",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.black, size: 24),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
