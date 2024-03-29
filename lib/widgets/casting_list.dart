import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_fluutter/models/models.dart';
import 'package:peliculas_fluutter/providers/movies_services.dart';

import 'package:provider/provider.dart';

class CastingList extends StatelessWidget {
  final int movieId;

  const CastingList({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final castingProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: castingProvider.getCastOnMovie(movieId),
      //initialData: InitialData,
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }
        final List<Cast> cast = snapshot.data!;
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) {
              final actor = cast[index];
              return _CastCard(actor: actor,);
            },
          ),
        );
      },
    );

    //print('hola desde casting list $movieId');
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({super.key, required this.actor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePathImg),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
