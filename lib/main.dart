import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CollectionReference employees=FirebaseFirestore.instance
      .collection('employees');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("EMPLOYEE DETAILS"),
      ),
      body: StreamBuilder(
        stream: employees.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context,index){
                final DocumentSnapshot documentSnapshot=
                    streamSnapshot.data!.docs[index];
                if(documentSnapshot['exp']>=5){
                  return Card(
                    //color: Colors.green,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black,width: 1.5),
                          gradient: LinearGradient(
                              colors: [Colors.black,Colors.black87,Colors.black54],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight
                          )
                      ),
                      child: ListTile(

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(documentSnapshot['name'],style: TextStyle(fontSize: 25,color: Colors.white),),
                            Icon(Icons.radio_button_checked_rounded,color: Colors.green,size: 28,)
                          ],
                        ),
                        subtitle: Text(documentSnapshot['address'],style: TextStyle(fontSize: 15,color: Colors.grey)),

                      ),
                    ),
                  );
                }
                else{
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black,width: 1.5),

                          gradient: LinearGradient(
                              colors: [Colors.black,Colors.black87,Colors.black54],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight
                          )
                      ),
                      child: ListTile(

                        title: Text(documentSnapshot['name'],style: TextStyle(fontSize: 25,color: Colors.white),),
                        subtitle: Text(documentSnapshot['address'],style: TextStyle(fontSize: 15,color: Colors.grey),),
                      ),
                    ),
                  );

                }

              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}



