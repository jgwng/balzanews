import 'dart:convert';

import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/model/feed.dart';
import 'package:balzanewsweb/screens/html_viewer_screen.dart';
import 'package:balzanewsweb/screens/iframe_viewer_screen.dart';
import 'package:balzanewsweb/util/device_padding.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Feed> topStories = [];
  Future? initData;
  int selectedIndex = 8;
  var techCorp = TechCorps.values[8];

  @override
  void initState() {
    initData = getArticles();
    super.initState();
  }

  Future<void> getArticles() async {
    const String apiKey = String.fromEnvironment("API_KEY");
    var queryParameters = {
          'rss_url': techCorp.rssUrl,
          'count' : '10'
    };
    if(apiKey.isNotEmpty){
      queryParameters.addAll({
        'count' : '25',
        'api_key' : apiKey,
      });
    }
    final uri = Uri.https('api.rss2json.com', '/v1/api.json', queryParameters);
    final response = await http.get(uri);
    var data = json.decode(response.body);
    setState(() {
      List<Feed> stories = [];
      for (var v in data['items'] ?? []) {
        stories.add(Feed.fromJson(v));
      }
      topStories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 28, bottom: 12),
              child: Text(
                '현재 신문사',
                style: TextStyle(fontSize: 20.fs, fontFamily: AppFonts.bold),
              ),
            ),
            InkWell(
              onTap: () async {
                var result = await _showGridBottomSheet(context);
                if (result != null) {
                  if (selectedIndex == result) return;
                  selectedIndex = result;
                  techCorp = TechCorps.values[result];
                  getArticles();
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Color(0xFFDDDDDD))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      techCorp.name,
                      style: TextStyle(fontFamily: AppFonts.bold, fontSize: 16),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 24,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.s,
            ),
            Padding(
              padding: EdgeInsets.only(top: 28, bottom: 12),
              child: Text(
                '주요 뉴스',
                style: TextStyle(fontSize: 20.fs, fontFamily: AppFonts.bold),
              ),
            ),
            FutureBuilder(
              future: initData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (topStories.isEmpty) {
                  return const SizedBox();
                }
                return ListView.separated(
                  itemCount: topStories.length,
                  shrinkWrap: true,
                  primary: false,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 12,
                    );
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          if(techCorp.useLink == false){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HtmlIframeViewer(
                                      htmlContent: topStories[index].content ?? '',
                                    )));
                          }else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IframeWidget(
                                      link: topStories[index].link ?? '' ?? '',
                                    )));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Color(0xFFDDDDDD))),
                          child: Text(
                            (topStories[index].title ?? '')
                                .replaceAll('&amp;', ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: AppFonts.bold, fontSize: 16),
                          ),
                        ));
                  },
                );
              },
            ),
            SizedBox(
              height: (PlatformUtil.isPWA) ? 24 + bottomInset() : 24,
            )
          ],
        ),
      ),
    );
  }

  Future<int?> _showGridBottomSheet(BuildContext context) async {
    var result = await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      // Allows dynamic height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // 60% screen height
          child: Column(
            children: [
              SizedBox(
                height: 12.s,
              ),
              Container(
                width: 40.s,
                height: 4.s,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(
                height: 12.s,
              ),
              Text(
                '신문사 선택',
                textAlign: TextAlign.center,
                style: AppStyles.w500.copyWith(
                  fontSize: 18.fs,
                  height: 24 / 18,
                  letterSpacing: -0.6.fs,
                ),
              ),
              SizedBox(
                height: 12.s,
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: TechCorps.values.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pop(context, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFDDDDDD)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(TechCorps.values[index].name,
                              style: AppStyles.w500.copyWith(
                                fontSize: 16.fs
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    return result;
  }
}
