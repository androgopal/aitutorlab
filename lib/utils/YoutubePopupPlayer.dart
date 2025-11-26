import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePopupPlayer {
  /// Call:
  /// YoutubePopupPlayer.show(context, "https://www.youtube.com/watch?v=dQw4w9WgXcQ");
  static void show(BuildContext context, String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid YouTube URL')),
      );
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'YouTube',
      // dim the background; adjust opacity as desired
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: Duration(milliseconds: 320),
      pageBuilder: (ctx, anim1, anim2) {
        // IMPORTANT: use a transparent Material so Flutter doesn't paint a white surface behind the dialog
        return Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: _YoutubeDialogContent(videoId: videoId),
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.95, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }
}

class _YoutubeDialogContent extends StatefulWidget {
  final String videoId;
  const _YoutubeDialogContent({Key? key, required this.videoId}) : super(key: key);

  @override
  State<_YoutubeDialogContent> createState() => _YoutubeDialogContentState();
}

class _YoutubeDialogContentState extends State<_YoutubeDialogContent> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
        disableDragSeek: false,
        showLiveFullscreenButton: false,
        hideThumbnail: false,
        loop: false,
        forceHD: false,
        enableCaption: false,
        isLive: false,
        hideControls: true
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9; // 90% width
    final height = width * 9 / 16; // 16:9

    return Center(
      child: Stack(
        children: [
          // Optional: blur the background behind the dialog (does not replace barrierColor)
          // If you prefer no blur, remove this Positioned.fill with BackdropFilter.
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),
          ),

          // The actual dialog content
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6), // semi-transparent glass
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Video Preview',
                              style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),

                    // player area
                    Container(
                      width: double.infinity,
                      height: height,
                      color: Colors.black,
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.redAccent,
                        onReady: () {
                          // optional callback
                        },
                      ),
                    ),

                    // actions row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _controller.play(),
                            icon: Icon(Icons.play_arrow),
                            label: Text('Play'),
                            style: ElevatedButton.styleFrom(elevation: 0),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _controller.pause(),
                            icon: Icon(Icons.pause),
                            label: Text('Pause'),
                            style: ElevatedButton.styleFrom(elevation: 0),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close', style: TextStyle(color: Colors.white70)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Call:
/// YoutubePopupPlayer.show(context, "https://www.youtube.com/watch?v=dQw4w9WgXcQ");
class YoutubePopupPlayer {
  static void show(BuildContext context, String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid YouTube URL')),
      );
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'YouTube',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: Duration(milliseconds: 320),
      pageBuilder: (ctx, anim1, anim2) {
        return _YoutubeDialogContent(videoId: videoId);
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.92, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }
}

class _YoutubeDialogContent extends StatefulWidget {
  final String videoId;
  const _YoutubeDialogContent({Key? key, required this.videoId}) : super(key: key);

  @override
  State<_YoutubeDialogContent> createState() => _YoutubeDialogContentState();
}

class _YoutubeDialogContentState extends State<_YoutubeDialogContent> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
        disableDragSeek: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9; // 90% screen width
    final height = width * 9 / 16; // 16:9

    return Material(
      child: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // header bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Video Preview',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.open_in_full, color: Colors.white70),
                            onPressed: () {
                              // optional: implement fullscreen behavior
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
      
                    // player
                    Container(
                      width: double.infinity,
                      height: height,
                      color: Colors.black,
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.redAccent,
                        onReady: () {
                          // Ready callback if needed
                        },
                      ),
                    ),
      
                    // action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _controller.play(),
                            icon: Icon(Icons.play_arrow),
                            label: Text('Play'),
                            style: ElevatedButton.styleFrom(elevation: 0),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _controller.pause(),
                            icon: Icon(Icons.pause),
                            label: Text('Pause'),
                            style: ElevatedButton.styleFrom(elevation: 0),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close', style: TextStyle(color: Colors.white70)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
