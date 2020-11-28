import 'package:flutter/cupertino.dart';

class Song
{
  int id;
  String track_name;
  String album_name;
  String artist_name;
  String track_id;
  Song({this.track_id,this.id,this.album_name,this.track_name,this.artist_name});
  Map<String,dynamic> toMap()
  {
    var map=<String,dynamic>{
      'id':id,
      'track_id':track_id,
      'track_name':track_name,
      'album_name':album_name,
      'artist_name':artist_name
    };
    return map;
  }

  Song.fromMap(Map<String,dynamic> map)
  {
    id=map['id'];
    track_id=map['track_id'];
    album_name=map['album_name'];
    artist_name=map['artist_name'];
    track_name=map['track_name'];
  }

}