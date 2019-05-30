import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/form_store.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //store
  final _store = FormStore();

  @override
  void initState() {
    super.initState();

    //get all posts
    _store.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Posts'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            SharedPreferences.getInstance().then((preference) {
              preference.setBool(Preferences.is_logged_in, false);
              Navigator.of(context).pushReplacementNamed(Routes.login);
            });
          },
          icon: Icon(
            Icons.power_settings_new,
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return _store.postsList != null
            ? Material(
                child: _buildListView(),
              )
            : CustomProgressIndicatorWidget();
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: _store.postsList.posts.length,
      separatorBuilder: (context, position) {
        return Divider();
      },
      itemBuilder: (context, position) {
        return ListTile(
          leading: Icon(Icons.cloud_circle),
          title: Text(
            '${_store.postsList.posts[position].title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            '${_store.postsList.posts[position].body}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        );
      },
    );
  }
}
