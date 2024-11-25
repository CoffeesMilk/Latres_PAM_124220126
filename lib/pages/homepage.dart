import 'package:flutter/material.dart';
import 'package:latres/pages/listblogs.dart';
import 'package:latres/pages/listnews.dart';
import 'package:latres/pages/listreports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String? username = '';
  late SharedPreferences logindata;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $username', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listnews(),
                    ),
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/news.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Text('News',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2),
                            Text(
                                'Dapatkan berita terbaru tentang perjalanan ruang angkasa dari berbagai sumber.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listblogs(),
                    ),
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/blogs.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Blogs',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2),
                            Text(
                                'Blogs terkadang memiliki informasi yang lebih detail yang dibuat oleh komunitas yang antusias pada perjalanan ruang angkasa, yuk baca'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listreports(),
                    ),
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/reports.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Reports',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2),
                            Text(
                                'Stasiun ruang angkasa terkadang merilis laporan yang sangat menarik, yuk lihat selengkapnya'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
