import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Route;
import 'dart:async' as async;

class JumpButton extends PositionComponent with HasGameRef,TapCallbacks {
  final Function(bool) onJumpButtonPressed;
  bool _enabled = true;
  int _jumpCount = 0;  // เพิ่มตัวแปรเก็บจำนวนครั้งที่กระโดด
  final int maxJumpCount = 2;  // จำกัดจำนวนครั้งกระโดดสูงสุด
  async.Timer? _cooldownTimer;

  JumpButton({required this.onJumpButtonPressed});

  @override
  Future<void>? onLoad() async {
    size = Vector2(200, 200);
    position = Vector2(
      gameRef.size.x - size.x - 20,
      gameRef.size.y - size.y - 20,
    );
    anchor = Anchor.topLeft;
    return super.onLoad();
  }

  // เรียกฟังก์ชันนี้เมื่อผู้เล่นกดปุ่มกระโดด
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (_enabled && _jumpCount < maxJumpCount) {
      onJumpButtonPressed(true);
      _jumpCount++;
      if (_jumpCount >= maxJumpCount) {
        _startCooldown();  // เริ่ม cooldown หลังจากกระโดดครบ 2 ครั้ง
      }
    }
  }

  void _startCooldown() {
    _enabled = false;
    _cooldownTimer = async.Timer(const Duration(milliseconds: 1070), () {
      _enabled = true;
      _jumpCount = 0;  // รีเซ็ตตัวแปรการกระโดดเมื่อ cooldown สิ้นสุด
    });
  }

  // ฟังก์ชันรีเซ็ตการกระโดดเมื่อแตะพื้น
  void resetJump() {
    _jumpCount = 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = _enabled
          ? const Color.fromARGB(65, 103, 104, 105).withOpacity(0.75)
          : Colors.grey.withOpacity(0.5);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );

    final textPainter = TextPaint(
      style: TextStyle(color: _enabled ? Colors.white : Colors.grey, fontSize: 20),
    );
    textPainter.render(
      canvas,
      'Jump',
      Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
  }

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }
}
