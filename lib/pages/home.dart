import 'package:flutter/material.dart';
import 'package:my_fav/components/alert.dart';

import 'package:my_fav/pages/list_page.dart';
import 'package:my_fav/utils/enumerations.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                Icon(Icons.favorite),
                SizedBox(
                  width: 10.0,
                ),
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
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) {
            return BeautifulAlertDialog(
              title: 'Are you sure?',
              message: 'Do you want to exit an App',
              acceptText: "Yes",
              discardText: "No",
              onAcceptPressed: () {
                Navigator.of(context).pop(true);
              },
              onDiscardPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.exit_to_app,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ) ??
        false;
  }
}
