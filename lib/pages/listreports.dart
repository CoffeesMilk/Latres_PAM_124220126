import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latres/pages/detailreports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class listreports extends StatefulWidget {
  const listreports({super.key});

  @override
  State<listreports> createState() => _listreportsState();
}

class _listreportsState extends State<listreports> {
  late SharedPreferences logindata;
  Future<List<dynamic>> fetchreports() async {
    final apireports =
        await Dio().get('https://api.spaceflightnewsapi.net/v4/reports/');

    if (apireports.statusCode == 200) {
      return apireports.data['results'];
    } else {
      throw Exception('Bad request');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchreports().then((data) {
      setState(() {
        reportslist = data;
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  List<dynamic> reportslist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: reportslist.map((reports) {
              return Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            detailreports(reportid: reports['id']),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          '${reports['image_url']}',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Text('${reports['title']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        Text(
                          '${reports['news_site']}',
                        ),
                        Text('${reports['published_at']}',
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
