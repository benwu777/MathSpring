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
    this.eyeColorId = 'eye_color_01',
    this.accessoryId = 'accessory_none',
  });

  final AvatarPresentation presentation;
  final String skinId;
  final String faceId;
  final String hairId;
  final String eyesId;
  final String noseId;
  final String mouthId;

  /// 舊版儲存的眼珠顏色。保留欄位以讀取既有帳號，但不再用於顯示或編輯。
  final String eyeColorId;

  /// 臉上的配件（眼鏡／墨鏡）。`accessory_none` 代表不戴。
  final String accessoryId;

  static const Map<AvatarPresentation, Map<String, List<String>>> _options =
      <AvatarPresentation, Map<String, List<String>>>{
    AvatarPresentation.girl: <String, List<String>>{
      'skin': <String>[
        'girl_skin_01',
        'girl_skin_02',
        'girl_skin_03',
        'girl_skin_04',
        'girl_skin_05',
      ],
      'face': <String>[
        'girl_face_01',
        'girl_face_02',
        'girl_face_03',
        'girl_face_04',
        'girl_face_05',
      ],
      'hair': <String>[
        'girl_hair_01',
        'girl_hair_02',
        'girl_hair_03',
        'girl_hair_04',
        'girl_hair_05',
        // 雙馬尾：由 hair-05 拆成前後兩層，馬尾垂在臉後面。
        'girl_hair_06',
        // 紅棕高馬尾、金色蓬鬆捲髮、藍紫短鮑伯、深棕雙辮。
        'girl_hair_07',
        'girl_hair_08',
        'girl_hair_09',
        'girl_hair_10',
      ],
      'eyes': <String>[
        'girl_eyes_01',
        'girl_eyes_02',
        'girl_eyes_03',
        'girl_eyes_04',
        'girl_eyes_05',
      ],
      'nose': <String>[
        'girl_nose_01',
        'girl_nose_02',
        'girl_nose_03',
        'girl_nose_04',
        'girl_nose_05',
      ],
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
      'skin': <String>[
        'boy_skin_01',
        'boy_skin_02',
        'boy_skin_03',
        'boy_skin_04',
        'boy_skin_05',
      ],
      'face': <String>[
        'boy_face_01',
        'boy_face_02',
        'boy_face_03',
        'boy_face_04',
        'boy_face_05',
      ],
      'hair': <String>[
        'boy_hair_01',
        'boy_hair_02',
        'boy_hair_03',
        'boy_hair_04',
        'boy_hair_05',
        // 金色刺蝟頭、紅棕捲髮、藍紫側削短髮、深棕髮髻。
        'boy_hair_06',
        'boy_hair_07',
        'boy_hair_08',
        'boy_hair_09',
      ],
      'eyes': <String>[
        'boy_eyes_01',
        'boy_eyes_02',
        'boy_eyes_03',
        'boy_eyes_04',
        'boy_eyes_05',
      ],
      'nose': <String>[
        'boy_nose_01',
        'boy_nose_02',
        'boy_nose_03',
        'boy_nose_04',
        'boy_nose_05',
      ],
      'mouth': <String>[
        'boy_mouth_01',
        'boy_mouth_02',
        'boy_mouth_03',
        'boy_mouth_04',
        'boy_mouth_05',
      ],
    },
  };

  /// 舊版眼色值，以便從既有帳號資料恢復設定。
  static const List<String> _legacyEyeColorIds = <String>[
    'eye_color_01', // 深褐
    'eye_color_02', // 淺褐
    'eye_color_03', // 琥珀
    'eye_color_04', // 灰藍
    'eye_color_05', // 墨綠
  ];

  static const List<String> _accessoryOptions = <String>[
    'accessory_none',
    'accessory_glasses_01', // 圓框
    'accessory_glasses_02', // 方框
    'accessory_sunglasses_01', // 墨鏡
  ];

  static List<String> optionsFor(
      AvatarPresentation presentation, String category) {
    if (category == 'accessory') {
      return List<String>.unmodifiable(_accessoryOptions);
    }
    final List<String>? options = _options[presentation]![category];
    if (options == null) {
      throw ArgumentError.value(category, 'category', 'Unknown avatar option');
    }
    return List<String>.unmodifiable(options);
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
      eyeColorId: 'eye_color_01',
      accessoryId: optionsFor(presentation, 'accessory').first,
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
      eyeColorId: _resolvedLegacyEyeColor(map['avatar_eye_color_id']),
      accessoryId: resolved('accessory', 'avatar_accessory_id'),
    );
  }

  static String _resolvedLegacyEyeColor(Object? value) {
    final String candidate = value as String? ?? '';
    return _legacyEyeColorIds.contains(candidate)
        ? candidate
        : _legacyEyeColorIds.first;
  }

  AvatarConfiguration copyWith({
    AvatarPresentation? presentation,
    String? skinId,
    String? faceId,
    String? hairId,
    String? eyesId,
    String? noseId,
    String? mouthId,
    String? eyeColorId,
    String? accessoryId,
  }) {
    return AvatarConfiguration(
      presentation: presentation ?? this.presentation,
      skinId: skinId ?? this.skinId,
      faceId: faceId ?? this.faceId,
      hairId: hairId ?? this.hairId,
      eyesId: eyesId ?? this.eyesId,
      noseId: noseId ?? this.noseId,
      mouthId: mouthId ?? this.mouthId,
      eyeColorId: eyeColorId ?? this.eyeColorId,
      accessoryId: accessoryId ?? this.accessoryId,
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
        'avatar_eye_color_id': eyeColorId,
        'avatar_accessory_id': accessoryId,
      };
}
