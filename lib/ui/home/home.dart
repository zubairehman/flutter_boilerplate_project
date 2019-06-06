import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/sharedpref/constants/preferences.dart';
import '../../locale/index.dart';
import '../../routes.dart';
import '../../stores/post/post_store.dart';
import '../../widgets/progress_indicator_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //store
  final _store = PostStore();

  @override
  void initState() {
    super.initState();

    //get all posts
    _store.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Observer(
          builder: (context) {
            return _store.loading
                ? CustomProgressIndicatorWidget()
                : Material(child: _buildListView());
          },
        ),
        Observer(
          name: 'error',
          builder: (context) {
            return _store.success
                ? Container()
                : showErrorMessage(context, _store.errorStore.errorMessage);
          },
        )
      ],
    );
  }

  Widget _buildListView() {
    return _store.postsList != null
        ? ListView.separated(
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
          )
        : Center(child: Text(AppLocalizations.of(context).posts_not_found));
  }

  // General Methods:-----------------------------------------------------------
  showErrorMessage(BuildContext context, String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null) {
        FlushbarHelper.createError(
          message: message,
          title: 'Error',
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return Container();
  }
}
