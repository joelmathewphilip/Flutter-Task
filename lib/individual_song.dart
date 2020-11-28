import 'dart:convert' as convert;
import 'package:flutter_task/Network/network_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/services/Loading.dart';
import 'package:flutter_task/services/database_helper.dart';
import 'package:flutter_task/services/database_object.dart';
import 'package:flutter_task/services/error_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_task/services/loading_event.dart';
import 'package:flutter_task/services/favourite_event_individual.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task/services/bloc_for_loading.dart';


class Individual_Song extends StatefulWidget {
  String track_id;
  Individual_Song({this.track_id});
  @override
  _Individual_SongState createState() => _Individual_SongState(track_id: track_id);
}

class _Individual_SongState extends State<Individual_Song> {
  String name="",artist="",album_name="",explicit="",rating="",lyrics="";
  String track_id;
  final _bloc = Loading_Bloc();
  List<Song> songs_list;

  _Individual_SongState({this.track_id});
  double font_size_2=18,font_size_1=16;
  bool loading=true;
  Database_helper database_helper;
  bool present = false;

  void get_data() async
  {
    String url2='https://api.musixmatch.com/ws/1.1/track.get?track_id='+track_id+'&apikey=4a661adfb957ee6f43cb8073d20ad72d';
    String url3='https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id='+track_id+'&apikey=4a661adfb957ee6f43cb8073d20ad72d';
    var response=await http.get(url2);
    if(convert.jsonDecode(response.body)['message']['header']['status_code']==200)
      {
        var json_response=convert.jsonDecode(response.body);
        var api_response=json_response['message']['body']['track'];

        name=api_response['track_name'];
        artist=api_response['artist_name'];
        album_name=api_response['album_name'];
        explicit=api_response['explicit'].toString();
        rating=api_response['track_rating'].toString();



      }
    response= await http.get(url3);
    if(convert.jsonDecode(response.body)['message']['header']['status_code']==200)
      {
        var json_response=convert.jsonDecode(response.body);
        var api_response=json_response['message']['body']['lyrics'];

        lyrics=api_response['lyrics_body'];

        _bloc.loadingEventSink.add(notLoading());
      }

  }

  void load_favourites_data() async
  {
    database_helper = Database_helper();
    songs_list = await database_helper.getSongs();
    print(songs_list);
    for(int i=0;i<songs_list.length;i++)
    {
      if(songs_list[i].track_id == track_id)
      {
        present = true;
        break;
      }
    }



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
    load_favourites_data();


  }
  @override
  Widget build(BuildContext context) {
    var connection_status = Provider.of<NetworkStatus>(context);
    return connection_status == NetworkStatus.Offline ? Error_Screen(error_message: 'No Internet Connectivity',) :
    StreamBuilder(
      stream: _bloc.loading,
      initialData: loading,
      builder: (context, snapshot) {
        loading = snapshot.data;
        return snapshot.data ? Loading() : Scaffold(
          appBar: AppBar(title: Text('Track Details'),actions: [

                IconButton(icon: Icon(Icons.favorite,color: present ? Colors.red : Colors.white,size: 25,),
                  onPressed: ()
                  {

                    print(present);
                    database_helper = Database_helper();
                    if(present == false)
                    {
                      database_helper.save(Song(track_id: track_id,album_name: album_name,track_name:name,artist_name: artist));
                      print("Added to Favourite List");
                      //_bloc2.presentEventSink.add(isPresent());

                    }
                    else
                      {
                        database_helper.delete(track_id);
                        //_bloc2.presentEventSink.add(notPresent());

                      }
                    setState(() {
                      present = !present;
                    });

                  },)

          ],),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Name',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: font_size_1),),
                  Text(name,style: TextStyle(color: Colors.black,fontSize: font_size_2),),
                  SizedBox(height: 20,),
                  Text('Artist',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: font_size_1),),
                  Text(artist,style: TextStyle(color: Colors.black,fontSize: font_size_2),),
                  SizedBox(height: 20,),
                  Text('Album Name',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: font_size_1),),
                  Text(artist,style: TextStyle(color: Colors.black,fontSize: font_size_2),),
                  SizedBox(height: 20,),
                  Text('Explicit',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: font_size_1),),
                  Text(explicit,style: TextStyle(color: Colors.black,fontSize: font_size_2),),
                  SizedBox(height: 20,),
                  Text('Rating',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: font_size_1),),
                  Text(rating,style: TextStyle(color: Colors.black,fontSize: font_size_2),),
                  SizedBox(height: 20,),
                  snapshot.data ? Center(child: CircularProgressIndicator()) :
                      Text('Lyrics',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: font_size_1)),
                  Text(lyrics,style: TextStyle(color: Colors.black,fontSize: font_size_2),),
                  SizedBox(height: 30,),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
