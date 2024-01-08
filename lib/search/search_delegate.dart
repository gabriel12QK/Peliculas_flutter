import 'package:flutter/material.dart';
import 'package:peliculas_fluutter/models/movie.dart';
import 'package:peliculas_fluutter/providers/movies_services.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: Icon(Icons.clear_rounded))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('build resource');
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 200,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    final movieService = Provider.of<MoviesProvider>(context, listen: false);
    movieService.getSuggestionByQuery(query);
    return StreamBuilder(
        stream: movieService.suggestionsStream,
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) return _emptyContainer();
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) {
              var movie = movies[index];
              return _MovieSearchItem(movie: movie);
            },
          );
        });
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  const _MovieSearchItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'searchMovie-${movie.id}';
    return Hero(
      tag: movie.heroId!,
      child: ListTile(
        leading: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          height: 65,
          fit: BoxFit.contain,
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        },
      ),
    );
  }
}
