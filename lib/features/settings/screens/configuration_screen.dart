import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  ConsumerState<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {
  bool _reminderEnabled = true;
  int _reminderHour = 20;
  int _reminderMinute = 0;

  @override
  void initState() {
    super.initState();
    _loadReminderPreferences();
  }

  Future<void> _loadReminderPreferences() async {
    final enabled = await NotificationService.instance.isReminderEnabled();
    final hour = await NotificationService.instance.getReminderHour();
    final minute = await NotificationService.instance.getReminderMinute();

    if (mounted) {
      setState(() {
        _reminderEnabled = enabled;
        _reminderHour = hour;
        _reminderMinute = minute;
      });
    }
  }

  Future<void> _toggleReminder(bool value) async {
    await NotificationService.instance.setReminderEnabled(value);
    setState(() => _reminderEnabled = value);
  }

  Future<void> _pickReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.expense,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimaryDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await NotificationService.instance.setReminderTime(picked.hour, picked.minute);
      setState(() {
        _reminderHour = picked.hour;
        _reminderMinute = picked.minute;
      });
    }
  }

  String _formatTime(int hour, int minute) {
    final tod = TimeOfDay(hour: hour, minute: minute);
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('Configuration')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Currency Symbol',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: ListTile(
              leading: const Text(
                '₹',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              title: const Text(
                'Indian Rupee (INR)',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Wallet Manager is strictly tailored for Indian Rupees (₹)',
                style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
              ),
              trailing: const Icon(Icons.check_circle_rounded, color: AppColors.expense),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Daily Evening Reminder',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: const Text(
                    'Daily Transaction Reminder',
                    style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Reminds you every evening: "आज का record किया क्या? 💰"',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11.5),
                  ),
                  value: _reminderEnabled,
                  activeColor: AppColors.expense,
                  onChanged: _toggleReminder,
                ),
                if (_reminderEnabled) ...[
                  const Divider(color: AppColors.darkDivider, height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: const Icon(Icons.access_time_rounded, color: AppColors.expense, size: 22),
                    title: const Text(
                      'Reminder Time',
                      style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 13.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_reminderHour, _reminderMinute),
                          style: const TextStyle(
                            color: AppColors.expense,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondaryDark),
                      ],
                    ),
                    onTap: _pickReminderTime,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.textSecondaryDark, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'All transactions, accounts, balance sheets, and statistics operate in ₹ INR.',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
