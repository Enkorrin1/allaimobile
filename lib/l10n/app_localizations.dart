import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('pt'),
    Locale('it'),
    Locale('tr'),
    Locale('ar'),
    Locale('hi'),
    Locale('zh'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AllAi'**
  String get appTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get commonMenu;

  /// No description provided for @commonLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get commonLogout;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading data'**
  String get commonLoading;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @createSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createSheetTitle;

  /// No description provided for @createVideo.
  ///
  /// In en, this message translates to:
  /// **'VIDEO'**
  String get createVideo;

  /// No description provided for @createImage.
  ///
  /// In en, this message translates to:
  /// **'IMAGE'**
  String get createImage;

  /// No description provided for @createEffects.
  ///
  /// In en, this message translates to:
  /// **'EFFECTS'**
  String get createEffects;

  /// No description provided for @createMotion.
  ///
  /// In en, this message translates to:
  /// **'MOTION'**
  String get createMotion;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Image to Video'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your ideas into AI video with cinematic effects'**
  String get authWelcomeSubtitle;

  /// No description provided for @authWelcomeLogin.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get authWelcomeLogin;

  /// No description provided for @authWelcomeLegal.
  ///
  /// In en, this message translates to:
  /// **'Registration requires 18+ confirmation and AllAi terms acceptance.'**
  String get authWelcomeLegal;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginTitle;

  /// No description provided for @authLoginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginHeadline;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to open the generator, library, and coin balance.'**
  String get authLoginSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'creator@allai.market'**
  String get authEmailHint;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordHint;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @authLoginSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get authLoginSubmitting;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get authPasswordRequired;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterHeadline.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterHeadline;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A demo account saves this session on the device and unlocks the generator.'**
  String get authRegisterSubtitle;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authNameLabel;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'How should we call you'**
  String get authNameHint;

  /// No description provided for @authPasswordMinHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get authPasswordMinHint;

  /// No description provided for @authRepeatPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get authRepeatPasswordLabel;

  /// No description provided for @authAcceptTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I accept '**
  String get authAcceptTermsPrefix;

  /// No description provided for @authTermsLabel.
  ///
  /// In en, this message translates to:
  /// **'terms of use'**
  String get authTermsLabel;

  /// No description provided for @authAcceptPrivacyPrefix.
  ///
  /// In en, this message translates to:
  /// **'I accept '**
  String get authAcceptPrivacyPrefix;

  /// No description provided for @authPrivacyLabel.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get authPrivacyLabel;

  /// No description provided for @authConfirmAge.
  ///
  /// In en, this message translates to:
  /// **'I confirm that I am 18 or older'**
  String get authConfirmAge;

  /// No description provided for @authRegisterSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get authRegisterSubmitting;

  /// No description provided for @authRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterButton;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authHaveAccount;

  /// No description provided for @authLegalPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Legal copy will be connected after the links are approved. This is a demo placeholder.'**
  String get authLegalPlaceholder;

  /// No description provided for @authLegalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get authLegalConfirm;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore access'**
  String get authResetTitle;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email. In demo mode we show a safe confirmation without sending mail.'**
  String get authResetSubtitle;

  /// No description provided for @authResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'If the account exists, the request was accepted in demo mode.'**
  String get authResetSuccess;

  /// No description provided for @authResetSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get authResetSubmitting;

  /// No description provided for @authResetButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authResetButton;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToLogin;

  /// No description provided for @homeLoadingEffects.
  ///
  /// In en, this message translates to:
  /// **'Loading effects'**
  String get homeLoadingEffects;

  /// No description provided for @homeEffectsUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Effects are unavailable'**
  String get homeEffectsUnavailableTitle;

  /// No description provided for @homeEffectsUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing the catalog a little later.'**
  String get homeEffectsUnavailableDescription;

  /// No description provided for @homeTitleVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get homeTitleVideos;

  /// No description provided for @homeReadyScenariosTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready scenarios'**
  String get homeReadyScenariosTitle;

  /// No description provided for @homeReadyScenariosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a format and start creating'**
  String get homeReadyScenariosSubtitle;

  /// No description provided for @homeMarketingTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketing studio'**
  String get homeMarketingTitle;

  /// No description provided for @homeMarketingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'UGC, unboxing, try-on, demos'**
  String get homeMarketingSubtitle;

  /// No description provided for @homeVideoStudioTitle.
  ///
  /// In en, this message translates to:
  /// **'AI video studio'**
  String get homeVideoStudioTitle;

  /// No description provided for @homeVideoStudioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seedance, zine rhythm, cinematic presets'**
  String get homeVideoStudioSubtitle;

  /// No description provided for @homeMagicTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Magic'**
  String get homeMagicTitle;

  /// No description provided for @homeMagicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring your imagination to life!'**
  String get homeMagicSubtitle;

  /// No description provided for @homeRecentProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get homeRecentProjectsTitle;

  /// No description provided for @homeAllEffects.
  ///
  /// In en, this message translates to:
  /// **'All effects'**
  String get homeAllEffects;

  /// No description provided for @homeActionAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get homeActionAll;

  /// No description provided for @homeActionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get homeActionOpen;

  /// No description provided for @homeTryNow.
  ///
  /// In en, this message translates to:
  /// **'Try Now'**
  String get homeTryNow;

  /// No description provided for @generatorUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Generator unavailable'**
  String get generatorUnavailableTitle;

  /// No description provided for @generatorUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Could not load creation tools. Try again.'**
  String get generatorUnavailableDescription;

  /// No description provided for @generatorNoGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'No generator available'**
  String get generatorNoGeneratorTitle;

  /// No description provided for @generatorNoGeneratorDescription.
  ///
  /// In en, this message translates to:
  /// **'Creation models will appear after catalog update.'**
  String get generatorNoGeneratorDescription;

  /// No description provided for @generatorImageUploadLater.
  ///
  /// In en, this message translates to:
  /// **'Image upload will be connected later.'**
  String get generatorImageUploadLater;

  /// No description provided for @generatorLoadingBalance.
  ///
  /// In en, this message translates to:
  /// **'Loading balance...'**
  String get generatorLoadingBalance;

  /// No description provided for @generatorBalanceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Balance is temporarily unavailable.'**
  String get generatorBalanceUnavailable;

  /// No description provided for @generatorTitleImage.
  ///
  /// In en, this message translates to:
  /// **'Image Generation'**
  String get generatorTitleImage;

  /// No description provided for @generatorTitleVideo.
  ///
  /// In en, this message translates to:
  /// **'Video Generation'**
  String get generatorTitleVideo;

  /// No description provided for @generatorTitleUpscale.
  ///
  /// In en, this message translates to:
  /// **'Upscale'**
  String get generatorTitleUpscale;

  /// No description provided for @generatorTitleAvatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar Generation'**
  String get generatorTitleAvatar;

  /// No description provided for @generatorTitleMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion Control'**
  String get generatorTitleMotion;

  /// No description provided for @generatorHintImage.
  ///
  /// In en, this message translates to:
  /// **'Describe an image...'**
  String get generatorHintImage;

  /// No description provided for @generatorHintVideo.
  ///
  /// In en, this message translates to:
  /// **'Describe a video...'**
  String get generatorHintVideo;

  /// No description provided for @generatorHintUpscale.
  ///
  /// In en, this message translates to:
  /// **'Describe what to enhance...'**
  String get generatorHintUpscale;

  /// No description provided for @generatorHintAvatar.
  ///
  /// In en, this message translates to:
  /// **'Describe an avatar...'**
  String get generatorHintAvatar;

  /// No description provided for @generatorHintMotion.
  ///
  /// In en, this message translates to:
  /// **'Describe motion...'**
  String get generatorHintMotion;

  /// No description provided for @generatorEmptyImage.
  ///
  /// In en, this message translates to:
  /// **'Describe an image to generate.'**
  String get generatorEmptyImage;

  /// No description provided for @generatorEmptyVideo.
  ///
  /// In en, this message translates to:
  /// **'Describe a video to generate.'**
  String get generatorEmptyVideo;

  /// No description provided for @generatorEmptyUpscale.
  ///
  /// In en, this message translates to:
  /// **'Describe what needs better quality.'**
  String get generatorEmptyUpscale;

  /// No description provided for @generatorEmptyAvatar.
  ///
  /// In en, this message translates to:
  /// **'Describe the avatar scene.'**
  String get generatorEmptyAvatar;

  /// No description provided for @generatorEmptyMotion.
  ///
  /// In en, this message translates to:
  /// **'Describe the motion you want.'**
  String get generatorEmptyMotion;

  /// No description provided for @generatorFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'FORMAT'**
  String get generatorFormatLabel;

  /// No description provided for @generatorModelsLabel.
  ///
  /// In en, this message translates to:
  /// **'MODELS'**
  String get generatorModelsLabel;

  /// No description provided for @generatorModelCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No models} =1{1 model} other{{count} models}}'**
  String generatorModelCount(int count);

  /// No description provided for @generatorAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get generatorAddImage;

  /// No description provided for @generatorGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generatorGenerate;

  /// No description provided for @generatorGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generatorGenerating;

  /// No description provided for @generatorOpenResult.
  ///
  /// In en, this message translates to:
  /// **'Open result'**
  String get generatorOpenResult;

  /// No description provided for @generatorFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Generation did not finish. Settings were saved.'**
  String get generatorFailedTitle;

  /// No description provided for @generatorCoinsRefunded.
  ///
  /// In en, this message translates to:
  /// **'Coins were returned to your balance.'**
  String get generatorCoinsRefunded;

  /// No description provided for @generatorNoCharge.
  ///
  /// In en, this message translates to:
  /// **'No charge was made.'**
  String get generatorNoCharge;

  /// No description provided for @generatorMetaCost.
  ///
  /// In en, this message translates to:
  /// **'{model} · Cost {cost} coins · {available} available'**
  String generatorMetaCost(String model, String cost, String available);

  /// No description provided for @generatorSuggestionFuturistic.
  ///
  /// In en, this message translates to:
  /// **'Futuristic walk of her'**
  String get generatorSuggestionFuturistic;

  /// No description provided for @generatorSuggestionTiger.
  ///
  /// In en, this message translates to:
  /// **'Majestic baby tiger walk'**
  String get generatorSuggestionTiger;

  /// No description provided for @generatorSuggestionDragon.
  ///
  /// In en, this message translates to:
  /// **'Tiny dragon flying'**
  String get generatorSuggestionDragon;

  /// No description provided for @generatorSuggestionProduct.
  ///
  /// In en, this message translates to:
  /// **'Cinematic product reveal'**
  String get generatorSuggestionProduct;

  /// No description provided for @projectsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading projects'**
  String get projectsLoading;

  /// No description provided for @projectsUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects are unavailable'**
  String get projectsUnavailableTitle;

  /// No description provided for @projectsUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Generation history could not be loaded.'**
  String get projectsUnavailableDescription;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @projectsNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get projectsNew;

  /// No description provided for @projectsSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No saved generations} =1{1 saved generation} other{{count} saved generations}}'**
  String projectsSavedCount(int count);

  /// No description provided for @projectsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Magic'**
  String get projectsEmptyTitle;

  /// No description provided for @projectsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI videos and images will appear here'**
  String get projectsEmptySubtitle;

  /// No description provided for @projectsCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'Create first project'**
  String get projectsCreateFirst;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLocalBuild.
  ///
  /// In en, this message translates to:
  /// **'Local build'**
  String get settingsLocalBuild;

  /// No description provided for @settingsDemoBilling.
  ///
  /// In en, this message translates to:
  /// **'No live payments'**
  String get settingsDemoBilling;

  /// No description provided for @settingsAppTitle.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get settingsAppTitle;

  /// No description provided for @settingsAppDescription.
  ///
  /// In en, this message translates to:
  /// **'These options do not affect generation or payments in the demo build.'**
  String get settingsAppDescription;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'The interface now supports the main launch languages. A language switcher will be connected in the next step.'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Generation-ready notifications will appear after a separate permission and device setup.'**
  String get settingsNotificationsDescription;

  /// No description provided for @settingsLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal documents'**
  String get settingsLegalTitle;

  /// No description provided for @settingsLegalDescription.
  ///
  /// In en, this message translates to:
  /// **'Terms, privacy policy, and AI content rules will be connected before release.'**
  String get settingsLegalDescription;

  /// No description provided for @settingsSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupportTitle;

  /// No description provided for @settingsSupportDescription.
  ///
  /// In en, this message translates to:
  /// **'Generation, balance, and account help will appear after the support channel is prepared.'**
  String get settingsSupportDescription;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Account deletion will appear after a secure confirmation flow is ready.'**
  String get settingsDeleteAccountDescription;

  /// No description provided for @profileRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring session'**
  String get profileRestoring;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileFallbackName.
  ///
  /// In en, this message translates to:
  /// **'AllAi Account'**
  String get profileFallbackName;

  /// No description provided for @profileSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to open your profile.'**
  String get profileSignInPrompt;

  /// No description provided for @profileSessionActive.
  ///
  /// In en, this message translates to:
  /// **'Session active'**
  String get profileSessionActive;

  /// No description provided for @profileBalanceLoading.
  ///
  /// In en, this message translates to:
  /// **'Balance is loading'**
  String get profileBalanceLoading;

  /// No description provided for @profileBalanceCoins.
  ///
  /// In en, this message translates to:
  /// **'Balance: {coins} coins'**
  String profileBalanceCoins(String coins);

  /// No description provided for @profileAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountTitle;

  /// No description provided for @profileAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Email, name, 18+ confirmation, and local session. Profile editing will appear later.'**
  String get profileAccountDescription;

  /// No description provided for @profileCoinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Coins and balance'**
  String get profileCoinsTitle;

  /// No description provided for @profileCoinsDescription.
  ///
  /// In en, this message translates to:
  /// **'Demo balance and packages are visible now. Real purchases are intentionally disabled in this build.'**
  String get profileCoinsDescription;

  /// No description provided for @profileOpenBalance.
  ///
  /// In en, this message translates to:
  /// **'Open balance'**
  String get profileOpenBalance;

  /// No description provided for @profileSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Language, notifications, legal links, and support.'**
  String get profileSettingsDescription;

  /// No description provided for @profileOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get profileOpenSettings;

  /// No description provided for @profileDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Account deletion will appear after the backend contract is ready. The action is unavailable now.'**
  String get profileDeleteDescription;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of account?'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutContent.
  ///
  /// In en, this message translates to:
  /// **'Local history will stay on this device.'**
  String get profileLogoutContent;

  /// No description provided for @pricingLoadingPro.
  ///
  /// In en, this message translates to:
  /// **'Loading PRO'**
  String get pricingLoadingPro;

  /// No description provided for @pricingBalanceUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance is unavailable'**
  String get pricingBalanceUnavailableTitle;

  /// No description provided for @pricingBalanceUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Coin data could not be loaded right now.'**
  String get pricingBalanceUnavailableDescription;

  /// No description provided for @pricingStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Creating Now'**
  String get pricingStartTitle;

  /// No description provided for @pricingStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate anything. PRO purchase flow will be connected after store setup.'**
  String get pricingStartSubtitle;

  /// No description provided for @pricingLoadingPackages.
  ///
  /// In en, this message translates to:
  /// **'Loading packages'**
  String get pricingLoadingPackages;

  /// No description provided for @pricingPackagesUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Packages are unavailable'**
  String get pricingPackagesUnavailableTitle;

  /// No description provided for @pricingPackagesUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'The demo package list could not be loaded.'**
  String get pricingPackagesUnavailableDescription;

  /// No description provided for @pricingContinueSnack.
  ///
  /// In en, this message translates to:
  /// **'Purchases will be connected later.'**
  String get pricingContinueSnack;

  /// No description provided for @pricingDemoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode. No live payment is charged in this build.'**
  String get pricingDemoMode;

  /// No description provided for @pricingCoinsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{coins} coins available'**
  String pricingCoinsAvailable(String coins);

  /// No description provided for @pricingReserved.
  ///
  /// In en, this message translates to:
  /// **'{coins} reserved'**
  String pricingReserved(String coins);

  /// No description provided for @pricingPackagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Coin packages will appear here after billing setup.'**
  String get pricingPackagesEmpty;

  /// No description provided for @pricingPackageCoins.
  ///
  /// In en, this message translates to:
  /// **'{coins} coins'**
  String pricingPackageCoins(String coins);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
