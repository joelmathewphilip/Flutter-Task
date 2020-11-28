import 'package:flutter/material.dart';
import 'package:flutter_task/Songs_list/songs_list_data.dart';
import 'package:flutter_task/services/error_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'favourite_songs.dart';
import 'package:flutter_task/individual_song.dart';
import 'package:flutter_task/services/Loading.dart';
import 'package:flutter_task/Network/network_status.dart';
import 'package:flutter_task/song_list_template.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_task/services/loading_event.dart';
import 'package:flutter_task/services/bloc_for_loading.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _bloc = Loading_Bloc();
  String track_name,album_name,artist_name,track_id;
  bool loading=true;
  List<Songs_list_data> _songs_list_data=List();


  // void display()
  // {
  //   for(int i=0;i<_songs_list_data.length;i++)
  //   {
  //     print(_songs_list_data[i].track_name);
  //   }
  // }
  void get_data() async
  {
    _songs_list_data=[];
    var url='https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=4a661adfb957ee6f43cb8073d20ad72d';
    var response = await http.get(url);
    //print(response.statusCode);
    if(convert.jsonDecode(response.body)['message']['header']['status_code']==200) {
      var json_response=convert.jsonDecode(response.body);
      var api_response=json_response['message']['body']['track_list'];
      //print(api_response);
      for(int i=0;i<api_response.length;i++)
        {

          artist_name=api_response[i]['track']['artist_name'];
          track_name=api_response[i]['track']['track_name'];
          album_name=api_response[i]['track']['album_name'];
          track_id=api_response[i]['track']['track_id'].toString();
          _songs_list_data.add(Songs_list_data(artist: artist_name,track_name: track_name,album_name: album_name,track_id: track_id));
        }

      _bloc.loadingEventSink.add(notLoading());
    }
    _bloc.loadingEventSink.add(notLoading());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
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
        return snapshot.data ? Loading () : Scaffold(
          appBar: AppBar(title: Text('Trending',),centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.list,color: Colors.white,),onPressed: ()
              {
                //_bloc.dispose();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favourite_Songs()),
                );
              },)
          ],),
          body: ListView.builder(
              itemCount: _songs_list_data.length,
              itemBuilder: (context,index)
          {
            return GestureDetector(
                onTap: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Individual_Song(track_id: _songs_list_data[index].track_id,)),
                  );
                },
                child: Songs_List_Template(track_name: _songs_list_data[index].track_name,artist_name: _songs_list_data[index].artist,
                    album_name: _songs_list_data[index].album_name));
          })
        );
      }
    );
  }
}
