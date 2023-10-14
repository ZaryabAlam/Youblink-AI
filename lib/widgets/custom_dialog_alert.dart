import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({super.key});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("YOUBLINK"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Text("Eye Blink Detection Demo"),
          const Text("Zaryab Alam"),
          const Text("Hashone Digital"),
          const SizedBox(height: 5),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Made with Flutter with",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
              SizedBox(width: 5),
              Container(
                height: 35,
                width: 35,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30 * _pulseAnimation.value,
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.facebookF,
                    color: Colors.purple[700]),
                onPressed: () {
                  _launchURL('https://www.facebook.com/zaryab.alam.35');
                },
              ),
              IconButton(
                icon:
                    FaIcon(FontAwesomeIcons.github, color: Colors.purple[700]),
                onPressed: () {
                  _launchURL('https://github.com/ZaryabAlam');
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.linkedinIn,
                    color: Colors.purple[700]),
                onPressed: () {
                  _launchURL(
                      'https://pk.linkedin.com/in/zaryab-alam-660b7a187?trk=people-guest_people_search-card&challengeId=AQGEEmHy88VWOQAAAYstllTvYBFoXHZBfMgcb2xrCUYvgvPhaW9QiHKWk6yfxflEWD15aEvvOAL2u-Wmf0exQugUwnnJ7C7_pg&submissionId=1ca5f80f-5bf0-8d17-01de-9831b1efa85f&challengeSource=AgGKG4qlzzRmwgAAAYstlsvRbkO96omesnovBVpf2Ih5tLzehkjelASnIghWt1Q&challegeType=AgH8ieoj8PK_MwAAAYstlsvUY0YdIBiP2RwUQaqBQi_WNiKOguvqBuM&memberId=AgFhbDnJdWSH0gAAAYstlsvWDP5IqgAkLC3vJWzydNv9uZk&recognizeDevice=AgGr0jRUfhKcvAAAAYstlsvZNxIAegqBpr6SnzawQze7sxauaiXu');
                },
              ),
              IconButton(
                icon:
                    FaIcon(FontAwesomeIcons.twitter, color: Colors.purple[700]),
                onPressed: () {
                  _launchURL('https://twitter.com/zaryabalam');
                },
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            side: const BorderSide(color: Colors.purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Colors.purple),
            ),
          ),
          child: const Text('  Okay  '),
        ),
      ],
    );
  }
}
