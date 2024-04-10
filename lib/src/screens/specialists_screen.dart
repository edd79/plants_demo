import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';


class Specialist {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  Specialist(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.website});
}

class Specialists extends StatelessWidget {
  const Specialists({Key? key}) : super(key: key);

Future<List<Specialist>> getSpecialists() async {
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
  final Database db = await openDatabase(path);

  final List<Map<String, dynamic>> maps = await db.query('specialists');

  return List.generate(maps.length, (i) {
    return Specialist(
      id: maps[i]['SpecialistID'],
      name: maps[i]['specialist_name'],
      email: maps[i]['email'],
      phone: maps[i]['phone'],
      website: maps[i]['website'],
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(133, 17, 31, 14),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(88, 22, 185, 7),
        title: const Text('Specialist Contacts'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Specialist>>(
        future: getSpecialists(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Specialist>> snapshot) {
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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    color: const Color.fromARGB(136, 106, 230, 158),
                    child: ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Column(
                        children: [
                          Text(
                              'Email:\n ${snapshot.data![index].email}\n\nPhone:\n ${snapshot.data![index].phone}'),
                          TextButton(
                            onPressed: () async {
                              try{
                                var url = Uri.parse(snapshot.data![index].website);
                                print(url);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw 'Could not launch ${snapshot.data![index].website}';
                                }
                
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              snapshot.data![index].website,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
