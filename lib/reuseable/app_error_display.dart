import 'dart:developer';

import 'package:flutter/material.dart';

import 'error_modal.dart';

/// Central dispatch point for all error display.
///
/// - Connectivity/network errors (no internet, timeout, SSL) → floating snackbar
/// - Everything else (server, business, validation from BLoC)  → bottom sheet modal
///
/// Call this from every BlocListener failure case instead of calling
/// [showErrorBottomSheet] directly, so display logic can be changed in one place.
class AppErrorDisplay {
  static void show(BuildContext context, String error) {
    log('[AppErrorDisplay] show: $error');
    if (_isConnectivityError(error)) {
      _showSnackBar(context, error, icon: Icons.wifi_off_rounded);
    } else {
      // Delay slightly longer than a modal dismiss animation (~300 ms) so that
      // any in-flight route transition (e.g., the payment bottom sheet closing)
      // has fully completed before we try to push a new modal route.
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!context.mounted) return;
        try {
          showErrorBottomSheet(context, error);
        } catch (e) {
          log('[AppErrorDisplay] showErrorBottomSheet failed ($e), falling back to snackbar');
          if (context.mounted) {
            _showSnackBar(context, error, icon: Icons.error_outline_rounded);
          }
        }
      });
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static bool _isConnectivityError(String error) {
    final lower = error.toLowerCase();
    return lower.contains('no internet') ||
        lower.contains('internet connection') ||
        lower.contains('timed out') ||
        lower.contains('time out') ||
        lower.contains('secure connection failed') ||
        lower.contains('connection failed');
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFB71C1C),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 4),
        ),
      );
  }
}
