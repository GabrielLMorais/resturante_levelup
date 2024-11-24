import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_levelup/model/categorias.dart';
import 'package:restaurante_levelup/model/itens_cardapio.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> inicializarDados() async {
    final categoriasRef = _firestore.collection('categorias');
    final categoriasSnapshot = await categoriasRef.get();
    if (categoriasSnapshot.docs.isEmpty) {
      await categoriasRef.add(Categorias(
              'Lanches', 'Categoria de lanches', 'assets/imagens/lanche.png', 1)
          .toJson());
      await categoriasRef.add(Categorias(
              'Pizzas', 'Categoria de pizzas', 'assets/imagens/pizza.png', 2)
          .toJson());
      await categoriasRef.add(Categorias(
              'Bebidas', 'Categoria de bebidas', 'assets/imagens/bebida.png', 3)
          .toJson());
      await categoriasRef.add(Categorias('Sobremesas',
              'Categoria de sobremesas', 'assets/imagens/sobremesa.png', 4)
          .toJson());
      await categoriasRef.add(
          Categorias('Outros', 'Outros itens', 'assets/imagens/outros.png', 5)
              .toJson());
    }

    final itensRef = _firestore.collection('itens_cardapios');
    final itensSnapshot = await itensRef.get();
    if (itensSnapshot.docs.isEmpty) {
      await itensRef.add(ItensCardapio(
              'Lanche de carne',
              'Um hambúrguer com carne bovina grelhada, com fatias de tomate, cebola, e alface, com cheddar. Tudo isso é servido em um pão macio e levemente tostado.',
              27.99,
              'assets/imagens/hamburguer.png',
              true,
              'Lanches')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Lanche de frango',
              'Um hambúrguer de frango grelhado, com fatias de tomate, cheddar, e alface. Tudo isso é servido em um pão macio e levemente tostado.',
              25.99,
              'assets/imagens/lanche-frango.png',
              true,
              'Lanches')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Lanche de cheddar',
              'Um hambúrguer com carne bovina grelhada, coberta por uma porção de queijo cheddar derretido e fatias de bacon. Tudo isso é servido em um pão macio e levemente tostado.',
              24.99,
              'assets/imagens/lanche-cheddar-bacon.png',
              true,
              'Lanches')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Lanche de cebola',
              'Um hambúrguer com carne bovina grelhada, com fatias de tomate, cebola empanada (Onion Rings), e alface, com cheddar. Tudo isso é servido em um pão macio e levemente tostado.',
              29.99,
              'assets/imagens/lanche-cebola.png',
              true,
              'Lanches')
          .toJson());

      await itensRef.add(ItensCardapio(
              'Pizza de frango',
              'Uma pizza de frango temperado e desfiado, cobertas por uma camada de queijo derretido. Pedaços de tomate e azeitonas, tudo sobre uma massa leve e crocante.',
              45.99,
              'assets/imagens/pizzaf.png',
              true,
              'Pizzas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Pizza de calabresa',
              'Uma pizza de calabresa, cobertas por uma camada de queijo derretido. Pedaços de tomate e ervas, tudo sobre uma massa leve e crocante.',
              43.99,
              'assets/imagens/pizza-calabresa.png',
              true,
              'Pizzas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Pizza de queijo',
              'Uma pizza de queijo, coberta por uma camada de queijo derretido. Pedaços de tomate e ervas, tudo sobre uma massa leve e crocante.',
              41.99,
              'assets/imagens/pizza-queijo.png',
              true,
              'Pizzas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Pizza acebolada',
              'Uma pizza de calabresa, cobertas por uma camada de queijo derretido. Pedaços de cebola, tomate e azeitonas, tudo sobre uma massa leve e crocante.',
              44.99,
              'assets/imagens/pizza-calabresa-cebola.png',
              true,
              'Pizzas')
          .toJson());

      await itensRef.add(ItensCardapio(
              'Batata frita',
              'Batatas sequinhas, fritas na perfeição para garantir uma casquinha crocante por fora e maciez por dentro. Acompanhadas com maionese ou o molho de sua preferência.',
              19.99,
              'assets/imagens/batata-frita.png',
              true,
              'Outros')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Balde de frango',
              'Frango suculento por dentro e empanado com uma camada dourada e crocante por fora, preparado com temperos especiais para realçar o sabor. O balde vem repleto de pedaços.',
              36.99,
              'assets/imagens/balde-frango.png',
              true,
              'Outros')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Batata e cheddar',
              'Batatas sequinhas, fritas na perfeição para garantir uma casquinha crocante por fora e maciez por dentro. Acompanhadas com queijo cheddar derretido e fatias de bacon.',
              29.99,
              'assets/imagens/batata-frita-cheddar.png',
              true,
              'Outros')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Salada',
              'Uma combinação leve e nutritiva uma salada de alface crocante, tomates maduros e suculentos, fatias finas de cebola e pimentão fresco.',
              12.99,
              'assets/imagens/salada.png',
              true,
              'Outros')
          .toJson());

      await itensRef.add(ItensCardapio(
              'Água',
              'Uma garrafinha de água pura e cristalina, perfeita para matar a sede. Para um toque extra de frescor, adicione gelo e uma fatia de limão ao copo, criando uma bebida leve e revigorante.',
              3.99,
              'assets/imagens/agua.png',
              true,
              'Bebidas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Coca-Cola',
              'A clássica e irresistível bebida gaseificada, perfeita para qualquer momento!  Ela fica ainda mais refrescante ao ser acompanhada de gelo e uma fatia de limão no copo.',
              6.99,
              'assets/imagens/coca-cola.png',
              true,
              'Bebidas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Suco de laranja',
              'Refresque-se com um suco de laranja, feito com frutas selecionadas e repleto de sabor. Para um toque ainda mais gelado e revigorante, sirva com gelo e uma rodela de laranja no copo.',
              4.99,
              'assets/imagens/suco-laranja.png',
              true,
              'Bebidas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Suco de limão',
              'Refresque-se com um suco de limão, feito com frutas selecionadas e repleto de sabor. Para um toque ainda mais gelado e revigorante, sirva com gelo e uma rodela de limão no copo.',
              4.99,
              'assets/imagens/suco-limao.png',
              true,
              'Bebidas')
          .toJson());

      await itensRef.add(ItensCardapio(
              'Bolo de chocolate',
              'Este bolo macio e fofinho é preparado com ingredientes de alta qualidade, proporcionando um sabor intenso e rico. Coberto com uma camada de chocolate cremoso. Finalizado com um pouco de chantilly.',
              39.99,
              'assets/imagens/bolo.png',
              true,
              'Sobremesas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Sorvete',
              'Uma deliciosa combinação de três sabores clássicos em um só lugar! Traz camadas de chocolate, baunilha e morango suave, oferecendo uma experiência refrescante e cheia de sabor a cada colherada.',
              29.99,
              'assets/imagens/sorvete.png',
              true,
              'Sobremesas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Pudim',
              'Uma sobremesa leve, com textura cremosa que derrete na boca. Feito com a combinação perfeita de leite condensado e maracujá, traz um equilíbrio delicioso entre o doce e o azedinho da fruta.',
              19.99,
              'assets/imagens/pudim.png',
              true,
              'Sobremesas')
          .toJson());
      await itensRef.add(ItensCardapio(
              'Torta de morango',
              'Uma sobremesa que combina uma massa leve e crocante com um recheio cremoso e suave. Coberta com morangos frescos e suculentos, essa delícia é finalizada com um pouco de chantilly.',
              41.99,
              'assets/imagens/torta-morango.png',
              true,
              'Sobremesas')
          .toJson());
    }
  }
}
