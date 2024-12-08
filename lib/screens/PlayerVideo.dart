import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:first_app/constans.dart'; // Đảm bảo import đúng đường dẫn constans.dart

class PlayerVideo extends StatefulWidget {
  final String videoUrl;
  final List<String> videoUrls;
  final Function(int) onVideoEnded;
  const PlayerVideo({
    Key? key,
    required this.videoUrl,
    required this.videoUrls,
    required this.onVideoEnded,
  }) : super(key: key);

  @override
  _PlayerVideoState createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int likeCount = 0;
  int commentCount = 0;
  bool isError = false;
  double _videoPosition = 0.0;
  bool isDraggingSlider = false;

  @override
  void initState() {
    super.initState();
    _loadVideo(widget.videoUrl);

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  Future<void> _loadVideo(String url) async {
    try {
      final cache = await DefaultCacheManager().getFileFromCache(url);

      if (cache != null) {
        _controller = VideoPlayerController.file(cache.file)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                isError = false;
                _controller!.play();
              });
            }
          }).catchError((error) {
            if (mounted) {
              setState(() {
                isError = true;
              });
            }
          });
      } else {
        final file = await DefaultCacheManager().getSingleFile(url);
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                isError = false;
                _controller!.play();
              });
            }
          }).catchError((error) {
            if (mounted) {
              setState(() {
                isError = true;
              });
            }
          });
      }
      _controller?.addListener(() {
        // Kiểm tra video đã kết thúc
        if (_controller!.value.position == _controller!.value.duration) {
          // Khi video kết thúc, gọi callback để chuyển video
          widget.onVideoEnded(widget.videoUrls.indexOf(widget.videoUrl));
        }

        // Cập nhật vị trí video nếu người dùng chưa kéo thanh trượt
        if (!isDraggingSlider) {
          setState(() {
            _videoPosition = (_controller!.value.position.inMilliseconds /
                    _controller!.value.duration.inMilliseconds)
                .clamp(0.0, 1.0);
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      _videoPosition = value;
      final position = Duration(
          milliseconds:
              (_videoPosition * _controller!.value.duration.inMilliseconds)
                  .toInt());
      _controller!.seekTo(position);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final videoDuration = _controller?.value.duration ?? Duration.zero;
    final videoPosition = _controller?.value.position ?? Duration.zero;

    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitsMinutes:$twoDigitsSeconds";
    }

    return Stack(
      children: [
        // Video hiển thị
        Center(
          child: isError
              ? Text(
                  'Không thể phát video. Vui lòng kiểm tra URL.',
                  style: TextStyle(color: Colors.red),
                )
              : _controller?.value.isInitialized == true
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : CircularProgressIndicator(),
        ),
        // Nút bên phải
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenSize.width * 0.06,
                  backgroundImage:
                      NetworkImage('https://p16-sign-sg.tiktokcdn.com/...'),
                ),
                SizedBox(height: screenSize.height * 0.02),
                _buildIconButton(
                  icon: Icons.favorite,
                  label: likeCount.toString(),
                  onPressed: () {
                    setState(() {
                      likeCount++;
                    });
                  },
                  isActive: likeCount > 0,
                  color: Colors.red,
                ),
                _buildIconButton(
                  icon: FontAwesomeIcons.solidCommentDots,
                  label: commentCount.toString(),
                  onPressed: () {
                    setState(() {
                      commentCount++;
                    });
                  },
                  isActive: false,
                ),
                _buildIconButton(
                  icon: FontAwesomeIcons.solidBookmark,
                  label: 'Lưu',
                  onPressed: () {
                    // Lưu hành động
                  },
                ),
                _buildIconButton(
                  icon: FontAwesomeIcons.share,
                  label: 'Chia sẻ',
                  onPressed: () {
                    // Chia sẻ hành động
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                RotationTransition(
                  turns: _animation,
                  child: CircleAvatar(
                    radius: screenSize.width * 0.06,
                    backgroundImage: AssetImage('assets/images/diathan.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Thanh tiến trình
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Slider(
                value: _videoPosition,
                min: 0.0,
                max: 1.0,
                onChanged: _onSliderChanged,
                onChangeStart: (_) => setState(() => isDraggingSlider = true),
                onChangeEnd: (_) => setState(() => isDraggingSlider = false),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(videoPosition),
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    _formatDuration(videoDuration),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
    Color color = Colors.white,
  }) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            size: screenSize.width * 0.08,
            color: isActive ? color : Colors.white,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width * 0.035,
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }
}
