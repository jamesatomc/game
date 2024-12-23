import 'package:flame/camera.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:game_somo/game2/Quiz/quiz2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';

import '../components/game-ui/bumpy.dart';
import '../components/game-ui/cion.dart';
import '../components/game-ui/game_over_overlay.dart';
import '../components/game-ui/ground.dart';
import '../components/game-ui/jumpButton.dart';
import '../components/game-ui/monsters.dart';
import '../components/game-ui/player.dart';
import '../components/game-ui/win_overlay.dart';

class Jump1 extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        TapCallbacks,
        WidgetsBindingObserver {
  late Player myPlayer;
  late Cion myCoin;
  late Monsters monsters;

  late List<Vector2> grounds;
  late int mapWidth;
  late int mapHeight;
  late JoystickComponent joystick;
  late JoystickComponent jump;
  late SpriteComponent background;
  late Vector2 playerSpawnPoint; // Declare playerSpawnPoint here

  int lives = 3; // Start with 2 lives
  int initialLives = 3; // Store the initial number of lives
  int level1CoinScore = 0; // Track the number of coins collected
  int level1CoinScoreReset = 0; // New variable for resetting purposes

  late TextComponent livesText; // Declare a TextComponent for lives
  late SpriteComponent livesImage;
  late TextComponent coinsText; // Declare a TextComponent for coins
  late SpriteComponent coinImage;

  bool isPlayerDead = false; // Flag to track if the player is dead

  late JumpButton jumpButton;
  late ParallaxComponent parallax;
  bool _isCurrentPage = true; 

  @override
  Future<void> onLoad() async {
    WidgetsBinding.instance.addObserver(this);
    initialLives = lives; // Initialize initialLives in onLoad

    // Load the saved coin score
    level1CoinScore = await getLevel1CoinScore() ?? 0;
    
    final screenSize = camera.viewport.size;
    parallax = await loadParallaxComponent(
      [
        ParallaxImageData('bg/8.png'),
        ParallaxImageData('bg/11.png'),
        ParallaxImageData('bg/12.png'),
      ],
      size: screenSize,
      priority: -1,
    );
    add(parallax);
// Load the lives image
    final livesSprite = await loadSprite('lives.png');

// Initialize livesImage
    livesImage = SpriteComponent(
      sprite: livesSprite,
      position: Vector2(170, 30),
      size: Vector2(24, 24), // Set the size of the image
      anchor: Anchor.topRight,
    );

// Initialize livesText
    livesText = TextComponent(
      text: '$lives',
      position: Vector2(200, 30), // Position on the far left
      anchor: Anchor.topRight, // Align text to top-right
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 0, 0),
          fontSize: 20,
        ),
      ),
    );

// Load the coin image
    final coinSprite = await loadSprite('coin.png');

// Initialize coinImage
    coinImage = SpriteComponent(
      sprite: coinSprite,
      position: Vector2(livesImage.position.x + livesImage.size.x + 50, 30),
      size: Vector2(24, 24), // Set the size of the image
      anchor: Anchor.topRight, priority: 1,
    );

// Initialize coinsText
    coinsText = TextComponent(
      text: '0', // Initialize with the saved coin score
      position: Vector2(coinImage.position.x + coinImage.size.x + 10,
          30), // Position to the right of coinImage
      anchor: Anchor.topRight, // Align text to top-left
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 215, 0),
          fontSize: 20,
        ),
      ),
    );
    coinsText.priority = 1;

    // Load the GIF background
    // background = SpriteComponent()
    //   ..sprite = await loadSprite('bg2.gif')
    //   ..size = Vector2(1700, 450);
    FlameAudio.bgm.play("bg.mp3");

    // Add the background to the game world
    // add(background);
    add(livesImage);
    add(livesText);
    add(coinImage);
    add(coinsText);
    overlays.add('BackButton');

    await loadLevel();

    joystick = JoystickComponent(
        knob: CircleComponent(
            radius: 65, paint: Paint()..color = Colors.grey.withOpacity(0.50)),
        background: CircleComponent(
            radius: 100, paint: Paint()..color = Colors.grey.withOpacity(0.5)),
        margin: const EdgeInsets.only(left: 10, bottom: 20));
    await camera.viewport.add(joystick);

    joystick.priority = 0;

    jumpButton = JumpButton(onJumpButtonPressed: (bool jumped) {
      if (!isPlayerDead && jumped) {
        myPlayer.moveJump();
      }
    });
    world.add(jumpButton);
    await camera.viewport.add(jumpButton);

    // Register the game over overlay
    overlays.addEntry(
      'GameOver',
      (context, game) => GameOverOverlay(
        onRestart: restartGame,
      ),
    );

    // Register the win overlay
    overlays.addEntry(
      'Win',
      (context, game) => WinOverlay(
        onNextQuiz: () {
          FlameAudio.bgm.stop(); // Stop the background music

          // Navigate to Quiz2
          // Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              onPageExit(); // Call this before navigating away
              return const Quiz2();
            }),
          );
        },
      ),
    );

    return super.onLoad();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isCurrentPage) {
      // Only manage audio if this is the current page
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.detached) {
        FlameAudio.bgm.pause();
      } else if (state == AppLifecycleState.resumed) {
        FlameAudio.bgm.resume();
      }
    }
  }

  // New method to call when navigating away from this page
  void onPageExit() {
    _isCurrentPage = false;
    FlameAudio.bgm.pause();
  }

  // New method to call when returning to this page
  void onPageEnter() {
    _isCurrentPage = true;
    FlameAudio.bgm.resume();
  }

  @override
  void onRemove() {
    WidgetsBinding.instance.removeObserver(this);
    super.onRemove();
  }

  Future<void> loadLevel() async {

    final level = await TiledComponent.load(
      "map.tmx",
      Vector2.all(32),
    );

    FlameAudio.bgm.stop(); // Stop the background music

    mapWidth = (level.tileMap.map.width * level.tileMap.destTileSize.x).toInt();
    mapHeight =
        (level.tileMap.map.height * level.tileMap.destTileSize.y).toInt();
    world.add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>("spawn");
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case "player":
          playerSpawnPoint = spawnPoint.position; // Store the spawn point
          myPlayer = Player(position: spawnPoint.position);
          world.add(myPlayer);
          camera.follow(myPlayer); // Ensure camera follows the player
          break;
      }
    }

    final coinPointsLayer = level.tileMap.getLayer<ObjectGroup>("coin");
    for (final coinPoint in coinPointsLayer!.objects) {
      switch (coinPoint.class_) {
        case "coin":
          myCoin = Cion(position: coinPoint.position);
          world.add(myCoin);
          break;
      }
    }

    final monstersPointsLayer = level.tileMap.getLayer<ObjectGroup>("monsters");
    for (final monstersPoint in monstersPointsLayer!.objects) {
      switch (monstersPoint.class_) {
        case "monsters":
          monsters = Monsters(position: monstersPoint.position);
          world.add(monsters);
          break;

        case "bumpy":
          final bumpy = Bumpy(position: monstersPoint.position);
          world.add(bumpy);
          break;
      }
    }

    final groundLayer = level.tileMap.getLayer<ObjectGroup>("ground");
    for (final groundPoint in groundLayer!.objects) {
      final grounds =
          GroundBlock(position: groundPoint.position, size: groundPoint.size);
      world.add(grounds);
    }

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(1500, 650),
    );

    camera.setBounds(
      Rectangle.fromLTRB(size.x / 2, size.y / 2.4, level.width - size.x / 2,
          level.height - size.y / 2),
    );

    // Set the camera anchor to the center
    camera.viewfinder.anchor = Anchor.center;
  }

  //  @override
  // void onTapUp(TapUpEvent event) async {
  //   super.onTapUp(event);
  //   if (!isPlayerDead) {
  //     myPlayer.moveJump();
  //   }
  // }

  @override
  void update(double dt) {
    super.update(dt);
    updateJoystrick();

    // Check for collisions with monsters or bumpy
    if (myPlayer.hasCollided) {
      myPlayer.removeFromParent();
      respawnPlayer(); // Respawn the player immediately
    }

    // Check for collisions with coins
    for (final coin in world.children.whereType<Cion>()) {
      if (myPlayer.toRect().overlaps(coin.toRect())) {
        coin.removeFromParent();
        collectCoin(); // Call collectCoin when a coin is collected
      }
    }

    // Ensure the camera follows the player
    camera.follow(myPlayer);
  }

  void showGameOver() {
    overlays.add('GameOver');
  }

  void showWin() {
    overlays.add('Win');
  }

  void restartGame() {
    overlays.remove('GameOver');
    overlays.remove('Win');
    resetGame();
  }

  updateJoystrick() {
    if (!isPlayerDead) {
      switch (joystick.direction) {
        case JoystickDirection.downLeft:
          myPlayer.moveLeft();
          break;
        case JoystickDirection.upLeft:
          myPlayer.moveLeft();
          break;
        case JoystickDirection.left:
          myPlayer.moveLeft();
          break;
        case JoystickDirection.right:
          myPlayer.moveRight();
          break;
        case JoystickDirection.downRight:
          myPlayer.moveRight();
          break;
        case JoystickDirection.upRight:
          myPlayer.moveRight();
          break;
        default:
          myPlayer.moveNone();
      }
    }
  }

  // Function to respawn the player at the initial spawn point
  void respawnPlayer() {
    if (lives > 0) {
      lives--;
      myPlayer = Player(position: playerSpawnPoint);
      world.add(myPlayer);
      camera.follow(myPlayer);
      camera.viewfinder.position = playerSpawnPoint;

      livesText.text = '$lives';

      // Re-enable the jump button
      jumpButton.setEnabled(true);

      isPlayerDead = false; // Reset player dead flag

      if (lives == 0) {
        isPlayerDead = true;
        jumpButton.setEnabled(false); // Disable jump button when player is dead
        showGameOver();
      }
    } else {
      resetGame();
    }
  }

  // Function to reset the game to its initial state
  void resetGame() async {
    lives = initialLives; // Reset lives to the initial value
    livesText.text = '$lives'; // Update livesText
    level1CoinScoreReset = 0; // Reset coin score using the new variable
    coinsText.text = '0'; // Reset coinsText to 0

    // Remove existing game objects (player, monsters, coins, etc.)
    world.removeAll(world.children);

    // Reload the level
    await loadLevel();

    // Reinitialize UI components
    add(livesImage);
    add(livesText);
    add(coinImage);
    add(coinsText);
    await camera.viewport.add(joystick);
    await camera.viewport.add(jumpButton);

    // Reset the player dead flag
    isPlayerDead = false;

    // Reset and re-enable the jump button
    jumpButton.setEnabled(true);

    // Restart the background music
    FlameAudio.bgm.play("bg.mp3");
  }

  // Function to handle coin collection
  void collectCoin() {
    if (level1CoinScore < 10) {
      level1CoinScore++;
    }
    if (level1CoinScoreReset < 10) {
      level1CoinScoreReset++; // Increment the reset variable as well
    }
    coinsText.text = '$level1CoinScoreReset';
    saveLevel1CoinScore(level1CoinScore); // Save the coin score

    if (level1CoinScoreReset >= 10) {
      unlockNextLevel(); // Unlock the next level
      showWin(); // Show win overlay when 10 coins are collected
    }
  }

  // Method to update the coin count
  void updateCoinCount(int newCoinCount) {
    level1CoinScore = newCoinCount;
    coinsText.text = '$level1CoinScore';
  }

  // Example of updating the coin count
  void onCoinCollected() {
    updateCoinCount(level1CoinScore + 1);
  }

  Future<void> saveLevel1CoinScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level1CoinScore', score);
  }

  Future<int?> getLevel1CoinScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level1CoinScore');
  }

  Future<void> unlockNextLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'level2Unlocked', true); // Example for unlocking level 2
  }

  Future<bool> isLevelUnlocked(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('level${level}Unlocked') ?? false;
  }
}
