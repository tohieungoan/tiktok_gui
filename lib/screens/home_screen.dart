import 'dart:async';
import 'package:flutter/material.dart';
import 'package:first_app/screens/PlayerVideo.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:first_app/constans.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:first_app/widgets/customAddIcon.dart';
import 'shop_screen.dart'; // Import màn hình Cửa hàng
import 'add_screen.dart'; // Import màn hình Thêm
import 'message_screen.dart'; // Import màn hình Hộp thư
import 'profile_screen.dart'; // Import màn hình Hồ sơ

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  final PageController _mainPageController = PageController();
  final PageController _videoPageController = PageController();
  final List<String> videoUrls = [
    'https://firebasestorage.googleapis.com/v0/b/fakebook-4d415.appspot.com/o/video%2FSnaptik.app_7440164479834328328.mp4?alt=media&token=dad64d56-4fea-40a5-911d-68c74585e9a5',
    'https://firebasestorage.googleapis.com/v0/b/fakebook-4d415.appspot.com/o/video%2FSnaptik.app_7440168059001720084.mp4?alt=media&token=16685132-6e95-4934-85fa-3e496cc4675a',
    'https://firebasestorage.googleapis.com/v0/b/fakebook-4d415.appspot.com/o/video%2FSnaptik.app_7440177593099242760.mp4?alt=media&token=af8f7722-0cab-4520-89d1-936d92306d3e'
  ];

  @override
  void dispose() {
    _mainPageController.dispose();
    _videoPageController.dispose();
    super.dispose();
  }
  void _onVideoEnded(int currentIndex) {
    if (currentIndex + 1 < videoUrls.length) {
      // Chuyển sang video tiếp theo
      _videoPageController.jumpToPage(currentIndex + 1);
    }
  }
  // Tải video tiếp theo và lưu vào bộ nhớ tạm
  Future<void> _cacheNextVideo(int index) async {
    if (index + 1 < videoUrls.length) {
      await DefaultCacheManager().getSingleFile(videoUrls[index + 1]);
      print("Đã tải video tiếp theo: ${videoUrls[index + 1]}");
    }
  }

  // Xóa bộ nhớ cache video sau một khoảng thời gian nhất định (ví dụ: 1 giờ)
  Future<void> _clearCacheAfterTimeout() async {
    // Tạo một timer để xóa bộ nhớ cache sau 1 giờ (3600 giây)
    Timer(Duration(minutes: 3), () async {
      final cacheManager = DefaultCacheManager();
      await cacheManager.emptyCache();
      print("Đã xóa bộ nhớ cache sau 3p");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Gọi hàm xóa bộ nhớ cache khi trang được xây dựng
    _clearCacheAfterTimeout();

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _mainPageController,
        onPageChanged: (index) {
          setState(() {
            pageIdx = index;
          });
          // Cache video tiếp theo khi chuyển trang
          _cacheNextVideo(index);
        },
        children: [
          Stack(
            children: [
              PageView.builder(
                controller: _videoPageController,
                scrollDirection: Axis.vertical,
                itemCount: videoUrls.length,
                itemBuilder: (context, index) {
                  return PlayerVideo(
                    videoUrl: videoUrls[index],
                    videoUrls: videoUrls,
                     onVideoEnded: _onVideoEnded,
                  );
                },
              ),
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                  color: Colors.black.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.live_tv,
                          color: TikTokColors.white,
                          size: screenSize.width * 0.1),
                      Column(children: [
                        Text("Bạn bè",
                            style: TextStyle(
                                color: TikTokColors.white,
                                fontSize: screenSize.width * 0.05))
                      ]),
                      Column(children: [
                        Text("Đã follow",
                            style: TextStyle(
                                color: TikTokColors.white,
                                fontSize: screenSize.width * 0.05))
                      ]),
                      Column(children: [
                        Text("Đề xuất",
                            style: TextStyle(
                                color: TikTokColors.white,
                                fontSize: screenSize.width * 0.05))
                      ]),
                      Icon(Icons.search,
                          color: TikTokColors.white,
                          size: screenSize.width * 0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Các trang khác
          ShopScreen(),
          AddScreen(),
          MessagesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            pageIdx = index;
            _mainPageController.jumpToPage(index);
          });
        },
        currentIndex: pageIdx,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), label: "Home"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bagShopping, size: 25),
              label: "Cửa hàng"),
          BottomNavigationBarItem(icon: customAddIcon(), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.message, size: 25),
              label: "Hộp thư"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30), label: "Hồ sơ"),
        ],
      ),
    );
  }
}
