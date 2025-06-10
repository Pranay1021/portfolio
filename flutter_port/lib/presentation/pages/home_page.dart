// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import '../sections/introduction_section.dart';
import '../sections/about_section.dart';
import '../sections/services_section.dart';
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';
import '../widgets/nav_bar.dart'; // Import the NavBar

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late List<NavBarItem> _navBarItems;
  GlobalKey? _activeSectionKey;

  final GlobalKey _introductionKey = GlobalKey(debugLabel: 'Introduction');
  final GlobalKey _aboutKey = GlobalKey(debugLabel: 'About');
  final GlobalKey _servicesKey = GlobalKey(debugLabel: 'Services');
  final GlobalKey _projectsKey = GlobalKey(debugLabel: 'Projects');
  final GlobalKey _contactKey = GlobalKey(debugLabel: 'Contact');

  @override
  void initState() {
    super.initState();
    _navBarItems = [
      NavBarItem(title: 'Home', sectionKey: _introductionKey),
      NavBarItem(title: 'About', sectionKey: _aboutKey),
      NavBarItem(title: 'Services', sectionKey: _servicesKey),
      NavBarItem(title: 'Projects', sectionKey: _projectsKey),
      NavBarItem(title: 'Contact', sectionKey: _contactKey),
    ];
    _scrollController.addListener(_onScroll);
    // Initialize active key if needed, e.g., to introduction
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final scrollPosition = _scrollController.offset;
    GlobalKey? currentActiveKey;

    for (var item in _navBarItems) {
      final context = item.sectionKey.currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero).dy + scrollPosition;
        // Consider a section active if its top is within a certain range of the viewport top
        // Or if a significant portion of it is visible.
        // This threshold might need adjustment.
        final navBarHeight = 60.0; // Height of the NavBar
        if (scrollPosition >= offset - navBarHeight - (MediaQuery.of(context).size.height * 0.3) &&
            scrollPosition < offset + box.size.height - (MediaQuery.of(context).size.height * 0.3)) {
            currentActiveKey = item.sectionKey;
            break; // Found the topmost visible section
        }
      }
    }
     if (_activeSectionKey != currentActiveKey) {
      setState(() {
        _activeSectionKey = currentActiveKey ?? _navBarItems.first.sectionKey;
      });
    }
  }


  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0, // Align to the top
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Use Stack to overlay NavBar
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                IntroductionSection(key: _introductionKey),
                AboutSection(key: _aboutKey),
                ServicesSection(key: _servicesKey),
                ProjectsSection(key: _projectsKey),
                ContactSection(key: _contactKey),
              ],
            ),
          ),
          Positioned( // Position NavBar at the top
            top: 0,
            left: 0,
            right: 0,
            child: PortfolioNavBar(
              items: _navBarItems,
              onItemSelected: _scrollToSection,
              activeSectionKey: _activeSectionKey,
            ),
          ),
        ],
      ),
    );
  }
}