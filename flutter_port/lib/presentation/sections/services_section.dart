// lib/presentation/sections/services_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';

class AnimatedDecorativeShapes extends StatefulWidget {
  final Key? shapesKey;
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

  final List<Map<String, dynamic>> shapesData = [
    {'size': 80.0, 'color': AppTheme.primaryColorLight.withOpacity(0.35), 'initialPos': const Offset(-0.92, -0.75), 'delay': 400.ms, 'shape': BoxShape.circle},
    {'size': 100.0, 'color': AppTheme.accentColorBrown.withOpacity(0.20), 'initialPos': const Offset(-0.88, 0.65), 'delay': 700.ms, 'shape': BoxShape.rectangle},
    {'size': 90.0, 'color': AppTheme.primaryColor.withOpacity(0.40), 'initialPos': const Offset(0.92, -0.70), 'delay': 550.ms, 'shape': BoxShape.rectangle},
    {'size': 110.0, 'color': AppTheme.primaryColorLight.withOpacity(0.30), 'initialPos': const Offset(0.85, 0.75), 'delay': 800.ms, 'shape': BoxShape.circle},
    {'size': 70.0, 'color': AppTheme.accentColorBrown.withOpacity(0.25), 'initialPos': const Offset(0.0, -0.95), 'delay': 650.ms, 'shape': BoxShape.circle},
    {'size': 90.0, 'color': AppTheme.primaryColor.withOpacity(0.3), 'initialPos': const Offset(0.0, 0.95), 'delay': 950.ms, 'shape': BoxShape.rectangle},
  ];

  @override
  void initState() {
    super.initState();
    _entranceControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: (2400 + math.Random().nextInt(1600)).ms)
    );
    _rotationControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: Duration(seconds: 22 + math.Random().nextInt(22)))
    );
    _opacityAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.0, end: 0.07 + math.Random().nextDouble() * 0.10).animate(
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
                      width: shape['size'] * (screenSize.width / 1650),
                      height: shape['size'] * (screenSize.width / 1650),
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

class ServiceItemData {
  final String title;
  final String description;
  final IconData icon;
  final Color? cardColor; // Optional: for unique card background
  final Color? iconAccentColor; // Optional: for unique icon treatment

  ServiceItemData({
    required this.title,
    required this.description,
    required this.icon,
    this.cardColor,
    this.iconAccentColor,
  });
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isWideScreen = screenSize.width > 950;

    const Duration sectionEntranceDelay = Duration(milliseconds: 200);
    const Duration titleAnimationDuration = Duration(milliseconds: 800);
    const Duration contentStagger = Duration(milliseconds: 150);
    const Duration cardEntranceDuration = Duration(milliseconds: 600);
    const Duration cardWaveStartDelayBase = Duration(milliseconds: 1000);

    // Define a list of accent colors for cards, or derive them
    final List<Color> cardAccentColors = [
      AppTheme.primaryColorLight.withOpacity(0.15),
      AppTheme.accentColorBrown.withOpacity(0.1),
      AppTheme.primaryColor.withOpacity(0.12),
      Colors.teal.shade50.withOpacity(0.5), // A very light teal
      Colors.brown.shade50.withOpacity(0.5), // A very light brown
      AppTheme.primaryColorLight.withOpacity(0.2),
      Colors.blue.shade50.withOpacity(0.5), // A very light blue
      Colors.green.shade50.withOpacity(0.5), // A very light green
      Colors.purple.shade50.withOpacity(0.5), // A very light purple
      Colors.orange.shade50.withOpacity(0.5), // A very light orange


    ];

    final List<ServiceItemData> services = [
      ServiceItemData(
        title: 'Machine Learning Solutions',
        description: 'Developing custom AI models for NLP & Computer Vision, fine-tuning transformers (BERT, etc.), and building robust data pipelines.',
        icon: FontAwesomeIcons.brain,
        cardColor: cardAccentColors[6 % cardAccentColors.length],
        iconAccentColor: AppTheme.primaryColorDark,
      ),
      ServiceItemData(
        title: 'AI Research & Development',
        description: 'Exploring cutting-edge AI techniques, conducting insightful comparative analyses, and optimizing models for peak performance.',
        icon: FontAwesomeIcons.flaskVial,
        cardColor: cardAccentColors[1 % cardAccentColors.length],
        iconAccentColor: AppTheme.accentColorBrown,
      ),
      ServiceItemData(
        title: 'Full-Stack Development',
        description: 'Crafting scalable web applications using Python (Flask/Django), React, and modern database solutions like MongoDB & Firebase.',
        icon: FontAwesomeIcons.laptopCode,
        cardColor: cardAccentColors[2 % cardAccentColors.length],
        iconAccentColor:Colors.teal.shade700,
      ),
      ServiceItemData(
        title: 'Mobile App Development',
        description: 'Building intuitive and responsive cross-platform mobile applications with Flutter, focusing on exceptional user experiences.',
        icon: FontAwesomeIcons.mobileScreenButton,
        cardColor: cardAccentColors[7 % cardAccentColors.length],
        iconAccentColor:  AppTheme.primaryColorDark,// Use a primary color for mobile
      ),
      ServiceItemData(
        title: 'Data Science & Analytics',
        description: 'Transforming raw data into actionable insights through advanced analytics, visualization, and predictive modeling.',
        icon: FontAwesomeIcons.chartSimple,
        cardColor: cardAccentColors[8 % cardAccentColors.length],
        iconAccentColor: Colors.brown.shade700,
      ),
      ServiceItemData(
        title: 'Game Development (Unity)',
        description: 'Creating engaging 2D and 3D games using the Unity engine, with a focus on gameplay mechanics and interactive storytelling.',
        icon: FontAwesomeIcons.gamepad,
        cardColor: cardAccentColors[7 % cardAccentColors.length],
        iconAccentColor: AppTheme.primaryColorDark,
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppTheme.backgroundColor, // Match main background for seamless feel
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? screenSize.width * 0.08 : screenSize.width * 0.06,
        vertical: 100.0,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedDecorativeShapes(
              shapesKey: const Key('services_shapes_v2'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'What I Offer',
                style: textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: sectionEntranceDelay)
                  .fadeIn(duration: titleAnimationDuration, curve: Curves.easeOutExpo)
                  .slideY(begin: 0.3, duration: titleAnimationDuration, curve: Curves.easeOutExpo),
              const SizedBox(height: 20),
              Text(
                "Leveraging a diverse skill set to build innovative and impactful digital solutions.",
                style: textTheme.headlineSmall?.copyWith(
                    color: AppTheme.onBackgroundColor.withOpacity(0.8),
                    fontSize: isWideScreen ? 19 : 17,
                    height: 1.6
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: sectionEntranceDelay + contentStagger)
                  .fadeIn(duration: titleAnimationDuration, curve: Curves.easeOutExpo)
                  .slideY(begin: 0.3, duration: titleAnimationDuration, curve: Curves.easeOutExpo),
              const SizedBox(height: 70),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 1200) { // Adjusted for potentially wider cards due to accent
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 750) { // Adjusted
                    crossAxisCount = 2;
                  }
                  double cardHeight = isWideScreen ? 340 : 360; // Fixed height for cards
                  double childAspectRatio = (constraints.maxWidth / crossAxisCount) / cardHeight;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: isWideScreen ? 40.0 : 30.0, // Increased spacing
                      mainAxisSpacing: isWideScreen ? 40.0 : 30.0,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final entranceDelay = sectionEntranceDelay + (contentStagger * 2) + (contentStagger * (index * 0.40));
                      final waveDelay = entranceDelay + cardEntranceDuration + cardWaveStartDelayBase + (Duration(milliseconds: index * 110));

                      return ServiceCard(
                        key: ValueKey('service_card_v2_${service.title.replaceAll(" ", "_")}'),
                        service: service,
                        entranceAnimationDelay: entranceDelay,
                        continuousAnimationStartDelay: waveDelay,
                      );
                    },
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final ServiceItemData service;
  final Duration entranceAnimationDelay;
  final Duration continuousAnimationStartDelay;

  const ServiceCard({
    super.key,
    required this.service,
    required this.entranceAnimationDelay,
    required this.continuousAnimationStartDelay,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2500), // Slightly different wave
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.02), weight: 50), // Even more subtle
      TweenSequenceItem(tween: Tween<double>(begin: 1.02, end: 1.0), weight: 50),
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Hover effects
    final Color? currentCardBg = widget.service.cardColor;
    final Color currentBorderColor = _isHovered ? AppTheme.primaryColor : (widget.service.cardColor != null ? Colors.transparent : AppTheme.subtleBorderColor.withOpacity(0.5));
    final double currentBorderSize = _isHovered ? 2.0 : 1.0;
    final Matrix4 currentTransform = _isHovered
        ? (Matrix4.identity()..translate(0.0, -7.0, 0.0)..scale(1.035))
        : Matrix4.identity();
    final List<BoxShadow> currentBoxShadow = _isHovered ? [
      BoxShadow(
        color: AppTheme.primaryColor.withOpacity(0.22),
        blurRadius: 25, spreadRadius: 3, offset: const Offset(0, 12),
      )] : [
      BoxShadow(
        color: AppTheme.accentColorBrown.withOpacity(0.08), // Softer default shadow
        blurRadius: 15, spreadRadius: 1, offset: const Offset(0, 6),
      )
    ];

    // Icon styling
    final Color iconColor = _isHovered ? AppTheme.onPrimaryColor : (widget.service.iconAccentColor ?? AppTheme.primaryColor);
    final Color iconBgShapeColor = _isHovered ? (widget.service.iconAccentColor ?? AppTheme.primaryColor) : (widget.service.cardColor ?? AppTheme.primaryColor.withOpacity(0.08));


    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 280), // Smooth transition
      curve: Curves.easeOutCubic,
      transform: currentTransform,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: BoxDecoration(
        color: currentCardBg,
        borderRadius: BorderRadius.circular(20.0), // More rounded
        border: Border.all(color: currentBorderColor, width: currentBorderSize),
        boxShadow: currentBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start, // Align content to top
        children: <Widget>[
          Container( // Icon container
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconBgShapeColor,
              borderRadius: BorderRadius.circular(16), // Softer square
            ),
            child: Icon(widget.service.icon, size: 30.0, color: iconColor),
          ),
          const SizedBox(height: 28.0),
          Text(
            widget.service.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.onSurfaceColor, // Always dark text on light card
              letterSpacing: 0.1,
              height: 1.3
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14.0),
          Expanded(
            child: Text(
              widget.service.description,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTextColor,
                height: 1.7, // Good line height for readability
                fontSize: 14,
              ),
              maxLines: 5, // Allow more lines if needed, card height is fixed
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    var cardEntranceDuration = const Duration(milliseconds: 600);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered ? 1.0 : _scaleAnimation.value,
            alignment: Alignment.center,
            child: child,
          );
        },
        child: cardContent,
      ),
    )
    .animate(delay: widget.entranceAnimationDelay)
    .fadeIn(duration: cardEntranceDuration, curve: Curves.easeOut)
    .slideY(begin: 0.35, end:0, duration: cardEntranceDuration, curve: Curves.easeOutCubic)
    .scaleXY(begin: 0.9, end: 1.0, duration: cardEntranceDuration, curve: Curves.easeOutBack); // Subtle scale entrance
  }
}