import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatefulWidget {
   StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
final String collectionPath='/students/A7aTKfOEtsfLhsGOPw7n/contacts';

final fnCtrl=TextEditingController();

final lnCtrl=TextEditingController();

final degreeCtrl=TextEditingController();
final searchCtrl=TextEditingController();
 var studentList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebaseeeeee'),
        backgroundColor: Colors.amber,
        actions: [IconButton(onPressed: (){
          showDialog(context: context, builder: (_){
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                
                  TextField(
                    controller: fnCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('First Name')
                    ),  
                  ),
                  SizedBox(height: 8,),
                  TextField(
                    controller: lnCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text('Last Name'),
                    ),  
                  ),
                      SizedBox(height: 8,),
                  TextField(
                    controller: degreeCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text('Degree')
                    ),  
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text('Cancel')),
                ElevatedButton(onPressed: doAdd, child: Text('Add'))
              ],
            );
          });
        }, icon: Icon(Icons.add))],
      ),
      body: Column(
        children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),suffixIcon: Icon(Icons.search)
                      ),
                      
                      onChanged: (value) {
                 searchCtrl.text=value;
                setState(() {
                  
                });
                      },
                    ),
            ),
          Expanded(
            child: StreamBuilder(stream:searchCtrl.text!=''? FirebaseFirestore.instance.collection(collectionPath).where('fn',isEqualTo: searchCtrl.text).snapshots():FirebaseFirestore.instance.collection(collectionPath).snapshots(), builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
               return Center(child: CircularProgressIndicator());
              }
              if(snapshot.data==null){
                return Text('No records');
              }
              var documents=snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (_,index){
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance.collection(collectionPath).doc(documents[index].id).delete();
                    setState(() {
                      
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${documents[index]['pnum']}'),
                      // subtitle: Text('${documents[index]['degree']}'),
                    ),
                  ),
                );
              });
            }),
          ),
        ],
      ),
    );
  }

  void doAdd() {
FirebaseFirestore.instance.collection(collectionPath).add({
  'fn':fnCtrl.text,
'ln':lnCtrl.text,'degree':degreeCtrl.text,
});

setState(() {
  
});
Navigator.of(context).pop();
  }
}