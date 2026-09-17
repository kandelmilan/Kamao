import 'package:flutter/material.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/help_support/presentation/utils/support_ticket_status_filter.dart';

class SupportStatusChip extends StatelessWidget {
  const SupportStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        SupportTicketStatusFilter.label(status),
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.$2,
        ),
      ),
    );
  }

  static (Color, Color) _statusColors(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return (const Color(0xFFE8F0E5), const Color(0xFF426340));
      case 'closed':
        return (const Color(0xFF353037), Colors.white);
      case 'inprogress':
        return (const Color(0xFFFFF4E5), const Color(0xFFB45309));
      case 'waitingcustomer':
        return (const Color(0xFFE8EEF8), const Color(0xFF3B5BDB));
      case 'open':
        return (const Color(0xFFE7F6ED), const Color(0xFF2F6B4F));
      default:
        return (const Color(0xFFF2F5F9), const Color(0xFF6F6875));
    }
  }
}

InputDecoration supportInputDecoration({
  required String hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint.isEmpty ? null : hint,
    hintStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF9A949E),
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: const Color(0xFFF7FAF6),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE4EBE1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE4EBE1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: AppColors.onboardingGreen,
        width: 1.5,
      ),
    ),
  );
}
