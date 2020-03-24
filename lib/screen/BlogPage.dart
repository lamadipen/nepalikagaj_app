

import 'package:flutter/material.dart';
import 'package:nepalikagaj/api/get_post.dart';
import 'package:nepalikagaj/modal/Post.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';

class BlogPage extends StatefulWidget {
  BlogPage({Key key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPostsAndImageLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nepalikagaj',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Nepalikagaj'),
          ),
          body: Container(
              child: FutureBuilder<List<Post>>(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return postUI(snapshot.data[index]);
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
        ));
  }

  Widget postUI([Post data]) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.title,
                    ),
//                      Text(
//                        data.date.toString(),
//                        style: Theme.of(context).textTheme.subtitle,
//                      ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    getPopupMenu(data),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(data.imageUrl, fit: BoxFit.cover),
            SizedBox(
              height: 10.0,
            ),
            MarkdownBody(
              data: htmlEncode(data.content),
              styleSheet: htlmMarkdownStyle(),
            )
          ],
        ),
      ),
    );
  }

  htlmMarkdownStyle(){
    TextTheme textTheme = Typography(platform: TargetPlatform.android)
        .black
        .merge(TextTheme(body1: TextStyle(fontSize: 18.0)));
    ThemeData theme = ThemeData.dark().copyWith(textTheme: textTheme);
    final MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet.fromTheme(theme);
    return markdownStyleSheet;
  }


  Widget getPopupMenu(Post data) {
    return PopupMenuButton<PostContextMenu>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PostContextMenu>>[
        const PopupMenuItem<PostContextMenu>(
          value: PostContextMenu.OPEN_IN_BROWSER,
          child: ListTile(
            leading: Icon(Icons.open_with),
            title: Text('Open in browser'),
          ),
          enabled: true,
        ),
        const PopupMenuItem<PostContextMenu>(
          value: PostContextMenu.SHARE,
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text('Share Post'),
          ),
          enabled: true,
        ),
      ],
      onSelected: (PostContextMenu result) {
        switch (result) {
          case PostContextMenu.OPEN_IN_BROWSER:
            launchURLOnBrowser(data.webPageLink);
            break;
          case PostContextMenu.SHARE:
            share(context, data);
            break;
        }
      },
    );
  }

  PostContextMenu _selection;

  share(BuildContext context, Post data) {
    final RenderBox box = context.findRenderObject();
    Share.share("${data.title} - ${data.webPageLink}",
        subject: data.title,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  launchURLOnBrowser(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  htmlEncode(String content) {
    return html2md.convert(content);
  }
}

enum PostContextMenu { OPEN_IN_BROWSER, SHARE }
