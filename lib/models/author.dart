/// Author model ported from React domain type
class Author {
  final String name;
  final String handle;
  final String avatar;
  final bool verified;
  final int? karma;
  final bool isOnline;

  const Author({
    required this.name,
    required this.handle,
    required this.avatar,
    this.verified = false,
    this.karma,
    this.isOnline = false,
  });

  Author copyWith({
    String? name,
    String? handle,
    String? avatar,
    bool? verified,
    int? karma,
    bool? isOnline,
  }) {
    return Author(
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatar: avatar ?? this.avatar,
      verified: verified ?? this.verified,
      karma: karma ?? this.karma,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
