import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:urban_assignment/utils/screens/login_screen.dart';
import 'package:urban_assignment/utils/widgets/button.dart';

class StreaksScreen extends StatefulWidget {
  const StreaksScreen({super.key});

  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  String _selectedInterval = '1D';
  final Map<String, List<FlSpot>> _chartData = {
    '1D': [
      const FlSpot(0, 3),
      const FlSpot(0.3, 3),
      const FlSpot(0.8, 2),
      const FlSpot(1.2, 4),
      const FlSpot(1.6, 3),
      const FlSpot(2, 4),
      const FlSpot(2.4, 5),
      const FlSpot(3.6, 3),
      const FlSpot(3.7, 5),
      const FlSpot(5, 4),
    ],
    '1W': [
      const FlSpot(0, 1),
      const FlSpot(0.3, 2),
      const FlSpot(0.5, 2),
      const FlSpot(1.2, 4),
      const FlSpot(1.6, 3),
      const FlSpot(2, 4),
      const FlSpot(2.4, 5),
      const FlSpot(2.8, 4),
      const FlSpot(3.2, 1),
      const FlSpot(3.6, 2),
      const FlSpot(4, 5),
    ],
    '1M': [
      const FlSpot(0, 2),
      const FlSpot(0.3, 3),
      const FlSpot(0.7, 2),
      const FlSpot(1.2, 4),
      const FlSpot(1.6, 3),
      const FlSpot(2, 4),
      const FlSpot(2.3, 5),
      const FlSpot(3.5, 3),
      const FlSpot(3.7, 5),
      const FlSpot(5, 4),
    ],
    '3M': [
      const FlSpot(0, 2),
      const FlSpot(0.3, 3),
      const FlSpot(0.7, 2),
      const FlSpot(1.3, 4),
      const FlSpot(1.6, 3),
      const FlSpot(2, 4),
      const FlSpot(2.3, 5),
      const FlSpot(2.5, 3),
      const FlSpot(3.7, 5),
      const FlSpot(5, 4),
      const FlSpot(5, 4),
    ],
    '1Y': [
      const FlSpot(0, 1),
      const FlSpot(0.4, 3),
      const FlSpot(0.8, 2),
      const FlSpot(1.2, 4),
      const FlSpot(1.6, 3),
      const FlSpot(2, 4),
      const FlSpot(2.4, 5),
      const FlSpot(2.8, 4),
      const FlSpot(3.2, 1),
      const FlSpot(3.6, 2),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Streaks',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        _logoutButton(screenWidth),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      "Today's Goal: 3 streak days",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    StreamBuilder<int>(
                      stream: getTrueCountStream(),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return _streakDaysCard(screenHeight, screenWidth, count);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    StreamBuilder<int>(
                      stream: getTrueCountStream(),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return _dailySticks(screenHeight, count);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _graphChart(screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Keep it up! You're on a roll.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    MyButton(
                      title: "Get Started",
                      textColor: Colors.black,
                      onTap: () {},
                      bgColor: const Color.fromRGBO(242, 232, 235, 1),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _streakDaysCard(double screenHeight, double screenWidth, int count) {
    return SizedBox(
      width: screenWidth * 0.9, // Adjust the width percentage as needed
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color.fromRGBO(242, 232, 235, 1),
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Streak Days',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dailySticks(double screenHeight, int count) {
    return Container(
      padding: EdgeInsets.all(screenHeight * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Streak',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Row(
            children: [
              Text(
                'Last 30 Days ',
                style: TextStyle(
                    color: Color.fromRGBO(150, 79, 102, 1),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '+ 100%',
                style: TextStyle(
                    color: Color.fromRGBO(8, 135, 89, 1),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _graphChart(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      // Adjust horizontal padding
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.2,
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _chartData[_selectedInterval] ?? [],
                  isCurved: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7C4DFF).withOpacity(0.5),
                        const Color(0xFF7C4DFF).withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  color: const Color(0xFF7C4DFF),
                  barWidth: 3,
                ),
              ],
            )),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _intervalButton('1D', screenWidth),
              _intervalButton('1W', screenWidth),
              _intervalButton('1M', screenWidth),
              _intervalButton('3M', screenWidth),
              _intervalButton('1Y', screenWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _intervalButton(String label, double screenWidth) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedInterval = label;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: _selectedInterval == label
                  ? const Color.fromRGBO(150, 79, 102, 1)
                  : Colors.amber),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                color: _selectedInterval == label ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(double screenWidth) {
    return IconButton(
      icon: const Icon(Icons.logout),
      color: const Color.fromRGBO(124, 77, 255, 1),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Get.to(() => const LoginScreen());
      },
    );
  }

  Stream<int> getTrueCountStream() {
    return FirebaseFirestore.instance
        .collection('skincare_routines')
        .where('isChecked', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      print('Document count: ${snapshot.docs.length}'); // Debug line
      return snapshot.docs.length;
    });
  }
}
