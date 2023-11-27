import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:via_cep/controller/via_cep_controller.dart';
import 'package:via_cep/model/via_cep_model.dart';

class SearchAddress extends StatefulWidget {
  const SearchAddress({super.key});

  @override
  State<SearchAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.closeStream();
    super.dispose();
  }

  Address address = Address();
  final SearchAddressController _controller = SearchAddressController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Address>(
      stream: _controller.addressStream.stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Search Addresss"),
          ),
          body: addressForm(snapshot.data, context),
        );
      }
    );
  }

  Widget addressForm(Address? address, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _controller.cepController,
            validator:(String? value) => _controller.validatorCep(value!),
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Digite seu CEP", hintText: "00000-000"),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, _controller.maskFormatter],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onEditingComplete: () => _controller.cepRequest(context),
          ),
          const SizedBox(height: 16,),
          StreamBuilder<bool>(
            stream: _controller.requestingStream.stream,
            builder: (context, snapshot) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize:  const Size(double.maxFinite, 62)),
                onPressed:() => _controller.cepRequest(context),
                child: snapshot.data == true ? const CircularProgressIndicator(color: Colors.white,) : const Text("PESQUISAR")
              );
            }
          ),
          const SizedBox(height: 16,),
          if(address?.cep != null && _controller.cepController.text != "") ...{
            addressFound(address)
          } else if(address?.cep == null && _controller.cepController.text != "") ...{
            const Text("CEP não existe !")
          }
          else ...{
            Container()
          }
        ],
      ),
    );
  }

  Widget addressFound(Address? address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "CEP: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: address?.cep.toString()),
            ]
          )
        ),
        const SizedBox(height: 8,),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "Logradouro: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: address?.publicPlace == "" ? "Não disponível" : address?.publicPlace??"Não disponível".toString(), style: const TextStyle(overflow: TextOverflow.ellipsis,)),
            ]
          )
        ),
        const SizedBox(height: 8,),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "Bairro: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: address?.neighborhood == ""  ? "Não disponível" : address?.neighborhood.toString(), style: const TextStyle(overflow: TextOverflow.ellipsis,)),
            ]
          )
        ),
        const SizedBox(height: 8,),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "Cidade: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: address?.city.toString()),
            ]
          )
        ),
        const SizedBox(height: 8,),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "UF: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: address?.state.toString()),
            ]
          )
        ),
        const SizedBox(height: 8,),
        Center(
          child: TextButton(
            onPressed: () => _controller.clearRequest(address!),
            child: const Text("LIMPAR")
          ),
        ),
      ],
    );
  }
}