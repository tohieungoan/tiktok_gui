import 'package:flutter/material.dart';
import 'package:first_app/constans.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerVideo extends StatefulWidget {
  final String videoUrl;

  const PlayerVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _PlayerVideoState createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int likeCount = 0;
  int commentCount = 0;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          isError = false;
          _controller.play();
        });
      }).catchError((error) {
        setState(() {
          isError = true;
        });
      });

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Center(
          child: isError
              ? Text(
                  'Không thể phát video. Vui lòng kiểm tra URL.',
                  style: TextStyle(color: Colors.red),
                )
              : _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : CircularProgressIndicator(),
        ),
        Positioned(
          right: 16,
          top: 225,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: screenSize.width * 0.06,
                backgroundImage: NetworkImage(
                    'https://p9-sign-sg.tiktokcdn.com/aweme/1080x1080/tos-alisg-avt-0068/07c2b080eabf890e7d90e2de0eebd206.jpeg?lk3s=a5d48078&nonce=5068&refresh_token=46f1e0a9af5aefb2739529a4a4c3431d&x-expires=1729872000&x-signature=ezE1x1zgaDFrjfJsG7aqvT0EUWg%3D&shp=a5d48078&shcp=81f88b70'),
              ),
              SizedBox(height: screenSize.width * 0.02),
              Column(
                children: [
                  IconButton(
                    iconSize: screenSize.width * 0.12,
                    color: TikTokColors.white,
                    icon: Icon(
                      Icons.favorite,
                      color: likeCount > 0 ? Colors.red : TikTokColors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        likeCount++;
                      });
                    },
                  ),
                  Text(
                    likeCount.toString(),
                    style: TextStyle(
                      color: TikTokColors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    iconSize: screenSize.width * 0.12,
                    color: TikTokColors.white,
                    icon: FaIcon(
                      FontAwesomeIcons.solidCommentDots,
                      size: screenSize.width * 0.1,
                    ),
                    onPressed: () {
                      setState(() {
                        commentCount++;
                      });
                    },
                  ),
                  Text(
                    commentCount.toString(),
                    style: TextStyle(
                      color: TikTokColors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    iconSize: screenSize.width * 0.07,
                    color: TikTokColors.white,
                    icon: FaIcon(
                      FontAwesomeIcons.solidBookmark,
                      size: screenSize.width * 0.08,
                    ),
                    onPressed: () {
                      // Thêm chức năng lưu tại đây
                    },
                  ),
                  Text(
                    'Lưu',
                    style: TextStyle(
                      color: TikTokColors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.width * 0.02),
              Column(
                children: [
                  IconButton(
                    iconSize: screenSize.width * 0.07,
                    color: TikTokColors.white,
                    icon: FaIcon(
                      FontAwesomeIcons.share,
                      size: screenSize.width * 0.08,
                    ),
                    onPressed: () {
                      // Thêm chức năng chia sẻ tại đây
                    },
                  ),
                  Text(
                    'Chia sẻ',
                    style: TextStyle(
                      color: TikTokColors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.width * 0.04),
              RotationTransition(
                turns: _animation,
                child: CircleAvatar(
                  radius: screenSize.width * 0.06,
                  backgroundImage: NetworkImage(
                      'https://p9-sign-sg.tiktokcdn.com/aweme/1080x1080/tos-alisg-avt-0068/07c2b080eabf890e7d90e2de0eebd206.jpeg?lk3s=a5d48078&nonce=5068&refresh_token=46f1e0a9af5aefb2739529a4a4c3431d&x-expires=1729872000&x-signature=ezE1x1zgaDFrjfJsG7aqvT0EUWg%3D&shp=a5d48078&shcp=81f88b70'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
