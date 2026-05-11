import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController cityController = TextEditingController();

  String cityName = '';
  String temperature = '';
  String weatherDescription = '';
  String message = '도시 이름을 입력하고 날씨를 검색하세요.';
  bool isLoading = false;

  final String apiKey = '여기에_API_KEY를_입력하세요';

  Future<void> getWeather() async {
    String city = cityController.text;

    if (city.isEmpty) {
      setState(() {
        message = '도시 이름을 입력해주세요.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = '날씨 정보를 가져오는 중입니다...';
    });

    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=kr';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          cityName = data['name'];
          temperature = data['main']['temp'].toString();
          weatherDescription = data['weather'][0]['description'];
          message = '날씨 정보 조회 성공';
          isLoading = false;
        });
      } else {
        setState(() {
          message = '요청 실패: ${response.statusCode}\n${response.body}';
          cityName = '';
          temperature = '';
          weatherDescription = '';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = '오류가 발생했습니다.';
        cityName = '';
        temperature = '';
        weatherDescription = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        title: const Text('Flutter 날씨앱'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: '도시 이름 입력',
                hintText: '예: Seoul, Tokyo, Beijing',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: getWeather,
              child: const Text('날씨 검색'),
            ),

            const SizedBox(height: 32),

            if (isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  Text(
                    message,
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 24),

                  if (cityName.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            cityName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$temperature ℃',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            weatherDescription,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}