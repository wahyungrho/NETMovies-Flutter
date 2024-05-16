import 'package:flutter/material.dart';
import 'package:movie_app_flutter/constant.dart';
import 'package:movie_app_flutter/models/genre_model.dart';
import 'package:movie_app_flutter/models/movie_model.dart';
import 'package:movie_app_flutter/pages/genre_page.dart';
import 'package:movie_app_flutter/pages/search_page.dart';
import 'package:movie_app_flutter/services/movie_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = false;
  List<Movie> moviesRecomendation = [],
      moviesUpcoming = [],
      moviesNowPlaying = [];
  List<Genres> genres = [];
  int index = 0;

  void getMovies() async {
    setState(() {
      isLoading = true;
    });

    final recomendations = await MovieServices.getMovies('recomendation');
    final upcoming = await MovieServices.getMovies('upcoming');
    final nowPlaying = await MovieServices.getMovies('now_playing');
    getGenres();

    setState(() {
      moviesRecomendation = recomendations;
      moviesUpcoming = upcoming;
      moviesNowPlaying = nowPlaying;
      isLoading = false;
    });
  }

  void getGenres() async {
    final result = await MovieServices.getGenres();
    setState(() {
      genres = result;
    });
  }

  void onClickGenre(Genres genre) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => GenrePage(genre: genre)));
  }

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  @override
  Widget build(BuildContext context) {
    Widget recomendationMovie() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Recomendation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final result = moviesRecomendation[index];
                  return Container(
                    height: 250,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      onTap: () {
                        HelperVideoPlayer.showAlertDialog(result, context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${result.backdropPath}',
                                    fit: BoxFit.cover)),
                            // shadow with title
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent
                                  ],
                                ),
                              ),
                            ),
                            // title
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Text(
                                result.title ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

    Widget nowPlayingMovie() => // now playing movie
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Now Playing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moviesNowPlaying.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final result = moviesNowPlaying[index];
                  return Card(
                    child: Container(
                      width: 170,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: () {
                          HelperVideoPlayer.showAlertDialog(result, context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${result.backdropPath}',
                                      fit: BoxFit.cover)),

                              // title
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result.title ?? '',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // short overview
                                      Expanded(
                                        child: Text(
                                          result.overview ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

    Widget upcomingMovie() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Upcoming',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moviesUpcoming.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final result = moviesUpcoming[index];
                  return Card(
                    child: Container(
                      width: 170,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: () {
                          HelperVideoPlayer.showAlertDialog(result, context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${result.backdropPath}',
                                      fit: BoxFit.cover)),

                              // title
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result.title ?? '',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // short overview
                                      Expanded(
                                        child: Text(
                                          result.overview ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

    Widget genresWidget() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Genres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: genres.length,
                itemBuilder: (context, i) {
                  final result = genres[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      onPressed: () {
                        onClickGenre(result);
                      },
                      child: Text(result.name ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        );

    return Scaffold(
        appBar: AppBar(
          title: const Text('NETMovies'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchPage()));
              },
            ),
          ],
        ),
        body: (isLoading)
            ? const Center(child: CircularProgressIndicator())
            : ListView(children: [
                recomendationMovie(),
                const SizedBox(height: 16),
                genresWidget(),
                const SizedBox(height: 16),
                nowPlayingMovie(),
                const SizedBox(height: 16),
                upcomingMovie(),
              ]));
  }
}
