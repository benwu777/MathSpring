enum AvatarPresentation { girl, boy }

class AvatarConfiguration {
  const AvatarConfiguration({
    required this.presentation,
    required this.skinId,
    required this.faceId,
    required this.hairId,
    required this.eyesId,
    required this.noseId,
    required this.mouthId,
  });

  final AvatarPresentation presentation;
  final String skinId;
  final String faceId;
  final String hairId;
  final String eyesId;
  final String noseId;
  final String mouthId;

  static const Map<AvatarPresentation, Map<String, List<String>>> _options =
      <AvatarPresentation, Map<String, List<String>>>{
    AvatarPresentation.girl: <String, List<String>>{
      'skin': <String>['girl_skin_01', 'girl_skin_02', 'girl_skin_03'],
      'face': <String>['girl_face_01', 'girl_face_02', 'girl_face_03'],
      'hair': <String>[
        'girl_hair_01',
        'girl_hair_03',
        'girl_hair_04',
        'girl_hair_05',
      ],
      'eyes': <String>['girl_eyes_01', 'girl_eyes_02', 'girl_eyes_03'],
      'nose': <String>['girl_nose_01', 'girl_nose_02', 'girl_nose_03'],
      'mouth': <String>[
        'girl_mouth_01',
        'girl_mouth_02',
        'girl_mouth_03',
        'girl_mouth_04',
        'girl_mouth_05',
        'girl_mouth_06',
        'girl_mouth_07',
      ],
    },
    AvatarPresentation.boy: <String, List<String>>{
      'skin': <String>['boy_skin_01', 'boy_skin_02', 'boy_skin_03'],
      'face': <String>['boy_face_01', 'boy_face_02', 'boy_face_03'],
      'hair': <String>['boy_hair_01', 'boy_hair_02', 'boy_hair_03'],
      'eyes': <String>['boy_eyes_01', 'boy_eyes_02', 'boy_eyes_03'],
      'nose': <String>['boy_nose_01', 'boy_nose_02', 'boy_nose_03'],
      'mouth': <String>['boy_mouth_01', 'boy_mouth_02', 'boy_mouth_03'],
    },
  };

  static List<String> optionsFor(
      AvatarPresentation presentation, String category) {
    return List<String>.unmodifiable(_options[presentation]![category]!);
  }

  factory AvatarConfiguration.defaultFor(AvatarPresentation presentation) {
    return AvatarConfiguration(
      presentation: presentation,
      skinId: optionsFor(presentation, 'skin').first,
      faceId: optionsFor(presentation, 'face').first,
      hairId: optionsFor(presentation, 'hair').first,
      eyesId: optionsFor(presentation, 'eyes').first,
      noseId: optionsFor(presentation, 'nose').first,
      mouthId: optionsFor(presentation, 'mouth').first,
    );
  }

  factory AvatarConfiguration.fromMap(Map<String, Object?> map) {
    final AvatarPresentation presentation = map['avatar_presentation'] == 'boy'
        ? AvatarPresentation.boy
        : AvatarPresentation.girl;
    String resolved(String category, String column) {
      final String candidate = map[column] as String? ?? '';
      final List<String> options = optionsFor(presentation, category);
      return options.contains(candidate) ? candidate : options.first;
    }

    return AvatarConfiguration(
      presentation: presentation,
      skinId: resolved('skin', 'avatar_skin_id'),
      faceId: resolved('face', 'avatar_face_id'),
      hairId: resolved('hair', 'avatar_hair_id'),
      eyesId: resolved('eyes', 'avatar_eyes_id'),
      noseId: resolved('nose', 'avatar_nose_id'),
      mouthId: resolved('mouth', 'avatar_mouth_id'),
    );
  }

  AvatarConfiguration copyWith({
    AvatarPresentation? presentation,
    String? skinId,
    String? faceId,
    String? hairId,
    String? eyesId,
    String? noseId,
    String? mouthId,
  }) {
    return AvatarConfiguration(
      presentation: presentation ?? this.presentation,
      skinId: skinId ?? this.skinId,
      faceId: faceId ?? this.faceId,
      hairId: hairId ?? this.hairId,
      eyesId: eyesId ?? this.eyesId,
      noseId: noseId ?? this.noseId,
      mouthId: mouthId ?? this.mouthId,
    );
  }

  Map<String, Object?> toMap() => <String, Object?>{
        'avatar_presentation': presentation.name,
        'avatar_skin_id': skinId,
        'avatar_face_id': faceId,
        'avatar_hair_id': hairId,
        'avatar_eyes_id': eyesId,
        'avatar_nose_id': noseId,
        'avatar_mouth_id': mouthId,
      };
}
