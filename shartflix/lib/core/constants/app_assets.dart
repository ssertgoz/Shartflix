class AppAssets {
  AppAssets._();

  static const icons = _Icons();
  static const images = _Images();
  static const animations = _Animations();
}

class _Icons {
  const _Icons();

  // Social
  String get apple => 'assets/icons/Apple.svg';
  String get google => 'assets/icons/Google.svg';
  String get facebook => 'assets/icons/Facebook.svg';

  // Navigation
  String get home => 'assets/icons/Home.svg';
  String get homeFill => 'assets/icons/Home-fill.svg';
  String get profile => 'assets/icons/Profile.svg';
  String get profileFill => 'assets/icons/Profile-fill.svg';

  // Actions
  String get heart => 'assets/icons/Heart.svg';
  String get heartFill => 'assets/icons/Heart-fill.svg';
  String get plus => 'assets/icons/Plus.svg';
  String get arrow => 'assets/icons/Arrow.svg';
  String get x => 'assets/icons/X.svg';
  String get gem => 'assets/icons/Gem.svg';

  // Form
  String get mail => 'assets/icons/Mail.svg';
  String get lock => 'assets/icons/Lock.svg';
  String get user => 'assets/icons/User.svg';
  String get hide => 'assets/icons/Hide.svg';
  String get see => 'assets/icons/See.svg';
}

class _Images {
  const _Images();

  String get appIcon => 'assets/images/app_icon.png';
  String get launcherIcon => 'assets/images/luncher_icon.png';
}

class _Animations {
  const _Animations();

  String get loading => 'assets/animations/Artboard_1.json';
}
