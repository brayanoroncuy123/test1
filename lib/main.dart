import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  //This widget is the root of your application

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpeechScreen extends StatefulWidget{

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>{
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _textSpeech = 'Presione el botón para empezar a hablar';

  void onListen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus:  $val'),
          onError: (val) => print('onError: $val')
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (val) =>
                setState(() {
                  _textSpeech = val.recognizedWords;
                })
        );
      }
    } else {
      setState((){
        _isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Limachay - Test')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
      animate: _isListening,
      glowColor: Theme.of(context).primaryColor,
      endRadius: 80,
      duration: Duration(milliseconds: 2000),
      repeatPauseDuration: Duration(milliseconds: 100),
      repeat: true,
      child: FloatingActionButton(
        onPressed: () => onListen(),
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 25, 25, 150),
          child: Text(
            _textSpeech,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w500
            )
          )
        )
      )
    );
  }
}