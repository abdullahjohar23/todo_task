import 'package:intl/intl.dart';
import 'package:todo_task/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_task/login_page.dart';
import 'package:todo_task/add_new_task.dart';
import 'package:todo_task/widgets/task_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_task/widgets/date_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key});

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    Future<void> signOut() async {
        bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold),),
                content: Text('Are you sure you want to sign out?'),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel', style: TextStyle(color: Colors.deepOrange),),
                    ),
                    
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Logout', style: TextStyle(color: Colors.deepOrange),),
                    ),
                ],
            ),
        );
        

        if (confirm == true) {
            try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                );

                 // Optional: Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Signed out successfully'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                    ),
                );
            } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error signing out: ${e.toString()}'),
                        duration: const Duration(seconds: 2),
                    ),
                );
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            
            appBar: AppBar(
                title: const Text('My Tasks'),
                actions: [
                    IconButton(
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddNewTask(),
                                ),
                            );
                        },
                        
                        icon: const Icon(
                            CupertinoIcons.add,
                        ),
                    ),
                ],
            ),

            body: Center(
                child: Column(
                    children: [
                        const DateSelector(),
                        
                        // FutureBuilder(
                        //     future: FirebaseFirestore.instance.collection('tasks').get(),

                        // before it was FutureBuilder, you can see the above 2 lines
                        // FutureBuilder was non real time but StreamBuilder is real time
                        
                        StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('tasks').where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                            builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                    return const Center(child: Text('No Tasks Found!'));
                                }

                                return Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                            final taskData = snapshot.data!.docs[index].data();
                                            
                                            // if you want to make it understandable
                                            // final timestamp = taskData['date'];
                                            // final dateTime = timestamp.toDate();
                                            // final formattedTime = DateFormat('hh:mm a').format(dateTime);
                                            
                                            final formattedTime = DateFormat('hh:mm a').format(taskData['date'].toDate()); // DateFormat is from intl package

                                            return Dismissible(
                                                key: ValueKey(snapshot.data!.docs[index].id),
                                                direction: DismissDirection.endToStart,
                                                background: Container(
                                                    color: Colors.red,
                                                    alignment: Alignment.centerRight,
                                                    padding: const EdgeInsets.only(right: 20),
                                                    child: const Icon(Icons.delete, color: Colors.white),
                                                ),
                                                
                                                confirmDismiss: (direction) async {
                                                    if (direction == DismissDirection.endToStart) {
                                                        return await showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                                title: const Text('Delete Task'),
                                                                content: const Text('Are you sure you want to delete this task?'),
                                                                actions: [
                                                                    TextButton(
                                                                        onPressed: () => Navigator.of(context).pop(false),
                                                                        child: const Text('Cancel', style: TextStyle(color: Colors.deepOrange),),
                                                                    ),
                                                                    
                                                                    TextButton(
                                                                        onPressed: () => Navigator.of(context).pop(true),
                                                                        child: const Text('Delete', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),),
                                                                    ),
                                                                ],
                                                            ),
                                                        );
                                                    }
                                                    
                                                    return false;
                                                },
                                                
                                                onDismissed: (direction) async {
                                                    final docId = snapshot.data!.docs[index].id;
                                                    await FirebaseFirestore.instance.collection('tasks').doc(docId).delete();
                                                },

                                                child: Row(
                                                    children: [
                                                        Expanded(
                                                            child: TaskCard(
                                                                color: hexToColor(taskData['color']),
                                                                headerText: taskData['title'],
                                                                descriptionText: taskData['description'],
                                                                scheduledDate: DateFormat('dd MMM yyyy').format(taskData['date'].toDate()),
                                                            ),
                                                        ),
                                                        
                                                        Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                color: strengthenColor(
                                                                    hexToColor(taskData['color']),
                                                                    0.69,
                                                                ),
                                                                shape: BoxShape.circle,
                                                            ),
                                                        ),
                                                        
                                                        Padding(
                                                            padding: const EdgeInsets.all(12.0),
                                                            child: Text(
                                                                formattedTime,
                                                                style: const TextStyle(fontSize: 17),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            );
                                        },
                                    ),
                                );
                            },
                        ),
                    ],
                ),
            ),

            // logout button
            floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 30, right: 20),
                
                child: FloatingActionButton(
                    backgroundColor: Colors.deepOrange,
                    
                    onPressed: (() {
                        signOut();
                    }),
                    
                    child: Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                        size: 30,
                    ),
                ),
            ),
        );
    }
}
