import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int groupValue = 0;
  List<Map<dynamic, dynamic>> answered = [];

  bool loading = false;
  List value = [];
  List<Map<dynamic, dynamic>> questions = [
    { 
      0:{
        "question": "1 + 1",
        "answers": [
          {
            "id": 1,
            "sign": 1,
            "answer": "A. 2",
            "isanswer": true
          },
          {
            "id": 2,
            "sign": 1,
            "answer": "B. 4",
            "isanswer": false
          },
          {
            "id": 3,
            "sign": 1,
            "answer": "C. 5",
            "isanswer": false
          }
        ]
      },
    },
    {
      1:{
        "question": "2 + 2",
        "answers": [
          {
            "id": 1,
            "sign": 2,
            "answer": "A. 3",
            "isanswer": false
          },
          {
            "id": 2,
            "sign": 2,
            "answer": "B. 4",
            "isanswer": true
          },
          {
            "id": 3,
            "sign": 2,
            "answer": "C. 5",
            "isanswer": false
          }
        ]
      },
    },
    {
      2:{
        "question": "4 + 2",
        "answers": [
          {
            "id": 1,
            "answer": "A. 6",
            "sign": 3,
            "isanswer": true
          },
          {
            "id": 2,
            "answer": "B. 8",
            "sign": 3,
            "isanswer": false
          },
          {
            "id": 3,
            "answer": "C. 10",
            "sign": 3,
            "isanswer": false
          }
        ]
      }
    }
  ];

  @override
  void initState() {
    super.initState();
    loading = true;
    Future.delayed(Duration(seconds: 1), () {
      for (var i = 0; i < questions.length; i++) {
        setState(() {
          value.add(null);          
          loading = false;       
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose the correct answer by fill circle", 
          style: TextStyle(
            fontSize: 17.0
          ),
        ),
      ),
      body:  loading 
      ? Center(
          child: CircularProgressIndicator(),
        ) 
      :
      ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: questions.length,
            itemBuilder: (BuildContext context, int i) { 
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: .8,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${i + 1}. ${questions[i][i]["question"].toString()}"),
                        SizedBox(height: 8.0),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: questions[i][i]["answers"].length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int z) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  value: int.parse("$i$z"),
                                  groupValue: value[i],
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (index) {
                                    setState(() => value[i]= index);          
                                    answered.add({
                                      "id": questions[i][i]["answers"][z]["id"], 
                                      "sign": questions[i][i]["answers"][z]["sign"],
                                      "answered": questions[i][i]["answers"][z]["isanswer"]
                                    });    
                                  },  
                                  title: Text(questions[i][i]["answers"][z]["answer"],
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },  
          ),

      

          // Submit Button
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {     

              Map<dynamic, dynamic> mp = {};
              for (var item in answered) {
                mp[item["sign"]] = item;
              }

              var filteredList = mp.values.toList();
              int wrongAnswer = filteredList.where((element) => element["answered"] == false).length;
              int correctAnswer = filteredList.where((element) => element["answered"] == true).length;
              String point = (filteredList.where((element) => element["answered"] == true).length / value.length * 100).toStringAsFixed(0);      

              // Show Pop Up
              showModalBottomSheet(
                context: context, 
                builder: (context) {
                  return Container(
                    height: 250.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        if(int.parse(point) > 70)
                          Container(
                            child: Text("YOU PASSED!",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.green
                              ),
                            ),
                          ),
                        if(int.parse(point) < 70) 
                          Container(
                            child: Text("YOU FAIL!",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.red
                              ),
                            ),
                          ),
                        
                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text("Score : "),
                            ),
                            Container(
                              child: Text(point.toString())
                            )
                          ],
                        ),

                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text("Correct Answer : ",
                                style: TextStyle(
                                  color: Colors.green
                                ), 
                              ),
                            ),
                            Container(
                              child: Text(correctAnswer.toString())
                            )
                          ],
                        ),

                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text("Wrong Answer : ",
                                style: TextStyle(
                                  color: Colors.red
                                ), 
                              ),
                            ),
                            Container(
                              child: Text(wrongAnswer.toString())
                            )
                          ],
                        ),

                      ]
                    ),
                  );
                });
              },
              child: Text("Submit"),
            ),
          )


        ],
      )
    );
  }
}
