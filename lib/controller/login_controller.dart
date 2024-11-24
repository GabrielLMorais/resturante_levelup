import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/components/mensagem.dart';

class LoginController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void criarConta(context, nome, email, senha) {
    auth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      FirebaseFirestore.instance.collection('usuarios').add(
        {'uid': resultado.user!.uid, 'nome': nome},
      );

      sucesso(context, 'Usuário criado com sucesso!');
      Navigator.pop(context);
    }).catchError((e) {
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  void login(context, email, senha) {
    auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      sucesso(context, 'Usuário autenticado com sucesso!');
      Navigator.pushNamed(context, 'cardapio');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  void esqueceuSenha(context, String email) {
    if (email.isNotEmpty) {
      auth.sendPasswordResetEmail(email: email);
      sucesso(context, 'Email enviado com sucesso.');
    } else {
      erro(context, 'Informe o email para recuperação.');
    }
    Navigator.pop(context);
  }

  logout() {
    auth.signOut();
  }

  idUsuario() {
    return auth.currentUser!.uid;
  }

  Future<String> usuarioLogado() async {
    var nome = '';
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('uid', isEqualTo: idUsuario())
        .get()
        .then((resultado) {
      nome = resultado.docs[0].data()['nome'] ?? '';
    });
    return nome;
  }
}
