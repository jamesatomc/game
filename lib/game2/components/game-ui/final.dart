import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_somo/game2/GameJump.dart';
import 'package:audioplayers/audioplayers.dart';

class Final extends StatefulWidget {
  @override
  _FinalState createState() => _FinalState();
}

class _FinalState extends State<Final> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // สร้าง instance ของ AudioPlayer

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose(); // หยุดเสียงเมื่อ widget ถูกทำลาย
    super.dispose();
  }

  bool _isMusicPlaying = false; // Flag to track music playback
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
                          _stopBackgroundMusic();
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
