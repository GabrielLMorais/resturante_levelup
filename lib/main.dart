import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_levelup/controller/firebase_controller.dart';
import 'package:restaurante_levelup/firebase_options.dart';
import 'package:restaurante_levelup/view/cadastrar_view.dart';
import 'package:restaurante_levelup/view/cardapio_view.dart';
import 'package:restaurante_levelup/view/detalhes_view.dart';
import 'package:restaurante_levelup/view/login_view.dart';

Future<void> main() async {

  //
  //INICIALIZAR O FIREBASE
  //
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseService().inicializarDados();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainView(),
    ),
  );
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Up Restaurantes',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'cadastrar': (context) => CadastrarView(),
        'login': (context) => LoginView(),
        'cardapio': (context) => CardapioView(),
        'detalhes': (context) => DetalhesView(),
      },
    );
  }
}

