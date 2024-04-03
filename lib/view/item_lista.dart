class ItemLista {
  String nome;
  bool comprado;

  ItemLista({required this.nome, this.comprado = false});

  factory ItemLista.fromJson(Map<String, dynamic> json) {
    return ItemLista(
      nome: json['nome'],
      comprado: json['comprado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'comprado': comprado,
    };
  }
}
