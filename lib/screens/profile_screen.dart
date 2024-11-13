import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:first_app/constans.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0; // Chỉ số của icon đã chọn

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenSize = MediaQuery.of(context).size;
    final profileImageSize = screenSize.width * 0.25; // 25% chiều rộng màn hình
    FirebaseAuth auth = FirebaseAuth.instance;

    signOut() async {
      await auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    // Địa chỉ URL của hình đại diện
    final String avatarUrl =
        "https://farm9.staticflickr.com/8505/8441256181_4e98d8bff5_z_d.jpg"; // Thay thế bằng URL hình đại diện của bạn

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Hành động khi nhấn vào icon thêm bạn
                    },
                    child: Icon(Icons.person_add_alt_1_outlined),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Hành động khi nhấn vào tên
                    },
                    child: Text(
                      "Tô Hiếu Ngoan",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      signOut();
                    },
                    child: Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Container(
                            color: Colors.grey, // Placeholder cho hình đại diện
                            height: profileImageSize,
                            width: profileImageSize,
                            child: ClipOval(
                              child: Image.network(
                                avatarUrl,
                                height: profileImageSize,
                                width: profileImageSize,
                                fit: BoxFit.cover, // Cắt hình theo hình tròn
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "@ngoantohieu",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatColumn("36", "Đã follow"),
                        _buildVerticalDivider(),
                        _buildStatColumn("13", "Follower"),
                        _buildVerticalDivider(),
                        _buildStatColumn("143", "Thích"),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionContainer("Sửa hồ sơ", 140),
                        SizedBox(width: 5),
                        _buildActionContainer("", 45, icon: Icons.bookmark),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildIconColumn(0, Icons.menu,
                              color: Colors.black26),
                          _buildIconColumn(1, Icons.bookmark_border,
                              color: Colors.black26),
                          _buildIconColumn(2, Icons.favorite_border,
                              color: Colors.black26),
                          _buildIconColumn(3, Icons.lock_outline,
                              color: Colors.black26),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    // Sử dụng IndexedStack để hiển thị nội dung tương ứng
                    IndexedStack(
                      index: _selectedIndex,
                      children: [
                        _buildContent(
                            "Nội dung Danh sách"), // Nội dung cho icon "Menu"
                        _buildContent(
                            "Nội dung Đã lưu"), // Nội dung cho icon "Bookmark"
                        _buildContent(
                            "Nội dung Thích"), // Nội dung cho icon "Yêu thích"
                        _buildContent(
                            "Nội dung Riêng tư"), // Nội dung cho icon "Khóa"
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xây dựng một cột hiển thị số lượng
  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Hàm xây dựng đường chia cột
  Widget _buildVerticalDivider() {
    return Container(
      color: Colors.black54,
      width: 1,
      height: 15,
      margin: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _buildActionContainer(String text, double width, {IconData? icon}) {
    return Container(
      width: width,
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12), color: TikTokColors.gray),
      child: Center(
        child: icon != null
            ? Icon(icon)
            : Text(
                text,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildIconColumn(int index, IconData icon,
      {Color color = Colors.black}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Cập nhật chỉ số đã chọn
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(icon, color: _selectedIndex == index ? Colors.black : color),
          SizedBox(height: 7),
          Container(
            color: Colors.black,
            height: 2,
            width: 55,
          )
        ],
      ),
    );
  }

  // Hàm xây dựng nội dung tương ứng
  Widget _buildContent(String content) {
    return Center(
      child: Text(
        content,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 160,
            color: Colors.black26,
          ),
        ),
        Expanded(
          child: Container(
            height: 160,
            color: Colors.black26,
          ),
        ),
        Expanded(
          child: Container(
            height: 160,
            color: Colors.black26,
          ),
        ),
      ],
    );
  }
}
