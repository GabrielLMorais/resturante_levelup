// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget campoTexto(label, controller, icone, dica, {senha}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextField(
      controller: controller,
      obscureText: (senha != null) ? senha : false,
      style: TextStyle(color: Colors.white), // Define a cor do texto como branco
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        hintText: dica,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        icon: Icon(icone, color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}
