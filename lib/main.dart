import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hanjiang_music/music.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Exam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _isExamMode = false;
  var _isRandomPlaying = false;
  var _isPlaying = false;
  var _currentSliderValue = 0.0;

  var _musicList = List<String>.from(musicTitles);
  var _currentMusicIndex = 0;
  var _currentMusic = musicTitles[0];

  var _currentTestTotal = 0;
  var _currentTestPassed = 0;

  var _musicLength = "";
  var _musicpos = "";

  // void refreshRandom(){
  //   var totalnum = _musicList.length;
  //   setState(() {
  //     _currentMusicIndex = Random().nextInt(totalnum);
  //     _currentMusic = _musicList[_currentMusicIndex];
  //   });
  // }

  AudioPlayer player = AudioPlayer();
  Duration _pausedPosition = Duration.zero;

  Future playMusic() async {
    if (_pausedPosition != Duration.zero) {
      player.seek(_pausedPosition);
    }
    player.play(UrlSource("https://unpkg.com/hjmusic-res@1.0.0/$_currentMusic.mp3"));
  }

  Future pauseMusic() async {
    _pausedPosition = await player.getCurrentPosition() ?? Duration.zero;
    player.pause();
  }

  void taskDone(bool isCorrect) {
    setState(() {
      _currentTestTotal++;
      if (isCorrect) {
        _currentTestPassed++;
      }
    });
  }

  void changeCurrentMusicIndex(int index) {
    setState(() {
      _currentMusicIndex = index;
      _currentMusic = _musicList[_currentMusicIndex];
    });
    player.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void listShuffle() {
    setState(() {
      var random = Random();
      for (var i = _musicList.length - 1; i > 0; i--) {
        var j = random.nextInt(i + 1);
        var temp = _musicList[i];
        _musicList[i] = _musicList[j];
        _musicList[j] = temp;
      }

      _currentMusicIndex = 0;
      _currentMusic = _musicList[_currentMusicIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    listShuffle();
    player.setReleaseMode(ReleaseMode.loop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("音乐练习室 || " + (_isExamMode ? '😎 考试模式' : '🤗 练习模式')),
        leading: IconButton(
          onPressed: () {
            setState(() {
              _isExamMode = !_isExamMode;
            });
          },
          icon: _isExamMode ? Icon(Icons.draw) : Icon(Icons.draw_outlined),
          tooltip: _isExamMode ? '切换练习模式' : "切换考试模式",
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Card.filled(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    height: 250,
                    width: 250,
                    child: CircleAvatar(backgroundColor: Colors.amber),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                !_isExamMode ? _currentMusic : "?",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              // Text(!_isExamMode ? "高松 燈" : "?", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // LinearProgressIndicator(
                        //   minHeight: 8,
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   value: 0.8,
                        //   semanticsLabel: 'Linear progress indicator',
                        // ),
                        // Slider(
                        //   year2023: false,
                        //   value: _currentSliderValue,
                        //   // max: player.getDuration(),
                        //   onChanged: (double value) {
                        //     setState(() {
                        //       _currentSliderValue = value;
                        //     });
                        //   },
                        // ),
                        StreamBuilder<Duration>(
                          stream: player.onPositionChanged,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return FutureBuilder<Duration?>(
                              future: player.getDuration(),
                              builder: (context, durationSnapshot) {
                                final maxDuration =
                                    durationSnapshot.data?.inSeconds
                                        .toDouble() ??
                                    1.0;
                                return Slider(
                                  year2023: false,
                                  value: position.inSeconds.toDouble().clamp(0, maxDuration),
                                  max: maxDuration,
                                  onChanged: (value) {
                                    player.seek(
                                      Duration(seconds: value.toInt()),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 4),
                        StreamBuilder<Duration>(
                          stream: player.onPositionChanged,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            _musicpos = position.toString().split('.').first;
                            player.onDurationChanged.listen((Duration d) {
                              setState(() {
                                _musicLength = d.toString().split('.').first;
                              });
                            });

                            return Text(
                              !_isExamMode
                                  ? "${position.toString().split('.').first} / ${_musicLength ?? "0:00"}"
                                  : "...",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // -1
                          changeCurrentMusicIndex(
                            _currentMusicIndex == 0
                                ? _musicList.length - 1
                                : _currentMusicIndex - 1,
                          );
                        },
                        icon: Icon(Icons.fast_rewind, size: 40),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_isPlaying)
                              pauseMusic();
                            else
                              playMusic();

                            _isPlaying = !_isPlaying;
                          });
                        },
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          changeCurrentMusicIndex(
                            _currentMusicIndex == _musicList.length - 1
                                ? 0
                                : _currentMusicIndex + 1,
                          );
                        },
                        icon: Icon(Icons.fast_forward, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),

              _isExamMode
                  ? Card.filled(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: SizedBox(
                        width: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(5, (index) {
                              var options = List<String>.from(_musicList);
                              var _isend = false;
                              options.remove(_currentMusic);

                              var random = Random();
                              for (var i = options.length - 1; i > 0; i--) {
                                var j = random.nextInt(i + 1);
                                var temp = options[i];
                                options[i] = options[j];
                                options[j] = temp;
                              }

                              var correctIndex = Random().nextInt(5);
                              if (index != correctIndex) {
                                return ListTile(
                                  leading: Icon(
                                    Icons.music_note,
                                    color: _isend ? Colors.red : null,
                                  ),
                                  title: Text(options[index]),
                                  onTap:
                                      () => {
                                        setState(() {
                                          _currentTestTotal++;
                                          _isExamMode = false;
                                        }),
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '回答错误~ 当前战绩 $_currentTestPassed/$_currentTestTotal',
                                            ),
                                            width: 300.0,

                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                              vertical: 15,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                              milliseconds: 700,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                      },
                                );
                              } else {
                                return ListTile(
                                  leading: Icon(
                                    Icons.music_note,
                                    color: _isend ? Colors.green : null,
                                  ),
                                  title: Text(
                                    _currentMusic,
                                  ),
                                  onTap:
                                      () => {
                                        changeCurrentMusicIndex(
                                          _currentMusicIndex ==
                                                  _musicList.length - 1
                                              ? 0
                                              : _currentMusicIndex + 1,
                                        ),
                                        setState(() {
                                          _currentTestTotal++;
                                          _currentTestPassed++;
                                        }),
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '回答正确！当前战绩 $_currentTestPassed/$_currentTestTotal',
                                            ),
                                            width: 300.0,

                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                              vertical: 15,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                              milliseconds: 700,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                      },
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  )
                  : SizedBox(),

              SizedBox(height: 20),
              Text("❤️ Developed by FlipWind x SaltPig233."),
              Text("2025.2.21"),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isRandomPlaying = !_isRandomPlaying;
                });
              },
              tooltip: _isRandomPlaying ? '随机播放' : '顺序播放',
              icon: _isRandomPlaying ? Icon(Icons.shuffle) : Icon(Icons.repeat),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("来看看你的成绩！😘"),
                      icon: Icon(Icons.flag_outlined),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "当前战绩：",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("题目总数: $_currentTestTotal"),
                          Text("已通过: $_currentTestPassed"),
                          Text(
                            "通过率: ${_currentTestTotal == 0 ? 0.00 : (_currentTestPassed / _currentTestTotal * 100).toStringAsFixed(2)}%",
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              tooltip: '战绩信息',
              icon: Icon(Icons.info_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.cloud_download_outlined),
              tooltip: "下载音乐包",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            builder: (context) {
              return SizedBox(
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "当前播放列表",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            listShuffle();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.shuffle_rounded),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ReorderableListView(
                            children: [
                              for (
                                int index = 0;
                                index < _musicList.length;
                                index++
                              )
                                ListTile(
                                  selected: _currentMusicIndex == index,
                                  onTap: () {
                                    changeCurrentMusicIndex(index);
                                  },
                                  key: Key('$index'),
                                  leading: Icon(
                                    Icons.music_note_outlined,
                                    color:
                                        _currentMusicIndex == index
                                            ? Colors.amber
                                            : null,
                                  ),
                                  title: Text(_musicList[index]),
                                ),
                            ],
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final item = _musicList.removeAt(oldIndex);
                                _musicList.insert(newIndex, item);

                                // _currentMusicIndex = newIndex;
                                changeCurrentMusicIndex(newIndex);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: '播放列表',
        child: Icon(Icons.queue_music),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
