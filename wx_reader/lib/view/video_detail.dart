import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wx_reader/model/video.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:wx_reader/utils/static_values.dart';

class VideoDetailPage extends StatefulWidget {
  Video _video;
  VideoDetailPage(this._video);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoDetailPageState(_video);
  }

}

class _VideoDetailPageState extends State<VideoDetailPage> {
  Video _video;
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  _VideoDetailPageState(this._video);

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(serverPath + _video.url);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    _videoPlayerController.setLooping(false);

    _videoPlayerController.initialize();

    _videoPlayerController.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_video.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder:(context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            }
            else {
              return Center(child: CircularProgressIndicator());
            }
          },

        ),
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

}

