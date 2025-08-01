import 'package:flutter/material.dart';
import 'package:todo_task/home_page.dart';
import 'package:todo_task/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
    static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
    );
  
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    @override
    void dispose() {
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
    }

    Future<void> loginWithEmailAndPassword() async {
        try {
            /*final userCredential = */ // uncomment this is you want access of user credentials
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
            );

            // Show success message using a SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Logged In Successfully!'), // Success message
                    backgroundColor: Colors.green, // Green background for success
                    duration: Duration(seconds: 3), // Show for 2 seconds
                ),
            );

            // Navigate to Home Page
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
            );
        } on FirebaseAuthException catch (e) { // Handle specific Firebase authentication errors            
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(e.message ?? 'An error occurred'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                ),
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            
            appBar: AppBar(),

            body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text(
                                'Sign In.',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                    hintText: 'Email',
                                ),
                            ),
                            
                            const SizedBox(height: 15),
                            
                            TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: 'Password',
                                ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            ElevatedButton(
                                onPressed: () async {
                                    await loginWithEmailAndPassword();
                                },
                                
                                child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                    ),
                                ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            GestureDetector(
                                onTap: () {
                                    Navigator.push(context, SignUpPage.route());
                                },
                                
                                child: RichText(
                                    text: TextSpan(
                                        text: 'Don\'t have an account? ',
                                        style: Theme.of(context).textTheme.titleMedium,
                                        children: [
                                            TextSpan(
                                                text: 'Sign Up',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
