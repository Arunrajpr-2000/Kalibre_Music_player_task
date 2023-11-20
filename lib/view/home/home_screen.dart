import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kalibre_music_player/function/fetchsong.dart';
import 'package:kalibre_music_player/service/openaudio.dart';
import 'package:kalibre_music_player/view/nowplay/nowplay.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> fetchsongs() async {
    List<Audio> audio = await fetchingsongs();
    setState(() {
      audiosongs = audio;
    });
  }

  @override
  void initState() {
    fetchsongs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Songs'),
        centerTitle: true,
      ),
      body: audiosongs.isEmpty
          ? Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('No Songs, Click to Reload')),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: audiosongs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 8),
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              bottomLeft: Radius.circular(32))),
                      tileColor: Colors.red,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScreenNowplay(
                                index: index, myaudiosong: audiosongs)));

                        PlayMyAudio(index: index, allsongs: audiosongs)
                            .openAsset(audios: audiosongs, index: index);
                      },
                      title: Text(
                        audiosongs[index].metas.title.toString(),
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "poppinz",
                            fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        audiosongs[index].metas.artist.toString() == '<unknown>'
                            ? 'unknown '
                            : audiosongs[index].metas.artist.toString(),
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "poppinz",
                            fontWeight: FontWeight.w300),
                      ),
                      leading: QueryArtworkWidget(
                        id: int.parse(audiosongs[index].metas.id.toString()),
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: ClipOval(
                          child: Image.asset(
                            'assets/images/good_times_with_bad_music_1050x700.webp',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
