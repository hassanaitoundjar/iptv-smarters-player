import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Simple main function for diagnostic purposes
void main() {
  try {
    print("DEBUG: Starting simplified app");
    WidgetsFlutterBinding.ensureInitialized();
    print("DEBUG: Flutter binding initialized");
    
    // Enable system UI for visibility
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, 
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]
    );
    print("DEBUG: System UI enabled");
    
    print("DEBUG: Running simplified app");
    runApp(const SimpleApp());
    print("DEBUG: Simple app started successfully");
  } catch (e, stackTrace) {
    print("ERROR during app initialization: $e");
    print("Stack trace: $stackTrace");
  }
}

// A very simple app for diagnostic purposes
class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Building SimpleApp widget");
    return MaterialApp(
      title: 'Azul IPTV - Diagnostic',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const DiagnosticScreen(),
    );
  }
}

// A simple diagnostic screen
class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  @override
  void initState() {
    super.initState();
    print("DEBUG: DiagnosticScreen initState called");
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Building DiagnosticScreen widget");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Azul IPTV - Diagnostic'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'App is running!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Screen size: ${MediaQuery.of(context).size.width.toStringAsFixed(1)} x ${MediaQuery.of(context).size.height.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button pressed!'))
                );
              },
              child: const Text('Test Button'),
            ),
          ],
        ),
      ),
    );
  }
}
