$file = ".\lib\pages\home.dart"

if (!(Test-Path $file)) {
    Write-Host "home.dart NOT FOUND!" -ForegroundColor Red
    exit 1
}

Copy-Item $file ".\lib\pages\home.dart.before_premium4_quick_practice" -Force

$content = Get-Content $file -Raw

$gridMarker = "  Widget _practiceGrid(BuildContext context) {"
$gridStart = $content.IndexOf($gridMarker)

if ($gridStart -lt 0) {
    Write-Host "PRACTICE GRID NOT FOUND!" -ForegroundColor Red
    exit 1
}

$levelMarker = "  Widget _levelCard() {"
$levelStart = $content.IndexOf($levelMarker, $gridStart)

if ($levelStart -lt 0) {
    Write-Host "LEVEL CARD NOT FOUND!" -ForegroundColor Red
    exit 1
}

$newPractice = @'
  Widget _practiceGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 650;

        final cards = [
          _practiceCard(
            context,
            icon: Icons.record_voice_over_rounded,
            title: _t(
              'Pronunciation',
              'Pronuncia',
              'النطق',
            ),
            subtitle: _t(
              'Improve your pronunciation',
              'Migliora la tua pronuncia',
              'حسّن نطقك',
            ),
            meta: _t(
              'Speak with confidence',
              'Parla con sicurezza',
              'تحدث بثقة',
            ),
            colors: const [
              Color(0xFF7C2D12),
              Color(0xFFEA580C),
            ],
            accent: Color(0xFFFDBA74),
            page: const PronunciationPage(),
          ),
          _practiceCard(
            context,
            icon: Icons.headphones_rounded,
            title: _t(
              'Listening',
              'Ascolto',
              'الاستماع',
            ),
            subtitle: _t(
              'Train your listening skills',
              'Allena il tuo ascolto',
              'درّب مهارات الاستماع',
            ),
            meta: _t(
              'Sharpen your ear',
              'Affina il tuo orecchio',
              'طوّر قدرتën të dëgjosh',
            ),
            colors: const [
              Color(0xFF164E63),
              Color(0xFF0891B2),
            ],
            accent: Color(0xFF67E8F9),
            page: const ReadingPage(),
          ),
          _practiceCard(
            context,
            icon: Icons.quiz_rounded,
            title: _t(
              'Quiz',
              'Quiz',
              'اختبار',
            ),
            subtitle: _t(
              'Test your knowledge',
              'Metti alla prova le tue conoscenze',
              'اختبر معرفتك',
            ),
            meta: _t(
              'Challenge yourself',
              'Mettiti alla prova',
              'تحدَّ نفسك',
            ),
            colors: const [
              Color(0xFF4C1D95),
              Color(0xFF7C3AED),
            ],
            accent: Color(0xFFC4B5FD),
            page: const QuizPage(),
          ),
        ];

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 14),
              Expanded(child: cards[1]),
              const SizedBox(width: 14),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 14),
            cards[1],
            const SizedBox(height: 14),
            cards[2],
          ],
        );
      },
    );
  }

  Widget _practiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String meta,
    required List<Color> colors,
    required Color accent,
    required Widget page,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          ).then((_) => _loadProgress());
        },
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors[0],
                colors[1],
                colors[1].withValues(alpha: 0.82),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.09),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.20),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 11,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.55),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.58),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

'@

$content = $content.Substring(0, $gridStart) +
    $newPractice +
    $content.Substring($levelStart)

Set-Content $file $content -Encoding UTF8

Write-Host ""
Write-Host "PREMIUM 4 INSTALLED" -ForegroundColor Green
Write-Host ""

Get-Content $file |
    Select-String "Widget _continueLearning|Widget _practiceGrid|Widget _practiceCard|Widget _levelCard|Widget _progressCard" |
    Select-Object LineNumber, Line

Write-Host ""
Write-Host "===== FLUTTER ANALYZE =====" -ForegroundColor Cyan

flutter analyze lib/pages/home.dart