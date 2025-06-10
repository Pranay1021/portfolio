// lib/presentation/sections/about_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:animated_text_kit/animated_text_kit.dart'; // Removed for faster load, can be re-added
import '../../core/theme/app_theme.dart';

// Re-introducing the full AnimatedDecorativeShapes widget here for use in AboutSection
// (This is the same as the one from the IntroductionSection)
class AnimatedDecorativeShapes extends StatefulWidget {
  final Key? shapesKey; // Optional key if you need to differentiate instances
  const AnimatedDecorativeShapes({this.shapesKey}) : super(key: shapesKey);

  @override
  State<AnimatedDecorativeShapes> createState() => _AnimatedDecorativeShapesState();
}

class _AnimatedDecorativeShapesState extends State<AnimatedDecorativeShapes> with TickerProviderStateMixin {
  late List<AnimationController> _entranceControllers;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<double>> _scaleAnimations;
  late List<AnimationController> _rotationControllers;
  late List<Animation<double>> _rotationAnimations;

  // Define shapes - adjust initialPos for desired spread on left AND right
  // initialPos.dx: -1 (far left) to 1 (far right)
  // initialPos.dy: -1 (top) to 1 (bottom)
  final List<Map<String, dynamic>> shapesData = [
    // Left Side Shapes for About Section
    {'size': 90.0, 'color': AppTheme.primaryColorLight.withOpacity(0.6), 'initialPos': const Offset(-0.9, -0.7), 'delay': 300.ms, 'shape': BoxShape.circle},
    {'size': 70.0, 'color': AppTheme.accentColorBrown.withOpacity(0.4), 'initialPos': const Offset(-0.8, 0.5), 'delay': 500.ms, 'shape': BoxShape.rectangle},
    {'size': 110.0, 'color': AppTheme.primaryColor.withOpacity(0.5), 'initialPos': const Offset(-0.95, 0.1), 'delay': 700.ms, 'shape': BoxShape.circle},

    // Right Side Shapes for About Section
    {'size': 100.0, 'color': AppTheme.primaryColor.withOpacity(0.6), 'initialPos': const Offset(0.9, -0.6), 'delay': 400.ms, 'shape': BoxShape.rectangle},
    {'size': 120.0, 'color': AppTheme.primaryColorLight.withOpacity(0.5), 'initialPos': const Offset(0.85, 0.6), 'delay': 600.ms, 'shape': BoxShape.circle},
    {'size': 75.0, 'color': AppTheme.accentColorBrown.withOpacity(0.35), 'initialPos': const Offset(0.95, 0.0), 'delay': 800.ms, 'shape': BoxShape.rectangle},

    //middle
    {'size': 130.0, 'color': AppTheme.primaryColor.withOpacity(0.4), 'initialPos': const Offset(0.1, 0.1), 'delay': 1000.ms, 'shape': BoxShape.circle},
    {'size': 100.0, 'color': AppTheme.primaryColorLight.withOpacity(0.3), 'initialPos': const Offset(0.0, -0.5), 'delay': 1200.ms, 'shape': BoxShape.rectangle},
    {'size': 90.0, 'color': AppTheme.accentColorBrown.withOpacity(0.25), 'initialPos': const Offset(0.0, 0.5), 'delay': 1400.ms, 'shape': BoxShape.circle},
  
  ];

  @override
  void initState() {
    super.initState();
    _entranceControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: (2500 + math.Random().nextInt(1500)).ms)
    );
    _rotationControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: Duration(seconds: 20 + math.Random().nextInt(20)))
    );

    _opacityAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.0, end: 0.1 + math.Random().nextDouble() * 0.20).animate( // Even more subtle opacity for About
        CurvedAnimation(parent: _entranceControllers[index], curve: Curves.easeIn))
    );
    _scaleAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.3, end: 1.0).animate(
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
                      width: shape['size'] * (screenSize.width / 1500), // Slightly smaller responsive factor
                      height: shape['size'] * (screenSize.width / 1500),
                      decoration: BoxDecoration(
                        color: shape['color'],
                        shape: shape['shape'],
                        borderRadius: shape['shape'] == BoxShape.rectangle ? BorderRadius.circular(shape['size'] * 0.2) : null,
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


class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final String _profileImagePath = 'assets/images/pranay_profile.jpg';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isWideScreen = screenSize.width > 950;

    const Duration sectionEntranceDelay = Duration(milliseconds: 200);
    const Duration titleAnimationDuration = Duration(milliseconds: 800);
    const Duration contentStagger = Duration(milliseconds: 200);
    const Duration skillBounceStartDelayBase = Duration(milliseconds: 1500);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? screenSize.width * 0.1 : screenSize.width * 0.07,
        vertical: 100.0,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AnimatedDecorativeShapes(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'About Me',
                style: textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: sectionEntranceDelay)
                  .fadeIn(duration: titleAnimationDuration, curve: Curves.easeOutExpo)
                  .slideY(begin: 0.3, duration: titleAnimationDuration, curve: Curves.easeOutExpo),
              const SizedBox(height: 60),
              Flex(
                direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: isWideScreen ? CrossAxisAlignment.center : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: isWideScreen ? 2 : 0,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: isWideScreen ? 300 : 220),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            blurRadius: 25,
                            spreadRadius: 5,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: isWideScreen ? 150 : 110,
                        backgroundColor: AppTheme.surfaceColor,
                        backgroundImage: AssetImage(_profileImagePath),
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: !_profileImagePath.contains('.')
                            ? Icon(FontAwesomeIcons.userAstronaut, size: isWideScreen ? 100 : 70, color: AppTheme.primaryColor.withOpacity(0.7))
                            : null,
                      ),
                    ).animate(delay: sectionEntranceDelay + contentStagger)
                       .fadeIn(duration: titleAnimationDuration * 1.2, curve: Curves.easeOut)
                       .scale(begin: Offset(0.85, 0.85), duration: titleAnimationDuration * 1.2, curve: Curves.elasticOut),
                  ),
                  if (isWideScreen) const SizedBox(width: 70),
                  if (!isWideScreen) const SizedBox(height: 50),
                  Flexible(
                    flex: isWideScreen ? 3 : 0,
                    child: Column(
                      crossAxisAlignment: isWideScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Crafting Intelligent Solutions",
                          style: textTheme.headlineMedium?.copyWith(
                              color: AppTheme.onBackgroundColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                          ),
                          textAlign: isWideScreen ? TextAlign.left : TextAlign.center,
                        ).animate(delay: sectionEntranceDelay + (contentStagger * 2))
                           .fadeIn(duration: titleAnimationDuration)
                           .slideY(begin: 0.2, curve: Curves.easeOut),
                        const SizedBox(height: 20),
                        Container(
                          constraints: BoxConstraints(maxWidth: isWideScreen ? 500 : double.infinity),
                          child: Text(
                            "My journey into Computer Science at ignited a deep passion for Artificial Intelligence and Machine Learning. I thrive on dissecting complex problems and harnessing AI's transformative power. Through research in NLP and model optimization, I've honed my skills to develop innovative solutions that make a meaningful impact. I'm a firm believer in continuous learning and the collaborative spirit of open source.",
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppTheme.onBackgroundColor.withOpacity(0.9),
                              height: 1.75,
                              fontSize: 17,
                            ),
                            textAlign: isWideScreen ? TextAlign.left : TextAlign.justify,
                          ).animate(delay: sectionEntranceDelay + (contentStagger * 2.5))
                             .fadeIn(duration: titleAnimationDuration * 1.3)
                             .slideY(begin: 0.2, curve: Curves.easeOut),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              Text(
                'Core Competencies',
                style: textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: sectionEntranceDelay + (contentStagger * 3))
                  .fadeIn(duration: titleAnimationDuration)
                  .slideY(begin: 0.3, curve: Curves.easeOutExpo),
              const SizedBox(height: 50),
              _buildSkillsSection(context, skillBounceStartDelayBase + sectionEntranceDelay + (contentStagger * 3.5) + titleAnimationDuration),
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, Duration baseContinuousDelay) {
    final textTheme = Theme.of(context).textTheme;
    final List<Map<String, dynamic>> languages = [
      {'name': 'Python', 'icon': FontAwesomeIcons.python, 'delayIndex': 0},
      {'name': 'Java', 'icon': FontAwesomeIcons.java, 'delayIndex': 1},
      {'name': 'Dart', 'icon': FontAwesomeIcons.codeBranch, 'delayIndex': 2},
      {'name': 'C++', 'icon': FontAwesomeIcons.c, 'delayIndex': 3},
      {'name': 'SQL', 'icon': FontAwesomeIcons.database, 'delayIndex': 4},
      {'name': 'HTML5', 'icon': FontAwesomeIcons.html5, 'delayIndex': 5},
      {'name': 'CSS3', 'icon': FontAwesomeIcons.css3Alt, 'delayIndex': 6},
    ];
    final List<Map<String, dynamic>> technologies = [
      {'name': 'Deep Learning', 'icon': FontAwesomeIcons.brain, 'delayIndex': 0},
      {'name': 'NLP', 'icon': FontAwesomeIcons.commentDots, 'delayIndex': 1},
      {'name': 'TensorFlow', 'icon': FontAwesomeIcons.microchip, 'delayIndex': 2},
      {'name': 'PyTorch', 'icon': FontAwesomeIcons.atom, 'delayIndex': 3},
      {'name': 'Scikit-learn', 'icon': FontAwesomeIcons.chartPie, 'delayIndex': 4},
      {'name': 'Flutter', 'icon': FontAwesomeIcons.mobileScreenButton, 'delayIndex': 5},
      {'name': 'Git', 'icon': FontAwesomeIcons.gitAlt, 'delayIndex': 6},
      {'name': 'MongoDB', 'icon': FontAwesomeIcons.server, 'delayIndex': 7},
      {'name': 'React', 'icon': FontAwesomeIcons.react, 'delayIndex': 8},
      {'name': 'OpenCV', 'icon': FontAwesomeIcons.cameraRetro, 'delayIndex': 9},
    ];
    final Duration skillItemEntranceStagger = 80.ms;
    final Duration skillItemContinuousStagger = 60.ms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Languages", style: textTheme.headlineMedium?.copyWith(color: AppTheme.onBackgroundColor, fontWeight: FontWeight.w700))
            .animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),
        const SizedBox(height: 30),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 25.0,
          runSpacing: 25.0,
          children: languages
              .map((skill) => _SimplifiedSkillItem(
                    key: ValueKey('lang_about_simple_${skill['name']}'),
                    label: skill['name'],
                    icon: skill['icon'],
                    entranceAnimationDelay: skillItemEntranceStagger * skill['delayIndex'],
                    continuousAnimationStartDelay: baseContinuousDelay + (skillItemContinuousStagger * skill['delayIndex']),
                  ))
              .toList(),
        ),
        const SizedBox(height: 60),
        Text("Technologies & Frameworks", style: textTheme.headlineMedium?.copyWith(color: AppTheme.onBackgroundColor, fontWeight: FontWeight.w700))
            .animate(delay: 300.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3),
        const SizedBox(height: 30),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 25.0,
          runSpacing: 25.0,
          children: technologies
              .map((skill) => _SimplifiedSkillItem(
                    key: ValueKey('tech_about_simple_${skill['name']}'),
                    label: skill['name'],
                    icon: skill['icon'],
                    entranceAnimationDelay: skillItemEntranceStagger * skill['delayIndex'],
                    continuousAnimationStartDelay: baseContinuousDelay + Duration(milliseconds: languages.length * skillItemContinuousStagger.inMilliseconds) + (skillItemContinuousStagger * skill['delayIndex']),
                  ))
              .toList(),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 300.ms);
  }
}

class _SimplifiedSkillItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final Duration entranceAnimationDelay;
  final Duration continuousAnimationStartDelay;

  const _SimplifiedSkillItem({
    super.key,
    required this.label,
    required this.icon,
    required this.entranceAnimationDelay,
    required this.continuousAnimationStartDelay,
  });

  @override
  State<_SimplifiedSkillItem> createState() => _SimplifiedSkillItemState();
}

class _SimplifiedSkillItemState extends State<_SimplifiedSkillItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.05), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeInOutSine));

    Future.delayed(widget.continuousAnimationStartDelay, () {
      if (mounted) {
        _waveController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget skillContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(widget.icon, color: AppTheme.primaryColor, size: 19),
        const SizedBox(width: 10),
        Text(
          widget.label,
          style: textTheme.bodyLarge?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: skillContent,
      ),
    )
    .animate(delay: widget.entranceAnimationDelay)
    .fadeIn(duration: 500.ms, curve: Curves.easeOut)
    .slideY(begin: 0.4, duration: 400.ms, curve: Curves.easeOut);
  }
}