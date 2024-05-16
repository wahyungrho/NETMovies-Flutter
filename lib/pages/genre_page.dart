import 'package:flutter/material.dart';
import 'package:movie_app_flutter/constant.dart';
import 'package:movie_app_flutter/models/genre_model.dart';
import 'package:movie_app_flutter/models/movie_model.dart';
import 'package:movie_app_flutter/services/movie_services.dart';

class GenrePage extends StatefulWidget {
  final Genres genre;
  const GenrePage({super.key, required this.genre});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List<Movie> movies = [];
  bool isLoading = false;

  Future<void> getMovies() async {
    movies = [];
    setState(() {
      isLoading = true;
    });
    final result = await MovieServices.getMovies('genre',
        query: widget.genre.id.toString());

    setState(() {
      movies = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genre.name ?? ''),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    HelperVideoPlayer.showAlertDialog(movies[index], context);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)),
                                child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movies[index].title ?? '',
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold),
                              ),
                              // short overview
                              Text(
                                movies[index].overview ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
