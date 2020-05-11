import 'package:alltv/widgets/alltv_panel.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

// import 'custom_ui.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  VideoScreen({@required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    startPlay();
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(widget.url, autoPlay: true,showCover: true).catchError((e) {
      print("setDataSource error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FijkView(
            player: player,
            color: Colors.black,
            panelBuilder: allTVPanelBuilder(snapShot: true,doubleTap: false),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}

// import 'dart:async';

// import 'package:chewie/src/chewie_player.dart';
// import 'package:chewie/src/chewie_progress_colors.dart';
// import 'package:chewie/src/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class ChewieCustomWithDanmaku extends StatefulWidget {
//   final GestureTapCallback onTap;
//   ChewieCustomWithDanmaku(this.onTap);

//   @override
//   State<StatefulWidget> createState() {
//     return _ChewieCustomWithDanmakuState();
//   }
// }

// class _ChewieCustomWithDanmakuState extends State<ChewieCustomWithDanmaku> {
//   VideoPlayerValue _latestValue;
//   bool _hideStuff = true;
//   bool _hideDanmaku = false;
//   Timer _hideTimer;
//   Timer _initTimer;
//   Timer _showAfterExpandCollapseTimer;
//   bool _dragging = false;
//   bool _displayTapped = false;

//   final barHeight = 48.0;
//   final marginSize = 5.0;
//   DateTime _lastSync;

//   VideoPlayerController controller;
//   ChewieController chewieController;

//   @override
//   Widget build(BuildContext context) {
//     if (_latestValue.hasError) {
//       return chewieController.errorBuilder != null
//           ? chewieController.errorBuilder(
//               context,
//               chewieController.videoPlayerController.value.errorDescription,
//             )
//           : Center(
//               child: Icon(
//                 Icons.error,
//                 color: Colors.white,
//                 size: 42,
//               ),
//             );
//     }

//     return MouseRegion(
//       onHover: (_) {
//         _cancelAndRestartTimer();
//       },
//       child: GestureDetector(
//           onTap: () => _cancelAndRestartTimer(),
//           child: Stack(
//             children: <Widget>[
//               AbsorbPointer(
//                 absorbing: _hideStuff,
//                 child: Column(
//                   children: <Widget>[
//                     _latestValue != null &&
//                                 !_latestValue.isPlaying &&
//                                 _latestValue.duration == null ||
//                             _latestValue.isBuffering
//                         ? const Expanded(
//                             child: const Center(
//                               child: const CircularProgressIndicator(),
//                             ),
//                           )
//                         : _buildHitArea(),
//                     _buildBottomBar(context),
//                   ],
//                 ),
//               ),
//             ],
//           )),
//     );
//   }

//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }

//   void _dispose() {
//     // controller.removeListener(_updateState);
//     _hideTimer?.cancel();
//     _initTimer?.cancel();
//     _showAfterExpandCollapseTimer?.cancel();
//   }

//   @override
//   void didChangeDependencies() {
//     final _oldController = chewieController;
//     chewieController = ChewieController.of(context);
//     controller = chewieController.videoPlayerController;

//     if (_oldController != chewieController) {
//       _dispose();
//       _initialize();
//     }

//     super.didChangeDependencies();
//   }

//   AnimatedOpacity _buildBottomBar(
//     BuildContext context,
//   ) {
//     final iconColor = Theme.of(context).textTheme.button.color;
//     return AnimatedOpacity(
//       opacity: _hideStuff ? 0.0 : 1,
//       duration: Duration(milliseconds: 300),
//       child: Container(
//         height: barHeight,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color.fromRGBO(0, 0, 0, 0.02), Colors.black]),
//         ),
//         child: Row(
//           children: <Widget>[
//             _buildRefreshButton(controller),
//             chewieController.isLive
//                 ? Expanded(
//                     child: const Text(
//                       '直播',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   )
//                 : _buildPosition(iconColor),
//             _buildHideDanmakuButton(),
//             chewieController.allowFullScreen
//                 ? _buildExpandButton()
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }

//   GestureDetector _buildExpandButton() {
//     return GestureDetector(
//       onTap: _onExpandCollapse,
//       child: AnimatedOpacity(
//         opacity: _hideStuff ? 0.0 : 1.0,
//         duration: Duration(milliseconds: 300),
//         child: Container(
//           height: barHeight,
//           margin: EdgeInsets.only(right: 12.0),
//           padding: EdgeInsets.only(
//             left: 8.0,
//             right: 8.0,
//           ),
//           child: Center(
//             child: Icon(
//               chewieController.isFullScreen
//                   ? Icons.fullscreen_exit
//                   : Icons.fullscreen,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHideDanmakuButton() {
//     return Container(
//       child: GestureDetector(
//         child: Icon(
//           _hideDanmaku ? Icons.favorite : Icons.face,
//           color: Colors.white,
//         ),
//         onTap: () {
//           setState(() {
//             _hideDanmaku = !_hideDanmaku;
//           });
//         },
//       ),
//     );
//   }

//   Expanded _buildHitArea() {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           if (_latestValue != null && _latestValue.isPlaying) {
//             if (_displayTapped) {
//               setState(() {
//                 _hideStuff = true;
//               });
//             } else
//               _cancelAndRestartTimer();
//           } else {
//             setState(() {
//               _hideStuff = true;
//             });
//           }
//         },
//         onDoubleTap: () {
//           _playPause();
//         },
//         child: Container(
//           color: Colors.transparent,
//           child: Container(
//             alignment: Alignment.bottomRight,
//             child: AnimatedOpacity(
//               opacity:
//                   _latestValue != null && !_latestValue.isPlaying && !_dragging
//                       ? 0.8
//                       : 0.0,
//               duration: Duration(milliseconds: 300),
//               child: GestureDetector(
//                   onTap: () {
//                     _playPause();
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 10, right: 10),
//                     decoration: BoxDecoration(
//                       boxShadow: <BoxShadow>[
//                         BoxShadow(color: Colors.black54, blurRadius: 20),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.play_arrow,
//                       size: 40.0,
//                       color: Colors.white,
//                     ),
//                   )),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   // GestureDetector _buildMuteButton(
//   //   VideoPlayerController controller,
//   // ) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       _cancelAndRestartTimer();

//   //       if (_latestValue.volume == 0) {
//   //         controller.setVolume(_latestVolume ?? 0.5);
//   //       } else {
//   //         _latestVolume = controller.value.volume;
//   //         controller.setVolume(0.0);
//   //       }
//   //     },
//   //     child: AnimatedOpacity(
//   //       opacity: _hideStuff ? 0.0 : 1.0,
//   //       duration: Duration(milliseconds: 300),
//   //       child: ClipRect(
//   //         child: Container(
//   //           child: Container(
//   //             height: barHeight,
//   //             padding: EdgeInsets.only(
//   //               left: 8.0,
//   //               right: 8.0,
//   //             ),
//   //             child: Icon(

//   //               (_latestValue != null && _latestValue.volume > 0)
//   //                   ? Icons.volume_up
//   //                   : Icons.volume_off,
//   //                   color: Colors.white,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   GestureDetector _buildRefreshButton(VideoPlayerController controller) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         height: barHeight,
//         color: Colors.transparent,
//         margin: EdgeInsets.only(left: 8.0, right: 4.0),
//         padding: EdgeInsets.only(
//           left: 12.0,
//           right: 12.0,
//         ),
//         child: Icon(
//           Icons.refresh,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   GestureDetector _buildPlayPause(VideoPlayerController controller) {
//     return GestureDetector(
//       onTap: _playPause,
//       child: Container(
//         height: barHeight,
//         color: Colors.transparent,
//         margin: EdgeInsets.only(left: 8.0, right: 4.0),
//         padding: EdgeInsets.only(
//           left: 12.0,
//           right: 12.0,
//         ),
//         child: Icon(
//           controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildPosition(Color iconColor) {
//     final position = _latestValue != null && _latestValue.position != null
//         ? _latestValue.position
//         : Duration.zero;
//     final duration = _latestValue != null && _latestValue.duration != null
//         ? _latestValue.duration
//         : Duration.zero;

//     return Padding(
//       padding: EdgeInsets.only(right: 24.0),
//       child: Text(
//         '${formatDuration(position)}/${formatDuration(duration)}',
//         style: TextStyle(fontSize: 14.0, color: Colors.white),
//       ),
//     );
//   }

//   void _cancelAndRestartTimer() {
//     _hideTimer?.cancel();
//     _startHideTimer();

//     setState(() {
//       _hideStuff = false;
//       _displayTapped = true;
//     });
//   }

//   Future<Null> _initialize() async {
//     // controller.addListener(_updateState);

//     // _updateState();

//     if ((controller.value != null && controller.value.isPlaying) ||
//         chewieController.autoPlay) {
//       _startHideTimer();
//     }

//     if (chewieController.showControlsOnInitialize) {
//       _initTimer = Timer(Duration(milliseconds: 200), () {
//         setState(() {
//           _hideStuff = false;
//         });
//       });
//     }
//   }

//   void _onExpandCollapse() {
//     setState(() {
//       _hideStuff = true;

//       chewieController.toggleFullScreen();
//       _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
//         setState(() {
//           _cancelAndRestartTimer();
//         });
//       });
//     });
//   }

//   void _playPause() {
//     bool isFinished = _latestValue.position >= _latestValue.duration;

//       setState(() {
//       if (controller.value.isPlaying) {
//         _hideStuff = false;
//         _hideTimer?.cancel();
//         controller.pause();
//       } else {
//         _cancelAndRestartTimer();

//         if (!controller.value.initialized) {
//           controller.initialize().then((_) {
//             controller.play();
//           });
//         } else {
//           if (isFinished) {
//             controller.seekTo(Duration(seconds: 0));
//           }
//           controller.play();
//         }
//       }
//     });
//   }

//   void _startHideTimer() {
//     _hideTimer = Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _hideStuff = true;
//       });
//     });
//   }

//   // //TODO 监听弹幕
//   // void _updateState() {
//   //   setState(() {
//   //     _latestValue = controller.value;
//   //     //同步音频视频
//   //     //print("widget.audioController.value.isPlaying ${widget.audioController.value.isPlaying}");
//   //     if (widget.audioController != null &&
//   //         abs(widget.audioController.value.position.inMilliseconds -
//   //                 controller.value.position.inMilliseconds) >
//   //             600 &&
//   //         (_lastSync == null ||
//   //             DateTime.now().difference(_lastSync).inMilliseconds > 5000)) {
//   //       widget.audioController?.seekTo(controller.value.position);
//   //       widget.audioController?.play();
//   //       _lastSync = DateTime.now();
//   //     }
//   //   });
//   // }

//   //绝对值
//   int abs(int n) {
//     if (n < 0) {
//       return -n;
//     } else {
//       return n;
//     }
//   }
// }