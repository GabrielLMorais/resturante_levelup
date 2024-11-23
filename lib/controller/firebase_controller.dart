import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_levelup/model/categorias.dart';
import 'package:restaurante_levelup/model/itens_cardapio.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função que insere as categorias e os itens do cardápio
  Future<void> inicializarDados() async {
    // Verifica se as categorias já existem no Firestore
    final categoriasRef = _firestore.collection('categorias');
    final categoriasSnapshot = await categoriasRef.get();
    if (categoriasSnapshot.docs.isEmpty) {
      // Se não houver categorias, insere as categorias padrão
      await categoriasRef.add(Categorias('Lanches', 'Categoria de lanches', 'assets/imagens/lanche.png', 1).toJson());
      await categoriasRef.add(Categorias('Pizzas', 'Categoria de pizzas', 'assets/imagens/pizza.png', 2).toJson());
      await categoriasRef.add(Categorias('Bebidas', 'Categoria de bebidas', 'assets/imagens/bebida.png', 3).toJson());
      await categoriasRef.add(Categorias('Sobremesas', 'Categoria de sobremesas', 'assets/imagens/sobremesa.png', 4).toJson());
      await categoriasRef.add(Categorias('Outros', 'Outros itens', 'assets/imagens/outros.png', 5).toJson());
    }

    // Verifica se os itens do cardápio já existem no Firestore
    final itensRef = _firestore.collection('itens_cardapios');
    final itensSnapshot = await itensRef.get();
    if (itensSnapshot.docs.isEmpty) {
      // Se não houver itens, insere os itens padrão
      await itensRef.add(ItensCardapio('Lanche de carne', 'Descrição do lanche de carne', 'R\$27,99', 'assets/imagens/hamburguer.png', true, 'Lanches').toJson());
      await itensRef.add(ItensCardapio('Pizza de frango', 'Descrição da pizza de frango', 'R\$45,99', 'assets/imagens/pizzaf.png', true, 'Pizzas').toJson());
      await itensRef.add(ItensCardapio('Batata frita', 'Descrição da batata frita', 'R\$19,99', 'assets/imagens/batata-frita.png', true, 'Outros').toJson());
      await itensRef.add(ItensCardapio('Lanche de outra', 'Descrição do lanche de outra', 'R\$27,99', 'assets/imagens/hamburguer.png', true, 'Lanches').toJson());
    }
  }
}
