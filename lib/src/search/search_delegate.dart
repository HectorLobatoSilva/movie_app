import 'package:flutter/material.dart';
import 'package:movie_app/src/models/pelicula_model.dart';
import 'package:movie_app/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman',
    'Capitan America'
  ];

  final peliculasResientes = ['Spiderman', 'Batman'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appbar, como el icono de cancelar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar como el icono de buscar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Instruccion que crea los resultados
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando escribes
    if (query.isEmpty) return Container();
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImage()),
                placeholder: AssetImage('assets/images/fetchImage.png'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
              onTap: () {
                close(context, null);
                pelicula.uniqueId = '';
                Navigator.pushNamed(context, '/detalle', arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// @override
//   Widget buildSuggestions(BuildContext context) {
//     // Sugerencias que aparecen cuando escribes
//     final listaSugerida = query.isEmpty
//         ? peliculasResientes
//         : peliculas
//             .where((element) =>
//                 element.toLowerCase().startsWith(query.toLowerCase()))
//             .toList();
//     return ListView.builder(
//       itemCount: listaSugerida.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: Icon(Icons.movie),
//           title: Text(listaSugerida[index]),
//           onTap: () {},
//         );
//       },
//     );
//   }
