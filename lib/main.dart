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

class Status {
  static const PENDING = -1;
  static const SUCCESS = 0;
  static const FAILED = 1;
}

class _MyHomePageState extends State<MyHomePage> {
  String _songPath = 'You haven\'t picked a song yet ^_*';
  String _outDirPath = 'You haven\'t picked an output folder *_^';
  String _outSongSubDir = '...';
  var _status = Status.PENDING;
  final _colorMap = <int, Color>{
    Status.PENDING: Colors.grey,
    Status.SUCCESS: Colors.green,
    Status.FAILED: Colors.red,
  };
  var _resultMsg = 'CLICK the "+" Button after picking song/folder ~~    You\'ll be taken to the output folder once I\'m done ^_^';

  @override
  void initState() {
    initOutDir();
    super.initState();
  }

  void initOutDir() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    _outDirPath = pathlib.join(docDir.parent.path, 'Desktop', 'karagen');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onSelectSong() async {
    final songFile = await openFile(
      acceptedTypeGroups: <XTypeGroup>[
        XTypeGroup(
          label: 'Music Files',
        )
      ],
      initialDirectory: _outDirPath,
      confirmButtonText: 'Select Song',
    );
    setState(() {
      _songPath = songFile!.path;
    });
    // extract subdir name
    _outSongSubDir = pathlib.withoutExtension(pathlib.basename(_songPath));
  }

  Future<void> _onSelectOutDir() async {
    final String? dirPath = await getDirectoryPath(
      initialDirectory: _outDirPath,
      confirmButtonText: 'Select Folder',
    );
    setState(() {
      if (dirPath != null) {
        _outDirPath = pathlib.join(dirPath, 'karagen');
      }
    });
  }

  Future<void> _onSubmit() async {
    final outDir = Directory(_outDirPath).createSync();
    var env = Platform.environment;
    var sysPath = '';
    if (Platform.isWindows) {
      sysPath = env['PATH'] ?? 'c:\\python\\python38\\Scripts;c:\\python\\python38';
    } else if (Platform.isMacOS) {
      sysPath = '/Library/Frameworks/Python.framework/Versions/3.8/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:';
    }

    // modal progress
    uiutil.openProgressUI(context, 'Working ...');
    // spleeter separate -p spleeter:2stems -o output audio_example.mp3
    var result = await Process.run('spleeter', [
      'separate',
      '-p',
      'spleeter:2stems',
      '-b',
      '320k',
      '-o',
      _outDirPath,
      '$_songPath'
    ],
    environment: {
      'PATH': sysPath,
    });
    // print('status: ${result.exitCode}');
    // print('stdout: ${result.stdout}');
    // print('stderr: ${result.stderr}');
    // final outfile = File(pathlib.join(_outDirPath, 'stdout.txt'));
    // final errfile = File(pathlib.join(_outDirPath, 'stderr.txt'));
    // final envfile = File(pathlib.join(_outDirPath, 'stdenv.txt'));
    // await outfile.writeAsString(result.stdout);
    // await errfile.writeAsString(result.stderr);
    // await envfile.writeAsString(Platform.environment['PATH'].toString());
    uiutil.closeProgressUI(context);

    setState(() {
      if (result.exitCode == 0) {
        _status = result.exitCode;
        final outSongPath = pathlib.join(_outDirPath, _outSongSubDir, 'accompaniment.wav');
        _resultMsg = 'Generated: $outSongPath';
      } else {
        _status = 1;
        _resultMsg = """Failed! 
- Have you picked a song? :(
- Is your internet connection OK? You may need a VPN or a proxy :(
- The pre-cached data may be empty or corrupted :( Try deleting the folder karagen/pretrained_models and run me again  
""";
      }
    });

    if (result.exitCode != 0) {
      return;
    }

    // open location
    final dirToOpen = pathlib.join(_outDirPath, _outSongSubDir);
    if (Platform.isWindows) {
      var result = await Process.run('explorer', [dirToOpen]);
    } else {
      var result = await Process.run('open', [dirToOpen]);
    }

  }

  @override
  Widget build(BuildContext context) {
    const horiPad = 30.0;
    final title = '${widget.title}: sing the songs you love';
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(horiPad, 30, 8.0, 0),
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onPressed: _onSelectSong,
                        child: const Text('Pick a Song    ')),
                    VerticalDivider(),
                    Expanded(
                      child: Text(
                        _songPath,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(horiPad, 30, 8.0, 0),
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onPressed: _onSelectOutDir,
                        child: const Text('Output Folder')),
                    VerticalDivider(),
                    Expanded(
                      child: Text(
                        _outDirPath,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(),
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(horiPad, 30, 8.0, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset('_assets/parrot.png',
                          width: 60,
                          height: 60,
                        )
                      )
                  ),
                  VerticalDivider(),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 8.0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hi There :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: _colorMap[_status],
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(horiPad, 30, 8.0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _resultMsg,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _colorMap[_status],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        tooltip: 'Extract Accompaniment Track',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
