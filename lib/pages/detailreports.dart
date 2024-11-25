import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class detailreports extends StatefulWidget {
  final int reportid;
  const detailreports({super.key, required this.reportid});

  @override
  State<detailreports> createState() => _detailreportsState();
}

class _detailreportsState extends State<detailreports> {
  late SharedPreferences logindata;
  Future<Map<String, dynamic>> fetchdetail() async {
    final detailreport = await Dio().get(
        'https://api.spaceflightnewsapi.net/v4/reports/${widget.reportid}');

    if (detailreport.statusCode == 200) {
      return detailreport.data;
    } else {
      throw Exception('Bad request');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdetail().then((data) {
      setState(() {
        reportdetail = data;
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> reportdetail = {};

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
                '${reportdetail['image_url']}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${reportdetail['title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${reportdetail['news_site']}',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${reportdetail['published_at']}',
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                '${reportdetail['summary']}',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          launchURL(reportdetail['url']);
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
