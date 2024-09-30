import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_somo/game2/GameJump.dart';
import 'package:audioplayers/audioplayers.dart';

class Final extends StatefulWidget {
  @override
  _FinalState createState() => _FinalState();
}

class _FinalState extends State<Final> {
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // สร้าง instance ของ AudioPlayer

  @override
  void initState() {
    super.initState();
    _playBackgroundSound(); // เรียกเล่นเสียงเมื่อหน้าแสดงผล
  }

  // ฟังก์ชันสำหรับเล่นเสียง
  void _playBackgroundSound() async {
    await _audioPlayer
        .play(AssetSource('audio/final1.mp3')); // เล่นเสียงไฟล์ victory.mp3
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // หยุดเสียงเมื่อ widget ถูกทำลาย
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/01.png'), // ใช้พื้นหลังแบบพิกเซล
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 50),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'คุณคือผู้ชนะ! โลกแห่งนี้จะจดจำคุณตลอดไป!',
                        textStyle: const TextStyle(
                          fontFamily: 'Itim-Regular',
                          fontSize: 35,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 0,
                              color: Colors.redAccent,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(seconds: 1),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/final.gif', // ระบุเส้นทางของรูปภาพ
                        height: 120,
                        width: 100,
                      ),
                      Image.asset(
                        'assets/images/final.gif', // ระบุเส้นทางของรูปภาพ
                        height: 120,
                        width: 100,
                      ),
                      
                    ],
                  ),
                  ElevatedButton(
                        onPressed: () {
                          FlameAudio.bgm.stop();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GameJump()),
                          );
                        },
                        child: Text(
                          'กลับหน้าหลัก',
                          style: TextStyle(
                            fontFamily: 'Itim-Regular',
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
