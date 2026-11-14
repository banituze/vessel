import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vessel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.cyan,
      ),
      home: const VesselPage(),
    );
  }
}

class Glassware {
  const Glassware(this.name, this.short, this.tagline, this.capacity,
      this.accuracy, this.shape, this.tip, this.photo);
  final String name;
  final String short;
  final String tagline;
  final int capacity;
  final String accuracy;
  final String shape;
  final String tip;
  final String photo;
}

final List<Glassware> vessels = [
  Glassware(
    'Beaker',
    'Beaker',
    'The all-rounder',
    250,
    'Rough marks',
    'Wide · flat base',
    'Hold, stir, heat and pour liquids. Its marks are only a rough guide, '
        'so never use it for exact amounts.',
    'assets/images/beaker.jpg',
  ),
  Glassware(
    'Graduated cylinder',
    'Cylinder',
    'The precise one',
    100,
    'Precise marks',
    'Tall · narrow',
    'Measure the volume of a liquid accurately. Read the scale at eye '
        'level, at the bottom of the liquid curve.',
    'assets/images/cylinder.jpg',
  ),
  Glassware(
    'Conical flask',
    'Flask',
    'The swirler',
    250,
    'Rough marks',
    'Narrow neck',
    'The narrow neck lets you swirl a liquid without spilling it. A '
        'favourite for titrations and reactions.',
    'assets/images/flask.jpg',
  ),
];

class VesselPage extends StatefulWidget {
  const VesselPage({super.key});

  @override
  State<VesselPage> createState() => _VesselPageState();
}

class _VesselPageState extends State<VesselPage> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/lab_bench.jpg', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(4, 18, 32, 0.62)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header(),
                      const SizedBox(height: 24),
                      picker(),
                      const SizedBox(height: 20),
                      infoCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: glass(
            radius: 28,
            padding: EdgeInsets.zero,
            child: const Center(child: Icon(Icons.science, size: 28)),
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VESSEL',
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 6),
            ),
            Text('Lab glassware, explained',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  Widget picker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [for (int i = 0; i < vessels.length; i++) pickItem(i)],
    );
  }

  Widget pickItem(int i) {
    final bool on = i == selected;
    return GestureDetector(
      onTap: () => setState(() => selected = i),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: on ? 88 : 68,
            height: on ? 88 : 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: on ? Colors.white : Colors.white38,
                width: on ? 3 : 1.5,
              ),
              image: DecorationImage(
                image: AssetImage(vessels[i].photo),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            vessels[i].short,
            style: TextStyle(
              fontSize: 12,
              fontWeight: on ? FontWeight.bold : FontWeight.normal,
              color: on ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget infoCard() {
    final Glassware v = vessels[selected];
    return glass(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: ClipOval(
              key: ValueKey(selected),
              child: Image.asset(
                v.photo,
                width: 190,
                height: 190,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            v.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            v.tagline,
            style: const TextStyle(
                color: Colors.cyanAccent, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              chip(Icons.opacity, '${v.capacity} mL'),
              chip(Icons.straighten, v.accuracy),
              chip(Icons.category, v.shape),
            ],
          ),
          const SizedBox(height: 14),
          Text(v.tip,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }

  Widget glass({
    required Widget child,
    double radius = 28,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.14),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.4),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
