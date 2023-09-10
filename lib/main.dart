import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  LoadData();
  runApp(
    MaterialApp(
      title: 'Lap Times',
      home: HomePage(),
    ),
  );
}

class LapTime extends StatelessWidget{
  String time;
  String name;
  String car;
  String track;

  LapTime(this.time, this.name, this.car, this.track);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 228, 128, 22),
            width: 5,
          ),
          color: Color.fromARGB(255, 228, 128, 22),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(
              car + " - " + track,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lap Times'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 228, 128, 22),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 16,),
            //I want to display the laps here
            //I have a function that returns a column of widgets
            //I want to display that column here
            //I have tried calling the function here but it doesn't work
            //How do I display the column of widgets here?
            getLapData(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => TimePage()),
              );
            },
            backgroundColor: Color.fromARGB(255, 228, 128, 22),
            child: Icon(
              Icons.add,
              size: 36,
            ),
          ),
          SizedBox(height: 16,),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                getLapData();
              });
            },
            backgroundColor: Color.fromARGB(255, 228, 128, 22),
            child: Icon(
              Icons.refresh,
              size: 36,
            ),
          ),
        ],
      ),
    );
    
  }
}

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePage();
}

class _TimePage extends State<TimePage>{
  final timeInputController = TextEditingController();
  final nameInputController = TextEditingController();
  final carInputController = TextEditingController();
  final trackInputController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Lap Time'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 228, 128, 22),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: TextFormField(
                  controller: timeInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '00:00:00',
                  ),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: TextFormField(
                  controller: nameInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Driver name',
                  ),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: TextFormField(
                  controller: carInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Car name',
                  ),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: TextFormField(
                  controller: trackInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Track name',
                  ),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                
                child: ElevatedButton(
                  onPressed: () {
                    SaveData(
                      context, 
                      timeInputController.text,
                      nameInputController.text,
                      carInputController.text,
                      trackInputController.text,
                      );
                      LoadData();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 228, 128, 22),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void SaveData(context, timeText, nameText, carText, trackText) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var allLapsCount = prefs.getInt('allLapsCount') ?? null;

  if(allLapsCount == null){
    await prefs.setInt('allLapsCount', 0);
    allLapsCount = 0;
  }

  var lap = carText + "-" + trackText + "-" + timeText + "-" + nameText;

  prefs.setString('lap$allLapsCount', lap);

  Navigator.pop(context);
}

var allLaps = [];

void LoadData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var allLapsCount = prefs.getInt('allLapsCount') ?? 0;

  allLapsCount = allLapsCount.toInt();

  for (var i = 0; i < allLapsCount; i++) {
    var lap = prefs.getString('lap$i').toString();

    var lapSplit = [];
    if(lap == false){
      break;
    }else{
      lapSplit = lap.split('-');
      print(lapSplit);
    }

    allLaps[i] = [lapSplit[2], lapSplit[3], lapSplit[0], lapSplit[1]];  
  }
}

Widget getLapData(){
  var allLapsCount = allLaps.length;
  var allLapsList = Column();
  print(allLaps);

  if(allLapsCount < 1){
    allLapsList = Column(
      children: [
        Text(
          "No laps to show",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }else{
    for (var i = 0; i < allLapsCount; i++) {
      allLapsList.children.add(
        LapTime(
          allLaps[i][2],
          allLaps[i][3],
          allLaps[i][0],
          allLaps[i][1],
        ),
      );
    }
  }

  print("Load data has been called");

  return allLapsList;
}