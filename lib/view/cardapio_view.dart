// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardapioView extends StatefulWidget {
  const CardapioView({super.key});

  @override
  State<CardapioView> createState() => _CardapioViewState();
}

class _CardapioViewState extends State<CardapioView> {
  @override
  Widget build(BuildContext context) {
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
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.logout_sharp, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(66, 0, 79, 1),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categorias')
              .orderBy('ordem')
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: Text('Não foi possível conectar.'));
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar dados.'));
                }

                final dadosCategorias = snapshot.requireData;
                if (dadosCategorias.size > 0) {
                  List<Map<String, dynamic>> categorias = [];
                  for (var doc in dadosCategorias.docs) {
                    categorias.add(doc.data() as Map<String, dynamic>);
                  }

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('itens_cardapios')
                        .snapshots(),
                    builder: (context, snapshotItens) {
                      switch (snapshotItens.connectionState) {
                        case ConnectionState.none:
                          return Center(
                              child:
                                  Text('Não foi possível conectar aos itens.'));
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshotItens.hasError) {
                            return Center(
                                child: Text('Erro ao carregar os itens.'));
                          }

                          final dadosItens = snapshotItens.requireData;
                          if (dadosItens.size > 0) {
                            Map<String, List<dynamic>> itensPorCategoria = {};

                            for (var doc in dadosItens.docs) {
                              Map<String, dynamic> item =
                                  doc.data() as Map<String, dynamic>;
                              String categoria = item['categoria'];

                              if (!itensPorCategoria.containsKey(categoria)) {
                                itensPorCategoria[categoria] = [];
                              }
                              itensPorCategoria[categoria]?.add(item);
                            }

                            return ListView(
                              children: categorias.map((categoria) {
                                String nomeCategoria = categoria['nome'];
                                List<dynamic> itensCategoria =
                                    itensPorCategoria[nomeCategoria] ?? [];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        nomeCategoria,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children:
                                          itensCategoria.map<Widget>((item) {
                                        String nome =
                                            item['nome'] ?? 'Sem nome';
                                        double preco = item['preco'] ?? 0.0;
                                        String imagem = item['imagem'] ?? '';

                                        return Card(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: InkWell(
                                            onTap: () {
                                              var prato =
                                                  dadosItens.docs.firstWhere(
                                                (doc) {
                                                  Map<String, dynamic> data =
                                                      doc.data() as Map<String,
                                                          dynamic>;
                                                  return data['nome'] == nome;
                                                },
                                              );
                                              String idPrato = prato.id;
                                              Navigator.pushNamed(
                                                  context, 'detalhes',
                                                  arguments: idPrato);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imagem.isNotEmpty
                                                          ? NetworkImage(imagem)
                                                          : AssetImage(
                                                                  'assets/default_image.png')
                                                              as ImageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          nome,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          'R\$ ${preco.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          } else {
                            return Center(
                                child: Text(
                              'Nenhum item encontrado.',
                              style: TextStyle(color: Colors.white),
                            ));
                          }
                      }
                    },
                  );
                } else {
                  return Center(
                      child: Text(
                    'Nenhuma categoria encontrada.',
                    style: TextStyle(color: Colors.white),
                  ));
                }
            }
          },
        ),
      ),
    );
  }
}
