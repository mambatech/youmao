import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youmao/home.dart';
import 'package:youmao/home_page.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:redux/redux.dart';

class SplashScreen extends StatefulWidget {

  Store<GlobalAppState> globalStore;

  SplashScreen(this.globalStore);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SplashState(globalStore);
  }
}

class SplashState extends State<SplashScreen> {
  var mIsLoading = false;
  Store<GlobalAppState> globalStore;

  SplashState(this.globalStore);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: new Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/launch.png", height:200, width: 200, fit: BoxFit.cover,),

                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5),
                child: Text(
                  "友猫",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: mIsLoading ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ):Container(),
                ),
              ),
              Text("Seting up...",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }

  loadData() async {
    setState(() {
      mIsLoading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
        return new HomeManagerWidget(globalStore);
      }));
    });
  }
}