// lib/presentation/sections/projects_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

enum ProjectType { research, personal, publication, app }

class ProjectItemModel {
  final String title;
  final String description;
  final List<String> technologies;
  final String? imageUrl;
  final String? projectUrl;
  final ProjectType type;
  final String? achievement;
  final Color? cardColor; // For unique card background tint
  final Color? accentColor; // For icon, link, or chip accents

  ProjectItemModel({
    required this.title,
    required this.description,
    required this.technologies,
    this.imageUrl,
    this.projectUrl,
    required this.type,
    this.achievement,
    this.cardColor,
    this.accentColor,
  });
}

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
    {'size': 70.0, 'color': AppTheme.primaryColor.withOpacity(0.35), 'initialPos': const Offset(-0.95, -0.15), 'delay': 300.ms, 'shape': BoxShape.rectangle},
    {'size': 110.0, 'color': AppTheme.accentColorBrown.withOpacity(0.18), 'initialPos': const Offset(-0.82, 0.82), 'delay': 600.ms, 'shape': BoxShape.circle},
    {'size': 85.0, 'color': AppTheme.primaryColorLight.withOpacity(0.45), 'initialPos': const Offset(0.92, -0.45), 'delay': 450.ms, 'shape': BoxShape.circle},
    {'size': 95.0, 'color': AppTheme.primaryColor.withOpacity(0.28), 'initialPos': const Offset(0.88, 0.35), 'delay': 700.ms, 'shape': BoxShape.rectangle},
    {'size': 60.0, 'color': AppTheme.accentColorBrown.withOpacity(0.25), 'initialPos': const Offset(0.05, -0.05), 'delay': 100.ms, 'shape': BoxShape.circle},
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
      Tween<double>(begin: 0.0, end: 0.06 + math.Random().nextDouble() * 0.09).animate(
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
                      width: shape['size'] * (screenSize.width / 1750),
                      height: shape['size'] * (screenSize.width / 1750),
                      decoration: BoxDecoration(
                        color: shape['color'], shape: shape['shape'],
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


class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
    final bool isWideScreen = screenSize.width > 950;

    const Duration sectionEntranceDelay = Duration(milliseconds: 200);
    const Duration titleAnimationDuration = Duration(milliseconds: 800);
    const Duration contentStagger = Duration(milliseconds: 150);
    const Duration cardEntranceDuration = Duration(milliseconds: 600);
    const Duration cardWaveStartDelayBase = Duration(milliseconds: 1000);

    final List<Color> cardAccentColors = [ // For Project Cards
      AppTheme.primaryColorLight.withOpacity(0.08),
      AppTheme.accentColorBrown.withOpacity(0.06),
      AppTheme.primaryColor.withOpacity(0.07),
      Colors.teal.shade50.withOpacity(0.4),
      Colors.brown.shade50.withOpacity(0.4),
      AppTheme.primaryColorLight.withOpacity(0.15),
    ];


    final List<ProjectItemModel> projects = [
           ProjectItemModel(
        title: 'Multilingual Service Classification',
        description: 'Fine-tuned transformer models (XLM-RoBERTa, BERT) for classifying API services across languages, achieving high accuracy.',
        technologies: ['Python', 'PyTorch', 'Hugging Face', 'NLP'],
        type: ProjectType.research,
        achievement: '82% Accuracy',
        imageUrl: 'assets/images/project_multilingual.png',
        cardColor: cardAccentColors[2 % cardAccentColors.length],
        accentColor: AppTheme.primaryColor,
      ),
      ProjectItemModel(
        title: 'Personal Portfolio Website',
        description: 'The very website you are currently viewing! Built with Flutter Web, showcasing skills, projects, and experience with a focus on attractive UI/UX and animations.',
        technologies: ['Flutter', 'Dart', 'Flutter Animate'],
        type: ProjectType.app,
        achievement: 'Live & Interactive',
        imageUrl: 'assets/images/project_portfolio_website.png',
        projectUrl: 'https://github.com/Pranay1021/Portfolio',
        cardColor: cardAccentColors[0 % cardAccentColors.length],
        accentColor: AppTheme.primaryColorDark,
      ),
      ProjectItemModel(
        title: 'Who\'s More Likely To App',
        description: 'A fun, interactive party game application built with Flutter and Firebase. Users answer "Who\'s More Likely To..." questions about their friends.',
        technologies: ['Flutter', 'Firebase', 'Dart', 'Realtime DB'],
        type: ProjectType.app,
        achievement: 'Multiplayer Fun',
        imageUrl: 'assets/images/project_whos_more_likely.png',
        projectUrl: 'https://github.com/Pranay1021/WhosMoreLikelyTo',
        cardColor: cardAccentColors[1 % cardAccentColors.length],
        accentColor: AppTheme.accentColorBrown,
      ),

      ProjectItemModel(
        title: 'Hybrid NLP for Web Services',
        description: 'Integrated BERT/Word2Vec with heuristic optimization for service categorization in challenging low-data, multi-class scenarios.',
        technologies: ['Python', 'pyMetaheuristics', 'BERT', 'NLP'],
        type: ProjectType.research,
        achievement: 'Robust Low-Data Performance',
        imageUrl: 'assets/images/project_hybrid_nlp.png',
        cardColor: cardAccentColors[3 % cardAccentColors.length],
        accentColor: Colors.teal.shade700,
      ),
      ProjectItemModel(
        title: 'Waste Classification CNN',
        description: 'Developed a CNN model using TensorFlow for image-based waste sorting into multiple categories, with a Streamlit UI.',
        technologies: ['Python', 'TensorFlow', 'CNN', 'Streamlit'],
        type: ProjectType.personal,
        achievement: '86% Accuracy',
        imageUrl: 'assets/images/project_waste_classification.png',
        cardColor: cardAccentColors[4 % cardAccentColors.length],
        accentColor: Colors.brown.shade700,
      ),
      ProjectItemModel(
        title: 'Blockchain in AI Healthcare Security',
        description: 'Co-authored a Springer publication on leveraging blockchain to enhance security in AI-driven healthcare systems.',
        technologies: ['Blockchain', 'AI Security', 'Research'],
        type: ProjectType.publication,
        achievement: 'Springer Publication',
        imageUrl: 'assets/images/project_blockchain_healthcare.png',
        projectUrl: 'https://doi.org/10.1007/978-3-031-49593-9_2',
        cardColor: cardAccentColors[5 % cardAccentColors.length],
        accentColor: AppTheme.primaryColorDark,
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppTheme.backgroundColor.withOpacity(0.95),
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? screenSize.width * 0.07 : screenSize.width * 0.05,
        vertical: 100.0,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedDecorativeShapes(
              shapesKey: const Key('projects_shapes_v4'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'My Work',
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
                "Here's a glimpse into some of the projects and research I've been involved in.",
                style: textTheme.headlineSmall?.copyWith(
                    color: AppTheme.onBackgroundColor.withOpacity(0.85),
                    fontSize: isWideScreen ? 19 : 17,
                    height: 1.6),
                textAlign: TextAlign.center,
              )
                  .animate(delay: sectionEntranceDelay + contentStagger)
                  .fadeIn(duration: titleAnimationDuration, curve: Curves.easeOutExpo)
                  .slideY(begin: 0.3, duration: titleAnimationDuration, curve: Curves.easeOutExpo),
              const SizedBox(height: 70),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double maxCardWidth = 400; // Max width for a card
                  if (constraints.maxWidth > 1250) crossAxisCount = 3;
                  else if (constraints.maxWidth > 800) crossAxisCount = 2;

                  // Calculate spacing to make it look good
                  double horizontalSpacing = isWideScreen ? 40.0 : 25.0;
                  double calculatedCardWidth = (constraints.maxWidth - (horizontalSpacing * (crossAxisCount -1))) / crossAxisCount;
                  double cardWidth = math.min(calculatedCardWidth, maxCardWidth);


                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: horizontalSpacing,
                      mainAxisSpacing: isWideScreen ? 40.0 : 30.0,
                      childAspectRatio: cardWidth / 450, // Height is somewhat fixed now
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      final entranceDelay = sectionEntranceDelay + (contentStagger * 2) + (Duration(milliseconds: index * 200));
                      final waveDelay = entranceDelay + cardEntranceDuration + cardWaveStartDelayBase + (Duration(milliseconds: index * 150));

                      return ProjectCard(
                        key: ValueKey('project_card_v4_${project.title.replaceAll(" ", "_")}'),
                        project: project,
                        onLaunchUrl: _launchURL,
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

class ProjectCard extends StatefulWidget {
  final ProjectItemModel project;
  final Function(String) onLaunchUrl;
  final Duration entranceAnimationDelay;
  final Duration continuousAnimationStartDelay;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onLaunchUrl,
    required this.entranceAnimationDelay,
    required this.continuousAnimationStartDelay,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.012), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.012, end: 1.0), weight: 50),
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
    final bool hasLink = widget.project.projectUrl != null && widget.project.projectUrl!.isNotEmpty;

    final Color cardBaseColor = widget.project.cardColor ?? AppTheme.surfaceColor;
    final Color accent = widget.project.accentColor ?? AppTheme.primaryColor;

    final Color currentBorderColor = _isHovered ? accent : (widget.project.cardColor != null ? cardBaseColor.withBlue(cardBaseColor.blue - 10).withGreen(cardBaseColor.green-10) : AppTheme.subtleBorderColor);
    final Matrix4 currentTransform = _isHovered
        ? (Matrix4.identity()..translate(0.0, -10.0, 0.0)..scale(1.03))
        : Matrix4.identity();
    final List<BoxShadow> currentBoxShadow = _isHovered ? [
      BoxShadow(
        color: accent.withOpacity(0.2),
        blurRadius: 28, spreadRadius: 4, offset: const Offset(0, 12),
      )] : [
      BoxShadow(
        color: AppTheme.accentColorBrown.withOpacity(0.06),
        blurRadius: 15, spreadRadius: 0, offset: const Offset(0, 6),
      )
    ];

    Widget cardContent = SizedBox( // Ensure card has a height constraint
      height: 450, // Fixed height for ProjectCard to prevent overflow
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        transform: currentTransform,
        decoration: BoxDecoration(
          color: cardBaseColor, // Use the unique card color
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: currentBorderColor, width: _isHovered ? 2.0 : 1.2),
          boxShadow: currentBoxShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.project.imageUrl != null && widget.project.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17.0), topRight: Radius.circular(17.0),
                ),
                child: Image.asset(
                  widget.project.imageUrl!, height: 190, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => Container(
                    height: 190, color: AppTheme.subtleBorderColor.withOpacity(0.2), alignment: Alignment.center,
                    child: Icon(FontAwesomeIcons.image, color: AppTheme.lightTextColor.withOpacity(0.4), size: 40),
                  ),
                ),
              )
            else
              Container(
                height: 190, width: double.infinity,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(17.0), topRight: Radius.circular(17.0)),
                ),
                alignment: Alignment.center,
                child: Icon(FontAwesomeIcons.diagramProject, size: 55, color: accent.withOpacity(0.5)),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: AppTheme.onSurfaceColor, height: 1.35
                          ),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.project.achievement != null && widget.project.achievement!.isNotEmpty) ...[
                          const SizedBox(height: 7.0),
                          Text(
                            widget.project.achievement!,
                            style: textTheme.bodySmall?.copyWith(
                              color: accent, fontWeight: FontWeight.bold, fontSize: 12.5
                            ),
                          ),
                        ],
                        const SizedBox(height: 14.0),
                        Text(
                          widget.project.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTextColor, height: 1.65, fontSize: 13.5,
                          ),
                          maxLines: 3, overflow: TextOverflow.ellipsis, // Ensure description truncates
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const SizedBox(height: 18.0),
                          Wrap(
                            spacing: 8.0, runSpacing: 6.0,
                            children: widget.project.technologies.map((tech) => Chip(
                              label: Text(tech),
                              labelStyle: textTheme.bodySmall?.copyWith(color: accent, fontSize: 11, fontWeight: FontWeight.w600),
                              backgroundColor: accent.withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide.none
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            )).toList(),
                          ),
                          if (hasLink) ...[
                            const SizedBox(height: 18.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                FontAwesomeIcons.link,
                                size: 15,
                                color: _isHovered ? accent.withBlue((accent.blue * 0.8).round()).withGreen((accent.green * 0.8).round()) : accent,
                              ),
                           ),
                          ]
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    var cardEntranceDuration = const Duration(milliseconds: 600);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: hasLink ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: hasLink ? () => widget.onLaunchUrl(widget.project.projectUrl!) : null,
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
      ),
    )
    .animate(delay: widget.entranceAnimationDelay)
    .fadeIn(duration: cardEntranceDuration, curve: Curves.easeOut)
    .slideY(begin: 0.35, end:0, duration: cardEntranceDuration, curve: Curves.easeOutExpo)
    .scaleXY(begin: 0.90, end: 1.0, duration: cardEntranceDuration, curve: Curves.easeOutExpo);
  }
}