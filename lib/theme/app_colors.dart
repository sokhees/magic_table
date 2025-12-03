import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  // Background colors
  static const Color backgroundDark = Color(0xFF1a1a1a);
  static const Color backgroundMedium = Color(0xFF2a2a2a);
  static const Color backgroundDarkAlt = Color(0xFF2a2a3e);
  static const Color backgroundLight = Color(0xFF3a3a4e);
  static const Color borderColor = Color(0xFF4a4a4a);
  
  // Primary gradient colors
  static const Color primaryPurple = Color(0xFF667eea);
  static const Color primaryDeepPurple = Color(0xFF764ba2);
  static const Color primaryBlue = Color(0xFF6a11cb);
  static const Color primaryLightBlue = Color(0xFF2575fc);
  
  // Status colors
  static const Color success = Color(0xFF4caf50);
  static const Color error = Color(0xFFff6b6b);
  static const Color warning = Color(0xFFffd700);
  static const Color info = Color(0xFF2196f3);
  
  // Player card gradient colors (5 colors)
  static const List<Color> playerColors = [
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.teal,
  ];
  
  // Get gradient color for player card
  static Color getPlayerColor(int index, [double opacity = 1.0]) {
    return playerColors[index % playerColors.length].withOpacity(opacity);
  }
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryDeepPurple],
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [primaryBlue, primaryLightBlue],
  );
  
  static LinearGradient playerGradient(int index) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        getPlayerColor(index, 0.8),
        getPlayerColor(index, 1.0),
      ],
    );
  }
}
