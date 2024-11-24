class ItensCardapio {
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;
  final bool ativo;
  final String categoria;

  ItensCardapio(this.nome, this.descricao, this.preco, this.imagem, this.ativo,
      this.categoria);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'imagem': imagem,
      'ativo': ativo,
      'categoria': categoria
    };
  }

  factory ItensCardapio.fromJson(Map<String, dynamic> json) {
    return ItensCardapio(
      json['nome'],
      json['descricao'],
      json['preco'],
      json['imagem'],
      json['ativo'],
      json['categoria'],
    );
  }
}
