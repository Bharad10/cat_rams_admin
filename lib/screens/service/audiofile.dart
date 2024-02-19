import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioPlayerUI extends StatefulWidget {
  final String? audio;
  AudioPlayerUI({this.audio, super.key});

  @override
  State<AudioPlayerUI> createState() => _AudioPlayerUIState();
}

class _AudioPlayerUIState extends State<AudioPlayerUI> {
  double seekbar = 0, volumevalue = 0.5, totalduration = 0, uiduration = 0;
  bool isPlaying = false, ismuted = false;
  AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  void onPlay() {
    if (isPlaying) {
      player.pause();
    } else {
      player.resume();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void onStop() {
    player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void onProgress() {
    player.onDurationChanged.listen(
      (event) {
        setState(() {
          totalduration = event.inMilliseconds.toDouble();
          uiduration = event.inSeconds.toDouble();
        });
      },
    );
    player.onPositionChanged.listen((event) {
      setState(() {
        seekbar = event.inMilliseconds.toDouble() / totalduration;
      });
    });
    player.onPlayerComplete.listen((event) {
      onStop();
      setState(() {
        seekbar = 0;
      });
    });
  }

  void onSeekbarchanges(double value) {
    player.seek(Duration(milliseconds: (value * totalduration).toInt()));
    setState(() {
      seekbar = value;
    });
  }

  @override
  Future<void> dispose() async {
    player.dispose();
    player.stop();
    super.dispose(); //chang
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audio != "") {
      String url = dotenv.env['API_URL']! + widget.audio!;
      // String url = dotenv.env['API_URL']! + '/public/' + widget.audio!;
      player.setSourceUrl(url);
    }

    onProgress();
    return SizedBox(
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: onPlay,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow_outlined,
                color: Colors.blue,
              )),
          Slider(
              min: 0,
              max: 1,
              inactiveColor: Colors.blue.shade400,
              activeColor: Colors.blue.shade400,
              value: seekbar,
              onChanged: onSeekbarchanges),
        ],
      )),
    );
  }
}
