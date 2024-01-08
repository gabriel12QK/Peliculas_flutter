import 'package:flutter/material.dart';
import 'package:peliculas_fluutter/providers/movies_services.dart';
import 'package:peliculas_fluutter/search/search_delegate.dart';
import 'package:peliculas_fluutter/widgets/card_swiper.dart';
import 'package:peliculas_fluutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  // const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
   // final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en Cines'),
          elevation: 0,
          actions: [
            IconButton(onPressed: () => showSearch(context: context, delegate:MovieSearchDelegate() ), icon: Icon(Icons.search_outlined), color: Colors.white,)
          ],
        ),
        body: SingleChildScrollView(
          //controller: controller,
          child: Column(
            children: [
              //para que el cardswiper principal sea reutilizable enviaremos la data
              //desde aqui en vez de modificar internamente el widget
              CardSwiperPeliculas(movies: moviesProvider.onDisplayMovies),
              //slider Peliculas
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: 'Populares',
                onNextPage: () {
                  moviesProvider.getPopularMovies();
                },
              ),
              // MovieSlider(
              //   movies: moviesProvider.popularMovies,
              //   title: '',
              // ),
              // MovieSlider(),
              // MovieSlider(),
            ],
          ),
        ));
  }
}
