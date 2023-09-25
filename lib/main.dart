import 'dart:developer';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_meet_sdk/google_meet_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final CLINT_ID="387471976059-59099bmd4phc6g6m3t9ha2dm8hks2q0r.apps.googleusercontent.com";
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{

          await  GoogleSignIn().signOut();
          var user=await signInWithGoogle(context: context);
          if(user!=null)
            {
              CalendarClient() .insert(title: "test edzzat",
                  description: "cdurrentDesc" ?? '',
                  location: "badnha",
                  attendeeEmailList: ["zizoezzatan3@gmail.com"],
                  shouldNotifyAttendees: true,
                  hasConferenceSupport: true,
                  startTime: DateTime.now().add(Duration(hours: 1)),
                  endTime: DateTime.now().add(Duration(hours: 2))
              ).then((value) {
                log(value.toString());
              }).onError((error, stackTrace) {
                print(error.toString());
              });
            }




        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

   Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    var clientId = "767470877429-lfa087p8c3biol2mv326jp7m064j83fu.apps.googleusercontent.com";


    final GoogleSignIn googleSignIn = GoogleSignIn(
    //clientId: clientId,
      scopes: <String>[
        cal.CalendarApi.calendarScope,
        cal.CalendarApi.calendarEventsScope,
      ],
    );
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      print(googleSignInAccount.toString());
      final GoogleAPIClient httpClient =
      GoogleAPIClient(await googleSignInAccount.authHeaders);
      CalendarClient.calendar = cal.CalendarApi(httpClient);

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print(credential.toString());
      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print(

              'The account already exists with a different credential');
        } else if (e.code == 'invalid-credential') {
          print(

              'Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        print(
            'Error occurred using Google Sign In. Try again.');
      }
    }

    return user;
  }

}
