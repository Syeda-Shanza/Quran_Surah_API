import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuranSurah extends StatefulWidget {
  const QuranSurah({Key? key}) : super(key: key);

  @override
  State<QuranSurah> createState() => _QuranSurahState();
}

class _QuranSurahState extends State<QuranSurah> {
  late Future<List<dynamic>> userData;

  Future<List<dynamic>> getUserApi() async {
    final response =
    await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString())['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    userData = getUserApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('Quran Surah List',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('loading',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ReusableRow(
                                title: 'number',
                                value: data[index]['number'].toString(),
                              ),
                              ReusableRow(
                                title: 'name',
                                value: data[index]['name'].toString(),
                              ),
                              ReusableRow(
                                title: 'englishName',
                                value: data[index]['englishName'].toString(),
                              ),
                              ReusableRow(
                                title: 'englishNameTranslation',
                                value: data[index]['englishNameTranslation']
                                    .toString(),
                              ),
                              ReusableRow(
                                title: 'name',
                                value: data[index]['name'].toString(),
                              ),
                              ReusableRow(
                                title: 'numberOfAyahs',
                                value: data[index]['numberOfAyahs'].toString(),
                              ),
                              ReusableRow(
                                title: 'revelationType',
                                value: data[index]['revelationType'].toString(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}
