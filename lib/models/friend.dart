/// A friend displayed in the profile grid.
class Friend {
  /// Creates an immutable friend record.
  const Friend({required this.name, required this.imagePath});

  /// Friend display name.
  final String name;

  /// Bundled portrait asset path.
  final String imagePath;

  /// Copies this friend with selected values replaced.
  Friend copyWith({String? name, String? imagePath}) =>
      Friend(name: name ?? this.name, imagePath: imagePath ?? this.imagePath);
}
