import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Dive Into Your Profound Journey Of Wellness",
      "description":
          "Track your medications with ease and stay consistent on your wellness journey.",
      "image": "images/healthmvp.jpeg",
    },
    {
      "title": "Achieve More With Alerts: Stay Ahead Of The Curve",
      "description":
          "Timely alerts ensure you never miss a dose, even on your busiest days.",
      "image": "images/healthmvp.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (int index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(50),
                          child: Image.asset(
                            onboardingData[index]['image']!,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            onboardingData[index]['title']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            onboardingData[index]['description']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circularButton(
                                Icons.arrow_back,
                                Colors.white,
                                _currentPage > 0
                                    ?  Colors.deepPurple
                                                                        : Colors.deepPurple.shade100,
                                _currentPage > 0
                                    ? () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.ease,
                                      );
                                    }
                                    : null,
                              ),
                              Row(
                                children: List.generate(
                                  onboardingData.length,
                                  (i) => _indicator(_currentPage == i),
                                ),
                              ),
                              _circularButton(
                                Icons.arrow_forward,
                                Colors.white,
                          _currentPage < 0
                                    ?  Colors.deepPurple.shade100
                                                                        : Colors.deepPurple,
                                _currentPage < onboardingData.length - 1
                                    ? () {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.ease,
                                      );
                                    }
                                    : () {
                                      context.go('/loginscreen');
                                    },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              top: 10,
              right: 20,
              child: TextButton(
                onPressed: () => context.go('/loginscreen'),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circularButton(
    IconData icon,
    Color iconColor,
    Color bgColor,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
