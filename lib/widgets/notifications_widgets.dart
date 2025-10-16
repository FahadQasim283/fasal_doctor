import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/global_keys.dart';

/// Utility class for showing different types of notifications using ScaffoldMessenger
class NotificationWidgets {
  /// Show an error notification (red background)
  static void showError(String message, {Duration? duration}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show a success notification (green background)
  static void showSuccess(String message, {Duration? duration}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show an info notification (blue background)
  static void showInfo(String message, {Duration? duration}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show a warning notification (orange background)
  static void showWarning(String message, {Duration? duration}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show a custom notification with action button
  static void showWithAction({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    Color backgroundColor = Colors.blue,
    IconData? icon,
    Duration? duration,
  }) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[Icon(icon, color: Colors.white), const SizedBox(width: 12)],
            Expanded(
              child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(label: actionLabel, textColor: Colors.white, onPressed: onAction),
      ),
    );
  }

  /// Show a banner notification at the top of the screen
  static void showBanner({
    required String title,
    required String message,
    Color backgroundColor = Colors.blue,
    IconData? leadingIcon,
    List<Widget>? actions,
    Duration? duration,
  }) {
    scaffoldMessengerKey.currentState?.showMaterialBanner(
      MaterialBanner(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            if (title.isNotEmpty && message.isNotEmpty) const SizedBox(height: 4),
            if (message.isNotEmpty)
              Text(
                message,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.9)),
              ),
          ],
        ),
        leading: leadingIcon != null ? Icon(leadingIcon, color: Colors.white, size: 28) : null,
        backgroundColor: backgroundColor,
        actions:
            actions ??
            [
              TextButton(
                onPressed: () => scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner(),
                child: Text(
                  'DISMISS',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
      ),
    );

    // Auto-hide after duration
    if (duration != null) {
      Future.delayed(duration, () {
        scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
      });
    }
  }

  /// Show a loading notification
  static void showLoading(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade700,
        duration: const Duration(seconds: 30), // Long duration for loading
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Hide current snackbar
  static void hideCurrent() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  /// Hide current material banner
  static void hideCurrentBanner() {
    scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
  }

  /// Clear all notifications
  static void clearAll() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.clearMaterialBanners();
  }
}

/// Extension methods for easier usage
extension NotificationExtensions on BuildContext {
  void showErrorNotification(String message, {Duration? duration}) {
    NotificationWidgets.showError(message, duration: duration);
  }

  void showSuccessNotification(String message, {Duration? duration}) {
    NotificationWidgets.showSuccess(message, duration: duration);
  }

  void showInfoNotification(String message, {Duration? duration}) {
    NotificationWidgets.showInfo(message, duration: duration);
  }

  void showWarningNotification(String message, {Duration? duration}) {
    NotificationWidgets.showWarning(message, duration: duration);
  }
}
