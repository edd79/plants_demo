import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MoreInfoPage extends StatefulWidget {
  final String pdName;

  MoreInfoPage({required this.pdName});

  @override
  _MoreInfoPageState createState() => _MoreInfoPageState();
}
class _MoreInfoPageState extends State<MoreInfoPage> {
  late Future<Database> db;

  @override
  void initState() {
    super.initState();
    db = _initDatabase();
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "pestAndDisease.db");
    // Check if the database exists
    var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "pestAndDisease.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    return await openDatabase(path);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: db,
      builder: (BuildContext context, AsyncSnapshot<Database> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              backgroundColor: Color.fromARGB(133, 17, 31, 14),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(88, 22, 185, 7),
                title: Text(widget.pdName),
                centerTitle: true,
              ),
              body: ListView(
                padding: EdgeInsets.all(10.0),
                children: [
                  _buildInfoCard('About', snapshot.data!),
                  _buildInfoCard('Control Measures', snapshot.data!),
                  _buildInfoCard('Prevention', snapshot.data!),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoCard(String title, Database db) {
    return Card(
      child: FutureBuilder(
        future: _fetchInfo(title, db),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              color: Color.fromARGB(136, 106, 230, 158),
              child: ListTile(
                title: Text(title),
                subtitle: Text(snapshot.data),
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> _fetchInfo(String title, Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(
        'pest_and_disease_data',
        where: 'name = ?',
        whereArgs: [widget.pdName]);
    if (maps.isNotEmpty) {
      return maps[0][title] ?? 'No information available';
    } else {
      return 'No information available';
    }
  }
}