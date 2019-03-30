import 'package:flutter/material.dart';

import 'package:my_fav/pages/list_page.dart';
import 'package:my_fav/utils/enumerations.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Icon(Icons.favorite),
              SizedBox(width: 10.0,),
              Text('My Favourites'),
            ],
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.image),
                text: 'Image',
              ),
              Tab(
                icon: Icon(Icons.library_music),
                text: 'Audio',
              ),
              Tab(
                icon: Icon(Icons.video_library),
                text: 'Video',
              ),
              Tab(
                icon: Icon(Icons.attach_file),
                text: 'Document',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListPage(FileTypes.Image),
            ListPage(FileTypes.Audio),
            ListPage(FileTypes.Video),
            ListPage(FileTypes.Documents),
          ],
        ),
      ),
    );
  }
}
