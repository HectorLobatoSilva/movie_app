import 'package:flutter/material.dart';
import 'package:movie_app/src/pages/hode_page.dart';
import 'package:movie_app/src/pages/pelicula_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Peliculas',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/detalle': (BuildContext context) => PeliculaDetalle()
        });
  }
}
