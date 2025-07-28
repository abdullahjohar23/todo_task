import 'package:todo_task/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
                            stream: FirebaseFirestore.instance.collection('tasks').where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(), // ".where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)" is added to fetch the data of a single user
                            builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(),
                                    );
                                }

                                if (!snapshot.hasData) {
                                    return const Text('No Data Here!');
                                }

                                return Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                            return Row(
                                                children: [
                                                    Expanded(
                                                        child: TaskCard(
                                                            color: hexToColor(snapshot.data!.docs[index].data()['color'],),
                                                            headerText: snapshot.data!.docs[index].data()['title'],
                                                            descriptionText: snapshot.data!.docs[index].data()['description'],
                                                            scheduledDate: snapshot.data!.docs[index].data()['date'].toString(),
                                                        ),
                                                    ),
                                                    
                                                    Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(
                                                            color: strengthenColor(
                                                                const Color.fromRGBO(246, 222, 194, 1),
                                                                0.69,
                                                            ),
                                                            shape: BoxShape.circle,
                                                        ),
                                                    ),
                                                    
                                                    const Padding(
                                                        padding: EdgeInsets.all(12.0),
                                                        child: Text(
                                                            '10:00AM',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                            ),
                                                        ),
                                                    ),
                                                ],
                                            );
                                        },
                                    ),
                                );
                            }
                        ),
                    ],
                ),
            ),
        );
    }
}
