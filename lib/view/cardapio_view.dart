// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

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
              .collection(
                  'itens_cardapios') // Ajuste aqui para pegar os itens do cardápio diretamente
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
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      dynamic item = dados.docs[index].data();
                      String nome = item['nome'] ?? 'Sem nome';
                      String preco = item['preco'] ?? 'Preço não disponível';
                      String imagem = item['imagem'] ?? '';

                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: imagem.isNotEmpty
                                  ? Image.network(imagem,
                                      fit: BoxFit.cover, width: 60, height: 60)
                                  : Icon(Icons
                                      .image_not_supported), // Caso a imagem não exista
                            ),
                            title: Text(
                              nome, // Nome do prato
                              style: TextStyle(fontSize: 22),
                            ),
                            subtitle: Text(
                              preco, // Preço do prato
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic),
                            ),
                            onTap: () {
                              String idPrato = dados.docs[index]
                                  .id; // Aqui pegamos o ID do documento do Firebase
                              Navigator.pushNamed(context, 'detalhes',
                                  arguments: idPrato);
                            }),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Nenhum item encontrado.'));
                }
            }
          },
        ),
      ),
    );
  }
}
