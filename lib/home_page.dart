import 'package:todo_task/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_task/add_new_task.dart';
import 'package:todo_task/widgets/task_card.dart';
import 'package:todo_task/widgets/date_selector.dart';

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
                        Expanded(
                            child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                    return Row(
                                        children: [
                                            const Expanded(
                                                child: TaskCard(
                                                    color: Color.fromRGBO(246, 222, 194, 1),
                                                    headerText: 'My humor upsets me XD',
                                                    descriptionText: 'My humor not that great:(',
                                                    scheduledDate: '69th August, 4020',
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
                        ),
                    ],
                ),
            ),
        );
    }
}