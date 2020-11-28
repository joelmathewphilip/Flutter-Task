import 'package:flutter_task/services/database_object.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Database_helper
{
  static Database _db;
  static const String id = 'id';
  String path;
  static const String track_id = 'track_id';
  static const table_name='bookmarks';
  static const db_name='database.db';
  static const String track_name = 'track_name';
  static const String artist_name = 'artist_name';
  static const String album_name = 'album_name';

  initDb () async
  {
    io.Directory document_drectory= await getApplicationDocumentsDirectory();
    path=join(document_drectory.path,db_name);
    print(path);
    var db = await openDatabase(path,version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db,int version) async
  {
    await db.execute('CREATE TABLE $table_name ($id INTEGER PRIMARY KEY AUTOINCREMENT, $track_id TEXT , $artist_name TEXT, '
        '$album_name TEXT, $track_name TEXT)');

  }

  Future<Song> save(Song song) async
  {
    var dbClient = await db;
    song.id = await dbClient.insert(table_name,song.toMap());
    return song;
  }

  Future<Database> get db async
  {
    if(_db != null)
      {
        return _db;
      }
    else
      {
        _db = await initDb();
        return _db;
      }
  }

  Future<List<Song>> getSongs() async
  {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(table_name,columns: [id,track_id,artist_name,album_name,track_name]);
    List <Song> songs= [];
    if(maps.length > 0)
      {
        for(int i=0;i<maps.length;i++)
          {
            songs.add(Song.fromMap(maps[i]));
          }
      }
    return songs;

  }

  Future<int> delete(String track_id_content) async
  {
    var dbClient = await db;
    return await dbClient.delete(table_name,where: '$track_id = ?',whereArgs: [track_id_content]);
  }

  Future close () async
  {
    var dbClient = await db;
    dbClient.close();
  }


void delete_database() async
{
  var dbclient = db;

  await deleteDatabase(path);
}



}
