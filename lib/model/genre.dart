import 'package:flutter/material.dart';

@immutable
class Genre {
  static const _keyId = 'id';
  static const _keyName = 'name';

  final int id;
  final String name;

  const Genre({
    @required this.id,
    @required name,
  })  : assert(id != null),
        this.name = name ?? '';

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(id: map[_keyId], name: map[_keyName]);
  }

  Map<String, dynamic> toMap() {
    return {
      _keyId: id,
      _keyName: name,
    };
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Genre && other.id == id;
}
