import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

// Import all level screens
import '../components/game_button.dart';
import 'Level/Level1Screen.dart';
import 'Level/Level2Screen.dart';
import 'Level/Level3Screen.dart';
import 'Level/Level4Screen.dart';
import 'Level/Level5Screen.dart';
import 'Level/Level6Screen.dart';
import 'Level/Level7Screen.dart';
import 'Level/Level8Screen.dart';
import 'Level/Level9Screen.dart';
import 'Level/Level10Screen.dart';
import 'components/AudioManager.dart';
import 'components/LevelButton.dart';
import 'components/MusicToggleButton.dart';

class GameCardScreen extends StatefulWidget {
  const GameCardScreen({super.key});

  @override
  State<GameCardScreen> createState() => _GameCardScreenState();
}

class _GameCardScreenState extends State<GameCardScreen>
    with WidgetsBindingObserver {
  int? level1HighScore;
  int? level2HighScore;
  int? level3HighScore;
  int? level4HighScore;
  int? level5HighScore;
  int? level6HighScore;
  int? level7HighScore;
  int? level8HighScore;
  int? level9HighScore;
  int? level10HighScore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHighScores(); // Reload high scores when the widget becomes visible again
  }

  // Function to load high scores from SharedPreferences
  Future<void> _loadHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      level1HighScore = prefs.getInt('level1HighScore');
      level2HighScore = prefs.getInt('level2HighScore');
      level3HighScore = prefs.getInt('level3HighScore');
      level4HighScore = prefs.getInt('level4HighScore');
      level5HighScore = prefs.getInt('level5HighScore');
      level6HighScore = prefs.getInt('level6HighScore');
      level7HighScore = prefs.getInt('level7HighScore');
      level8HighScore = prefs.getInt('level8HighScore');
      level9HighScore = prefs.getInt('level9HighScore');
      level10HighScore = prefs.getInt('level10HighScore');
    });
  }

  // Function to reset high score for all levels
  Future<void> resetHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('level1HighScore');
    prefs.remove('level2HighScore');
    prefs.remove('level3HighScore');
    prefs.remove('level4HighScore');
    prefs.remove('level5HighScore');
    prefs.remove('level6HighScore');
    prefs.remove('level7HighScore');
    prefs.remove('level8HighScore');
    prefs.remove('level9HighScore');
    prefs.remove('level10HighScore');

    _loadHighScores(); // Reload high scores after reset
  }

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHighScores();
    AudioManager.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioManager.stopMusic();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App is in background or closed
      AudioManager.stopMusic();
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      AudioManager.playMusic();
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource(
        'sounds/button_click.mp3')); // Adjust the path to your sound file
  }

  void showHighScoresDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.black.withOpacity(0.8), // Black transparent background
          title: const Text(
            'สรุปคะแนน',
            style: TextStyle(
              fontFamily: 'PixelFont', // Use a pixel art font
              color: Colors.white, // White text color for visibility
            ),
          ),
          content: SingleChildScrollView(
            // ignore: sort_child_properties_last
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level1HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level2HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level3HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level4HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level5HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน ${level6HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level7HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level8HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
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
                          'คะแนน: ${level9HighScore ?? '-'}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
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
                              'คะแนน: ${level10HighScore ?? '-'}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
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
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AudioManager.stopMusic();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/gamecard/bg_pixel3.gif'), // Replace with your GIF path
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
                    AudioManager.stopMusic(); // Stop music when exiting
                    Navigator.pop(context); // Close the dialog
                    // Navigator.pop(context); // Go back to the previous screen

                    // _showExitConfirmationDialog(); // Call the confirmation dialog
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
                        PixelLevelButton(
                          level: 1,
                          isUnlocked: true,
                          nextScreen: const Level1Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 2,
                          isUnlocked:
                              level1HighScore != null && level1HighScore! >= 4,
                          nextScreen: const Level2Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 3,
                          isUnlocked:
                              level2HighScore != null && level2HighScore! >= 4,
                          nextScreen: const Level3Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 4,
                          isUnlocked:
                              level3HighScore != null && level3HighScore! >= 4,
                          nextScreen: const Level4Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 5,
                          isUnlocked:
                              level4HighScore != null && level4HighScore! >= 5,
                          nextScreen: const Level5Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelLevelButton(
                          level: 6,
                          isUnlocked:
                              level5HighScore != null && level5HighScore! >= 5,
                          nextScreen: const Level6Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 7,
                          isUnlocked: level6HighScore != null && level6HighScore! >= 5,
                          nextScreen: const Level7Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 8,
                          isUnlocked: level7HighScore != null && level7HighScore! >= 6,
                          nextScreen: const Level8Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 9,
                          isUnlocked: level8HighScore != null && level8HighScore! >= 6,
                          nextScreen: const Level9Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                        const SizedBox(width: 10),
                        PixelLevelButton(
                          level: 10,
                          isUnlocked: level9HighScore != null && level9HighScore! >= 6,
                          nextScreen: const Level10Screen(),
                          onTapUp: () {},
                          onTapDown: () {},
                          onTapCancel: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // Music Toggle Button
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
                        future: _loadHighScores(),
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
                          if (confirm == true) {
                            resetHighScores();
                          }
                        },
                        color: const Color.fromARGB(
                            255, 209, 208, 208), // Set the icon color
                        iconSize: 35.0, // Set the icon size (adjust as needed)
                      ),
                      MusicToggleButton(),
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
