import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  var posterSex;
  var posterMajor;
  var PostType;
  var PostTitle;
  var PostContent;
  PostCard(
      {this.posterSex,
      this.posterMajor,
      this.PostContent,
      this.PostTitle,
      this.PostType});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: posterSex == "男" ? Colors.blue : Colors.pink,
                  ),
                  Text(posterMajor),
                ],
              ),
              Text(PostTitle)
            ],
          )
        ],
      ),
    );
  }
}
