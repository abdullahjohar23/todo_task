import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:todo_task/utils.dart';

class AddNewTask extends StatefulWidget {
    const AddNewTask({super.key});

    @override
    State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    Color _selectedColor = Colors.blue;
    File? file;

    @override
    void dispose() {
        titleController.dispose();
        descriptionController.dispose();
        super.dispose();
    }

    Future<void> uploadTaskToDb() async {
        try {
            /*final data = */ // uncomment this is you want access of data
            await FirebaseFirestore.instance.collection('tasks').add({
                'title': titleController.text.trim(),
                'description': descriptionController.text.trim(),
                'date': selectedDate,
                'creator': FirebaseAuth.instance.currentUser!.uid, // this line is to fethc only the data of a single user. this is generate a id matching with the id in the authentication in firebase
                'postedAt': FieldValue.serverTimestamp(),
                'color': rgbToHex(_selectedColor),
            });

            // Show added message using a SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Added Successfully!'), // Success message
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
            appBar: AppBar(
                title: const Text('Add New Task'),
                actions: [
                    GestureDetector(
                        onTap: () async {
                            final selDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                const Duration(days: 90),
                                ),
                            );
                            if (selDate != null) {
                                setState(() {
                                selectedDate = selDate;
                                });
                            }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                DateFormat('MM-d-y').format(selectedDate),
                            ),
                        ),
                    ),
                ],
            ),
            
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        children: [
                            // UNCOMMENT THIS in Firebase Storage section!
                            /*
                            GestureDetector(
                                onTap: () async {
                                    final image = await selectImage();
                                    setState(() {
                                        file = image;
                                    });
                                },
                                
                                child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                        ),
                                        
                                        child: file != null
                                            ? Image.file(file!)
                                            : const Center(
                                        
                                        child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                            */
                            
                            const SizedBox(height: 10),
                            
                            TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                    hintText: 'Title',
                                ),
                            ),
                            
                            const SizedBox(height: 10),
                            
                            TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                    hintText: 'Description',
                                ),
                                maxLines: 3,
                            ),
                            
                            const SizedBox(height: 10),
                            
                            ColorPicker(
                                pickersEnabled: const {
                                    ColorPickerType.wheel: true,
                                },
                                color: Colors.blue,
                                onColorChanged: (Color color) {
                                    setState(() {
                                        _selectedColor = color;
                                    });
                                },
                                heading: const Text('Select color'),
                                subheading: const Text('Select a different shade'),
                            ),
                            
                            const SizedBox(height: 10),
                            
                            ElevatedButton(
                                onPressed: () async {
                                    await uploadTaskToDb();
                                },
                                child: const Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
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
