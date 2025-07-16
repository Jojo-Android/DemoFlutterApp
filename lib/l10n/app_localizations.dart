import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('th'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Demo Flutter App'**
  String get appName;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping App'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @noUserData.
  ///
  /// In en, this message translates to:
  /// **'No user data found'**
  String get noUserData;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get userNotFound;

  /// No description provided for @favoritePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritePageTitle;

  /// No description provided for @favoritePageEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no favorites yet'**
  String get favoritePageEmptyMessage;

  /// No description provided for @removeFromFavoritesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavoritesTooltip;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get confirmLogout;

  /// No description provided for @changeLanguageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This system does not yet support additional languages'**
  String get changeLanguageNotAvailable;

  /// No description provided for @changeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguageTitle;

  /// No description provided for @pickImageError.
  ///
  /// In en, this message translates to:
  /// **'Unable to pick image. Please try again.'**
  String get pickImageError;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// No description provided for @pickImageButton.
  ///
  /// In en, this message translates to:
  /// **'Pick profile image'**
  String get pickImageButton;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileImagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No profile image'**
  String get profileImagePlaceholder;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Loading favorites...'**
  String get loadingFavorites;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @errorLoadingUser.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading user data'**
  String get errorLoadingUser;

  /// No description provided for @errorLoadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading favorites'**
  String get errorLoadingFavorites;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @pullToRefreshLabel.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh the list'**
  String get pullToRefreshLabel;

  /// No description provided for @imagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imagePlaceholder;

  /// No description provided for @homePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePageTitle;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get languageThai;

  /// No description provided for @profileAvatarTapTooltip.
  ///
  /// In en, this message translates to:
  /// **'Tap to change profile image'**
  String get profileAvatarTapTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @loadingUser.
  ///
  /// In en, this message translates to:
  /// **'Loading user data...'**
  String get loadingUser;

  /// No description provided for @errorLoadingUserData.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading user data'**
  String get errorLoadingUserData;

  /// No description provided for @favoriteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get favoriteItemTitle;

  /// No description provided for @favoriteItemCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get favoriteItemCategory;

  /// No description provided for @favoriteItemImageError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load product image'**
  String get favoriteItemImageError;

  /// No description provided for @favoriteItemRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteItemRemoveTooltip;

  /// No description provided for @favoriteToggleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteToggleAdd;

  /// No description provided for @favoriteToggleRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteToggleRemove;

  /// No description provided for @retryLoadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Retry loading favorites'**
  String get retryLoadingFavorites;

  /// No description provided for @logoutDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get logoutDialogCancel;

  /// No description provided for @logoutDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogConfirm;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutDialogContent;

  /// No description provided for @changeLanguageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguageDialogTitle;

  /// No description provided for @changeLanguageDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred language'**
  String get changeLanguageDialogContent;

  /// No description provided for @changeLanguageDialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get changeLanguageDialogClose;

  /// No description provided for @imagePickFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to pick image. Please try again.'**
  String get imagePickFailedMessage;

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get profilePageTitle;

  /// No description provided for @profilePageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get profilePageLoading;

  /// No description provided for @profilePageError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading profile'**
  String get profilePageError;

  /// No description provided for @languageSelectionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageSelectionEnglish;

  /// No description provided for @languageSelectionThai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get languageSelectionThai;

  /// No description provided for @loginPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginPageTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginRegisterLink.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register here'**
  String get loginRegisterLink;

  /// No description provided for @loginInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get loginInvalidEmail;

  /// No description provided for @loginEmptyPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginEmptyPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get loginFailed;

  /// No description provided for @loginGenericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get loginGenericError;

  /// No description provided for @loginLoading.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loginLoading;

  /// No description provided for @loginIconTooltip.
  ///
  /// In en, this message translates to:
  /// **'Login icon'**
  String get loginIconTooltip;

  /// No description provided for @registerPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerPageTitle;

  /// No description provided for @registerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get registerNameLabel;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// No description provided for @registerEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get registerEmailInUse;

  /// No description provided for @registerPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get registerPasswordMinLength;

  /// No description provided for @registerConfirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get registerConfirmPasswordEmpty;

  /// No description provided for @registerConfirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerConfirmPasswordMismatch;

  /// No description provided for @registerPickImageTooltipShow.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get registerPickImageTooltipShow;

  /// No description provided for @registerPickImageTooltipHide.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get registerPickImageTooltipHide;

  /// No description provided for @registerPickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image. Please try again'**
  String get registerPickImageFailed;

  /// No description provided for @registerFieldRequiredName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get registerFieldRequiredName;

  /// No description provided for @registerFieldRequiredEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get registerFieldRequiredEmail;

  /// No description provided for @registerFieldRequiredPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get registerFieldRequiredPassword;

  /// No description provided for @registerFormGenericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String registerFormGenericError(String error);

  /// No description provided for @registerFormInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get registerFormInvalidEmail;

  /// No description provided for @registerGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get registerGoBack;

  /// No description provided for @registerPickImageFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String registerPickImageFailedWithError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
