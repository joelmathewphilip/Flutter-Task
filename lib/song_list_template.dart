import 'package:flutter/material.dart';

class Songs_List_Template extends StatelessWidget {
  String track_name,album_name,artist_name;
  Songs_List_Template({this.track_name,this.artist_name,this.album_name});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width:10),
                  Icon(Icons.music_note_outlined,color: Colors.black45,),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track_name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
                        SizedBox(height: 04,),
                        Text(album_name,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 15),)
                      ],
                    ),
                  ),
                  SizedBox(width: 30,),
                  Expanded(child: Text(artist_name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),))
                ],
              ),
            ),
            SizedBox(height: 15,),
            Divider(
              color: Colors.black26,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
