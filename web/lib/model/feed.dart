
class Feed {
  String? title;
  String? pubDate;
  String? link;
  String? guid;
  String? author;
  String? thumbnail;
  String? description;
  String? content;

  Feed(
      {this.pubDate,
        this.link,
        this.guid,
        this.author,
        this.thumbnail,
        this.description,
        this.content,
        this.title});

  Feed.fromJson(Map<String, dynamic> json) {
    pubDate = json['pubDate'];
    link = json['link'];
    guid = json['guid'];
    author = json['author'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    title = json['title'];
    content = json['content'];
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
  };

}