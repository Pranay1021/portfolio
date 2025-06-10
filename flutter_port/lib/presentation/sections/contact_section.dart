// lib/presentation/sections/contact_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

// Re-using AnimatedDecorativeShapes (ideally in a shared file)
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

  // Shapes specifically for Contact Section - more subtle, perhaps on one side or corners
  final List<Map<String, dynamic>> shapesData = [
    {'size': 70.0, 'color': AppTheme.primaryColorLight.withOpacity(0.4), 'initialPos': const Offset(-0.9, -0.8), 'delay': 400.ms, 'shape': BoxShape.rectangle},
    {'size': 110.0, 'color': AppTheme.accentColorBrown.withOpacity(0.2), 'initialPos': const Offset(-0.85, 0.85), 'delay': 700.ms, 'shape': BoxShape.circle},
    // Shapes for the right side if form is on left, or vice versa.
    // For this layout (Info Left, Form Right), we might want more shapes on the far left and far right.
    {'size': 80.0, 'color': AppTheme.primaryColor.withOpacity(0.35), 'initialPos': const Offset(0.9, -0.7), 'delay': 500.ms, 'shape': BoxShape.circle},
    {'size': 95.0, 'color': AppTheme.primaryColorLight.withOpacity(0.25), 'initialPos': const Offset(0.85, 0.75), 'delay': 800.ms, 'shape': BoxShape.rectangle},
    {'size': 60.0, 'color': AppTheme.accentColorBrown.withOpacity(0.15), 'initialPos': const Offset(0.0, -0.95), 'delay': 600.ms, 'shape': BoxShape.circle}, // Top center-ish
  ];

  @override
  void initState() {
    super.initState();
    _entranceControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: (2500 + math.Random().nextInt(1500)).ms)
    );
    _rotationControllers = List.generate(shapesData.length, (index) =>
      AnimationController(vsync: this, duration: Duration(seconds: 24 + math.Random().nextInt(20)))
    );
    _opacityAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.0, end: 0.05 + math.Random().nextDouble() * 0.08).animate( // Even more subtle
        CurvedAnimation(parent: _entranceControllers[index], curve: Curves.easeIn))
    );
    _scaleAnimations = List.generate(shapesData.length, (index) =>
      Tween<double>(begin: 0.2, end: 1.0).animate(
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
                      width: shape['size'] * (screenSize.width / 1900), // Smallest shapes
                      height: shape['size'] * (screenSize.width / 1900),
                      decoration: BoxDecoration(
                        color: shape['color'], shape: shape['shape'],
                        borderRadius: shape['shape'] == BoxShape.rectangle ? BorderRadius.circular(shape['size'] * 0.15) : null,
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


class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String message = _messageController.text;
      String mailtoLink = 'mailto:pranayshah2021@gmail.com'
          '?subject=Portfolio Contact: ${Uri.encodeComponent(name)}'
          '&body=${Uri.encodeComponent("Name: $name\nEmail: $email\n\nMessage:\n$message")}';
      _launchURL(mailtoLink);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: AppTheme.primaryColor,
            content: Text('Opening email client...', style: TextStyle(color: AppTheme.onPrimaryColor))),
      );
      _formKey.currentState!.reset();
      _nameController.clear(); _emailController.clear(); _messageController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose(); _emailController.dispose(); _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isWideScreen = screenSize.width > 1000; // Adjusted breakpoint for this layout

    final Duration animationDuration = 700.ms;
    final Duration staggerDelay = 200.ms;
    // Delay for elements within each column
    const Duration columnContentDelay = Duration(milliseconds: 300);


    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, end: Alignment.centerRight, // Adjusted gradient
          colors: [
            AppTheme.backgroundColor,
            AppTheme.surfaceColor.withOpacity(0.9),
            AppTheme.backgroundColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? screenSize.width * 0.08 : 30.0, // Adjusted padding
        vertical: 120.0, // Increased vertical padding
      ),
      child: Stack(
        children: [
           Positioned.fill(
            child: AnimatedDecorativeShapes(
              shapesKey: const ValueKey("contact_shapes_v3"), // Use the key from widget property
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Get In Touch',
                style: textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryColor, fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: animationDuration).slideY(begin: 0.4, curve: Curves.easeOutExpo),
              const SizedBox(height: 25),
              Text(
                "Have a project in mind, a question, or just want to connect? I'd love to hear from you!", // More engaging
                style: textTheme.headlineSmall?.copyWith(
                    color: AppTheme.onBackgroundColor.withOpacity(0.85), height: 1.6, fontSize: isWideScreen ? 19:17),
                textAlign: TextAlign.center,
              ).animate(delay: staggerDelay).fadeIn(duration: animationDuration).slideY(begin: 0.4, curve: Curves.easeOutExpo),
              const SizedBox(height: 80), // Increased spacing

              // Main content Row for wide screens, Column for narrow
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isWideScreen) {
                    // --- Wide Screen Layout: Info Left, Form Right ---
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Contact Info
                        Expanded(
                          flex: 4, // Adjust flex factors as needed
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40.0), // Space between columns
                            child: _buildContactInfoColumn(context, columnContentDelay),
                          ),
                        ),
                        // Right Column: Form
                        Expanded(
                          flex: 5,
                          child: _buildFormColumn(context, columnContentDelay + 200.ms),
                        ),
                      ],
                    );
                  } else {
                    // --- Narrow Screen Layout: Info Above, Form Below ---
                    return Column(
                      children: [
                        _buildContactInfoColumn(context, columnContentDelay),
                        const SizedBox(height: 60),
                        _buildFormColumn(context, columnContentDelay + 200.ms),
                      ],
                    );
                  }
                }
              ),
              const SizedBox(height: 100),
              Text("© ${DateTime.now().year} Pranay Shah. All rights reserved.",
                      style: textTheme.bodySmall?.copyWith(color: AppTheme.onBackgroundColor.withOpacity(0.65)))
                  .animate(delay: staggerDelay * 5).fadeIn(duration: animationDuration),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for Contact Info Column
  Widget _buildContactInfoColumn(BuildContext context, Duration initialDelay) {
    final textTheme = Theme.of(context).textTheme;
    const Duration itemStagger = Duration(milliseconds: 150);
    return Column(
      crossAxisAlignment: MediaQuery.of(context).size.width > 1000 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text("Let's Connect", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onBackgroundColor))
            .animate(delay: initialDelay).fadeIn().slideX(begin: -0.3, curve: Curves.easeOutExpo),
        const SizedBox(height: 35),
        _ContactInfoItem(
          icon: FontAwesomeIcons.solidEnvelope, text: 'pranayshah2021@gmail.com',
          url: 'mailto:pranayshah2021@gmail.com', animationDelay: initialDelay + itemStagger * 1,
        ),
        _ContactInfoItem(
          icon: FontAwesomeIcons.phoneVolume, text: '+91 6200866687',
          url: 'tel:+916200866687', animationDelay: initialDelay + itemStagger * 2,
        ),
        _ContactInfoItem(
          icon: FontAwesomeIcons.linkedinIn, text: 'linkedin.com/in/pranayshah1',
          url: 'https://linkedin.com/in/pranayshah1', animationDelay: initialDelay + itemStagger * 3,
        ),
        _ContactInfoItem(
          icon: FontAwesomeIcons.githubAlt, text: 'github.com/Pranay1021',
          url: 'https://github.com/Pranay1021', animationDelay: initialDelay + itemStagger * 4,
        ),
        _ContactInfoItem(
          icon: FontAwesomeIcons.mapPin, text: 'Bengaluru, Karnataka, India',
          isLocation: true, animationDelay: initialDelay + itemStagger * 5,
        ),
      ],
    );
  }

  // Helper widget for Form Column
  Widget _buildFormColumn(BuildContext context, Duration initialDelay) {
    final textTheme = Theme.of(context).textTheme;
    const Duration itemStagger = Duration(milliseconds: 150);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.08), blurRadius: 25, offset: const Offset(0, 10))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Send a Direct Message", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onSurfaceColor))
                .animate(delay: initialDelay).fadeIn().slideY(begin: 0.3, curve: Curves.easeOutExpo),
            const SizedBox(height: 35),
            _buildTextFormField(
              controller: _nameController, labelText: 'Your Name', icon: FontAwesomeIcons.userLarge, // Changed icon
              validator: (v) => v==null||v.isEmpty?'Please enter your name':null, delay: initialDelay + itemStagger * 1,
            ),
            const SizedBox(height: 25),
            _buildTextFormField(
              controller: _emailController, labelText: 'Your Email Address', icon: FontAwesomeIcons.at, // Changed icon
              keyboardType: TextInputType.emailAddress,
              validator: (v){if(v==null||v.isEmpty)return 'Please enter your email';if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v))return'Enter a valid email';return null;},
              delay: initialDelay + itemStagger * 2,
            ),
            const SizedBox(height: 25),
            _buildTextFormField(
              controller: _messageController, labelText: 'Your Message Here', icon: FontAwesomeIcons.penToSquare, // Changed icon
              maxLines: 5, validator: (v)=>v==null||v.isEmpty?'Please enter a message':null, delay: initialDelay + itemStagger * 3,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(FontAwesomeIcons.paperPlane, size: 18), // Changed icon
              label: const Text('Send Message'), onPressed: _submitForm,
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith( // Ensure consistent button style
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
              ),
            ).animate(delay: initialDelay + itemStagger*4).fadeIn(duration: 600.ms).slideY(begin:0.5).shimmer(delay: (initialDelay + itemStagger*4)+600.ms, duration: 1800.ms, color: Colors.white.withOpacity(0.15)),
          ],
        ),
      ),
    );
  }


  Widget _buildTextFormField({
    required TextEditingController controller, required String labelText, required IconData icon,
    int maxLines=1, TextInputType? keyboardType, String? Function(String?)? validator, required Duration delay,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0, top: 15), // Align icon better for multiline
          child: Icon(icon, size: 18, color: AppTheme.primaryColor),
        ),
         alignLabelWithHint: true, // Good for multiline
      ),
      keyboardType: keyboardType, maxLines: maxLines, validator: validator,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.onSurfaceColor),
    ).animate().fadeIn(delay: delay, duration: 600.ms).slideY(begin: 0.4, curve: Curves.easeOut);
  }
}

class _ContactInfoItem extends StatefulWidget {
  final IconData icon; final String text; final String? url;
  final bool isLocation; final Duration animationDelay;
  const _ContactInfoItem({ required this.icon, required this.text, this.url, this.isLocation = false, required this.animationDelay });
  @override State<_ContactInfoItem> createState() => _ContactInfoItemState();
}

class _ContactInfoItemState extends State<_ContactInfoItem> {
  bool _isHovered = false;
  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) { debugPrint('Could not launch $url');}
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.url != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: InkWell(
        onTap: widget.url != null ? () => _launchURL(widget.url!) : null,
        hoverColor: AppTheme.primaryColor.withOpacity(0.04), // Very subtle hover for the whole item
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Important for Wrap/Flex behavior
            mainAxisAlignment: MediaQuery.of(context).size.width > 1000 && !widget.isLocation
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
                child: Icon(widget.icon, color: _isHovered ? AppTheme.primaryColorDark : AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 20), // Increased spacing
              Flexible(
                child: Text(widget.text,
                  style: textTheme.bodyLarge?.copyWith(
                    color: _isHovered ? AppTheme.primaryColorDark : AppTheme.onBackgroundColor,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal, letterSpacing: 0.2
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: widget.animationDelay, duration: 700.ms).slideX(begin: -0.3, curve: Curves.easeOutExpo);
  }
}