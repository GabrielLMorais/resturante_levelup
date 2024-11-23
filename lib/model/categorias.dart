class Categorias {
  final String nome;
  final String descricao;
  final String imagem;
  final int ordem;

  Categorias(this.nome, this.descricao, this.imagem, this.ordem);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nome': nome,
      'descricao': descricao,
      'imagem': imagem,
      'ordem': ordem
    };
  }

  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(
      json['nome'],
      json['descricao'],
      json['imagem'],
      json['ordem'],
    );
  }
}
