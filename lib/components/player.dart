import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameRef, HasHitboxes, Collidable {
  double maxSpeed = 100.0;

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick) : super(size: Vector2(32, 24)) {
    addHitbox(HitboxRectangle(relation: Vector2(1, 1)));
    anchor = Anchor.center;
  }

  addPowerUps() async {
    var planes = await Flame.images.load('ships_packed.png');

    add(SpriteComponent(
        sprite: Sprite(planes,
            srcSize: Vector2(24, 29), srcPosition: Vector2(4, 39)),
        priority: 2)
      ..position = Vector2(-28, 4));
    add(SpriteComponent(
        sprite: Sprite(planes,
            srcSize: Vector2(24, 29), srcPosition: Vector2(4, 39)),
        priority: 2)
      ..position = Vector2(36, 4));
  }

  addShield() {
    add(
      CircleComponent(
          position: Vector2(15, 15),
          anchor: Anchor.center,
          radius: 30,
          paint: Paint()..color = Colors.lightBlueAccent.withAlpha(100)),
    );
    add(
      CircleComponent(
          position: Vector2(15, 15),
          anchor: Anchor.center,
          radius: 20,
          paint: Paint()
            ..color = Colors.purple.withAlpha(30)
            ..strokeWidth = 6
            ..style = PaintingStyle.stroke),
    );
    add(
      CircleComponent(
          position: Vector2(15, 15),
          anchor: Anchor.center,
          radius: 22,
          paint: Paint()
            ..color = Colors.orangeAccent.withAlpha(120)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var planes = await gameRef.images.load('ships_packed.png');
    sprite =
        Sprite(planes, srcPosition: Vector2(0, 4), srcSize: Vector2(32, 24));
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      var vector2 = joystick.relativeDelta * maxSpeed * dt;
      var x = vector2.x;
      var y = vector2.y;
      if ((this.x + x) > worldWidth - width / 2) {
        vector2.x = 0;
      }
      if ((this.x + x - width / 2) < 0) {
        vector2.x = 0;
      }
      if (this.y + y - height / 2 < 0) {
        vector2.y = 0;
      }
      if (this.y + y + height / 2 > 320) {
        vector2.y = 0;
      }
      position.add(vector2);
      angle = joystick.delta.screenAngle();
    }
  }
}
