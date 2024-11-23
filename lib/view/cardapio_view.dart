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
          stream: FirebaseFirestore.instance.collection('itens_cardapios').snapshots(),
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
                  // Agrupando os itens por categoria
                  Map<String, List<dynamic>> categorias = {};

                  for (var doc in dados.docs) {
                    Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
                    String categoria = item['categoria'];

                    if (!categorias.containsKey(categoria)) {
                      categorias[categoria] = [];
                    }
                    categorias[categoria]?.add(item);
                  }

                  return ListView(
                    children: categorias.keys.map((categoria) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título da categoria
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              categoria, // Nome da categoria
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Itens da categoria
                          Column(
                            children: categorias[categoria]!.map<Widget>((item) {
                              String nome = item['nome'] ?? 'Sem nome';
                              String preco = item['preco'] ?? 'Preço não disponível';
                              String imagem = item['imagem'] ?? '';

                              return Card(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imagem.isNotEmpty
                                        ? Image.network(imagem, fit: BoxFit.cover, width: 60, height: 60)
                                        : Icon(Icons.image_not_supported),
                                  ),
                                  title: Text(
                                    nome,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    preco,
                                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                  ),
                                  onTap: () {
                                    var prato = dados.docs.firstWhere(
                                      (doc) {
                                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                        return data['nome'] == nome;
                                      },
                                    );
                                    String idPrato = prato.id; // Obter o ID diretamente do prato encontrado
                                    Navigator.pushNamed(context, 'detalhes', arguments: idPrato);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
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
