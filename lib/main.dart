import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as pathlib;
import 'package:path_provider/path_provider.dart';

import 'util.dart' as uiutil;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appName = 'karagen';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: _appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // CAUTION: required is needed for sound null safety
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  // EDIT: Add your widgets and controllers here
  //
  String _songPath = 'You haven\'t selected any song';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onSelectDir() async {
    Directory startupDir = await getApplicationDocumentsDirectory();
    if (Platform.isMacOS) {
      final homeDir = pathlib.join(startupDir.path, '..');
      startupDir = Directory(homeDir);
    }
    final songFile = await openFile(
      acceptedTypeGroups: <XTypeGroup>[XTypeGroup(
        label: 'Music Files',
      )],
      initialDirectory: startupDir.path,
      confirmButtonText: 'Select Song',
    );
    setState(() {
      _songPath = songFile!.path;
    });
  }

  Future<void> _onSubmit() async {
    // modal progress
    uiutil.openProgressUI(context, 'Working ...');
    // spleeter separate -p spleeter:2stems -o output audio_example.mp3
    var result = await Process.run('spleeter',
        ['separate', '-p', 'spleeter:2stems', '-b', '320k', '-o', 'D:\\kakyo\\_dev\\karagen\\build\\windows\\runner\\Debug\\output', _songPath]);
    print('status: ${result.exitCode}');
    print('stdout: ${result.stdout}');
    print('stderr: ${result.stderr}');
    uiutil.closeProgressUI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 30, 8.0, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: _onSelectDir,
                      child: const Text('Click Me to Pick a Song File')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_songPath,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(),
                )
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        tooltip: 'Extract Instrumental Track',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
