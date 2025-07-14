import 'package:flutter/material.dart';

final shoppingAppTheme = ThemeData(
  primaryColor: const Color(0xFFEF6C00),
  // ส้มเข้ม Coral ที่น่าดึงดูด
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFFEF6C00),
    // ส้มเข้ม Coral
    onPrimary: Colors.white,
    secondary: const Color(0xFFFFC107),
    // เหลืองทอง สำหรับไฮไลต์
    onSecondary: Colors.black87,
    background: const Color(0xFFF5F5F5),
    // เทาอ่อน (Off-white) สบายตา
    onBackground: const Color(0xFF212121),
    // ดำอ่อนสำหรับข้อความหลัก
    surface: Colors.white,
    onSurface: const Color(0xFF212121),
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color(0xFF212121), // ข้อความหลัก
      letterSpacing: 0.15,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Color(0xFF616161), // ข้อความรองเทาเข้ม
      height: 1.4,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFEF6C00), // ป้ายหรือปุ่มสำคัญ
      letterSpacing: 0.5,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFFEF6C00),
    // ส้มเข้ม
    unselectedItemColor: Color(0xFF9E9E9E),
    // เทากลาง
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    elevation: 14,
    type: BottomNavigationBarType.fixed,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFEF6C00), // ส้ม Coral
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        letterSpacing: 0.5,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    shadowColor: Colors.black.withOpacity(0.12),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),
);
