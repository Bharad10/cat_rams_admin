import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

class AttachmentZoomingScreen extends StatefulWidget {
  final String? img;

  AttachmentZoomingScreen({this.img});

  @override
  AttachmentZoomingScreenState createState() => AttachmentZoomingScreenState();
}

class AttachmentZoomingScreenState extends State<AttachmentZoomingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(
      white,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: Container(
          width: context.width(),
          child: PhotoView(
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            minScale: PhotoViewComputedScale.contained * 0.9,
            imageProvider:
                NetworkImage(dotenv.env['API_URL']! + 'public/' + widget.img!),
          ),
        ),
      ),
    );
  }
}
