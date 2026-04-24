import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class JumpscareScreen extends StatefulWidget {
  const JumpscareScreen({super.key});

  @override
  State<JumpscareScreen> createState() => _JumpscareScreenState();
}

class _JumpscareScreenState extends State<JumpscareScreen> {
  VideoPlayerController? _controller;
  bool _isGato = false; 
  bool _gatoStarted = false;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    _playVideo('assets/videos/Susto_usuario.mp4', isGato: false);
  }

  void _popContext() {
    if (!_isPopped) {
      _isPopped = true;
      Navigator.pop(context);
    }
  }

  void _nextVideo() {
    if (!_isGato) {
      if (!_gatoStarted) {
        _gatoStarted = true;
        _playVideo('assets/videos/Gato_hablando.mp4', isGato: true);
      }
    } else {
      _popContext();
    }
  }

  void _playVideo(String path, {required bool isGato}) {
    if (_controller != null) {
      _controller!.dispose();
    }
    _isGato = isGato;
    final newController = VideoPlayerController.asset(path);
    _controller = newController;

    newController.initialize().then((_) {
      if (!mounted) return;
      newController.setVolume(1.0);
      newController.play();
      setState(() {});
    }).catchError((error) {
      debugPrint("Error inicializando video $path: $error");
      if (mounted) _nextVideo();
    });

    newController.addListener(() {
      if (!mounted) return;
      if (newController.value.hasError) {
        debugPrint("Video error: ${newController.value.errorDescription}");
        _nextVideo();
      } else if (newController.value.isInitialized &&
          !newController.value.isPlaying &&
          newController.value.position >= newController.value.duration &&
          newController.value.position > Duration.zero) {
        _nextVideo();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          // Si el usuario toca la pantalla durante el video del gato, puede saltarlo
          if (_isGato) {
            _popContext();
          }
        },
        child: (_controller != null && _controller!.value.isInitialized)
            ? Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
