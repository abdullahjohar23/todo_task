import 'package:flutter/material.dart';
import 'package:todo_task/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
    static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
    );
    
    const SignUpPage({super.key});

    @override
    State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    @override
    void dispose() {
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
    }

    Future<void> createUserWithEmailAndPassword() async {
        try {
            /*final userCredential = */ // uncomment this is you want access of user credentials
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
            );

            // Show success message using a SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Account created successfully!'), // Success message
                    backgroundColor: Colors.green, // Green background for success
                    duration: Duration(seconds: 3), // Show for 2 seconds
                ),
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

            body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text(
                                'Sign Up.',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),

                            const SizedBox(height: 10),
                            const SizedBox(height: 20),
                            
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
                                    await createUserWithEmailAndPassword();
                                },
                                child: const Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                    ),
                                ),
                            ),

                            const SizedBox(height: 20),
                            
                            GestureDetector(
                                onTap: () {
                                    Navigator.push(context, LoginPage.route());
                                },
                                
                                child: RichText(
                                    text: TextSpan(
                                        text: 'Already have an account? ',
                                        style: Theme.of(context).textTheme.titleMedium,
                                        children: [
                                            TextSpan(
                                                text: 'Sign In',
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
