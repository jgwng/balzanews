
import 'package:flutter/foundation.dart';

class Article {
  String? title;
  String? pubDate;
  String? link;
  String? guid;
  String? author;
  String? thumbnail;
  String? description;
  String? content;
  String? techCorp;
  bool useLink = false;
  ValueNotifier<bool> readYn = ValueNotifier(false);
  ValueNotifier<bool> bookMarkYN = ValueNotifier(false);

  Article(
      {this.pubDate,
        this.link,
        this.guid,
        this.author,
        this.thumbnail,
        this.description,
        this.content,
        this.title,
        this.techCorp,
        this.useLink = false
      });

  Article.fromJson(Map<String, dynamic> json) {
    pubDate = json['pubDate'];
    link = json['link'];
    guid = json['guid'];
    author = json['author'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    title = json['title'];
    techCorp = json['techCorp'];
    content = json['content'];
    useLink = json['useLink'] ?? false;
  }

  Map<String, dynamic> toJson() => {
    'pubDate': pubDate,
    'link': link,
    'guid': guid,
    'author': author,
    'thumbnail': thumbnail,
    'description': description,
    'content': content,
    'title': title,
    'useLink' : useLink,
    'techCorp' : techCorp,
  };

}