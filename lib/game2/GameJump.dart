import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game_somo/components/game_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Quiz/quiz1.dart';
import 'Quiz/quiz2.dart';
import 'Quiz/quiz3.dart';
import 'Quiz/quiz4.dart';
import 'Quiz/quiz5.dart';
import 'Quiz/quiz6.dart';
import 'Quiz/quiz7.dart';
import 'Quiz/quiz8.dart';
import 'Quiz/quiz9.dart';
import 'Quiz/quiz10.dart';

import 'components/LevelButton2.dart';

class GameJump extends StatefulWidget {
  const GameJump({Key? key}) : super(key: key);

  @override
  _GameJumpState createState() => _GameJumpState();
}

class _GameJumpState extends State<GameJump> with WidgetsBindingObserver {
  int? level1CoinScore;
  int? level2CoinScore;
  int? level3CoinScore;
  int? level4CoinScore;
  int? level5CoinScore;
  int? level6CoinScore;
  int? level7CoinScore;
  int? level8CoinScore;
  int? level9CoinScore;
  int? level10CoinScore;

  // level1
  int? answeredQuestions1;
  int? incorrectAnswers1;
  // level2
  int? answeredQuestions2;
  int? incorrectAnswers2;
  // level3
  int? answeredQuestions3;
  int? incorrectAnswers3;
  // level4
  int? answeredQuestions4;
  int? incorrectAnswers4;
  // level5
  int? answeredQuestions5;
  int? incorrectAnswers5;
  // level6
  int? answeredQuestions6;
  int? incorrectAnswers6;
  // level7
  int? answeredQuestions7;
  int? incorrectAnswers7;
  // level8
  int? answeredQuestions8;
  int? incorrectAnswers8;
  // level9
  int? answeredQuestions9;
  int? incorrectAnswers9;
  // level10
  int? answeredQuestions10;
  int? incorrectAnswers10;

  late AudioPlayer _backgroundAudioPlayer;
  late AudioPlayer _audioPlayer;
  bool _isMusicPlaying = false; // Flag to track music playback

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _backgroundAudioPlayer = AudioPlayer();
    _playBackgroundMusic();
    _loadCoinScores();
    _loadAnswerCounts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    _backgroundAudioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      _resumeBackgroundMusic();
    }
  }

Future<void> _playBackgroundMusic() async {
  if (!_isMusicPlaying) {
    // Only play if not already playing
    try {
      await _backgroundAudioPlayer.play(AssetSource('audio/lofi.mp3'), volume: 0.5);
      setState(() {
        _isMusicPlaying = true;
      });
      print('Background music started');
    } catch (e) {
      print('Error playing background music: $e');
    }
  }
}
  
void _pauseBackgroundMusic() {
  if (_isMusicPlaying) {
    _backgroundAudioPlayer.pause();
    setState(() {
      _isMusicPlaying = false;
    });
    print('Background music paused');
  }
}

void _resumeBackgroundMusic() {
  if (!_isMusicPlaying) {
    _backgroundAudioPlayer.resume();
    setState(() {
      _isMusicPlaying = true;
    });
    print('Background music resumed');
  }
}

void _stopBackgroundMusic() {
  if (_isMusicPlaying) {
    _backgroundAudioPlayer.stop();
    setState(() {
      _isMusicPlaying = false;
    });
    print('Background music stopped');
  }
}

  Future<void> _loadCoinScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      level1CoinScore = prefs.getInt('level1CoinScore') ?? 0;
      level2CoinScore = prefs.getInt('level2CoinScore') ?? 0;
      level3CoinScore = prefs.getInt('level3CoinScore') ?? 0;
      level4CoinScore = prefs.getInt('level4CoinScore') ?? 0;
      level5CoinScore = prefs.getInt('level5CoinScore') ?? 0;
      level6CoinScore = prefs.getInt('level6CoinScore') ?? 0;
      level7CoinScore = prefs.getInt('level7CoinScore') ?? 0;
      level8CoinScore = prefs.getInt('level8CoinScore') ?? 0;
      level9CoinScore = prefs.getInt('level9CoinScore') ?? 0;
      level10CoinScore = prefs.getInt('level10CoinScore') ?? 0;
    });
  }

  Future<void> _loadAnswerCounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // level1
      answeredQuestions1 = prefs.getInt('answeredQuestions1');
      incorrectAnswers1 = prefs.getInt('incorrectAnswers1');
      // level2
      answeredQuestions2 = prefs.getInt('answeredQuestions2');
      incorrectAnswers2 = prefs.getInt('incorrectAnswers2');
      // level3
      answeredQuestions3 = prefs.getInt('answeredQuestions3');
      incorrectAnswers3 = prefs.getInt('incorrectAnswers3');
      // level4
      answeredQuestions4 = prefs.getInt('answeredQuestions4');
      incorrectAnswers4 = prefs.getInt('incorrectAnswers4');
      // level5
      answeredQuestions5 = prefs.getInt('answeredQuestions5');
      incorrectAnswers5 = prefs.getInt('incorrectAnswers5');
      // level6
      answeredQuestions6 = prefs.getInt('answeredQuestions6');
      incorrectAnswers6 = prefs.getInt('incorrectAnswers6');
      // level7
      answeredQuestions7 = prefs.getInt('answeredQuestions7');
      incorrectAnswers7 = prefs.getInt('incorrectAnswers7');
      // level8
      answeredQuestions8 = prefs.getInt('answeredQuestions8');
      incorrectAnswers8 = prefs.getInt('incorrectAnswers8');
      // level9
      answeredQuestions9 = prefs.getInt('answeredQuestions9');
      incorrectAnswers9 = prefs.getInt('incorrectAnswers9');
      // level10
      answeredQuestions10 = prefs.getInt('answeredQuestions10');
      incorrectAnswers10 = prefs.getInt('incorrectAnswers10');
    });
  }

  // Function to reset high score for all levels
  Future<void> resetHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // level1
    prefs.remove('answeredQuestions1');
    prefs.remove('incorrectAnswers1');
    // level2
    prefs.remove('answeredQuestions2');
    prefs.remove('incorrectAnswers2');
    // level3
    prefs.remove('answeredQuestions3');
    prefs.remove('incorrectAnswers3');
    // level4
    prefs.remove('answeredQuestions4');
    prefs.remove('incorrectAnswers4');
    // level5
    prefs.remove('answeredQuestions5');
    prefs.remove('incorrectAnswers5');
    // level6
    prefs.remove('answeredQuestions6');
    prefs.remove('incorrectAnswers6');
    // level7
    prefs.remove('answeredQuestions7');
    prefs.remove('incorrectAnswers7');
    // level8
    prefs.remove('answeredQuestions8');
    prefs.remove('incorrectAnswers8');
    // level9
    prefs.remove('answeredQuestions9');
    prefs.remove('incorrectAnswers9');
    // level10
    prefs.remove('answeredQuestions10');
    prefs.remove('incorrectAnswers10');

    // Reset coin scores
    prefs.remove('level1CoinScore');
    prefs.remove('level2CoinScore');
    prefs.remove('level3CoinScore');
    prefs.remove('level4CoinScore');
    prefs.remove('level5CoinScore');
    prefs.remove('level6CoinScore');
    prefs.remove('level7CoinScore');
    prefs.remove('level8CoinScore');
    prefs.remove('level9CoinScore');
    prefs.remove('level10CoinScore');

    _loadAnswerCounts(); // Reload high scores after reset
    _loadCoinScores();
  }

  void showHighScoresDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.black.withOpacity(0.8), // Black transparent background
          title: const Text(
            'สรุปคะแนน Quiz',
            style: TextStyle(
              fontFamily: 'PixelFont', // Use a pixel art font
              color: Colors.white, // White text color for visibility
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      'Level 1',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions1 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers1 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 2',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions2 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers2 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 3',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions3 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers3 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 4',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions4 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers4 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 5',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions5 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers5 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 6',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions6 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers6 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 7',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions7 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers7 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 8',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions8 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers8 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 9',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions9 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers9 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Level 10',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ถูก: ${answeredQuestions10 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ผิด: ${incorrectAnswers10 ?? '-'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            PixelGameButton(
              height: 60,
              width: 200,
              text: 'Close',
              onTap: () {
                _playSound(); // Play sound when button is pressed
                Navigator.pop(context); // Close the dialog
              },
              onTapUp: () {},
              onTapDown: () {},
              onTapCancel: () {},
              backgroundColor: Colors.green,
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            )
          ],
        );
      },
    );
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource(
        'sounds/button_click.mp3')); // Adjust the path to your sound file
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _stopBackgroundMusic();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/bg2.gif'), // Replace with your GIF path
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Back button positioned at the top left corner
              Positioned(
                top: 16.0,
                left: 16.0,
                child: ElevatedButton(
                  onPressed: () {
                    _playSound(); // Play sound when button is pressed
                    // _stopBackgroundMusic();
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors
                        .transparent, // Make the button background transparent
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
 
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelLevelButton2(
                          level: 1,
                          isUnlocked: true,
                          nextScreen: Quiz1(
                              onResumeMusic:
                                  _playBackgroundMusic), // Pass the function
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 2,
                          isUnlocked:
                              level1CoinScore != null && level1CoinScore! >= 10,
                          nextScreen:
                              Quiz2(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 3,
                          isUnlocked:
                              level2CoinScore != null && level2CoinScore! >= 10,
                          nextScreen:
                              Quiz3(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 4,
                          isUnlocked:
                              level3CoinScore != null && level3CoinScore! >= 12,
                          nextScreen:
                              Quiz4(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 5,
                          isUnlocked:
                              level4CoinScore != null && level4CoinScore! >= 12,
                          nextScreen:
                              Quiz5(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelLevelButton2(
                          level: 6,
                          isUnlocked:
                              level5CoinScore != null && level5CoinScore! >= 14,
                          nextScreen:
                              Quiz6(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 7,
                          isUnlocked:
                              level6CoinScore != null && level6CoinScore! >= 14,
                          nextScreen:
                              Quiz7(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 8,
                          isUnlocked:
                              level7CoinScore != null && level7CoinScore! >= 16,
                          nextScreen:
                              Quiz8(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 9,
                          isUnlocked:
                              level8CoinScore != null && level8CoinScore! >= 16,
                          nextScreen:
                              Quiz9(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton2(
                          level: 10,
                          isUnlocked:
                              level9CoinScore != null && level9CoinScore! >= 18,
                          nextScreen:
                              Quiz10(onResumeMusic: _playBackgroundMusic),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                          onTap: _stopBackgroundMusic,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(
                      14.0), // Adjust the padding as needed
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // View High Scores Button
                      FutureBuilder(
                        future: _loadAnswerCounts(),
                        builder: (context, snapshot) {
                          return IconButton(
                            icon: Icon(Icons.emoji_events,
                                color:
                                    const Color.fromARGB(255, 209, 208, 208)),
                            iconSize: 35, // Adjust icon size
                            onPressed: () {
                              _playSound(); // Play sound when button is pressed
                              showHighScoresDialog(context);
                            },
                            color: Colors.white, // Background color
                            padding:
                                EdgeInsets.all(5), // Padding around the icon
                            splashRadius: 30, // Splash radius for the button
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh), // Use the desired icon
                        onPressed: () async {
                          _playSound(); // Play sound when button is pressed
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Reset"),
                                content: Text("Are you sure you want to reset high scores?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // Return false
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true); // Return true
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          _playBackgroundMusic(); // Play background music after dialog is closed
                          if (confirm == true) {
                            resetHighScores();
                          }
                        },
                        color: const Color.fromARGB(255, 209, 208, 208), // Set the icon color
                        iconSize: 35.0, // Set the icon size (adjust as needed)
                      ),
                      // MusicToggleButton
                      IconButton(
                        icon: Icon(_isMusicPlaying ? Icons.music_off : Icons.music_note),
                        color: const Color.fromARGB(255, 209, 208, 208),
                        iconSize: 35.0,
                        onPressed: () {
                          setState(() {
                            if (_isMusicPlaying) {
                              _stopBackgroundMusic();
                            } else {
                              _playBackgroundMusic();
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
