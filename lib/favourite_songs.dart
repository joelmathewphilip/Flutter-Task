import 'package:flutter/material.dart';
import 'package:flutter_task/individual_song.dart';
import 'package:flutter_task/services/Loading.dart';
import 'package:flutter_task/services/database_helper.dart';
import 'package:flutter_task/services/database_object.dart';
import 'package:flutter_task/song_list_template.dart';

class Favourite_Songs extends StatefulWidget {
  @override
  _Favourite_SongsState createState() => _Favourite_SongsState();
}

class _Favourite_SongsState extends State<Favourite_Songs> {

  Database_helper database_helper;
  List<Song> songs_list;
  bool loading=true;
  void get_data() async
  {
    database_helper = Database_helper();
    songs_list = await database_helper.getSongs();

    setState(() {
      loading = false;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite Songs'),),
      body: loading ?  Loading() :
      songs_list.length ==0 ? Center(child: Text('No Favourite Songs',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),) : ListView.builder(
          itemCount: songs_list.length,
          itemBuilder: (context,index)
          {
            return GestureDetector(
                onTap: ()
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Individual_Song(track_id: songs_list[index].track_id,)),
                  );
                },
                child: Songs_List_Template(track_name: songs_list[index].track_name,artist_name: songs_list[index].artist_name,
                    album_name: songs_list[index].album_name));
          })


    );
  }
}
