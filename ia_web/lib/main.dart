import 'package:flutter/material.dart';
import 'package:ia_web/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://xmolryumlhfuxhfuqrty.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhtb2xyeXVtbGhmdXhoZnVxcnR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTk4OTkxODQsImV4cCI6MTk3NTQ3NTE4NH0.e_f9ha8I_o3zUBO9gWCsh2ab0jZzihYwKz4QT6aaLu8',
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: generateRoute,
      initialRoute: 'home',
    );
  }
}
