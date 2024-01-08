import 'package:flutter/material.dart';
import 'package:peliculas_fluutter/models/models.dart';
import 'package:peliculas_fluutter/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  // const DetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Movie _movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      body: CustomScrollView(
        //sliver permite usar widgets que tiene una funcionalidad especial para el scroll
        slivers: [
          _CustomAppBar(movie: _movie),
          // sliverlist permite usar los widgets normales dentor del sliver
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(movie: _movie),
            _Overview(descripcion: _movie.overview),
            // _Overview(),
            // _Overview(),
            CastingList(movieId: _movie.id,)
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          child: Text(movie.originalTitle, textAlign: TextAlign.center,),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
                width: 100,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width-190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
                Text(
                  movie.originalTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_outlined,
                      size: 20,
                      color: Color.fromARGB(255, 253, 218, 17),
                    ),
                    Text(
                      movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String descripcion;

  const _Overview({super.key, required this.descripcion});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        descripcion,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
