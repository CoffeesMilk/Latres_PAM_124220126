import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class detailnews extends StatefulWidget {
  final int newsid;
  const detailnews({super.key, required this.newsid});

  @override
  State<detailnews> createState() => _detailnewsState();
}

class _detailnewsState extends State<detailnews> {
  late SharedPreferences logindata;
  Future<Map<String, dynamic>> fetchdetail() async {
    final detailnews = await Dio()
        .get('https://api.spaceflightnewsapi.net/v4/articles/${widget.newsid}');

    if (detailnews.statusCode == 200) {
      return detailnews.data;
    } else {
      throw Exception('Bad request');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdetail().then((data) {
      setState(() {
        newsdetail = data;
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> newsdetail = {};

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.network(
                '${newsdetail['image_url']}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${newsdetail['title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${newsdetail['news_site']}',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${newsdetail['published_at']}',
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                '${newsdetail['summary']}',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          launchURL(newsdetail['url']);
        },
        label: Text(
          'Buka di browser',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.open_in_browser,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
