// lib/presentation/sections/introduction_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../core/theme/app_theme.dart';
import 'dart:html' as html; // Import for web-specific download

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key});

  final String resumeAssetPath = "assets/resume/PranayShah_Resume.pdf"; // Path to your resume in assets

  Future<void> _triggerAssetDownload(BuildContext context, String assetPath) async {
    final String downloadUrl = assetPath; // Path relative to web root after build
    try {
      final anchor = html.AnchorElement(href: downloadUrl)
        ..setAttribute("download", assetPath.split('/').last)
        ..click();
      html.document.body?.children.remove(anchor);
    } catch (e) {
      debugPrint('Error triggering download: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not initiate download.")),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;

    const Duration contentBlockEntranceDuration = Duration(milliseconds: 1200);
    const Duration nameDelay = Duration(milliseconds: 200);
    const Duration roleTypewriterDelay = Duration(milliseconds: 500);
    const Duration socialButtonEntranceDelayBase = Duration(milliseconds: 800);
    const Duration socialButtonEntranceDuration = Duration(milliseconds: 700);
    const Duration socialButtonStagger = Duration(milliseconds: 150);
    const Duration continuousBounceStartDelayBase = Duration(milliseconds: 1000);
    final Duration resumeButtonDelay = socialButtonEntranceDelayBase + Duration(milliseconds: socialButtonStagger.inMilliseconds * 4) + socialButtonEntranceDuration;

    return Container(
      height: screenSize.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppTheme.backgroundColor,
            AppTheme.backgroundColor.withOpacity(0.92),
            AppTheme.surfaceColor.withOpacity(0.85),
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedDecorativeShapes(
              
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(
                left: screenSize.width * 0.07,
                bottom: screenSize.height * 0.10,
                right: screenSize.width * 0.07,
              ),
              constraints: BoxConstraints(maxWidth: screenSize.width * (screenSize.width > 1000 ? 0.45 : 0.55)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Pranay Shah',
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: screenSize.width > 1200 ? 72 : (screenSize.width > 700 ? 58: 48),
                      color: AppTheme.onBackgroundColor,
                       shadows: [
                        Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.15), offset: Offset(1.5,1.5))
                      ]
                    ),
                  ).animate(delay: nameDelay)
                   .fadeIn(duration: 800.ms, curve: Curves.easeOutQuart)
                   .slideX(begin: 0.25, end:0, curve: Curves.easeOutQuart),
                  const SizedBox(height: 15),
                  Container(
                    constraints: BoxConstraints(minHeight: screenSize.width > 700 ? 50 : 70),
                    child: DefaultTextStyle(
                      style: textTheme.headlineMedium!.copyWith(
                        fontSize: screenSize.width > 1200 ? 30 : (screenSize.width > 700 ? 26 : 22),
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      child: AnimatedTextKit(
                        key: UniqueKey(),
                        animatedTexts: [
                          TypewriterAnimatedText('AI Developer', speed: const Duration(milliseconds: 150), cursor: '❚'),
                          TypewriterAnimatedText('ML Engineer', speed: const Duration(milliseconds: 120), cursor: '❚'),
                          TypewriterAnimatedText('Flutter Developer', speed: const Duration(milliseconds: 150), cursor: '❚'),
                        ],
                        pause: const Duration(milliseconds: 2000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                        repeatForever: true,
                      ),
                    ),
                  ).animate(delay: roleTypewriterDelay)
                   .fadeIn(duration: 700.ms)
                   .slideX(begin: 0.35, end:0, curve: Curves.easeOutQuart),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _SocialButton(
                        key: const ValueKey('intro_github_btn_asset_dl_final'),
                        icon: FontAwesomeIcons.github,
                        url: 'https://github.com/Pranay1021',
                        tooltip: 'GitHub',
                        continuousAnimationStartDelay: socialButtonEntranceDelayBase + (socialButtonStagger * 0) + socialButtonEntranceDuration + continuousBounceStartDelayBase,
                      ).animate(delay: socialButtonEntranceDelayBase + (socialButtonStagger * 0)).fadeIn(duration: socialButtonEntranceDuration).slideY(begin: 0.7, curve: Curves.easeOutBack),
                      const SizedBox(width: 22),
                      _SocialButton(
                        key: const ValueKey('intro_linkedin_btn_asset_dl_final'),
                        icon: FontAwesomeIcons.linkedinIn,
                        url: 'https://linkedin.com/in/pranayshah1',
                        tooltip: 'LinkedIn',
                        continuousAnimationStartDelay: socialButtonEntranceDelayBase + (socialButtonStagger * 1) + socialButtonEntranceDuration + continuousBounceStartDelayBase,
                      ).animate(delay: socialButtonEntranceDelayBase + (socialButtonStagger * 1)).fadeIn(duration: socialButtonEntranceDuration).slideY(begin: 0.7, curve: Curves.easeOutBack),
                      const SizedBox(width: 22),
                      _SocialButton(
                        key: const ValueKey('intro_email_btn_asset_dl_final'),
                        icon: FontAwesomeIcons.solidEnvelope,
                        url: 'mailto:pranayshah2021@gmail.com',
                        tooltip: 'Email',
                        continuousAnimationStartDelay: socialButtonEntranceDelayBase + (socialButtonStagger * 2) + socialButtonEntranceDuration + continuousBounceStartDelayBase,
                      ).animate(delay: socialButtonEntranceDelayBase + (socialButtonStagger * 2)).fadeIn(duration: socialButtonEntranceDuration).slideY(begin: 0.7, curve: Curves.easeOutBack),
                      const SizedBox(width: 22),
                      _SocialButton(
                        key: const ValueKey('intro_globe_btn_asset_dl_final'),
                        icon: FontAwesomeIcons.globeAsia,
                        url: 'http://pranayshah.com.np',
                        tooltip: 'Website',
                        continuousAnimationStartDelay: socialButtonEntranceDelayBase + (socialButtonStagger * 3) + socialButtonEntranceDuration + continuousBounceStartDelayBase,
                      ).animate(delay: socialButtonEntranceDelayBase + (socialButtonStagger * 3)).fadeIn(duration: socialButtonEntranceDuration).slideY(begin: 0.7, curve: Curves.easeOutBack),
                    ],
                  ),
                  const SizedBox(height: 45),
                  ElevatedButton.icon(
                    key: const ValueKey('resume_download_btn_asset_final'),
                    onPressed: () {
                      _triggerAssetDownload(context, resumeAssetPath);
                    },
                    icon: const Icon(FontAwesomeIcons.solidFilePdf, size: 18),
                    label: const Text('Download Resume'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    ),
                  )
                  .animate(delay: resumeButtonDelay)
                  .fadeIn(duration: socialButtonEntranceDuration, curve: Curves.easeOut)
                  .slideY(begin: 0.6, curve: Curves.easeOutBack)
                  .shimmer(delay: resumeButtonDelay + 500.ms, duration: 1500.ms, color: Colors.white.withOpacity(0.1)),
                ],
              ),
            ).animate()
              .slideX(begin: (screenSize.width > 700 ? 0.6 : 0.8) , end:0, duration: contentBlockEntranceDuration, curve: Curves.easeOutCubic)
              .fadeIn(duration: contentBlockEntranceDuration * 0.6, curve: Curves.easeIn),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Icon(FontAwesomeIcons.anglesDown,
                      color: AppTheme.primaryColor.withOpacity(0.45), size: 20)
                  .animate(
                    delay: contentBlockEntranceDuration + 800.ms,
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .slideY(
                      begin: 0, end: 10, duration: 2000.ms, curve: Curves.easeInOutCubic)
                  .fade(begin: 0.05, end: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String url;
  final String tooltip;
  final Duration continuousAnimationStartDelay;

  const _SocialButton({
    super.key,
    required this.icon,
    required this.url,
    required this.tooltip,
    required this.continuousAnimationStartDelay,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.06), weight: 45),
      TweenSequenceItem(tween: Tween<double>(begin: 1.06, end: 1.0), weight: 55),
    ]).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeInOutSine));
    Future.delayed(widget.continuousAnimationStartDelay, () {
      if (mounted) _waveController.repeat();
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentBgColor = _isHovered ? AppTheme.primaryColorDark : AppTheme.primaryColor;
    final Color currentIconColor = AppTheme.onPrimaryColor;
    final Matrix4 currentTransform = _isHovered
        ? (Matrix4.identity()..translate(0.0, -3.5, 0.0)..scale(1.08))
        : Matrix4.identity();

    Widget buttonVisualCore = AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: currentTransform,
        decoration: BoxDecoration(
          color: currentBgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.3),
              blurRadius: _isHovered ? 16 : 8,
              spreadRadius: _isHovered ? 3 : 1,
              offset: Offset(0, _isHovered ? 8 : 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(widget.icon, color: currentIconColor, size: 21));

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: () => _launchURL(widget.url),
          borderRadius: BorderRadius.circular(35),
          hoverColor: Colors.transparent,
          splashColor: AppTheme.primaryColorLight.withOpacity(0.3),
          highlightColor: AppTheme.primaryColorLight.withOpacity(0.2),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isHovered ? 1.0 : _scaleAnimation.value,
                alignment: Alignment.center,
                child: child);
            },
            child: buttonVisualCore))));
  }
}

class AnimatedDecorativeShapes extends StatefulWidget {
  const AnimatedDecorativeShapes({super.key});

  @override
  State<AnimatedDecorativeShapes> createState() => _AnimatedDecorativeShapesState();
}

class _AnimatedDecorativeShapesState extends State<AnimatedDecorativeShapes> with TickerProviderStateMixin {
  late List<AnimationController> _entranceControllers;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<double>> _scaleAnimations;
  late List<AnimationController> _rotationControllers;
  late List<Animation<double>> _rotationAnimations;

  // initialPos.dx and initialPos.dy will now directly map to Alignment values (-1 to 1)
  final List<Map<String, dynamic>> shapesData = [
    // --- SHAPE FOR TOP-LEFT ---
    {'size': 100.0, 'color': AppTheme.primaryColorLight, 'initialPos': const Offset(-0.9, -0.9), 'delay': 100.ms, 'shape': BoxShape.circle},
    // --- EXISTING LEFT-SIDE SHAPES (initialPos.dx will be negative) ---
    {'size': 120.0, 'color': AppTheme.primaryColor.withOpacity(0.75), 'initialPos': const Offset(-0.75, -0.5), 'delay': 300.ms, 'shape': BoxShape.rectangle}, // Top-left-ish
    {'size': 90.0, 'color': AppTheme.accentColorBrown.withOpacity(0.55), 'initialPos': const Offset(-0.85, 0.2), 'delay': 500.ms, 'shape': BoxShape.circle}, // Mid-left
    {'size': 150.0, 'color': AppTheme.primaryColorLight.withOpacity(0.65), 'initialPos': const Offset(-0.6, 0.8), 'delay': 700.ms, 'shape': BoxShape.rectangle}, // Bottom-left-ish
    // --- EXISTING RIGHT-SIDE SHAPES (initialPos.dx will be positive) ---
    {'size': 140.0, 'color': AppTheme.primaryColor, 'initialPos': const Offset(0.75, -0.8), 'delay': 250.ms, 'shape': BoxShape.circle}, // Top-right-ish
    {'size': 100.0, 'color': AppTheme.primaryColorLight, 'initialPos': const Offset(0.9, -0.1), 'delay': 450.ms, 'shape': BoxShape.rectangle}, // Mid-right
    {'size': 170.0, 'color': AppTheme.accentColorBrown.withOpacity(0.45), 'initialPos': const Offset(0.65, 0.75), 'delay': 650.ms, 'shape': BoxShape.circle}, // Bottom-right-ish
    // ... add more shapes for the right side with positive initialPos.dx and varied initialPos.dy ...
    {'size': 80.0, 'color': AppTheme.primaryColor.withOpacity(0.55), 'initialPos': const Offset(0.95, -0.95), 'delay': 350.ms, 'shape': BoxShape.rectangle},
    {'size': 110.0, 'color': AppTheme.primaryColorLight.withOpacity(0.65), 'initialPos': const Offset(0.82, 0.92), 'delay': 550.ms, 'shape': BoxShape.circle},
    //middle
    {'size': 130.0, 'color': AppTheme.primaryColor, 'initialPos': const Offset(0.0, 0.0), 'delay': 800.ms, 'shape': BoxShape.circle},
    {'size': 160.0, 'color': AppTheme.accentColorBrown.withOpacity(0.35), 'initialPos': const Offset(0.2, 0.5), 'delay': 900.ms, 'shape': BoxShape.rectangle},
    {'size': 120.0, 'color': AppTheme.primaryColorLight.withOpacity(0.55), 'initialPos': const Offset(0.15, -0.5), 'delay': 1000.ms, 'shape': BoxShape.circle},
  
  ];

  @override
  void initState() {
    super.initState();
    _entranceControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: (2600 + math.Random().nextInt(1900)).ms)
    );
    _rotationControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: Duration(seconds: 25 + math.Random().nextInt(25)))
    );

    _opacityAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.0, end: 0.15 + math.Random().nextDouble() * 0.25).animate(
        CurvedAnimation(parent: _entranceControllers[index], curve: Curves.easeIn))
    );
    _scaleAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.25, end: 1.0).animate(
        CurvedAnimation(parent: _entranceControllers[index], curve: Curves.elasticOut))
    );
    _rotationAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0, end: (math.Random().nextBool() ? 1 : -1) * (math.pi * 2)).animate(_rotationControllers[index])
    );

    for (int i = 0; i < shapesData.length; i++) {
      Future.delayed(shapesData[i]['delay'], () {
        if (mounted) {
          _entranceControllers[i].forward();
          _entranceControllers[i].addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (mounted) _rotationControllers[i].repeat();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _entranceControllers) controller.dispose();
    for (var controller in _rotationControllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      children: List.generate(shapesData.length, (index) {
        final shape = shapesData[index];
        final Offset position = shape['initialPos'] as Offset;

        return Align(
          // Use initialPos directly for Alignment
          alignment: Alignment(position.dx, position.dy),
          child: AnimatedBuilder(
            animation: Listenable.merge([_entranceControllers[index], _rotationControllers[index]]),
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimations[index].value,
                child: Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: Transform.rotate(
                    angle: _rotationAnimations[index].value,
                    child: Container(
                      width: shape['size'] * (screenSize.width / 1400),
                      height: shape['size'] * (screenSize.width / 1400),
                      decoration: BoxDecoration(
                        color: shape['color'],
                        shape: shape['shape'],
                        borderRadius: shape['shape'] == BoxShape.rectangle ? BorderRadius.circular(shape['size'] * 0.22) : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}