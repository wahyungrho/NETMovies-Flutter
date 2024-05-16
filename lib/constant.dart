import 'package:flutter/material.dart';
import 'package:movie_app_flutter/models/movie_model.dart';
import 'package:movie_app_flutter/models/videos_model.dart';
import 'package:movie_app_flutter/services/movie_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

const String baseURL = 'https://api.themoviedb.org/3';
const String apiKey = '048f7ebd4036bbd1005ca4b9cddea106';
const String imageBaseURL = 'https://image.tmdb.org/t/p/w500';

class HelperVideoPlayer {
  static List<Videos> videos = [];

  static YoutubePlayerController? _controller;
  // get video
  static Future<YoutubePlayerController?> getVideo(int id) async {
    final result = await MovieServices.getVideos(id);

    videos = result;

    if (videos.isEmpty) {
      return null;
    }
    String initialVideoId = videos[0].key ?? '';

    return YoutubePlayerController(initialVideoId: initialVideoId);
  }

  static Future<void> showAlertDialog(
      Movie result, BuildContext context) async {
    _controller = await getVideo(result.id!);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            title: Row(children: [
              Expanded(
                  child: Text(result.title ?? '',
                      overflow: TextOverflow.ellipsis)),
              IconButton(
                  onPressed: () {
                    _controller?.reset();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ]),
            content: SingleChildScrollView(
              child: Column(children: [
                (_controller != null)
                    ? YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          const SizedBox(width: 10.0),
                          RemainingDuration(),
                        ],
                      )
                    : const Text('No Video Found'),
                const SizedBox(height: 16),
                Text(result.overview ?? ''),
              ]),
            ));
      },
    );
  }
}
