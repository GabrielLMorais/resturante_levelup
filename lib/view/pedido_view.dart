// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_levelup/model/pedido.dart';

class PedidoView extends StatefulWidget {
  const PedidoView({super.key});

  @override
  State<PedidoView> createState() => _PedidoViewState();
}

class _PedidoViewState extends State<PedidoView> {
  String _calcularPrecoTotal(List<Pedido> pedidos) {
    double total = 0;
    for (var pedido in pedidos) {
      for (var item in pedido.itens) {
        total += item.preco * item.quantidade;
      }
    }
    return 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void _atualizarQuantidade(Pedido pedido, String nomeItem, int quantidade) {
    setState(() {
      var item = pedido.itens.firstWhere((it) => it.nome == nomeItem);
      item.quantidade += quantidade;
      if (item.quantidade < 1) {
        item.quantidade = 1;
      }
    });

    FirebaseFirestore.instance.collection('pedidos').doc(pedido.uid).update({
      'itens': pedido.itens.map((e) => e.toMap()).toList(),
    });
  }

  void _removerItem(Pedido pedido, String nomeItem) {
    setState(() {
      pedido.itens.removeWhere((item) => item.nome == nomeItem);
      if (pedido.itens.isEmpty) {
        FirebaseFirestore.instance
            .collection('pedidos')
            .doc(pedido.uid)
            .delete();
      } else {
        FirebaseFirestore.instance
            .collection('pedidos')
            .doc(pedido.uid)
            .update({
          'itens': pedido.itens.map((e) => e.toMap()).toList(),
        });
      }
    });
  }

  void _finalizarCompra() {
    FirebaseFirestore.instance.collection('pedidos').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({
          'status': 'Finalizado',
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Compra concluída com sucesso!')),
    );

    setState(() {});
  }

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
              Navigator.pushReplacementNamed(context, 'cardapio');
            },
            icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 30),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('pedidos')
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.logout_sharp, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(66, 0, 79, 1),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meus Pedidos',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pedidos')
                    .where('status', isNotEqualTo: 'Finalizado')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Erro ao carregar pedidos.',
                      style: TextStyle(color: Colors.white),
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(
                      'Nenhum pedido encontrado.',
                      style: TextStyle(color: Colors.white),
                    ));
                  }

                  var pedidos = snapshot.data!.docs
                      .map((doc) =>
                          Pedido.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      var pedido = pedidos[index];
                      return Column(
                        children: pedido.itens.map((item) {
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                  ),
                                  child: Container(
                                    height: 110,
                                    width: 70,
                                    margin: EdgeInsets.fromLTRB(1, 0, 0, 0),
                                    child: Image.network(
                                      item.imagem,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      item.nome,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Preço: R\$ ${item.preco.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                _atualizarQuantidade(
                                                    pedido, item.nome, -1);
                                              },
                                            ),
                                            Text(
                                              '${item.quantidade}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                _atualizarQuantidade(
                                                    pedido, item.nome, 1);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _removerItem(pedido, item.nome);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 42),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pedidos')
                    .where('status', isNotEqualTo: 'Finalizado')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                      'Total: R\$ 0,00',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    );
                  }
                  var pedidos = snapshot.data!.docs
                      .map((doc) =>
                          Pedido.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();
                  return Text(
                    'Total: ${_calcularPrecoTotal(pedidos)}',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _finalizarCompra,
            child: Icon(Icons.check),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'cardapio');
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
