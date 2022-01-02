import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: firstpage()
    );
  }
}



class firstpage extends StatefulWidget {


  @override
  _firstpageState createState() => _firstpageState();
}


class _firstpageState extends State<firstpage> {
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  child: CircleAvatar(
                    radius:60,
                    backgroundImage: AssetImage('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 30.0,

                ),
                SingleChildScrollView(
                  child: Container(

                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, right: 35,top:10),
                          child: Column(
                            children: [

                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              ElevatedButton(
                                child: Text ("Login"),
                                onPressed: () async{
                                  await _googleSignIn.signIn().then((userData){
                                    setState((){
                                      _isLoggedIn= true;
                                      if(_isLoggedIn== true)
                                      {_userObj=userData!;
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (_)=> SecondPage()));
                                      }

                                    });
                                  }).catchError((e){
                                    print(e);
                                  });

                                },
                              ),



                            ],
                          ),

                        ),

                      ],
                    ),
                  ),
                ),

              ]
          )
      ),
    );


  }
}

class SecondPage extends StatefulWidget {

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("                     HomePage",
            style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body:Container(
        alignment: Alignment(0.0,-0.5),

        margin:EdgeInsets.all(10),
        child: Row(

          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(child: (Text('HELP A STRAY',
                style:TextStyle(color:Colors.black,
                    fontWeight:FontWeight.bold))),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                side:BorderSide(width:3),
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize:Size(150,150),

              ),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Thirdpage()));
              },
            ),
            ElevatedButton(child: Text('DONATE',
                style:TextStyle(color:Colors.black,
                    fontWeight:FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                side:BorderSide(width:3),
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                minimumSize:Size(150,150),

              ),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Fourthpage()));
              },
            ),
          ],
        ),
      ),


    );
  }
}
class Thirdpage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
class Fourthpage extends StatefulWidget {
  @override
  _FourthpageState createState() => _FourthpageState();
}

class _FourthpageState extends State<Fourthpage> {

  late Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(){
    var options = {
      "key" : "[YOUR_API_KEY]",
      "amount" : num.parse(textEditingController.text)*100,
      "name" : "HELP A STRAY ",
      "description" : "Payment for the some random product",
      "prefill" : {
        "contact" : "2323232323",
        "email" : "shdjsdh@gmail.com"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(){
    print("Payment success");
    Fluttertoast.showToast(msg:"Payment success");
  }

  void handlerErrorFailure(){
    print("Pament error");
    Fluttertoast.showToast(msg:"Payment error");
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Fluttertoast.showToast(msg:"External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Razor Pay "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: "amount to pay"
              ),
            ),
            SizedBox(height: 12,),
            RaisedButton(
              color: Colors.blue,
              child: Text("Donate Now", style: TextStyle(
                  color: Colors.white
              ),),
              onPressed: (){
                openCheckout();
              },
            )
          ],
        ),
      ),
    );
  }
}



