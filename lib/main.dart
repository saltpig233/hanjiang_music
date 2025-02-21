import 'package:flutter/material.dart';

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
  var _isRandomPlaying = true;
  var _isPlaying = false;
  var _currentSliderValue = 0.0;

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
                !_isExamMode ? "「迷星叫」" : "?",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(!_isExamMode ? "高松 燈" : "?", style: TextStyle(fontSize: 20)),
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
                        Slider(
                          year2023: false,
                          value: _currentSliderValue,
                          max: 100,
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        SizedBox(height: 4),
                        Text(!_isExamMode ? "03:00 / 04:00" : "..."),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.fast_rewind, size: 40),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
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
                            ListTile(
                              onTap:
                                  () => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: const Text('回答正确！当前战绩 5/123'),
                                      // action: SnackBarAction(
                                      //   label: 'Action',
                                      //   onPressed: () {
                                      //     // Code to execute.
                                      //   },
                                      // ),
                                      width: 300.0,

                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 15,
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                              iconColor: Colors.green,
                              leading: Icon(Icons.music_note),
                              title: Text("迷星叫"),
                              subtitle: Text("高松 燈"),
                              trailing: Icon(Icons.arrow_forward),
                            ),
                            ListTile(
                              iconColor: Colors.red,
                              leading: Icon(Icons.music_note),
                              title: Text("苹果箱"),
                              subtitle: Text("极地熊"),
                              trailing: Icon(Icons.arrow_forward),
                            ),
                            ListTile(
                              iconColor: Colors.red,
                              leading: Icon(Icons.music_note),
                              title: Text("熊出没"),
                              subtitle: Text("陈小雨"),
                              trailing: Icon(Icons.arrow_forward),
                            ),
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
                          Text("题目总数: 123"),
                          Text("已通过: 4"),
                          Text("通过率 34%"),
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
              return ReorderableList(
                shrinkWrap: true,
                itemBuilder:
                    (content, index) => ListTile(
                      key: Key(index.toString()),
                      title: Text("$index"),
                    ),
                itemCount: 5,
                onReorder: (int oldindex, int newindex) {},
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
