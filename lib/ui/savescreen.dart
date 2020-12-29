import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

class SaveScreen extends StatefulWidget {
  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  //Declare Globaly
  String directory;
  List<io.FileSystemEntity> file = new List<io.FileSystemEntity>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      file = io.Directory("storage/emulated/0/StatusSaver").listSync();
      file = file.reversed.toList();
      //use your folder name insted of resume.
    });
  }

  // Build Part
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saved Files',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Saved Files"),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: file == null ? 0 : file.length,
              itemBuilder: (BuildContext context, int index) {
                if (file.length == 0) {
                  return Center(
                    child: Text("No saved files exist"),
                  );
                }

                return Card(
                  child: ListTile(
                    onTap: () {
                      OpenFile.open(file[index].path);
                      print(file[index]);
                    },
                    title: Text(file[index]
                        .toString()
                        .split('/')
                        .last
                        .replaceAll("'", "")),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
