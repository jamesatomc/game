
 import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game_somo/game2/Level/jump9.dart';
import 'dart:math';

import '../../components/game_button.dart';
import '../GameJump.dart';
import '../components/BackButtonOverlay.dart';

class Quiz9 extends StatefulWidget {
  final VoidCallback? onResumeMusic; // Add this property

  const Quiz9({Key? key, this.onResumeMusic}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Quiz9State createState() => _Quiz9State();
}

class _Quiz9State extends State<Quiz9> {
  List<Question> questions = [
    // Add your questions here, following the same format as below:
      Question(
      "คำถาม\n A person who sends letters is ________.",
      ["policeman", "flight attendant", "mail carrier", "pilot"],
      2,
    ),
    Question(
      "คำถาม\nSeptember comes after _______.",
      ["July", "August", "May", "March"],
      1,
    ),
    Question(
      "คำถาม\n New Year Day is on _______.",
      ["January the first", "January the one", "February the first", "February the one"],
      0,
    ),
    Question(
      "คำถาม\n I _______ a letter to my mother last week.",
      ["is going to write", "write", "writes", "wrote"],
      3,
    ),
    Question(
      "คำถาม\n: 92nd = ______________.",
      ["the ninety-two", "the ninety-second", "ninety-second", "ninety-two"],
      1,
    ),
    Question(
      "คำถาม\n Halloween is on ______.",
      ["October the thirty-one", "October the thirty-first", "October the thirteenth", "October the thirtieth"],
      1,
    ),
    Question(
      "คำถาม\n I was at the store that sells a lot of toffees and chocolate bars.",
      ["toy store", "candy store", "bookstore", "hair salon"],
      1,
    ),
    Question(
      "คำถาม\n __________ are the names of month.",
      ["Monday, Tuesday, Friday", "May, June, September", "cat, snail, penguin", "candy store, bookstore"],
      1,
    ),
    Question(
      "คำถาม\n Today __________ because I have a toothache.",
      ["I'm going to see the pilot", "I going to see the dentist", "I going to the dentist", "I'm going to see the dentist"],
      3,
    ),
    Question(
      "คำถาม\n A : __________.\nB : I was at the bus station.",
      ["What's the weather like today?", "Will you take out the trash?", "Where were you at 06:30?", "1 and 3 are correct."],
      2,
    ),
    // More questions...
  ];
      late List<Question> remainingQuestions;
  late Question currentQuestion;
  int? selectedAnswerIndex;
  bool showAnswer = false;
  int incorrectAnswers = 0;
  int answeredQuestions = 0;
  final int maxIncorrectAnswers = 2;
  final int totalQuestions = 2;
  final Random random = Random();
  final AudioPlayer audioPlayer = AudioPlayer();

   @override
  void initState() {
    super.initState();
    remainingQuestions = List.from(questions);
    _loadRandomQuestion();
  }

  void _loadRandomQuestion() {
    setState(() {
      if (remainingQuestions.isEmpty) {
        remainingQuestions = List.from(questions);
      }
      currentQuestion = remainingQuestions
          .removeAt(random.nextInt(remainingQuestions.length));
      selectedAnswerIndex = null;
      showAnswer = false;
    });
  }

  void _checkAnswer(int selectedIndex) {
    if (selectedAnswerIndex != null) return; // Prevent multiple presses

    setState(() {
      selectedAnswerIndex = selectedIndex;
      showAnswer = true;
      if (selectedIndex == currentQuestion.correctAnswerIndex) {
        _playCorrectAnswerSound();
        answeredQuestions++;
      } else {
        _playIncorrectAnswerSound();
        incorrectAnswers++;
      }
    });



    // Delay to show the answer before loading the next question
    Future.delayed(const Duration(seconds: 2), () {
      if (answeredQuestions >= totalQuestions) {
        _showCompletionScreen();
      } else if (incorrectAnswers >= maxIncorrectAnswers) {
        // _resetQuiz();  //  <-- Remove this line
        _showFailScreen(); // <-- Add this line
      } else {
        _loadRandomQuestion();
      }
    });
  }

  void _playCorrectAnswerSound() async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  void _playIncorrectAnswerSound() async {
    await audioPlayer.play(AssetSource('sounds/wrong-buzzer.mp3'));
  }

  void _resetQuiz() {
    setState(() {
      incorrectAnswers = 0;
      answeredQuestions = 0;
      remainingQuestions = List.from(questions);
      _loadRandomQuestion();
    });
  }

  void _showCompletionScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameWidget(
          game: Jump9(),
          overlayBuilderMap: {
            'BackButton': (context, game) => BackButtonOverlay(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameJump()),
                    );
                  }, onResumeMusic: () { widget.onResumeMusic?.call(); },
                ),
          },
        ),
      ),
    );
  }

  void _showFailScreen() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เสียใจด้วย'),
          content: const Text('คุณต้องการลองอีกครั้งหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
                widget.onResumeMusic
                    ?.call(); // Call the function to resume music
              },
              child: const Text('ออกจากเกม'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuiz();
              },
              child: const Text('ลองอีกครั้ง'),
            ),
          ],
        );
      },
    );
  }


// void showExitDialog(BuildContext context, Function? onResumeMusic) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Exit the game'),
//           content: Text('Do you want to quit the game?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // ปิด AlertDialog
//                 // ออกจากเกมส์โดยไม่ทำอะไร
//               },
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => GameJump()),
//                     );
//                     Navigator.of(context).pop();
//                 onResumeMusic?.call(); // Call the function to resume music
//               },
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/01.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Expanded(
                                child: Text(
                                  'Quiz',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 3, 232, 221))
                                  ),
                                ),
                              
                        Row(
                          children: [
                            const SizedBox(width: 30),
                            Image.asset(
                              'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                              height: 145,
                              width: 150,
                            ),
                            // const SizedBox(width: 10),
                            Container(
                              height: 100,
                              width: 500,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.8), // Semi-transparent white background
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Text(
                                currentQuestion.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Itim-Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnswerButton(0),
                                  const SizedBox(
                                      width: 10), // Space between buttons
                                  _buildAnswerButton(1),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnswerButton(2),
                                  const SizedBox(
                                      width: 10), // Space between buttons
                                  _buildAnswerButton(3),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    Color buttonColor;
    if (showAnswer) {
      if (index == currentQuestion.correctAnswerIndex) {
        buttonColor = Colors.green;
      } else if (index == selectedAnswerIndex) {
        buttonColor = Colors.red;
      } else {
        buttonColor = const Color.fromARGB(255, 216, 125, 7);
      }
    } else {
      buttonColor = const Color.fromARGB(255, 216, 125, 7);
    }

    return Expanded(
      child: PixelGameButton(
        height: 50,
        width: 120,
        text: currentQuestion.answers[index],
        onTap: () {
          _checkAnswer(index);
        },
        onTapUp: () {},
        onTapDown: () {},
        onTapCancel: () {},
        backgroundColor: buttonColor,
        textColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class Question {
  final String text;
  final List<String> answers;
  final int correctAnswerIndex;

  Question(this.text, this.answers, this.correctAnswerIndex);
}
