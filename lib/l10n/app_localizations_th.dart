// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Demo Flutter App';

  @override
  String get close => 'ปิด';

  @override
  String get user => 'ผู้ใช้';

  @override
  String get changeLanguage => 'เปลี่ยนภาษา';

  @override
  String get noProductsFound => 'ไม่พบสินค้า';

  @override
  String get failedToLoadProducts => 'ไม่สามารถโหลดสินค้าได้';

  @override
  String get appTitle => 'แอปช้อปปิ้ง';

  @override
  String get welcome => 'ยินดีต้อนรับกลับ';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get settingsPageTitle => 'หน้าตั้งค่า';

  @override
  String get noUserData => 'ไม่พบข้อมูลผู้ใช้';

  @override
  String get userNotFound => 'ไม่พบผู้ใช้';

  @override
  String get favoritePageTitle => 'รายการโปรด';

  @override
  String get favoritePageEmptyMessage => 'คุณยังไม่มีรายการโปรด';

  @override
  String get removeFromFavoritesTooltip => 'ลบออกจากรายการโปรด';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get logoutConfirmTitle => 'ยืนยันการออกจากระบบ';

  @override
  String get logoutConfirmContent => 'คุณต้องการออกจากระบบใช่หรือไม่?';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get confirmLogout => 'ออกจากระบบ';

  @override
  String get changeLanguageNotAvailable => 'ระบบนี้ยังไม่รองรับภาษาเพิ่มเติม';

  @override
  String get changeLanguageTitle => 'เปลี่ยนภาษา';

  @override
  String get pickImageError => 'ไม่สามารถเลือกภาพได้ กรุณาลองใหม่อีกครั้ง';

  @override
  String get pickImage => 'เลือกภาพ';

  @override
  String get pickImageButton => 'เลือกภาพโปรไฟล์';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get profileImagePlaceholder => 'ไม่มีรูปภาพโปรไฟล์';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get loadingFavorites => 'กำลังโหลดรายการโปรด...';

  @override
  String errorOccurred(Object error) {
    return 'เกิดข้อผิดพลาด: $error';
  }

  @override
  String get errorLoadingUser => 'เกิดข้อผิดพลาดขณะโหลดข้อมูลผู้ใช้';

  @override
  String get errorLoadingFavorites => 'เกิดข้อผิดพลาดขณะโหลดรายการโปรด';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get pullToRefresh => 'ดึงเพื่อรีเฟรช';

  @override
  String get pullToRefreshLabel => 'ดึงเพื่อรีเฟรชรายการ';

  @override
  String get imagePlaceholder => 'ไม่พบรูปภาพ';

  @override
  String get homePageTitle => 'หน้าแรก';

  @override
  String get homePage => 'หน้าแรก';

  @override
  String get languageEnglish => 'ภาษาอังกฤษ';

  @override
  String get languageThai => 'ภาษาไทย';

  @override
  String get profileAvatarTapTooltip => 'แตะเพื่อเปลี่ยนรูปโปรไฟล์';

  @override
  String get settingsTooltip => 'ตั้งค่า';

  @override
  String get loadingUser => 'กำลังโหลดข้อมูลผู้ใช้...';

  @override
  String get errorLoadingUserData => 'เกิดข้อผิดพลาดขณะโหลดข้อมูลผู้ใช้';

  @override
  String get favoriteItemTitle => 'ชื่อสินค้า';

  @override
  String get favoriteItemCategory => 'หมวดหมู่';

  @override
  String get favoriteItemImageError => 'ไม่สามารถโหลดรูปภาพสินค้า';

  @override
  String get favoriteItemRemoveTooltip => 'ลบรายการโปรด';

  @override
  String get favoriteToggleAdd => 'เพิ่มในรายการโปรด';

  @override
  String get favoriteToggleRemove => 'ลบจากรายการโปรด';

  @override
  String get retryLoadingFavorites => 'ลองโหลดรายการโปรดอีกครั้ง';

  @override
  String get logoutDialogCancel => 'ยกเลิก';

  @override
  String get logoutDialogConfirm => 'ออกจากระบบ';

  @override
  String get logoutDialogTitle => 'ยืนยันการออกจากระบบ';

  @override
  String get logoutDialogContent => 'คุณแน่ใจหรือว่าต้องการออกจากระบบ?';

  @override
  String get changeLanguageDialogTitle => 'เปลี่ยนภาษา';

  @override
  String get changeLanguageDialogContent => 'กรุณาเลือกภาษาที่ต้องการใช้';

  @override
  String get changeLanguageDialogClose => 'ปิด';

  @override
  String get imagePickFailedMessage =>
      'ไม่สามารถเลือกภาพได้ กรุณาลองใหม่อีกครั้ง';

  @override
  String get profilePageTitle => 'โปรไฟล์ผู้ใช้';

  @override
  String get profilePageLoading => 'กำลังโหลดโปรไฟล์...';

  @override
  String get profilePageError => 'เกิดข้อผิดพลาดขณะโหลดโปรไฟล์';

  @override
  String get languageSelectionEnglish => 'ภาษาอังกฤษ';

  @override
  String get languageSelectionThai => 'ภาษาไทย';

  @override
  String get loginPageTitle => 'เข้าสู่ระบบ';

  @override
  String get loginEmailLabel => 'อีเมล';

  @override
  String get loginPasswordLabel => 'รหัสผ่าน';

  @override
  String get loginButton => 'เข้าสู่ระบบ';

  @override
  String get loginRegisterLink => 'ยังไม่มีบัญชี? สมัครสมาชิกที่นี่';

  @override
  String get loginInvalidEmail => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get loginEmptyPassword => 'กรุณากรอกรหัสผ่าน';

  @override
  String get loginFailed => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get loginGenericError => 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  @override
  String get loginLoading => 'กำลังเข้าสู่ระบบ...';

  @override
  String get loginIconTooltip => 'ไอคอนล็อกอิน';

  @override
  String get registerPageTitle => 'สมัครสมาชิก';

  @override
  String get registerNameLabel => 'ชื่อ';

  @override
  String get registerEmailLabel => 'อีเมล';

  @override
  String get registerPasswordLabel => 'รหัสผ่าน';

  @override
  String get registerConfirmPasswordLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get registerButton => 'สมัครสมาชิก';

  @override
  String get registerSuccess => 'สมัครสมาชิกสำเร็จ';

  @override
  String get registerEmailInUse => 'อีเมลนี้ถูกใช้แล้ว';

  @override
  String get registerPasswordMinLength => 'อย่างน้อย 6 ตัว';

  @override
  String get registerConfirmPasswordEmpty => 'กรุณายืนยันรหัสผ่าน';

  @override
  String get registerConfirmPasswordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get registerPickImageTooltipShow => 'แสดงรหัสผ่าน';

  @override
  String get registerPickImageTooltipHide => 'ซ่อนรหัสผ่าน';

  @override
  String get registerPickImageFailed =>
      'ไม่สามารถเลือกภาพได้ กรุณาลองใหม่อีกครั้ง';

  @override
  String get registerFieldRequiredName => 'กรุณากรอกชื่อ';

  @override
  String get registerFieldRequiredEmail => 'กรุณากรอกอีเมล';

  @override
  String get registerFieldRequiredPassword => 'กรุณากรอกรหัสผ่าน';

  @override
  String registerFormGenericError(String error) {
    return 'มีข้อผิดพลาด: $error';
  }

  @override
  String get registerFormInvalidEmail => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get registerGoBack => 'กลับหน้าก่อนหน้า';

  @override
  String registerPickImageFailedWithError(String error) {
    return 'ไม่สามารถเลือกภาพได้: $error';
  }
}
