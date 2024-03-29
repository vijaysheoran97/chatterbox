import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/rtc_engine.dart';

void main() {
  runApp(const MaterialApp(
    home: JoinIncomingCall(),
  ));
}

class JoinIncomingCall extends StatefulWidget {
  const JoinIncomingCall({Key? key}) : super(key: key);

  @override
  _JoinIncomingCallState createState() => _JoinIncomingCallState();
}

class _JoinIncomingCallState extends State<JoinIncomingCall> {
  late final RtcEngine _engine;
  bool _joined = false;
  bool _muted = false;
  bool _enableSpeakerphone = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext('YOUR_APP_ID'));
    _addListeners();
    await _engine.enableAudio();
    setState(() {});
    await fetchAudioTokenAndChannelId();
    await _joinChannel();
  }

  void _addListeners() {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          setState(() {
            _joined = true;
          });
        },
        leaveChannel: (stats) {
          setState(() {
            _joined = false;
          });
        },
        error: (errorCode) {
          print('Error code: $errorCode');
        },
      ),
    );
  }

  _joinChannel() async {
    await _engine.joinChannel(null, 'CHANNEL_ID', null, 0);
  }

  Future<void> fetchAudioTokenAndChannelId() async {
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final audioToken = responseData['audioToken'];
      final channelId = responseData['channelId'];
      await _engine.joinChannel(audioToken, channelId, null, 0);
    } else {
      print('Failed to fetch audio token and channel ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join Incoming Call')),
      body: Center(
        child: _joined
            ? _buildControls()
            : CircularProgressIndicator(), // Placeholder for UI when joining the call
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('You are in the call!'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _muted = !_muted;
            });
            _engine.muteLocalAudioStream(_muted);
          },
          child: Text(_muted ? 'Unmute Microphone' : 'Mute Microphone'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _enableSpeakerphone = !_enableSpeakerphone;
            });
            _engine.setEnableSpeakerphone(_enableSpeakerphone);
          },
          child: Text(_enableSpeakerphone ? 'Disable Speakerphone' : 'Enable Speakerphone'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await _engine.leaveChannel();
          },
          child: Text('Leave Call'),
        ),
      ],
    );
  }
}
