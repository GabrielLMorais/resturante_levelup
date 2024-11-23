import 'package:cloud_firestore/cloud_firestore.dart';

class CardapioController {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> listar({String? categoria}) {
    Query<Map<String, dynamic>> resultado = db.collection('itens_cardapios');
    if (categoria != null) {
      resultado = resultado.where('categoria', isEqualTo: categoria);
    }
    return resultado.snapshots();
  }
}
