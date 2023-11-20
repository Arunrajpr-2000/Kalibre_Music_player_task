import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:kalibre_music_player/model/hive_model.dart';
import 'package:kalibre_music_player/service/box_class.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<SongModel> allSongs = [];
final _audioquery = OnAudioQuery();
final box = Boxes.getinstance();
List<HiveModel> mappedsongs = [];
List<HiveModel> databaseSong = [];
List<Audio> audiosongs = [];
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');

Audio find(List<Audio> source, String fromPath) {
  return source.firstWhere((element) => element.path == fromPath);
}

fetchingsongs() async {
  bool ispermission = await _audioquery.permissionsStatus();
  if (!ispermission) {
    await _audioquery.permissionsRequest();
  }
  allSongs = await _audioquery.querySongs();
  mappedsongs = allSongs
      .map((e) => HiveModel(
          title: e.title,
          artist: e.artist,
          id: e.id,
          duration: e.duration,
          uri: e.uri!))
      .toList();

  await box.put("musics", mappedsongs);
  databaseSong = box.get("musics") as List<HiveModel>;

  databaseSong.forEach((element) {
    audiosongs.add(Audio.file(element.uri.toString(),
        metas: Metas(
            title: element.title,
            id: element.id.toString(),
            artist: element.artist)));
  });
}
