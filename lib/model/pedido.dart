class Pedido {
  String uid;
  String status;
  String dataHora;
  List<ItemPedido> itens;

  Pedido({
    required this.uid,
    required this.status,
    required this.dataHora,
    required this.itens,
  });

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      uid: map['uid'],
      status: map['status'],
      dataHora: map['data_hora'],
      itens: List<ItemPedido>.from(
        map['itens']?.map((item) => ItemPedido.fromMap(item)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'status': status,
      'data_hora': dataHora,
      'itens': itens.map((item) => item.toMap()).toList(),
    };
  }
}

class ItemPedido {
  String itemId;
  String nome;
  String imagem;
  double preco;
  int quantidade;
  String status;

  ItemPedido({
    required this.itemId,
    required this.nome,
    required this.imagem,
    required this.preco,
    required this.quantidade,
    required this.status,
  });

  factory ItemPedido.fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      itemId: map['item_id'],
      nome: map['nome'],
      imagem: map['imagem'],
      preco: map['preco'],
      quantidade: map['quantidade'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'nome': nome,
      'imagem': imagem,
      'preco': preco,
      'quantidade': quantidade,
      'status': status,
    };
  }
}
