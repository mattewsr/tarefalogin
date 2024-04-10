class ItemLista {
  String nome;
  int quantidade;
  double preco;
  bool comprado;

  ItemLista({required this.nome, required this.quantidade, required this.preco, this.comprado = false});

  factory ItemLista.fromJson(Map<String, dynamic> json) {
    return ItemLista(
      nome: json['nome'],
      quantidade: json['quantidade'],
      preco: json['preco'],
      comprado: json['comprado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco,
      'comprado': comprado,
    };
  }
}
