import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../services/language_controller.dart';
import '../services/theme_controller.dart';
import 'premium_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111827);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF59E0B);
  static const Color pink = Color(0xFFEC4899);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  late bool notifications;
  late bool dailyReminder;
  late bool soundEffects;
  late bool vibration;

  String selectedLanguage = 'English';
  String t({required String en, required String it, required String ar}) {
    return LanguageController.text(english: en, italian: it, arabic: ar);
  }

  @override
  void initState() {
    super.initState();

    notifications = HiveService.notifications;
    dailyReminder = HiveService.dailyReminder;
    soundEffects = HiveService.soundEffects;
    vibration = HiveService.vibration;
    selectedLanguage = LanguageController.current;
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => notifications = value);
    await HiveService.setNotifications(value);
  }

  Future<void> _setDailyReminder(bool value) async {
    setState(() => dailyReminder = value);
    await HiveService.setDailyReminder(value);
  }

  Future<void> _setSoundEffects(bool value) async {
    setState(() => soundEffects = value);
    await HiveService.setSoundEffects(value);
  }

  Future<void> _setVibration(bool value) async {
    setState(() => vibration = value);
    await HiveService.setVibration(value);
  }

  Future<void> _setLanguage(String language) async {
    await LanguageController.setLanguage(language);

    if (!mounted) return;

    setState(() {
      selectedLanguage = language;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Language changed to $language'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Sign out?',
            style: TextStyle(color: white, fontWeight: FontWeight.w900),
          ),
          content: const Text(
            'Are you sure you want to sign out of your Arab.it account?',
            style: TextStyle(color: muted, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: muted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Sign out',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true) return;

    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _appearance()),
            SliverToBoxAdapter(child: _premiumSection()),
            SliverToBoxAdapter(child: _language()),
            SliverToBoxAdapter(child: _notifications()),
            SliverToBoxAdapter(child: _learning()),
            SliverToBoxAdapter(child: _about()),
            const SliverToBoxAdapter(child: SizedBox(height: 35)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: white),
            ),
          ),
          const Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _appearance() {
    return _section(
      title: t(en: 'Appearance', it: 'Aspetto', ar: 'المظهر'),
      icon: Icons.palette_rounded,
      color: purple,
      children: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.mode,
          builder: (context, mode, _) {
            final dark = mode == ThemeMode.dark;

            return _settingTile(
              icon: dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              title: dark ? 'Dark Mode' : 'Light Mode',
              subtitle: dark
                  ? 'Dark appearance is enabled'
                  : 'Light appearance is enabled',
              color: dark ? purple : orange,
              trailing: Switch(
                value: dark,
                activeThumbColor: purple,
                onChanged: (value) {
                  ThemeController.setMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _premiumSection() {
    final isPremium = HiveService.isPremium;
    final plan = HiveService.premiumPlan;
    final yearly = plan == 'yearly';

    return _section(
      title: t(en: 'Premium', it: 'Premium', ar: 'Premium'),
      icon: Icons.workspace_premium_rounded,
      color: isPremium ? orange : purple,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPremium
                  ? [const Color(0xFF14532D), const Color(0xFF166534)]
                  : [const Color(0xFF312E81), const Color(0xFF4C1D95)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPremium
                  ? green.withValues(alpha: 0.35)
                  : purple.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isPremium
                      ? Icons.check_circle_rounded
                      : Icons.workspace_premium_rounded,
                  color: isPremium ? green : Colors.amber,
                  size: 26,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium ? 'Premium Active' : 'Upgrade to Premium',
                      style: const TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isPremium
                          ? yearly
                                ? 'Yearly plan • All features unlocked'
                                : 'Monthly plan • All features unlocked'
                          : 'Unlock all lessons, quizzes and pronunciation',
                      style: TextStyle(
                        color: white.withValues(alpha: 0.72),
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: white.withValues(alpha: 0.65),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.settings_suggest_rounded,
            color: isPremium ? green : purple,
          ),
          title: Text(
            isPremium ? 'Manage Premium' : 'View Premium Plans',
            style: const TextStyle(color: white, fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            isPremium
                ? yearly
                      ? 'Yearly • €39.99 / year'
                      : 'Monthly • €4.99 / month'
                : 'Choose Monthly or Yearly',
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: muted,
            size: 16,
          ),
          onTap: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const PremiumPage()));

            if (!mounted) return;

            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _language() {
    return _section(
      title: t(en: 'App Language', it: "Lingua dell'app", ar: 'لغة التطبيق'),
      icon: Icons.translate_rounded,
      color: cyan,
      children: [
        _languageTile('English', 'English', 'EN', cyan),
        const SizedBox(height: 8),
        _languageTile('Italiano', 'Italiano', 'IT', green),
        const SizedBox(height: 8),
        _languageTile('العربية', 'العربية', 'AR', purple),
      ],
    );
  }

  Widget _languageTile(
    String language,
    String subtitle,
    String flag,
    Color color,
  ) {
    final selected = selectedLanguage == language;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _setLanguage(language),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.10) : bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.35)
                : white.withValues(alpha: 0.04),
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 25)),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: const TextStyle(
                      color: white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: muted, fontSize: 9),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? color : muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notifications() {
    return _section(
      title: t(en: 'Notifications', it: 'Notifiche', ar: 'الإشعارات'),
      icon: Icons.notifications_rounded,
      color: orange,
      children: [
        _settingTile(
          icon: Icons.notifications_active_rounded,
          title: t(
            en: 'Push Notifications',
            it: 'Notifiche push',
            ar: 'إشعارات الدفع',
          ),
          subtitle: t(
            en: 'Receive learning updates and achievements',
            it: 'Ricevi aggiornamenti e risultati di apprendimento',
            ar: 'تلقي تحديثات التعلم والإنجازات',
          ),
          color: orange,
          trailing: Switch(
            value: notifications,
            activeThumbColor: orange,
            onChanged: _setNotifications,
          ),
        ),
        const SizedBox(height: 8),
        _settingTile(
          icon: Icons.alarm_rounded,
          title: t(
            en: 'Daily Reminder',
            it: 'Promemoria giornaliero',
            ar: 'التذكير اليومي',
          ),
          subtitle: t(
            en: 'Get reminded to practice every day',
            it: 'Ricevi un promemoria per esercitarti ogni giorno',
            ar: 'احصل على تذكير للتدرب كل يوم',
          ),
          color: pink,
          trailing: Switch(
            value: dailyReminder,
            activeThumbColor: pink,
            onChanged: _setDailyReminder,
          ),
        ),
      ],
    );
  }

  Widget _learning() {
    return _section(
      title: t(en: 'Learning', it: 'Apprendimento', ar: 'التعلم'),
      icon: Icons.school_rounded,
      color: green,
      children: [
        _settingTile(
          icon: Icons.volume_up_rounded,
          title: t(
            en: 'Sound Effects',
            it: 'Effetti sonori',
            ar: 'المؤثرات الصوتية',
          ),
          subtitle: t(
            en: 'Play sounds during exercises',
            it: 'Riproduci suoni durante gli esercizi',
            ar: 'تشغيل الأصوات أثناء التمارين',
          ),
          color: cyan,
          trailing: Switch(
            value: soundEffects,
            activeThumbColor: cyan,
            onChanged: _setSoundEffects,
          ),
        ),
        const SizedBox(height: 8),
        _settingTile(
          icon: Icons.vibration_rounded,
          title: t(en: 'Vibration', it: 'Vibrazione', ar: 'الاهتزاز'),
          subtitle: t(
            en: 'Haptic feedback during practice',
            it: 'Feedback aptico durante la pratica',
            ar: 'اهتزاز لمسي أثناء التدريب',
          ),
          color: purple,
          trailing: Switch(
            value: vibration,
            activeThumbColor: purple,
            onChanged: _setVibration,
          ),
        ),
      ],
    );
  }

  Widget _about() {
    return _section(
      title: t(en: 'About', it: 'Informazioni', ar: 'حول التطبيق'),
      icon: Icons.info_rounded,
      color: cyan,
      children: [
        _actionTile(
          Icons.star_rounded,
          'Rate Arab.it',
          'Tell us what you think',
          orange,
        ),
        const SizedBox(height: 8),
        _actionTile(
          Icons.privacy_tip_rounded,
          'Privacy Policy',
          'Your privacy matters',
          green,
        ),
        const SizedBox(height: 8),
        _actionTile(
          Icons.description_rounded,
          'Terms of Service',
          'Read our terms',
          purple,
        ),
        const SizedBox(height: 8),
        _actionTile(
          Icons.logout_rounded,
          'Sign out',
          'Sign out from your Arab.it account',
          Colors.redAccent,
          onTap: _confirmSignOut,
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'Arab.it',
            style: TextStyle(
              color: white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text(
            'Learn languages. Connect worlds.',
            style: TextStyle(color: muted, fontSize: 9),
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            'Version 1.0.0',
            style: TextStyle(color: muted, fontSize: 9),
          ),
        ),
      ],
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: color, size: 19),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 8.5),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _actionTile(
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: muted, fontSize: 8.5),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: muted, size: 20),
          ],
        ),
      ),
    );
  }
}
