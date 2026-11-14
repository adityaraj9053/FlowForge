import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - FlowForge Modern Indigo & Electric Violet
  static const Color primary = Color(0xFF4F46E5); // Vibrant Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Deep Indigo 800
  static const Color accent = Color(0xFF06B6D4); // Cyber Cyan 500 for flow accents
  static const Color forgeAmber = Color(0xFFF59E0B); // Amber 500 for forge highlights
  
  // Background Colors - Crisp, high-contrast modern workspace
  static const Color background = Color(0xFFF8FAFC); // Clean Slate 50
  static const Color surface = Color(0xFFFFFFFF); // Pure white surface
  static const Color cardBackground = Color(0xFFFFFFFF); // White card background
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Deep Slate 900
  static const Color textSecondary = Color(0xFF334155); // Slate 700
  static const Color textLight = Color(0xFF64748B); // Slate 500
  static const Color textWhite = Color(0xFFFFFFFF); // White text
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald 500 for "EARLY" / "DONE"
  static const Color warning = Color(0xFFF59E0B); // Amber 500 for warnings
  static const Color error = Color(0xFFEF4444); // Red 500 for "LATE" / "OVERDUE"
  static const Color info = Color(0xFF0EA5E9); // Sky Blue 500 for "ON TIME" / "IN PROGRESS"
  
  // Progress Ring Colors
  static const Color progressPrimary = Color(0xFF4F46E5); // Indigo
  static const Color progressSecondary = Color(0xFF8B5CF6); // Purple
  static const Color progressTertiary = Color(0xFF06B6D4); // Cyan
  static const Color progressQuaternary = Color(0xFFF97316); // Forge Orange
  static const Color progressBackground = Color(0xFFE2E8F0); // Slate 200
  
  // Glass Effect Colors
  static const Color glassBackground = Color(0x1AFFFFFF); // Semi-transparent white
  static const Color glassBorder = Color(0x33FFFFFF); // Semi-transparent white border
  
  // Navigation Colors
  static const Color navBackground = Color(0xFF312E81); // Midnight Indigo 900
  static const Color navActive = Color(0xFF818CF8); // Indigo 400
  static const Color navInactive = Color(0xFF94A3B8); // Slate 400
  
  // Shadow Colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x28000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3730A3), Color(0xFF6366F1)], // Deep Indigo to Electric Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)], // Indigo to Cyber Cyan
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)], // Slate 50 to Indigo 50
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Status Badge Colors
  static const Map<String, Color> statusColors = {
    'early': success,
    'on_time': info,
    'late': error,
    'pending': warning,
  };
}
