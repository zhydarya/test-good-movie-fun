import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Videos extends StatefulWidget {
  Videos(this._videos, this._category);

  final List<String> _videos;
  final String _category;

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    _controllers = widget._videos
        .map(
          (videoId) => YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              mute: false,
              autoPlay: false,
              disableDragSeek: true,
              loop: false,
            ),
          ),
        )
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._category),
      ),
      body: ListView.builder(
        itemCount: _controllers.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 8.0,
            child: YoutubePlayer(
              controller: _controllers[index],
              showVideoProgressIndicator: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }
}
