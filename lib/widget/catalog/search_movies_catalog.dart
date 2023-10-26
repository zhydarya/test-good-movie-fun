import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/catalog.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/widget/catalog/movies_catalog_builder.dart';
import 'package:provider/provider.dart';

class SearchMoviesCatalog extends StatefulWidget with MoviesCatalogBuilder {
  List<Movie> movies;

  SearchMoviesCatalog(this.movies);

  @override
  SearchMoviesCatalogState createState() => SearchMoviesCatalogState();
}

class SearchMoviesCatalogState extends State<SearchMoviesCatalog> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        var catalog = context.read<Catalog>();
        return catalog
            .refreshItems()
            .whenComplete(() => setState(() => widget.movies = catalog.movies));
      },
      child: widget.buildCatalog(context, widget.movies),
    );
  }
}
