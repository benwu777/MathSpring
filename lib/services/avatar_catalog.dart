import 'package:mathspring/models/avatar_configuration.dart';

class AvatarCatalog {
  const AvatarCatalog._();

  static List<String> skinOptionsFor(AvatarPresentation presentation) =>
      AvatarConfiguration.optionsFor(presentation, 'skin');
  static List<String> faceOptionsFor(AvatarPresentation presentation) =>
      AvatarConfiguration.optionsFor(presentation, 'face');
  static List<String> hairOptionsFor(AvatarPresentation presentation) =>
      AvatarConfiguration.optionsFor(presentation, 'hair');
  static List<String> eyeOptionsFor(AvatarPresentation presentation) =>
      AvatarConfiguration.optionsFor(presentation, 'eyes');
  static List<String> noseOptionsFor(AvatarPresentation presentation) =>
      AvatarConfiguration.optionsFor(presentation, 'nose');
  static List<String> mouthOptionsFor(AvatarPresentation presentation) =>
      AvatarConfiguration.optionsFor(presentation, 'mouth');
  static AvatarConfiguration defaultFor(AvatarPresentation presentation) =>
      AvatarConfiguration.defaultFor(presentation);
}
