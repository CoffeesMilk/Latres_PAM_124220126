import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latres/pages/detailnews.dart';
import 'package:shared_preferences/shared_preferences.dart';

class listnews extends StatefulWidget {
  const listnews({super.key});

  @override
  State<listnews> createState() => _listnewsState();
}

class _listnewsState extends State<listnews> {
  late SharedPreferences logindata;
  Future<List<dynamic>> fetchnews() async {
    final apinews =
        await Dio().get('https://api.spaceflightnewsapi.net/v4/articles/');

    if (apinews.statusCode == 200) {
      return apinews.data['results'];
    } else {
      throw Exception('Bad request');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchnews().then((data) {
      setState(() {
        newslist = data;
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  List<dynamic> newslist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: newslist.map((news) {
              return Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailnews(newsid: news['id']),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          '${news['image_url']}',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Text('${news['title']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        Text(
                          '${news['news_site']}',
                        ),
                        Text('${news['published_at']}',
                            overflow: TextOverflow.ellipsis, maxLines: 2),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
