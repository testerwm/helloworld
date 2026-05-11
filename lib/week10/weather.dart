// ============================================================
// Flutter 天气应用 - 完整修改版
// 根据「基本结构修改要点 - 团队 + AI」7项要求全面升级
// ============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

// ============================================================
// [原有] WeatherApp 根组件
// ============================================================
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [修改1 - 色彩变更] 使用 ThemeData 统一管理主题色，
    // 并引入 darkTheme 支持深色模式切换（原代码无任何主题配置）
    return ValueListenableBuilder<bool>(
      // [修改4 - 다크모드] 监听全局深色模式开关
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // [修改1 - 色彩变更] 亮色主题：主色改为深蓝绿色，原为默认蓝色
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1A6B5A), // 修改：深绿色主题色
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          // [修改4 - 다크모드] 新增深色主题，原代码无此配置
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1A6B5A),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          // [修改4 - 다크모드] 根据 darkModeNotifier 动态切换模式
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const WeatherPage(),
        );
      },
    );
  }
}

// [修改4 - 다크모드] 新增全局深色模式状态管理（原代码无此内容）
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

// ============================================================
// [原有] WeatherPage 主页面（有状态组件）
// ============================================================
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
// [修改5 - 애니메이션] 新增 TickerProviderStateMixin 支持动画控制器
// 原代码的 State 不含任何动画 mixin
    with TickerProviderStateMixin {

  // ──────────────────────────────────────────────
  // [原有] 基础状态变量
  // ──────────────────────────────────────────────
  final TextEditingController cityController = TextEditingController();
  String cityName    = '';
  String temperature = '';
  String weatherDescription = '';
  String message     = '도시 이름을 입력하고 날씨를 검색하세요.';
  bool   isLoading   = false;
  final String apiKey = 'c62c0e536dd79c603802b6075053e21a'; // [原有] API Key

  // ──────────────────────────────────────────────
  // [修改3 - 도시 추가] 新增多城市列表状态（原代码仅显示单城市）
  // ──────────────────────────────────────────────
  List<Map<String, String>> cityWeatherList = []; // 存储多个城市天气数据

  // ──────────────────────────────────────────────
  // [修改6 - 즐겨찾기] 新增收藏夹状态（原代码无收藏功能）
  // ──────────────────────────────────────────────
  List<String> favoriteList = []; // 收藏的城市名称列表

  // ──────────────────────────────────────────────
  // [修改5 - 애니메이션] 新增动画控制器（原代码无任何动画）
  // ──────────────────────────────────────────────
  late AnimationController _fadeController;  // 天气卡片渐显动画
  late AnimationController _shakeController; // 错误时抖动动画
  late Animation<double>   _fadeAnimation;
  late Animation<double>   _shakeAnimation;

  // ──────────────────────────────────────────────
  // [修改2 - 검색 기능] 新增搜索历史列表（原代码无搜索历史）
  // ──────────────────────────────────────────────
  List<String> searchHistory = []; // 最近搜索的城市历史

  // ──────────────────────────────────────────────
  // [修改] TabController - 管理「天气」/「收藏」Tab
  // ──────────────────────────────────────────────
  late TabController _tabController;

  // ──────────────────────────────────────────────
  // [修改7 - 아이콘 수정] 天气状态 → 图标映射表（原代码无天气图标）
  // ──────────────────────────────────────────────
  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear') || desc.contains('맑음') || desc.contains('晴')) {
      return Icons.wb_sunny_rounded;          // 晴天
    } else if (desc.contains('cloud') || desc.contains('구름') || desc.contains('cloudy')) {
      return Icons.cloud_rounded;             // 多云
    } else if (desc.contains('rain') || desc.contains('비')) {
      return Icons.grain_rounded;             // 雨天
    } else if (desc.contains('snow') || desc.contains('눈')) {
      return Icons.ac_unit_rounded;           // 雪天
    } else if (desc.contains('thunder') || desc.contains('storm')) {
      return Icons.thunderstorm_rounded;      // 雷雨
    } else if (desc.contains('fog') || desc.contains('mist') || desc.contains('안개')) {
      return Icons.foggy;                     // 雾
    } else if (desc.contains('wind') || desc.contains('바람')) {
      return Icons.air_rounded;               // 大风
    }
    return Icons.device_thermostat_rounded;   // 默认图标
  }

  // ──────────────────────────────────────────────
  // [修改7 - 아이콘 수정] 根据天气返回对应颜色（原代码无颜色差异化）
  // ──────────────────────────────────────────────
  Color _getWeatherColor(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear') || desc.contains('맑음')) return const Color(0xFFFFB300);
    if (desc.contains('cloud'))   return const Color(0xFF78909C);
    if (desc.contains('rain'))    return const Color(0xFF1565C0);
    if (desc.contains('snow'))    return const Color(0xFF80DEEA);
    if (desc.contains('thunder')) return const Color(0xFF6A1B9A);
    return const Color(0xFF1A6B5A); // 默认深绿
  }

  // ──────────────────────────────────────────────
  // [修改5 - 애니메이션] 初始化动画控制器（原代码无 initState 动画逻辑）
  // ──────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // 渐显动画：新卡片出现时从透明到不透明（300ms）
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // 抖动动画：搜索失败时搜索框左右摇摆（400ms）
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Tab 控制器：2个 Tab（天气列表 / 收藏夹）
    _tabController = TabController(length: 2, vsync: this);
  }

  // [修改5 - 애니메이션] 销毁动画控制器，防止内存泄漏
  @override
  void dispose() {
    _fadeController.dispose();
    _shakeController.dispose();
    _tabController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // [原有 + 修改] 核心天气请求方法
  // ──────────────────────────────────────────────
  Future<void> getWeather() async {
    String city = cityController.text.trim(); // [修改2] 去除首尾空格

    if (city.isEmpty) {
      setState(() { message = '도시 이름을 입력해주세요.'; });
      // [修改5 - 애니메이션] 输入为空时触发抖动动画提示用户
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      isLoading = true;
      message   = '날씨 정보를 가져오는 중입니다...';
    });

    // [原有] 构造 OpenWeatherMap API URL
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=kr';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // [修改3 - 도시 추가] 将结果追加到城市列表（原代码覆盖单一变量）
        final newEntry = {
          'city':        data['name'] as String,
          'temperature': data['main']['temp'].toString(),
          'description': data['weather'][0]['description'] as String,
          'humidity':    data['main']['humidity'].toString(), // [修改] 新增湿度
          'wind':        data['wind']['speed'].toString(),    // [修改] 新增风速
        };

        setState(() {
          // 防止重复添加同名城市
          cityWeatherList.removeWhere((e) => e['city'] == newEntry['city']);
          cityWeatherList.insert(0, newEntry); // 最新城市置顶

          // [修改2 - 검색 기능] 记录搜索历史（最多保留5条）
          searchHistory.remove(city);
          searchHistory.insert(0, city);
          if (searchHistory.length > 5) searchHistory.removeLast();

          cityName           = data['name'];
          temperature        = data['main']['temp'].toString();
          weatherDescription = data['weather'][0]['description'];
          message            = '날씨 정보 조회 성공';
          isLoading          = false;
        });

        // [修改5 - 애니메이션] 数据加载成功后播放渐显动画
        _fadeController.forward(from: 0);
        cityController.clear(); // [修改2] 搜索成功后清空输入框

      } else {
        setState(() {
          message            = '요청 실패: ${response.statusCode}';
          cityName           = '';
          temperature        = '';
          weatherDescription = '';
          isLoading          = false;
        });
        // [修改5 - 애니메이션] 请求失败时触发抖动动画
        _shakeController.forward(from: 0);
      }
    } catch (e) {
      setState(() {
        message            = '오류가 발생했습니다: $e';
        cityName           = '';
        temperature        = '';
        weatherDescription = '';
        isLoading          = false;
      });
      _shakeController.forward(from: 0); // [修改5] 异常时也触发抖动
    }
  }

  // ──────────────────────────────────────────────
  // [修改6 - 즐겨찾기] 收藏/取消收藏城市（原代码无此方法）
  // ──────────────────────────────────────────────
  void toggleFavorite(String city) {
    setState(() {
      if (favoriteList.contains(city)) {
        favoriteList.remove(city);   // 已收藏 → 取消收藏
      } else {
        favoriteList.add(city);      // 未收藏 → 添加收藏
      }
    });
  }

  // ──────────────────────────────────────────────
  // [修改6 - 즐겨찾기] 点击收藏城市直接查询（原代码无此方法）
  // ──────────────────────────────────────────────
  void searchFromFavorite(String city) {
    cityController.text = city;
    _tabController.animateTo(0); // 切换回天气 Tab
    getWeather();
  }

  // ──────────────────────────────────────────────
  // [原有 + 修改] UI 构建方法
  // ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // [修改4 - 다크모드] 根据当前主题获取颜色，适配亮/暗两种模式
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final bgColor     = isDark ? const Color(0xFF121212) : const Color(0xFFEAF6F2); // [修改1] 背景色改为绿色调
    final cardColor   = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor   = isDark ? Colors.white : const Color(0xFF1A3D2E);            // [修改1] 文字改深绿色

    return Scaffold(
      backgroundColor: bgColor,

      // ── AppBar ──────────────────────────────────
      appBar: AppBar(
        // [修改1 - 색彩变更] AppBar 背景使用主题绿色（原为默认蓝色）
        backgroundColor: const Color(0xFF1A6B5A),
        foregroundColor: Colors.white,
        title: const Text(
          '🌤 날씨 앱',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          // [修改4 - 다크모드] 新增深色模式切换按钮（原代码 AppBar 无任何按钮）
          ValueListenableBuilder<bool>(
            valueListenable: darkModeNotifier,
            builder: (_, isDarkMode, __) => IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDarkMode ? '라이트 모드' : '다크 모드',
              onPressed: () {
                darkModeNotifier.value = !darkModeNotifier.value;
              },
            ),
          ),
        ],
        // [修改6 - 즐겨찾기] 新增 TabBar 底部（原代码无 Tab 导航）
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.cloud), text: '날씨'),       // Tab1: 天气
            Tab(icon: Icon(Icons.favorite), text: '즐겨찾기'), // Tab2: 收藏夹
          ],
        ),
      ),

      // ── Body ────────────────────────────────────
      body: TabBarView(
        controller: _tabController,
        children: [
          // ══════════════════════════════════════
          // Tab 1: 天气搜索页面
          // ══════════════════════════════════════
          _buildWeatherTab(bgColor, cardColor, textColor, isDark),

          // ══════════════════════════════════════
          // [修改6 - 즐겨찾기] Tab 2: 收藏夹页面（全新，原代码无）
          // ══════════════════════════════════════
          _buildFavoriteTab(cardColor, textColor),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // [修改3] 天气 Tab 页面构建
  // ──────────────────────────────────────────────
  Widget _buildWeatherTab(Color bgColor, Color cardColor, Color textColor, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── 搜索栏区域 ────────────────────────
          // [修改5 - 애니메이션] AnimatedBuilder 让搜索框失败时左右抖动
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                // 偏移量：正弦波模拟左右抖动
                offset: Offset(
                  _shakeController.isAnimating
                      ? (_shakeAnimation.value * (_shakeController.value < 0.5 ? 1 : -1))
                      : 0,
                  0,
                ),
                child: child,
              );
            },
            child: Row(
              children: [
                // [修改2 - 검색 기능] 搜索框样式升级（原为简单 OutlineInputBorder）
                Expanded(
                  child: TextField(
                    controller: cityController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: '도시 이름 입력',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      hintText: '예: Seoul, Tokyo, Beijing',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                      // [修改1 - 색彩변경] 搜索框边框颜色使用主题绿色
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1A6B5A), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1A6B5A), width: 2.5),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      // [修改2] 新增搜索图标前缀
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF1A6B5A)),
                      // [修改2] 新增清除按钮后缀
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF1A6B5A)),
                        onPressed: () => cityController.clear(),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    // [修改2] 按回车直接搜索
                    onSubmitted: (_) => getWeather(),
                  ),
                ),
                const SizedBox(width: 12),
                // [修改1] 搜索按钮样式升级（原为默认 ElevatedButton）
                ElevatedButton(
                  onPressed: getWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6B5A), // 绿色背景
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('검색', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // ── [修改2] 搜索历史（原代码无此功能） ────
          if (searchHistory.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Text('최근 검색:', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 13)),
                ...searchHistory.map((city) => GestureDetector(
                  onTap: () {
                    cityController.text = city;
                    getWeather();
                  },
                  child: Chip(
                    label: Text(city, style: const TextStyle(fontSize: 12)),
                    backgroundColor: const Color(0xFF1A6B5A).withOpacity(0.15),
                    side: const BorderSide(color: Color(0xFF1A6B5A), width: 1),
                  ),
                )),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // ── 加载状态 ─────────────────────────
          // [原有] 加载指示器（样式微调）
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A6B5A)),
            )
          else ...[

            // ── [修改3 - 도시 추가] 多城市卡片列表（原代码只显示一个城市） ──
            ...cityWeatherList.map((cityData) {
              // [修改5 - 애니메이션] 每个卡片用 FadeTransition 渐显
              return FadeTransition(
                opacity: _fadeAnimation,
                // [修改5] SlideTransition：卡片从下方滑入
                child: _buildCityCard(cityData, cardColor, textColor),
              );
            }),

            // 无数据时显示提示（修改文字样式）
            if (cityWeatherList.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_queue, size: 80, color: textColor.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // [修改3 + 修改7] 单个城市天气卡片（全新设计，原代码只有简单 Container）
  // ──────────────────────────────────────────────
  Widget _buildCityCard(Map<String, String> cityData, Color cardColor, Color textColor) {
    final isFav       = favoriteList.contains(cityData['city']);
    final weatherIcon = _getWeatherIcon(cityData['description'] ?? '');   // [修改7] 图标
    final iconColor   = _getWeatherColor(cityData['description'] ?? '');  // [修改7] 颜色

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        // [修改1] 卡片添加彩色左边框（原代码无）
        border: Border(left: BorderSide(color: iconColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 城市名 + 收藏按钮 ──────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cityData['city'] ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              // [修改6 - 즐겨찾기] 收藏心形按钮（原代码无）
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.grey,
                  size: 28,
                ),
                onPressed: () => toggleFavorite(cityData['city']!),
                tooltip: isFav ? '즐겨찾기 해제' : '즐겨찾기 추가',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── 温度 + 天气图标 ────────────────────
          Row(
            children: [
              // [修改7 - 아이콘 수정] 天气图标（原代码无任何图标）
              Icon(weatherIcon, size: 52, color: iconColor),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // [原有] 温度（字号和样式调整）
                  Text(
                    '${cityData['temperature']} ℃',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: iconColor,
                    ),
                  ),
                  // [原有] 天气描述
                  Text(
                    cityData['description'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── [修改] 额外气象数据行（原代码无湿度/风速信息） ──
          Row(
            children: [
              _buildMetaChip(Icons.water_drop, '${cityData['humidity']}%', '습도'),
              const SizedBox(width: 12),
              _buildMetaChip(Icons.air, '${cityData['wind']} m/s', '풍속'),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // [修改] 气象信息小标签（湿度/风速）辅助方法（原代码无）
  // ──────────────────────────────────────────────
  Widget _buildMetaChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A6B5A).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1A6B5A)),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 13, color: Color(0xFF1A6B5A), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // [修改6 - 즐겨찾기] 收藏夹 Tab 页面（全新，原代码无）
  // ──────────────────────────────────────────────
  Widget _buildFavoriteTab(Color cardColor, Color textColor) {
    if (favoriteList.isEmpty) {
      // 收藏夹为空时的提示界面
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: textColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              '즐겨찾기한 도시가 없습니다.',
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6)),
            ),
            const SizedBox(height: 8),
            Text(
              '날씨 카드의 ♡ 버튼을 눌러 추가하세요!',
              style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.4)),
            ),
          ],
        ),
      );
    }

    // 收藏夹列表
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: favoriteList.length,
      itemBuilder: (context, index) {
        final city = favoriteList[index];
        // 查找该城市的天气数据（若已查询过）
        final weatherData = cityWeatherList.firstWhere(
              (e) => e['city'] == city,
          orElse: () => {'city': city, 'temperature': '-', 'description': '미조회'},
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // [修改7] 收藏列表也显示天气图标
            leading: Icon(
              _getWeatherIcon(weatherData['description'] ?? ''),
              color: _getWeatherColor(weatherData['description'] ?? ''),
              size: 36,
            ),
            title: Text(
              city,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
            subtitle: Text(
              weatherData['description'] ?? '',
              style: TextStyle(color: textColor.withOpacity(0.6)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 温度显示
                Text(
                  '${weatherData['temperature']} ℃',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(width: 8),
                // 点击刷新/查询该城市
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF1A6B5A)),
                  onPressed: () => searchFromFavorite(city),
                  tooltip: '날씨 업데이트',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// ============================================================
// 修改摘要（对应图2的7个要求）：
// ① 色彩变更   - 主题色改为深绿 #1A6B5A，背景/文字/边框统一绿色系
// ② 搜索功能   - 添加搜索历史 Chip、清除按钮、回车提交、输入框图标
// ③ 城市추가   - cityWeatherList 支持多城市同时展示，去重插入
// ④ 다크모드   - ValueNotifier + ThemeMode 实现全局亮/暗切换
// ⑤ 애니메이션 - FadeTransition + 抖动动画，成功渐显/失败抖动
// ⑥ 즐겨찾기   - 收藏夹 Tab、心形按钮、点击快速查询
// ⑦ 아이콘 수정 - 根据天气描述动态显示对应图标和颜色
// ============================================================