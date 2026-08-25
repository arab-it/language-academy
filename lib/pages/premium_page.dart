import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../services/language_controller.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  static const Color background = Color(0xFF070A12);
  static const Color surface = Color(0xFF111725);
  static const Color surface2 = Color(0xFF151D2D);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFA78BFA);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color gold = Color(0xFFF59E0B);
  static const Color textSecondary = Color(0xFF94A3B8);

  String _selectedPlan = 'monthly';
  bool _activating = false;

  @override
  void initState() {
    super.initState();
    _selectedPlan = HiveService.premiumPlan;
  }

  String _t(
    String english,
    String italian,
    String arabic,
  ) {
    return LanguageController.text(
      english: english,
      italian: italian,
      arabic: arabic,
    );
  }

  bool get _isPremium => HiveService.isPremium;

  String get _currentPlan =>
      HiveService.premiumPlan == 'yearly' ? 'yearly' : 'monthly';

  Future<void> _activatePremium() async {
    if (_activating) return;

    setState(() {
      _activating = true;
    });

    await HiveService.setPremiumPlan(_selectedPlan);
    await HiveService.setPremium(true);

    if (!mounted) return;

    setState(() {
      _activating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF14532D),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: green,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _t(
                  'Premium activated successfully.',
                  'Premium attivato con successo.',
                  'تم تفعيل Premium بنجاح.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePlan(String plan) async {
    if (_isPremium) {
      await HiveService.setPremiumPlan(plan);

      if (!mounted) return;

      setState(() {
        _selectedPlan = plan;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            _t(
              'Premium plan updated.',
              'Piano Premium aggiornato.',
              'تم تحديث خطة Premium.',
            ),
          ),
        ),
      );

      return;
    }

    setState(() {
      _selectedPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _t(
            'Premium',
            'Premium',
            'بريميوم',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _hero(),

              const SizedBox(height: 26),

              _sectionTitle(
                _t(
                  'Everything you need',
                  'Tutto ciò di cui hai bisogno',
                  'كل ما تحتاجه',
                ),
              ),

              const SizedBox(height: 14),

              _features(),

              const SizedBox(height: 28),

              _sectionTitle(
                _t(
                  'Choose your plan',
                  'Scegli il tuo piano',
                  'اختر خطتك',
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _t(
                  'Choose the plan that works best for you.',
                  'Scegli il piano più adatto a te.',
                  'اختر الخطة المناسبة لك.',
                ),
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              _planCard(
                plan: 'monthly',
                title: _t(
                  'Monthly',
                  'Mensile',
                  'شهري',
                ),
                price: '€4.99',
                period: _t(
                  '/ month',
                  '/ mese',
                  '/ شهر',
                ),
                icon: Icons.calendar_month_rounded,
              ),

              const SizedBox(height: 14),

              _planCard(
                plan: 'yearly',
                title: _t(
                  'Yearly',
                  'Annuale',
                  'سنوي',
                ),
                price: '€39.99',
                period: _t(
                  '/ year',
                  '/ anno',
                  '/ سنة',
                ),
                icon: Icons.calendar_today_rounded,
                popular: true,
              ),

              const SizedBox(height: 22),

              _membershipStatus(),

              const SizedBox(height: 18),

              _actionButton(),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  _t(
                    'Secure your learning journey with Premium.',
                    'Rendi il tuo percorso di apprendimento ancora migliore con Premium.',
                    'طوّر رحلة تعلمك مع Premium.',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C1D95),
            Color(0xFF7C3AED),
            Color(0xFF172554),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 35,
            bottom: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: cyan.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFFDE68A),
                  size: 31,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                _isPremium
                    ? _t(
                        'Premium Active',
                        'Premium Attivo',
                        'Premium نشط',
                      )
                    : _t(
                        'Upgrade your learning',
                        'Migliora il tuo apprendimento',
                        'طوّر تجربة التعلم',
                      ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 11),

              Text(
                _isPremium
                    ? _t(
                        'You have access to all Premium features.',
                        'Hai accesso a tutte le funzioni Premium.',
                        'لديك الآن وصول إلى جميع ميزات Premium.',
                      )
                    : _t(
                        'Learn faster. Practice more. Unlock everything.',
                        'Impara più velocemente. Fai più pratica. Sblocca tutto.',
                        'تعلم بشكل أسرع. تدرب أكثر. افتح كل الميزات.',
                      ),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 14,
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  _heroBadge(
                    Icons.bolt_rounded,
                    _t(
                      'Unlimited',
                      'Illimitato',
                      'غير محدود',
                    ),
                  ),
                  const SizedBox(width: 8),
                  _heroBadge(
                    Icons.lock_open_rounded,
                    _t(
                      'Full access',
                      'Accesso completo',
                      'وصول كامل',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _features() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.055),
        ),
      ),
      child: Column(
        children: [
          _feature(
            Icons.block_rounded,
            _t(
              'No ads',
              'Niente pubblicità',
              'بدون إعلانات',
            ),
          ),
          _feature(
            Icons.menu_book_rounded,
            _t(
              'All lessons',
              'Tutte le lezioni',
              'جميع الدروس',
            ),
          ),
          _feature(
            Icons.record_voice_over_rounded,
            _t(
              'Advanced pronunciation',
              'Pronuncia avanzata',
              'نطق متقدم',
            ),
          ),
          _feature(
            Icons.quiz_rounded,
            _t(
              'Unlimited quizzes',
              'Quiz illimitati',
              'اختبارات غير محدودة',
            ),
          ),
          _feature(
            Icons.menu_book_rounded,
            _t(
              'Unlimited reading practice',
              'Lettura illimitata',
              'تدريب قراءة غير محدود',
            ),
          ),
          _feature(
            Icons.insights_rounded,
            _t(
              'Advanced progress',
              'Progressi avanzati',
              'تقدم متقدم',
            ),
          ),
          _feature(
            Icons.workspace_premium_rounded,
            _t(
              'Premium achievements',
              'Obiettivi Premium',
              'إنجازات Premium',
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: purple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: purpleLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: green,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _planCard({
    required String plan,
    required String title,
    required String price,
    required String period,
    required IconData icon,
    bool popular = false,
  }) {
    final selected = _selectedPlan == plan;

    return GestureDetector(
      onTap: () => _changePlan(plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? purple.withValues(alpha: 0.13)
              : surface,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
            color: selected
                ? purpleLight
                : Colors.white.withValues(alpha: 0.07),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: purple.withValues(alpha: 0.16),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? purple.withValues(alpha: 0.22)
                    : surface2,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: selected
                    ? purpleLight
                    : textSecondary,
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (popular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            _t(
                              'BEST VALUE',
                              'MIGLIOR VALORE',
                              'أفضل قيمة',
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan == 'yearly'
                        ? _t(
                            'Save compared with monthly',
                            'Risparmia rispetto al mensile',
                            'وفر مقارنة بالشهري',
                          )
                        : _t(
                            'Flexible monthly access',
                            'Accesso mensile flessibile',
                            'وصول شهري مرن',
                          ),
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? purple
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? purple
                      : textSecondary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _membershipStatus() {
    final plan = _isPremium ? _currentPlan : _selectedPlan;

    final isYearly = plan == 'yearly';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isPremium
            ? const Color(0xFF0B2E1A)
            : surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isPremium
              ? green.withValues(alpha: 0.32)
              : Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: _isPremium
                  ? green.withValues(alpha: 0.13)
                  : gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPremium
                  ? Icons.verified_rounded
                  : Icons.workspace_premium_rounded,
              color: _isPremium ? green : gold,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPremium
                      ? _t(
                          'Premium Active',
                          'Premium Attivo',
                          'Premium نشط',
                        )
                      : _t(
                          'Selected plan',
                          'Piano selezionato',
                          'الخطة المختارة',
                        ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isYearly
                      ? _t(
                          'Yearly • €39.99 / year',
                          'Annuale • €39.99 / anno',
                          'سنوي • €39.99 / سنة',
                        )
                      : _t(
                          'Monthly • €4.99 / month',
                          'Mensile • €4.99 / mese',
                          'شهري • €4.99 / شهر',
                        ),
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          if (_isPremium)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _t(
                  'ACTIVE',
                  'ATTIVO',
                  'نشط',
                ),
                style: const TextStyle(
                  color: green,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton() {
    if (_isPremium) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () async {
            await HiveService.setPremiumPlan(_selectedPlan);

            if (!mounted) return;

            setState(() {});

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  _t(
                    'Premium plan updated successfully.',
                    'Piano Premium aggiornato con successo.',
                    'تم تحديث خطة Premium بنجاح.',
                  ),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.check_circle_rounded,
          ),
          label: Text(
            _t(
              'Premium Active',
              'Premium Attivo',
              'Premium نشط',
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF14532D),
            foregroundColor: green,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _activating ? null : _activatePremium,
        style: ElevatedButton.styleFrom(
          backgroundColor: purple,
          disabledBackgroundColor: purple.withValues(alpha: 0.55),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _activating
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 21,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    _selectedPlan == 'yearly'
                        ? _t(
                            'Upgrade to Yearly Premium',
                            'Passa a Premium Annuale',
                            'الترقية إلى Premium السنوي',
                          )
                        : _t(
                            'Upgrade to Monthly Premium',
                            'Passa a Premium Mensile',
                            'الترقية إلى Premium الشهري',
                          ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}




