import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class detailblogs extends StatefulWidget {
  final int blogsid;
  const detailblogs({super.key, required this.blogsid});

  @override
  State<detailblogs> createState() => _detailblogsState();
}

class _detailblogsState extends State<detailblogs> {
  late SharedPreferences logindata;
  Future<Map<String, dynamic>> fetchdetail() async {
    final detailblogs = await Dio()
        .get('https://api.spaceflightnewsapi.net/v4/blogs/${widget.blogsid}');

    if (detailblogs.statusCode == 200) {
      return detailblogs.data;
    } else {
      throw Exception('Bad request');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdetail().then((data) {
      setState(() {
        blogsdetail = data;
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> blogsdetail = {};

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
                '${blogsdetail['image_url']}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${blogsdetail['title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${blogsdetail['news_site']}',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${blogsdetail['published_at']}',
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                '${blogsdetail['summary']}',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          launchURL(blogsdetail['url']);
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
