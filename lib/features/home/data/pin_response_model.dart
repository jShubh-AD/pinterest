class PinModel {
  final String id;
  final String slug;
  final String? description;
  final String? altDescription;
  final int width;
  final int height;
  final PinUrls urls;
  final PinUser user;

  PinModel({
    required this.id,
    required this.slug,
    required this.width,
    required this.height,
    required this.urls,
    required this.user,
    this.description,
    this.altDescription,
  });

  factory PinModel.fromJson(Map<String, dynamic> json) {
    return PinModel(
      id: json['id'],
      slug: json['slug'],
      description: json['description'],
      altDescription: json['alt_description'],
      width: json['width'],
      height: json['height'],
      urls: PinUrls.fromJson(json['urls']),
      user: PinUser.fromJson(json['user']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'description': description,
      'alt_description': altDescription,
      'width': width,
      'height': height,
      'urls': urls.toJson(),
      'user': user.toJson(),
    };
  }
}

class PinUrls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  PinUrls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
  });

  factory PinUrls.fromJson(Map<String, dynamic> json) {
    return PinUrls(
      raw: json['raw'],
      full: json['full'],
      regular: json['regular'],
      small: json['small'],
      thumb: json['thumb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw': raw,
      'full': full,
      'regular': regular,
      'small': small,
      'thumb': thumb,
    };
  }
}

class PinUser {
  final String name;
  final String? bio;
  final UserLinks links;
  final UserProfileImage profileImage;

  PinUser({
    required this.name,
    this.bio,
    required this.links,
    required this.profileImage,
  });

  factory PinUser.fromJson(Map<String, dynamic> json) {
    return PinUser(
      name: json['name'],
      bio: json['bio'],
      links: UserLinks.fromJson(json['links']),
      profileImage: UserProfileImage.fromJson(json['profile_image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'links': links.toJson(),
      'profile_image': profileImage.toJson(),
    };
  }
}

class UserLinks {
  final String html;

  UserLinks({required this.html});

  factory UserLinks.fromJson(Map<String, dynamic> json) {
    return UserLinks(
      html: json['html'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'html': html,
    };
  }
}

class UserProfileImage {
  final String small;
  final String medium;
  final String large;

  UserProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory UserProfileImage.fromJson(Map<String, dynamic> json) {
    return UserProfileImage(
      small: json['small'],
      medium: json['medium'],
      large: json['large'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'medium': medium,
      'large': large,
    };
  }
}
