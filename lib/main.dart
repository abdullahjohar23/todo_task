import 'package:flutter/material.dart';
import 'package:todo_task/home_page.dart';
import 'package:todo_task/signup_page.dart';
import 'package:todo_task/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Task Management',
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
                fontFamily: 'Cera Pro',
                
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                        ),
                    ),
                ),

                inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.all(27),
                    
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                    ),
                    
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            // color: Pallete.gradient2,
                            width: 3,
                        ),
                        
                        borderRadius: BorderRadius.circular(10),
                    ),
                ),
            ),

            // "FirebaseAuth.instance.currentUser" is synchronous, it's not real time
            // home: FirebaseAuth.instance.currentUser != null ? const MyHomePage() : SignUpPage(),
            
            // Stream is asynchronous i.e. continuous real time value - whever the user updates to sign in or sign out
            // now we can have real time update
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(),
                        );
                    }

                    if (snapshot.data != null) { // meaning we are logged in
                        return const MyHomePage();
                    }
                    return SignUpPage();
                }
            ),
        );
    }
}
