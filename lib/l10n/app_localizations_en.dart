// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Demo Flutter App';

  @override
  String get close => 'Close';

  @override
  String get user => 'User';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get failedToLoadProducts => 'Failed to load products';

  @override
  String get appTitle => 'Shopping App';

  @override
  String get welcome => 'Welcome back';

  @override
  String get settings => 'Settings';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get noUserData => 'No user data found';

  @override
  String get userNotFound => 'No user found';

  @override
  String get favoritePageTitle => 'Favorites';

  @override
  String get favoritePageEmptyMessage => 'You have no favorites yet';

  @override
  String get removeFromFavoritesTooltip => 'Remove from favorites';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmContent => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmLogout => 'Logout';

  @override
  String get changeLanguageNotAvailable =>
      'This system does not yet support additional languages';

  @override
  String get changeLanguageTitle => 'Change Language';

  @override
  String get pickImageError => 'Unable to pick image. Please try again.';

  @override
  String get pickImage => 'Pick Image';

  @override
  String get pickImageButton => 'Pick profile image';

  @override
  String get profile => 'Profile';

  @override
  String get profileImagePlaceholder => 'No profile image';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingFavorites => 'Loading favorites...';

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get errorLoadingUser => 'An error occurred while loading user data';

  @override
  String get errorLoadingFavorites =>
      'An error occurred while loading favorites';

  @override
  String get retry => 'Retry';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get pullToRefreshLabel => 'Pull to refresh the list';

  @override
  String get imagePlaceholder => 'Image not found';

  @override
  String get homePageTitle => 'Home Page';

  @override
  String get homePage => 'Home Page';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageThai => 'Thai';

  @override
  String get profileAvatarTapTooltip => 'Tap to change profile image';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get loadingUser => 'Loading user data...';

  @override
  String get errorLoadingUserData =>
      'An error occurred while loading user data';

  @override
  String get favoriteItemTitle => 'Product name';

  @override
  String get favoriteItemCategory => 'Category';

  @override
  String get favoriteItemImageError => 'Unable to load product image';

  @override
  String get favoriteItemRemoveTooltip => 'Remove from favorites';

  @override
  String get favoriteToggleAdd => 'Add to favorites';

  @override
  String get favoriteToggleRemove => 'Remove from favorites';

  @override
  String get retryLoadingFavorites => 'Retry loading favorites';

  @override
  String get logoutDialogCancel => 'Cancel';

  @override
  String get logoutDialogConfirm => 'Logout';

  @override
  String get logoutDialogTitle => 'Confirm Logout';

  @override
  String get logoutDialogContent => 'Are you sure you want to logout?';

  @override
  String get changeLanguageDialogTitle => 'Change Language';

  @override
  String get changeLanguageDialogContent =>
      'Please select your preferred language';

  @override
  String get changeLanguageDialogClose => 'Close';

  @override
  String get imagePickFailedMessage =>
      'Unable to pick image. Please try again.';

  @override
  String get profilePageTitle => 'User Profile';

  @override
  String get profilePageLoading => 'Loading profile...';

  @override
  String get profilePageError => 'An error occurred while loading profile';

  @override
  String get languageSelectionEnglish => 'English';

  @override
  String get languageSelectionThai => 'Thai';

  @override
  String get loginPageTitle => 'Login';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginRegisterLink => 'Don\'t have an account? Register here';

  @override
  String get loginInvalidEmail => 'Invalid email format';

  @override
  String get loginEmptyPassword => 'Please enter your password';

  @override
  String get loginFailed => 'Incorrect email or password';

  @override
  String get loginGenericError => 'An error occurred. Please try again';

  @override
  String get loginLoading => 'Logging in...';

  @override
  String get loginIconTooltip => 'Login icon';

  @override
  String get registerPageTitle => 'Register';

  @override
  String get registerNameLabel => 'Name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm Password';

  @override
  String get registerButton => 'Register';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get registerEmailInUse => 'This email is already in use';

  @override
  String get registerPasswordMinLength => 'At least 6 characters';

  @override
  String get registerConfirmPasswordEmpty => 'Please confirm your password';

  @override
  String get registerConfirmPasswordMismatch => 'Passwords do not match';

  @override
  String get registerPickImageTooltipShow => 'Show password';

  @override
  String get registerPickImageTooltipHide => 'Hide password';

  @override
  String get registerPickImageFailed =>
      'Failed to pick image. Please try again';

  @override
  String get registerFieldRequiredName => 'Please enter your name';

  @override
  String get registerFieldRequiredEmail => 'Please enter your email';

  @override
  String get registerFieldRequiredPassword => 'Please enter your password';

  @override
  String registerFormGenericError(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get registerFormInvalidEmail => 'Invalid email format';

  @override
  String get registerGoBack => 'Go back';

  @override
  String registerPickImageFailedWithError(String error) {
    return 'Failed to pick image: $error';
  }
}
