// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

//TODO divide models and DTOs

class Player extends Equatable {
  const Player({
    this.id = '', // TODO as above
    required this.userId,
    required this.nick,
    this.character,
  });

  final String id;
  final String userId;
  final String nick;
  final String? character;

  /// Empty player which represents that user is currently not in any player.
  static const empty = Player(userId: '', nick: '');

  /// Convenience getter to determine whether the current player is empty.
  bool get isEmpty => this == Player.empty;

  /// Convenience getter to determine whether the current player is not empty.
  bool get isNotEmpty => this != Player.empty;

  @override
  List<Object?> get props => [id, userId, nick, character];

  factory Player.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Player(
      id: doc.id,
      userId: data?["user_uid"],
      nick: data?['nick'],
      character: data?['character'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user_uid": userId,
      "nick": nick,
      if (character != null) "character": character,
    };
  }
}
