// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../controller/login_controller.dart';
import 'components/text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var _formKey = GlobalKey<FormState>();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtEmailEsqueceuSenha = TextEditingController();

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
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              campoTexto('Email', txtEmail, Icons.email, 'Informe seu e-mail'),
              campoTexto('Senha', txtSenha, Icons.password, 'Informe sua senha',
                  senha: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color.fromRGBO(66, 0, 79, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          title: Text(
                            "Esqueceu a senha?",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Container(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Identifique-se para receber um e-mail com as instruções e o link para criar uma nova senha.",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 25),
                                campoTexto(
                                  'Email',
                                  txtEmailEsqueceuSenha,
                                  Icons.email,
                                  'Informe seu e-mail',
                                ),
                              ],
                            ),
                          ),
                          actionsPadding: EdgeInsets.all(20),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                minimumSize: Size(140, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                              ),
                              onPressed: () {
                                LoginController().esqueceuSenha(
                                  context,
                                  txtEmailEsqueceuSenha.text,
                                );
                                Navigator.pushReplacementNamed(
                                    context, 'login');
                              },
                              child: Text('Enviar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 237, 133, 255),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    LoginController().login(
                      context,
                      txtEmail.text,
                      txtSenha.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(800, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'cadastrar');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(800, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                child: Text(
                  'Criar conta',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
