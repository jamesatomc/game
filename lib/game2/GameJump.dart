import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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

  int? answeredQuestions1;
  int? incorrectAnswers1;

  int? answeredQuestions2;
  int? incorrectAnswers2;

  late AudioPlayer _audioPlayer;
  bool _isMusicPlaying = false; // Flag to track music playback

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
    _loadCoinScores();
    _loadAnswerCounts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
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
        await _audioPlayer.play(AssetSource('audio/lofi.mp3'), volume: 0.5);
        _isMusicPlaying = true;
        print('Background music started');
      } catch (e) {
        print('Error playing background music: $e');
      }
    }
  }

  void _pauseBackgroundMusic() {
    if (_isMusicPlaying) {
      _audioPlayer.pause();
      _isMusicPlaying = false;
      print('Background music paused');
    }
  }

  void _resumeBackgroundMusic() {
    if (!_isMusicPlaying) {
      _audioPlayer.resume();
      _isMusicPlaying = true;
      print('Background music resumed');
    }
  }

  void _stopBackgroundMusic() {
    if (_isMusicPlaying) {
      _audioPlayer.stop();
      _isMusicPlaying = false;
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
    });
  }


    // Function to reset high score for all levels
  Future<void> resetHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('answeredQuestions1');
    prefs.remove('incorrectAnswers1');



    _loadAnswerCounts(); // Reload high scores after reset
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
                              level1CoinScore != null && level1CoinScore! >= 10
                              ,
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
                              level2CoinScore != null && level2CoinScore! >= 10
                              ,
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
                              level3CoinScore != null && level3CoinScore! >= 12
                              ,
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
                              level4CoinScore != null && level4CoinScore! >= 12
                              ,
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
                              level5CoinScore != null && level5CoinScore! >= 14
                              ,
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
                              level6CoinScore != null && level6CoinScore! >= 14
                              ,
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
                              level7CoinScore != null && level7CoinScore! >= 16
                              ,
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
                              level8CoinScore != null && level8CoinScore! >= 16
                              ,
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
                              level9CoinScore != null && level9CoinScore! >= 18
                              ,
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
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        // Level1                   
                        Text(
                          'ถูก: ${answeredQuestions1 ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 0.5),
                        Text(
                          'ผิด: ${incorrectAnswers1 ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
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
                              // _playSound(); // Play sound when button is pressed
                              // showHighScoresDialog(context);
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
                        onPressed: () {
                          _playSound(); // Play sound when button is pressed
                          resetHighScores();
                        },
                        color: const Color.fromARGB(
                            255, 209, 208, 208), // Set the icon color
                        iconSize: 35.0, // Set the icon size (adjust as needed)
                      ),
                      // MusicToggleButton(),
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
