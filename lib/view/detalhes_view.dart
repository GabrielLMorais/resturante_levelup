// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_levelup/model/pedido.dart';

class DetalhesView extends StatefulWidget {
  const DetalhesView({super.key});

  @override
  State<DetalhesView> createState() => _DetalhesViewState();
}

class _DetalhesViewState extends State<DetalhesView> {
  String? nome;
  double? preco;

  @override
  Widget build(BuildContext context) {
    final String idPrato = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level Up Restaurantes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 30),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.logout_sharp, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(66, 0, 79, 1),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('itens_cardapios')
              .doc(idPrato)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados.'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Prato não encontrado.'));
            }

            var prato = snapshot.data!;
            nome = prato['nome'] ?? 'Sem nome';
            preco = prato['preco'] ??
                0.0; // Agora preco é tratado como double diretamente
            String imagem = prato['imagem'] ?? '';
            String descricao = prato['descricao'] ?? 'Sem descrição';

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Detalhes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      imagem,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Text(
                      nome!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      descricao,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 65,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'R\$ ${preco!.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (nome != null && preco != null) {
            _adicionarAoPedido(idPrato, nome!, preco!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Dados ainda não carregados!")),
            );
          }
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  void _adicionarAoPedido(String idPrato, String nome, double preco) async {
    var pratoSnapshot = await FirebaseFirestore.instance
        .collection('itens_cardapios')
        .doc(idPrato)
        .get();
    String imagem = pratoSnapshot['imagem'] ??
        ''; // Aqui, capturamos a imagem corretamente.

    var itemPedido = ItemPedido(
      itemId: idPrato,
      nome: nome,
      imagem: imagem, // Agora a imagem está definida corretamente
      preco: preco,
      quantidade: 1,
      status: "Preparando",
    );

    var pedido = Pedido(
      uid: FirebaseFirestore.instance.collection('pedidos').doc().id,
      status: 'Preparando',
      dataHora: DateTime.now().toString(),
      itens: [itemPedido],
    );

    await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(pedido.uid)
        .set(pedido.toMap());

    Navigator.pushNamed(context, 'pedido');
  }
}
