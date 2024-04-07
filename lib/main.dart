import 'package:flutter/material.dart';
import './history_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BMICalculator(),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              HistoryManager.clearHistory();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: HistoryManager.history.length,
        itemBuilder: (context, index) {
          final historyItem = HistoryManager.history[index];
          return ListTile(
            title: Text('Date: ${historyItem.date.toString()}'),
            subtitle: Text(
                'Height: ${historyItem.height}, Weight: ${historyItem.weight}, BMI: ${historyItem.bmi}'),
          );
        },
      ),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  double height = 0.0;
  double weight = 0.0;
  String heightUnit = 'cm';
  String weightUnit = 'kg';
  double bmi = 0.0;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              setState(() {
                height = 0.0;
                weight = 0.0;
                heightController.text = '';
                weightController.text = '';
                bmi = 0.0; // BMI değerini sıfırla
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.do_not_disturb),
            onPressed: () {
              // Buraya rahatsız etme işlemlerini ekleyebilirsiniz
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: Text('Geçmiş'),
                    value: 'Geçmiş',
                  ),
                  PopupMenuItem(
                    child: Text('Ayarlar'),
                    value: 'Ayarlar',
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value == 'Geçmiş') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                } else if (value == 'Ayarlar') {
                  // Ayarlar sayfasına git
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Height'),
                    TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your height',
                      ),
                      onTap: () {
                        setState(() {
                          heightController.text = '';
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          height = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Container(
                width: 100.0,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unit'),
                    DropdownButton<String>(
                      value: heightUnit,
                      onChanged: (value) {
                        setState(() {
                          heightUnit = value!;
                        });
                      },
                      items: <String>['cm', 'in'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight'),
                    TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your weight',
                      ),
                      onTap: () {
                        setState(() {
                          weightController.text = '';
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          weight = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Container(
                width: 100.0,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unit'),
                    DropdownButton<String>(
                      value: weightUnit,
                      onChanged: (value) {
                        setState(() {
                          weightUnit = value!;
                        });
                      },
                      items:
                          <String>['kg', 'lbs', 'stones'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              double heightInMeter = height;
              double weightInKg = weight;

              if (heightUnit == 'in') {
                heightInMeter = height * 2.54; // inçi santimetreye çevir
              }

              if (weightUnit == 'lbs') {
                weightInKg = weight * 0.453592; // pound'u kilograma çevir
              }

              double newBMI =
                  weightInKg / ((heightInMeter / 100) * (heightInMeter / 100));
              setState(() {
                bmi = newBMI;
              });

              // Add to history
              HistoryManager.addHistory(height, weight, newBMI);
            },
            child: Text('Calculate'),
          ),
          SizedBox(height: 16.0),
          Text(
            'BMI: ${bmi.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
