import 'package:flutter/material.dart';
import 'package:via_cep/page/via_cep_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchAddress(),
    )
  );
}
