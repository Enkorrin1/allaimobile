// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'AllAi';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonOpen => 'فتح';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonTryAgain => 'حاول مرة أخرى';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonDone => 'تم';

  @override
  String get commonMenu => 'القائمة';

  @override
  String get commonLogout => 'تسجيل الخروج';

  @override
  String get commonLoading => 'Loading data';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navProjects => 'المشاريع';

  @override
  String get createSheetTitle => 'إنشاء';

  @override
  String get createVideo => 'فيديو';

  @override
  String get createImage => 'صورة';

  @override
  String get createEffects => 'تأثيرات';

  @override
  String get createMotion => 'حركة';

  @override
  String get authWelcomeTitle => 'من صورة إلى فيديو';

  @override
  String get authWelcomeSubtitle => 'حوّل أفكارك إلى فيديو AI بمؤثرات سينمائية';

  @override
  String get authWelcomeLogin => 'لدي حساب بالفعل';

  @override
  String get authWelcomeLegal =>
      'يتطلب التسجيل تأكيد العمر 18+ وقبول شروط AllAi.';

  @override
  String get authOrContinueWith => 'أو تابع باستخدام';

  @override
  String get authContinueWithGoogle => 'متابعة باستخدام Google';

  @override
  String get authContinueWithApple => 'متابعة باستخدام Apple ID';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authLoginHeadline => 'Welcome back';

  @override
  String get authLoginSubtitle =>
      'Sign in to open the generator, library, and coin balance.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'creator@allai.market';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authLoginSubmitting => 'Signing in...';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authEmailRequired => 'Enter email';

  @override
  String get authEmailInvalid => 'Enter a valid email';

  @override
  String get authPasswordRequired => 'Enter password';

  @override
  String get authRegisterTitle => 'Registration';

  @override
  String get authRegisterHeadline => 'Create account';

  @override
  String get authRegisterSubtitle =>
      'A demo account saves this session on the device and unlocks the generator.';

  @override
  String get authNameLabel => 'Name';

  @override
  String get authNameHint => 'How should we call you';

  @override
  String get authPasswordMinHint => 'Minimum 8 characters';

  @override
  String get authRepeatPasswordLabel => 'Repeat password';

  @override
  String get authAcceptTermsPrefix => 'I accept ';

  @override
  String get authTermsLabel => 'terms of use';

  @override
  String get authAcceptPrivacyPrefix => 'I accept ';

  @override
  String get authPrivacyLabel => 'privacy policy';

  @override
  String get authConfirmAge => 'I confirm that I am 18 or older';

  @override
  String get authRegisterSubmitting => 'Creating...';

  @override
  String get authRegisterButton => 'Create account';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authLegalPlaceholder =>
      'Legal copy will be connected after the links are approved. This is a demo placeholder.';

  @override
  String get authLegalConfirm => 'Got it';

  @override
  String get authResetTitle => 'Restore access';

  @override
  String get authResetSubtitle =>
      'Enter your email. In demo mode we show a safe confirmation without sending mail.';

  @override
  String get authResetSuccess =>
      'If the account exists, the request was accepted in demo mode.';

  @override
  String get authResetSubmitting => 'Checking...';

  @override
  String get authResetButton => 'Continue';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get homeLoadingEffects => 'Loading effects';

  @override
  String get homeEffectsUnavailableTitle => 'Effects are unavailable';

  @override
  String get homeEffectsUnavailableDescription =>
      'Try refreshing the catalog a little later.';

  @override
  String get homeTitleVideos => 'الفيديوهات';

  @override
  String get homeReadyScenariosTitle => 'سيناريوهات جاهزة';

  @override
  String get homeReadyScenariosSubtitle => 'Choose a format and start creating';

  @override
  String get homeMarketingTitle => 'استوديو التسويق';

  @override
  String get homeMarketingSubtitle => 'UGC, unboxing, try-on, demos';

  @override
  String get homeVideoStudioTitle => 'استوديو فيديو AI';

  @override
  String get homeVideoStudioSubtitle =>
      'Seedance, zine rhythm, cinematic presets';

  @override
  String get homeMagicTitle => 'Create Your Magic';

  @override
  String get homeMagicSubtitle => 'Bring your imagination to life!';

  @override
  String get homeRecentProjectsTitle => 'Recent Projects';

  @override
  String get homeActiveJobsTitle => 'Creating now';

  @override
  String get homeActiveJobsSubtitle =>
      'Your generations continue in the background';

  @override
  String homeJobProgress(int progress) {
    return '$progress% complete';
  }

  @override
  String get homeAllEffects => 'All effects';

  @override
  String get homeActionAll => 'All';

  @override
  String get homeActionOpen => 'Open';

  @override
  String get homeTryNow => 'Try Now';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'Save models and templates for quick access';

  @override
  String get favoritesAdd => 'Add to favorites';

  @override
  String get favoritesRemove => 'Remove from favorites';

  @override
  String get generatorUnavailableTitle => 'Generator unavailable';

  @override
  String get generatorUnavailableDescription =>
      'Could not load creation tools. Try again.';

  @override
  String get generatorNoGeneratorTitle => 'No generator available';

  @override
  String get generatorNoGeneratorDescription =>
      'Creation models will appear after catalog update.';

  @override
  String get generatorImageUploadLater =>
      'Image upload will be connected later.';

  @override
  String get generatorLoadingBalance => 'Loading balance...';

  @override
  String get generatorBalanceUnavailable =>
      'Balance is temporarily unavailable.';

  @override
  String get generatorTitleImage => 'Image Generation';

  @override
  String get generatorTitleVideo => 'Video Generation';

  @override
  String get generatorTitleUpscale => 'Upscale';

  @override
  String get generatorTitleAvatar => 'Avatar Generation';

  @override
  String get generatorTitleMotion => 'Motion Control';

  @override
  String get generatorHintImage => 'Describe an image...';

  @override
  String get generatorHintVideo => 'Describe a video...';

  @override
  String get generatorHintUpscale => 'Describe what to enhance...';

  @override
  String get generatorHintAvatar => 'Describe an avatar...';

  @override
  String get generatorHintMotion => 'Describe motion...';

  @override
  String get generatorEmptyImage => 'Describe an image to generate.';

  @override
  String get generatorEmptyVideo => 'Describe a video to generate.';

  @override
  String get generatorEmptyUpscale => 'Describe what needs better quality.';

  @override
  String get generatorEmptyAvatar => 'Describe the avatar scene.';

  @override
  String get generatorEmptyMotion => 'Describe the motion you want.';

  @override
  String get generatorFormatLabel => 'الصيغة';

  @override
  String get generatorModelsLabel => 'النماذج';

  @override
  String generatorModelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نموذج',
      many: '$count نموذجًا',
      few: '$count نماذج',
      two: 'نموذجان',
      one: 'نموذج واحد',
      zero: 'لا توجد نماذج',
    );
    return '$_temp0';
  }

  @override
  String get generatorAddImage => 'إضافة صورة';

  @override
  String get generatorGenerate => 'إنشاء';

  @override
  String get generatorGenerating => 'جارٍ الإنشاء...';

  @override
  String get generatorOpenResult => 'Open result';

  @override
  String get generatorFailedTitle =>
      'Generation did not finish. Settings were saved.';

  @override
  String get generatorCoinsRefunded => 'Coins were returned to your balance.';

  @override
  String get generatorNoCharge => 'No charge was made.';

  @override
  String generatorMetaCost(String model, String cost, String available) {
    return '$model · Cost $cost coins · $available available';
  }

  @override
  String get generatorSuggestionFuturistic => 'Futuristic walk of her';

  @override
  String get generatorSuggestionTiger => 'Majestic baby tiger walk';

  @override
  String get generatorSuggestionDragon => 'Tiny dragon flying';

  @override
  String get generatorSuggestionProduct => 'Cinematic product reveal';

  @override
  String get generatorSavedPromptsTitle => 'Saved prompts';

  @override
  String get generatorSavePrompt => 'Save prompt';

  @override
  String get generatorRemovePrompt => 'Remove prompt';

  @override
  String get generatorPromptSaved => 'Prompt saved';

  @override
  String get projectsLoading => 'Loading projects';

  @override
  String get projectsUnavailableTitle => 'Projects are unavailable';

  @override
  String get projectsUnavailableDescription =>
      'Generation history could not be loaded.';

  @override
  String get projectsTitle => 'المشاريع';

  @override
  String get projectsNew => 'جديد';

  @override
  String projectsSavedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved generations',
      one: '1 saved generation',
      zero: 'No saved generations',
    );
    return '$_temp0';
  }

  @override
  String get projectsEmptyTitle => 'Create Your Magic';

  @override
  String get projectsEmptySubtitle =>
      'Your AI videos and images will appear here';

  @override
  String get projectsCreateFirst => 'Create first project';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLocalBuild => 'Local build';

  @override
  String get settingsDemoBilling => 'No live payments';

  @override
  String get settingsAppTitle => 'App settings';

  @override
  String get settingsAppDescription =>
      'These options do not affect generation or payments in the demo build.';

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsLanguageDescription =>
      'اختر لغة التطبيق. سيتم حفظ الاختيار على هذا الجهاز.';

  @override
  String get settingsLanguageSystem => 'لغة الجهاز';

  @override
  String get settingsLanguagePickerTitle => 'لغة التطبيق';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsDescription =>
      'Generation-ready notifications will appear after a separate permission and device setup.';

  @override
  String get settingsLegalTitle => 'Legal documents';

  @override
  String get settingsLegalDescription =>
      'Terms, privacy policy, and AI content rules will be connected before release.';

  @override
  String get settingsSupportTitle => 'Support';

  @override
  String get settingsSupportDescription =>
      'Generation, balance, and account help will appear after the support channel is prepared.';

  @override
  String get settingsDeleteAccountTitle => 'Delete account';

  @override
  String get settingsDeleteAccountDescription =>
      'Account deletion will appear after a secure confirmation flow is ready.';

  @override
  String get profileRestoring => 'Restoring session';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileFallbackName => 'AllAi Account';

  @override
  String get profileSignInPrompt => 'Sign in to open your profile.';

  @override
  String get profileSessionActive => 'Session active';

  @override
  String get profileBalanceLoading => 'Balance is loading';

  @override
  String profileBalanceCoins(String coins) {
    return 'Balance: $coins coins';
  }

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileAccountDescription =>
      'Email, name, 18+ confirmation, and local session. Profile editing will appear later.';

  @override
  String get profileCoinsTitle => 'Coins and balance';

  @override
  String get profileCoinsDescription =>
      'Demo balance and packages are visible now. Real purchases are intentionally disabled in this build.';

  @override
  String get profileOpenBalance => 'Open balance';

  @override
  String get profileSettingsDescription =>
      'Language, notifications, legal links, and support.';

  @override
  String get profileOpenSettings => 'Open settings';

  @override
  String get profileDeleteDescription =>
      'Account deletion will appear after the backend contract is ready. The action is unavailable now.';

  @override
  String get profileLogoutTitle => 'Log out of account?';

  @override
  String get profileLogoutContent => 'Local history will stay on this device.';

  @override
  String get pricingLoadingPro => 'Loading PRO';

  @override
  String get pricingBalanceUnavailableTitle => 'Balance is unavailable';

  @override
  String get pricingBalanceUnavailableDescription =>
      'Coin data could not be loaded right now.';

  @override
  String get pricingStartTitle => 'Start Creating Now';

  @override
  String get pricingStartSubtitle =>
      'Generate anything. PRO purchase flow will be connected after store setup.';

  @override
  String get pricingLoadingPackages => 'Loading packages';

  @override
  String get pricingPackagesUnavailableTitle => 'Packages are unavailable';

  @override
  String get pricingPackagesUnavailableDescription =>
      'The demo package list could not be loaded.';

  @override
  String get pricingContinueSnack => 'Purchases will be connected later.';

  @override
  String get pricingDemoMode =>
      'Demo mode. No live payment is charged in this build.';

  @override
  String pricingCoinsAvailable(String coins) {
    return '$coins عملة متاحة';
  }

  @override
  String pricingReserved(String coins) {
    return '$coins محجوزة';
  }

  @override
  String get pricingPackagesEmpty =>
      'Coin packages will appear here after billing setup.';

  @override
  String pricingPackageCoins(String coins) {
    return '$coins عملة';
  }

  @override
  String get pricingSelectPackage => 'Select a coin package';

  @override
  String get pricingBuyPackage => 'Continue with selected package';

  @override
  String get pricingRestorePurchases => 'Restore purchases';

  @override
  String get pricingPurchaseUnavailable =>
      'Store purchases are not enabled in this build.';

  @override
  String get pricingPurchaseFailed =>
      'The purchase could not be completed. No charge was made.';

  @override
  String get pricingRestoringPurchases => 'Checking previous purchases...';
}
