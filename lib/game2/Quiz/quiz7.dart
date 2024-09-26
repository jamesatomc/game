import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game_somo/game2/Level/Jump7.dart';
import 'dart:math';

import '../../components/game_button.dart';
import '../GameJump.dart';
import '../components/BackButtonOverlay.dart';

class Quiz7 extends StatefulWidget {
  final VoidCallback? onResumeMusic; // Add this property

  const Quiz7({Key? key, this.onResumeMusic}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Quiz7State createState() => _Quiz7State();
}

class _Quiz7State extends State<Quiz7> {
  List<Question> questions = [
    // Add your questions here, following the same format as below:
     Question(
      "คำถาม\n Mother : Tommy, will you hang up your clothes?\nTommy : ______________________.",
      ["Thanks, mother.", "Very good. ", "Sure. I'll hang up later.", "No, I wasn't."],
      2,
    ),
    Question(
      "คำถาม\nA : __________.\nB : I was at the subway station.",
      ["What were you doing at 3:00?", " What was the weather like at 3:00?", "Why were you there at 3:00?", "Where were you at 3:00?"],
      3,
    ),
     Question(
      "คำถาม\nA : What are you going to do the day after tomorrow?\nB : __________.",
      ["I am going to shop for clothes.", " I was at the candy store.", "I went to Europe.", "I was going to wait for the bus."],
      0,
    ),
     Question(
      "คำถาม\n Sunee : _____ you _____ any pencils?\nManee : Yes, I ______.",
      ["Does, did, did", "Did, do, does", "Do, have, do", "Does, have does"],
      2,
    ),
     Question(
      "คำถาม\n Grandfather : ________________?\nMichael : Sorry. I'm busy now.",
      ["Michael, where are you?", "Michael, will you pick up your toys? ", "Michael, what do you want to be?", "Michael, are you at the toy store?"],
      1,
    ),
     Question(
      "คำถาม\n _______ his birthday?",
      ["What", "What’s", "When", "When’s"],
      1,
    ),
     Question(
      "คำถาม\n Teacher : ________________?\nStudents : It's November 16th.",
      ["What were you at 19:00?", " Will you put away your books?", "What's the date today?", "Does you have any boats?"],
      2,
    ),
     Question(
      "คำถาม\n Nat : Did you go to the candy store last Sunday?\nTol : No, I ________. I _______ to the park.",
      ["didn't, went", " don't, go", "doesn't, go", "didn't, go"],
      1,
    ),
     Question(
      "คำถาม\n Namo : ____________?\nYuri : I'm going to play basketball.",
      ["Where were you yesterday?", "What are you going to do today? ", "Are you going to play basketball?", "Were you at the park?"],
      1,
    ),
     Question(
      "คำถาม\n _______ his birthday?",
      ["What", " What's", "When", "When's"],
      0,
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
          game: Jump7(),
          overlayBuilderMap: {
            'BackButton': (context, game) => BackButtonOverlay(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameJump()),
                    );
                  },
                  onResumeMusic: () {},
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
                Navigator.of(context).pop(); // ปิด AlertDialog
                Navigator.pop(context); // กลับไปหน้าหลัก
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
