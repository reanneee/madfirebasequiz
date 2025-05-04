import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  String collectionPath = "studentsInfo";

  var namectrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Column(
                      children: [TextField(controller: namectrl)],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(collectionPath)
                              .where('name', isEqualTo: namectrl.text)
                              .get()
                              .then((querySnapshot) {
                                if (querySnapshot.docs.isNotEmpty) {
                                  var doc = querySnapshot.docs.first;
                                  var counter = doc['quantity'] + 1 ?? 0;

                                  doc.reference.update({'quantity': counter});
                                } else {
                                  FirebaseFirestore.instance
                                      .collection(collectionPath)
                                      .add({
                                        'name': namectrl.text,
                                        'quantity': 1,
                                      });
                                }
                                setState(() {});
                                Navigator.pop(context);
                              });
                        },
                        child: Text('add'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection(collectionPath).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return Text('No data');
          }
          var document = snapshot.data!.docs;
          return ListView.builder(
            itemCount: document.length,
            itemBuilder: (_, index) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection(collectionPath)
                      .doc(document[index].id)
                      .delete();
                  setState(() {});
                },
                child: Card(
                  child: ListTile(
                    title: Text(document[index]['name']),

                    leading: CircleAvatar(
                      radius: 15,
                      child: Text('${document[index]['quantity']}'),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          namectrl.text = document[index]['name'];
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [TextField(controller: namectrl)],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection(collectionPath)
                                      .doc(document[index].id)
                                      .update({
                                        'name': namectrl.text,
                                        'quantity': document[index]['quantity'],
                                      });

                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: Text('Update'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
