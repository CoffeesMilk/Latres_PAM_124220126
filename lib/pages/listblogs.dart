import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latres/pages/detailblogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class listblogs extends StatefulWidget {
  const listblogs({super.key});

  @override
  State<listblogs> createState() => _listblogsState();
}

class _listblogsState extends State<listblogs> {
  late SharedPreferences logindata;
  Future<List<dynamic>> fetchblogs() async {
    final apiblogs =
        await Dio().get('https://api.spaceflightnewsapi.net/v4/blogs/');

    if (apiblogs.statusCode == 200) {
      return apiblogs.data['results'];
    } else {
      throw Exception('Bad request');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchblogs().then((data) {
      setState(() {
        blogslist = data;
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  List<dynamic> blogslist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: blogslist.map((blogs) {
              return Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailblogs(blogsid: blogs['id']),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          '${blogs['image_url']}',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Text('${blogs['title']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        Text(
                          '${blogs['news_site']}',
                        ),
                        Text('${blogs['published_at']}',
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
