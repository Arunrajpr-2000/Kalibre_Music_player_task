import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kalibre_music_player/function/fetchsong.dart';
import 'package:kalibre_music_player/model/hive_model.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// ignore: must_be_immutable
class ScreenNowplay extends StatefulWidget {
  ScreenNowplay({
    song,
    required this.myaudiosong,
    required this.index,
    Key? key,
  }) : super(key: key);

  Audio? song;
  List<Audio> myaudiosong = [];
  int index;

  @override
  State<ScreenNowplay> createState() => _ScreenNowplayState();
}

class _ScreenNowplayState extends State<ScreenNowplay> {
  bool nextDone = true;
  bool preDone = true;

  bool prevvisible = true;
  bool nxtvisible = true;

  @override
  void initState() {
    super.initState();
    databaseSong = box.get('musics') as List<HiveModel>;

    assetsAudioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          "Now Playing",
          style: TextStyle(
              fontFamily: "poppinz",
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: assetsAudioPlayer.builderCurrent(
          builder: (context, Playing? playing) {
        final myAudio = find(widget.myaudiosong, playing!.audio.assetAudioPath);

        if (playing.audio.assetAudioPath.isEmpty) {
          return const Center(
            child: Text('Loading....!!!'),
          );
        } else {
          return Column(
            children: [
              Container(
                width: size.width * 1.5,
                height: size.height * 0.3,
                margin: const EdgeInsets.only(left: 80, top: 50, right: 80),
                child: QueryArtworkWidget(
                  id: int.parse(myAudio.metas.id!),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/beatvis_nxyz5qxr.gif',
                      width: size.width * 0.5,
                      height: size.height * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  artworkBorder: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.7,
                child: Text(
                  myAudio.metas.title.toString(),
                  style: const TextStyle(
                      fontFamily: "poppinz",
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                myAudio.metas.artist.toString() == '<unknown>'
                    ? 'unknown Artist'
                    : myAudio.metas.artist.toString(),
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              SizedBox(
                height: size.height * 0.09,
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: assetsAudioPlayer.builderRealtimePlayingInfos(
                      builder: (context, infos) {
                    Duration currentposition = infos.currentPosition;
                    Duration totalduration = infos.duration;
                    return ProgressBar(
                        timeLabelTextStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        thumbColor: Colors.white,
                        baseBarColor: Colors.grey,
                        progressBarColor: Colors.red,
                        bufferedBarColor: Colors.red,
                        thumbRadius: 10,
                        barHeight: 4,
                        progress: currentposition,
                        total: totalduration,
                        onSeek: ((to) {
                          assetsAudioPlayer.seek(to);
                        }));
                  })),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async {
                        widget.index = widget.index + 1;
                        if (widget.index != audiosongs.length - 1) {
                          nxtvisible = true;
                        }

                        if (preDone) {
                          preDone = false;
                          await assetsAudioPlayer.previous();
                          preDone = true;
                        }
                      },
                      icon: const Icon(
                        Icons.skip_previous_sharp,
                        color: Colors.white,
                        size: 30,
                      )),
                  PlayerBuilder.isPlaying(
                      player: assetsAudioPlayer,
                      builder: (context, isPlaying) {
                        return GestureDetector(
                          onTap: () async {
                            await assetsAudioPlayer.playOrPause();
                          },
                          child: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      }),
                  IconButton(
                      onPressed: () async {
                        widget.index = widget.index + 1;
                        if (widget.index > 0) {
                          prevvisible = true;
                        }
                        if (nextDone) {
                          nextDone = false;
                          await assetsAudioPlayer.next();
                          nextDone = true;
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 30,
                      )),
                ],
              )
            ],
          );
        }
      }),
    );
  }
}
