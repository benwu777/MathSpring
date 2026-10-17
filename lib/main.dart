import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mathspring/competition_profiles.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart'
    as bundled;
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/models/favorite_question.dart';
import 'package:mathspring/models/geometry_scene.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_bank.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learning_activity_summary.dart';
import 'package:mathspring/services/daily_mission.dart';
import 'package:mathspring/services/formal_exam_preset.dart';
import 'package:mathspring/services/formal_exam_scoring.dart';
import 'package:mathspring/services/math_text_formatter.dart';
import 'package:mathspring/services/monetization_service.dart';
import 'package:mathspring/services/session_launch_plan_builder.dart';
import 'package:mathspring/services/storekit_monetization_service.dart';
import 'package:mathspring/ui/content_scroll_view.dart';
import 'package:mathspring/ui/layout_spec.dart';
import 'package:mathspring/widgets/avatar_editor.dart';
import 'package:mathspring/widgets/avatar_preview.dart';

part 'src/home_tabs.dart';
part 'src/review_tab.dart';
part 'src/settings_tab.dart';
part 'src/home_widgets.dart';
part 'src/learner_profiles.dart';
part 'src/library_pages.dart';
part 'src/practice_session.dart';
part 'src/quiz_session.dart';
part 'src/question_text.dart';
part 'src/app_strings.dart';
part 'src/question_figures.dart';
part 'src/session_helpers.dart';
part 'src/diagram_painters.dart';

const String appSupportUrl = 'https://benwu777.github.io/MathSpring/support/';
const String appPrivacyPolicyUrl =
    'https://benwu777.github.io/MathSpring/privacy/';

/// 全站共用的視覺 token。頁面不應自行發明相近但不同的藍、灰或陰影。
abstract final class AppVisualTokens {
  static const Color canvas = Color(0xFFF8F8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F3F1);
  static const Color ink = Color(0xFF17201D);
  static const Color inkMuted = Color(0xFF5E6E69);
  static const Color outline = Color(0xFFD9DEE8);
  static const Color brand = Color(0xFF273B78);
  static const Color brandSoft = Color(0xFFE7EBF8);
  static const Color progress = Color(0xFF168A82);
  static const Color progressSoft = Color(0xFFDDF3F0);
  static const Color primary = brand;
  static const Color primarySoft = brandSoft;
  static const Color danger = Color(0xFFB54747);
}

void main() {
  runApp(const MathSpringApp());
}

class MathSpringApp extends StatefulWidget {
  const MathSpringApp({super.key, this.services, this.monetizationService});

  final AppServices? services;
  final MonetizationService? monetizationService;

  @override
  State<MathSpringApp> createState() => _MathSpringAppState();
}

class _MathSpringAppState extends State<MathSpringApp> {
  Locale? _localeOverride;
  late final Future<AppServices> _servicesFuture;
  late final MonetizationService _monetization;

  @override
  void initState() {
    super.initState();
    _servicesFuture = widget.services == null
        ? AppServices.openDefault()
        : Future<AppServices>.value(widget.services!);
    _monetization = widget.monetizationService ??
        StoreKitMonetizationService(
          gateway: InAppPurchaseStorefrontGateway(),
        );
    unawaited(_monetization.initialize());
  }

  @override
  void dispose() {
    _monetization.dispose();
    super.dispose();
  }

  void _updateLocale(Locale locale) {
    setState(() {
      _localeOverride = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color seedColor = AppVisualTokens.primary;
    final Locale resolvedLocale = _localeOverride ??
        AppStrings.resolveLocale(
          WidgetsBinding.instance.platformDispatcher.locale,
          AppStrings.supportedLocales,
        );

    return MaterialApp(
      title: 'MathSpring',
      debugShowCheckedModeBanner: false,
      locale: resolvedLocale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // 字級依畫面寬度分級，iPad 不是放大的 iPhone。
      // 放在 builder 而不是 theme，是因為這裡才拿得到帶 MediaQuery 的 context；
      // 已經在用 Theme.of(context).textTheme 的畫面因此自動跟著縮放。
      builder: (BuildContext context, Widget? child) {
        final ThemeData base = Theme.of(context);
        return MonetizationScope(
          service: _monetization,
          child: Theme(
            data: base.copyWith(
              textTheme: LayoutSpec.of(context).textThemeFrom(base.textTheme),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
          surface: AppVisualTokens.surface,
        ).copyWith(
          primary: AppVisualTokens.primary,
          onPrimary: Colors.white,
          primaryContainer: AppVisualTokens.primarySoft,
          onPrimaryContainer: const Color(0xFF273B78),
          surface: AppVisualTokens.surface,
          surfaceContainerHighest: AppVisualTokens.surfaceMuted,
          onSurface: AppVisualTokens.ink,
          onSurfaceVariant: AppVisualTokens.inkMuted,
          outline: AppVisualTokens.outline,
          error: AppVisualTokens.danger,
        ),
        scaffoldBackgroundColor: AppVisualTokens.canvas,
        dividerColor: AppVisualTokens.outline,
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.0,
            color: AppVisualTokens.ink,
          ),
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppVisualTokens.ink,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppVisualTokens.ink,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppVisualTokens.ink,
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF34423E),
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppVisualTokens.inkMuted,
          ),
          bodySmall: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: Color(0xFF73817C),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppVisualTokens.canvas,
          foregroundColor: AppVisualTokens.ink,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppVisualTokens.ink,
            letterSpacing: -0.3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppVisualTokens.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppVisualTokens.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppVisualTokens.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppVisualTokens.primary, width: 1.2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 44),
            foregroundColor: AppVisualTokens.primary,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppVisualTokens.surface,
          indicatorColor: AppVisualTokens.brandSoft,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelTextStyle: WidgetStatePropertyAll<TextStyle>(
            TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppVisualTokens.inkMuted,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: AppVisualTokens.surface,
          shadowColor: const Color(0x1217201D),
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppVisualTokens.outline),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppVisualTokens.inkMuted,
            minimumSize: const Size.square(48),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppVisualTokens.surfaceMuted,
          selectedColor: AppVisualTokens.progressSoft,
          side: const BorderSide(color: AppVisualTokens.outline),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          labelStyle: const TextStyle(
            color: AppVisualTokens.inkMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: ValueListenableBuilder<MonetizationState>(
        valueListenable: _monetization,
        builder: (BuildContext context, MonetizationState monetization, _) =>
            widget.services != null
                ? MathSpringHomePage(
                    onLocaleChanged: _updateLocale,
                    services: widget.services!,
                    monetization: _monetization,
                  )
                : FutureBuilder<AppServices>(
                    future: _servicesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return MathSpringHomePage(
                        onLocaleChanged: _updateLocale,
                        services: snapshot.data!,
                        monetization: _monetization,
                      );
                    },
                  ),
      ),
    );
  }
}

class MonetizationScope extends InheritedNotifier<MonetizationService> {
  static final MonetizationService _fallback = NoopMonetizationService();

  const MonetizationScope({
    super.key,
    required MonetizationService service,
    required super.child,
  }) : super(notifier: service);

  static MonetizationService of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<MonetizationScope>()
          ?.notifier ??
      _fallback;
}
