import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:first_app/screens/PlayerVideo.dart';
import 'package:first_app/constans.dart';
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
    'https://firebasestorage.googleapis.com/v0/b/fakebook-4d415.appspot.com/o/Tikmate.io_7405816557563055377.mp4?alt=media&token=6e33e1e9-3fb2-482f-94b2-492388a45248',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  ];

  @override
  void dispose() {
    _mainPageController.dispose();
    _videoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _mainPageController,
        onPageChanged: (index) {
          setState(() {
            pageIdx = index;
          });
        },
        children: [
          // Trang chủ với video có thao tác vuốt lên xuống
          Stack(
            children: [
              PageView.builder(
                controller: _videoPageController,
                scrollDirection: Axis.vertical,
                itemCount: videoUrls.length,
                itemBuilder: (context, index) {
                  return PlayerVideo(
                    videoUrl: videoUrls[index],
                  );
                },
              ),
              // Thanh header cố định trên cùng
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
                                fontSize: screenSize.width * 0.05)),
                      ]),
                      Column(children: [
                        Text("Đã follow",
                            style: TextStyle(
                                color: TikTokColors.white,
                                fontSize: screenSize.width * 0.05)),
                      ]),
                      Column(children: [
                        Text("Đề xuất",
                            style: TextStyle(
                                color: TikTokColors.white,
                                fontSize: screenSize.width * 0.05)),
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
              icon: Icon(Icons.home, size: 30), label: "Trang chủ"),
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
