import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;

class BlogViewScreen extends StatefulWidget {
  final String image;
  final String title;
  final String desc;
  final String tags;
  const BlogViewScreen({Key key, this.image, this.title, this.desc, this.tags}) : super(key: key);

  @override
  State<BlogViewScreen> createState() => _BlogViewScreenState();
}

class _BlogViewScreenState extends State<BlogViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: new Card(
            child: Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: global.appInfo.imageUrl + widget.image,
                    imageBuilder: (context, imageProvider) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(image: AssetImage('${global.defaultImage}'), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10),
                      child: Text(
                        widget.tags,
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10, right: 12),
                  child: Html(
                    data: widget.desc,
                    style: {
                      "body": Style(color: Theme.of(context).primaryTextTheme.bodyText1.color),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
