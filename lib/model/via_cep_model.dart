class Address {
  String? cep;
  String? publicPlace;
  String?  neighborhood;
  String? city;
  String? state;

  Address({this.cep, this.publicPlace, this.neighborhood, this.city, this.state});

  factory Address.fromJson(Map address) {
    return Address(
      cep: address["cep"],
      publicPlace: address["logradouro"],
      neighborhood: address["bairro"],
      city: address["localidade"],
      state: address["uf"]
    );
  }
}
