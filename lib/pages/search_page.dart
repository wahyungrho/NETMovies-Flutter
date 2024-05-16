import 'package:flutter/material.dart';
import 'package:movie_app_flutter/constant.dart';
import 'package:movie_app_flutter/models/movie_model.dart';
import 'package:movie_app_flutter/services/movie_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie> movies = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<void> onChangeSearch(val) async {
    movies = [];
    setState(() {
      isLoading = true;
    });
    final result = await MovieServices.getMovies('search', query: val);

    setState(() {
      movies = result;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: searchController,
          onChanged: (String val) async {
            await onChangeSearch(val);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFFFFF),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            /* -- Text and Icon -- */
            hintText: "Search movie...",
            hintStyle: const TextStyle(
              fontSize: 18,
              color: Color(0xFFB3B1B1),
            ), // TextStyle
            suffixIcon: const Icon(
              Icons.search,
              size: 26,
              color: Colors.black54,
            ), // Icon
            /* -- Border Styling -- */
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                width: 2.0,
                color: Color(0xFFFF0000),
              ), // BorderSide
            ), // OutlineInputBorder
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                width: 2.0,
                color: Colors.grey,
              ), // BorderSide
            ), // OutlineInputBorder
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                width: 2.0,
                color: Colors.grey,
              ), // BorderSide
            ), // OutlineInputBorder
          ), // InputDecoration
        ), // Row
      ),
      // body gridview
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
