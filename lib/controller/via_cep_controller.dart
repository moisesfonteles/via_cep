import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rxdart/subjects.dart';
import 'package:via_cep/model/via_cep_model.dart';

class SearchAddressController {
  var maskFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  final addressStream = BehaviorSubject<Address>();
  final requestingStream = BehaviorSubject<bool>();

  TextEditingController cepController = TextEditingController();

  bool requesting = false;


  void closeStream() {
    addressStream.close();
    requestingStream.close();
  }

  String? validatorCep(String value) {
    int count = value.length;
    if(value.isEmpty || count < 9){
      return "Telefone obrigatório";
    }
    return null;
  }

  void cepRequest() async {
    requesting = true;
    requestingStream.sink.add(requesting);
    Uri uri = Uri.https("viacep.com.br" , "/ws/${cepController.text}/json/");
    final response = await get(uri);
    Map respondeAddress = (jsonDecode(response.body));
    Address address = Address.fromJson(respondeAddress);
    addressStream.sink.add(address);
    requesting = false;
    requestingStream.sink.add(requesting);
  }

  void clearRequest(Address address) {
    cepController.text = "";
    address.cep = "";
    address.publicPlace = "";
    address.neighborhood = "";
    address.city = "";
    address.state = "";
    cepController.text = "";
    addressStream.sink.add(address);
  }
}