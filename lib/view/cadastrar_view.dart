// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurante_levelup/controller/login_controller.dart';
import 'components/text_field.dart';

class CadastrarView extends StatefulWidget {
  const CadastrarView({super.key});

  @override
  State<CadastrarView> createState() => _CadastrarViewState();
}

class _CadastrarViewState extends State<CadastrarView> {
  var _formKey = GlobalKey<FormState>();
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtConfirmeSenha = TextEditingController();

  bool _senhasIguais = true;

  void _verificarSenhas() {
    setState(() {
      _senhasIguais = txtSenha.text == txtConfirmeSenha.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(66, 0, 79, 1),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagens/loguinho3.png',
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.8,
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Criar Conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    campoTexto('Nome', txtNome, Icons.person, 'Informe seu nome', senha: false),
                    campoTexto('Email', txtEmail, Icons.email, 'Informe seu e-mail', senha: false),
                    campoTexto('Senha', txtSenha, Icons.password, 'Informe sua senha', senha: true),
                    campoTexto('Confirme a Senha', txtConfirmeSenha, Icons.password, 'Confirme sua senha', senha: true),
                    if (!_senhasIguais)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'As senhas não coincidem',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            minimumSize: Size(800, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            _verificarSenhas();
                            if (_formKey.currentState!.validate() && _senhasIguais) {
                              LoginController().criarConta(
                                context,
                                txtNome.text,
                                txtEmail.text,
                                txtSenha.text,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cadastrado com sucesso.'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: screenWidth * 0.05),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            minimumSize: Size(800, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'login');
                          },
                          child: Text(
                            'Voltar',
                            style: TextStyle(fontSize: screenWidth * 0.05),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
