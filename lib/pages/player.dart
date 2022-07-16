import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:flutter_lyric/lyrics_log.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanskrit_music_player/constant.dart';
import 'package:sanskrit_music_player/data/dictionaryApi.dart';
import 'package:selectable/selectable.dart';

class Player extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>>?  song;
  int index;
  Player({required this.song,required this.index});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  AudioPlayer audioPlayer = AudioPlayer();
  bool isLiked = false;
  bool isPlayed = true;
  late Duration duration;
  Duration? _duration;
  Duration? _position;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  late String normalLyric;
  int playProgress = 0;
  var lyricModel;
  var lyricUI = UINetease();
  final _selectionController = SelectableController();
  var _isTextSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    normalLyric=widget.song?[widget.index].get('lyrics');
    normalLyric = normalLyric.replaceAll('/n', '\n');
    super.initState();
    lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(normalLyric)
        .getModel();

    play();

    _selectionController.addListener(() {
      if (_isTextSelected != _selectionController.isTextSelected) {
        _isTextSelected = _selectionController.isTextSelected;
        // print(_isTextSelected ? 'Text is selected' : 'Text is not selected');
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  millisToMinutesAndSeconds(millis) {

  var minutes = (millis / 60000).floor();
  var seconds = ((millis % 60000) / 1000);
  //ES6 interpolated literals/template literals
  //If seconds is less than 10 put a zero in front.
  return '${minutes}:${(seconds < 10 ? "0" : "")}${seconds}';
}
  play() async {

    final playPosition = (_position != null &&
        _duration != null &&
        _position!.inMilliseconds > 0 &&
        _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    int result = await audioPlayer.play(widget.song?[widget.index].get('link'),
        isLocal: false,position: playPosition);
    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
      //print('Current position: $p');
      setState(() {
        playProgress=p.inMilliseconds;
        duration=p;
      });
    });
    if (result == 1) {
      setState(() {
        isPlayed=true;
      });
    }
    _positionSubscription = audioPlayer.onAudioPositionChanged.listen((event) {setState(() {
      _position=event;
      playProgress = event.inMilliseconds;
    });});
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);});
    _playerCompleteSubscription =
        audioPlayer.onPlayerCompletion.listen((event) {
          setState(() {
            isPlayed=false;
          });
        });
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlayed=false;
      });
      print("playong stop");
    }
  }
  forward() async{
    final Position= _position!.inMilliseconds+10000;
    int result =await audioPlayer
        .seek(Duration(milliseconds: Position.round()));

  }
  reverse() async{
    final Position= _position!.inMilliseconds-10000;
    int result =await audioPlayer
        .seek(Duration(milliseconds: Position.round()));

  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.song?[widget.index].get('songName')),
        foregroundColor: primaryColor,
        backgroundColor: bgColor,
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              height: 250.h,
              width: 250.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.song?[widget.index].get('image')),
                      fit: BoxFit.cover
                  )
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.index==0?Container():GestureDetector(
                  child:Icon(Icons.arrow_back_ios,color:  widget.index==0?bgColor:primaryColor,size:50.sp),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(song: widget.song, index: widget.index-1)));
                  },
                ),
                SizedBox(
                  width: 20.sp,
                ),
                Column(
                  children: [
                    Text(widget.song?[widget.index].get('songName'),style: TextStyle(color: primaryColor,fontSize: 30.sp,),),
                    Text(widget.song?[widget.index].get('singerName'),style: TextStyle(color: primaryColor,fontSize: 18.sp),)
                  ],
                ),
               SizedBox(
                  width: 20.sp,
                ),
                widget.index+1==widget.song!.length?Container():GestureDetector(
                  child:Icon(Icons.arrow_forward_ios,color: primaryColor,size:50.sp ,),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(song: widget.song, index: widget.index+1)));
                   },
                ),
              ],
            ),


            LyricsReader(
              onTap: (){
                String time = millisToMinutesAndSeconds(playProgress);
                String min = time.split(":")[0];
                final line = normalLyric;
                min = min.toString().padLeft(2, '0');
                String sec = time.split(":")[1].split('.')[0];
                sec = sec.toString().padLeft(2,'0');
                print(sec);
                final regex = RegExp(r'\['+min+':'+sec+'.*');
                final match = regex.stringMatch(line);
//                  final words = match?.group(4);
//                  print(words);
                print(match);
                print("REGEX");
                showDialog(
                    context: context,
                    builder: (BuildContext context1) {
                      return Dialog(
                        child: Container(
                        width: 123,
                        height: height*0.3,
                          child: Selectable(
                            selectionController: _selectionController,
                              showSelection: true,
                              selectWordOnDoubleTap: true,
                              showPopup: true,
                              popupMenuItems: [
                              SelectableMenuItem(type: SelectableMenuItemType.copy),
                          SelectableMenuItem(
                            title: "Search Meaning",
                            isEnabled: (controller) {
                               //print('SelectableMenuItem Foo, isEnabled, selected text:
                              print("selected text is "+_selectionController.text.toString());
                              // ${controller!.text}');
                              return controller!.isTextSelected;
                            },
                            handler: (controller) {
                              DictionaryApi dictionary = DictionaryApi();

                              showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                builder: (builder) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: Container(
                                      padding: EdgeInsets.all(16),
                                      child: FutureBuilder(
                                        future:dictionary.getMeaning(_selectionController.text!) ,
                                        builder: (context, snapshot)  {
                                          if(snapshot.connectionState==ConnectionState.waiting){
                                            return SizedBox(height:30,width: 30,child: CircularProgressIndicator());
                                          }
                                          return Text(snapshot.data.toString());
                                        }),
                                      ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  );
                                },
                              );
                              return true;
                            },
                          ),],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Double Tap to Select Text And Search Meaning",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18.sp),),
                              Text(match.toString(),style: TextStyle(fontFamily: 'brh_dev',color: Colors.black,fontSize: 17.sp),),
                            ],
                          ),
                        ),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(14)),padding: EdgeInsets.symmetric(horizontal: 20.sp,vertical: 20.sp),),
                      );

                    });

              },

              model: lyricModel,
              position: playProgress,
              lyricUi: lyricUI,
              playing: isPlayed,
              size: Size(double.infinity, MediaQuery.of(context).size.height / 4),
              emptyBuilder: () => Center(
                child: Text(
                  "No lyrics",
                  style: lyricUI.getOtherMainTextStyle(),
                ),
              ),
              selectLineBuilder: (progress, confirm) {
                  audioPlayer.seek(Duration(milliseconds: progress));
                  playProgress= progress;
                  return Container();
                  },
            ),
             SliderTheme(
              data: SliderTheme.of(context).copyWith(
                inactiveTrackColor:
                Colors.white54,
                activeTrackColor: primaryColor,
                thumbColor: Colors.white,
                overlayColor: Color(0x29EB1555),
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 10.0),
                overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 30.0),
              ),
              child: Slider(
                onChanged: (v) {
                  print("ji");
                  if (_duration == null) {
                    return;
                  }

                  final Position = v * _duration!.inMilliseconds;
                  print(Position);
                  audioPlayer
                      .seek(Duration(milliseconds: Position.round()));
                  setState(() {
                    playProgress = v.toInt();
                    audioPlayer
                        .seek(Duration(milliseconds: Position.round()));
                  });
                },
                value: (_position != null &&
                    _duration != null &&
                    _position!.inMilliseconds > 0 &&
                    _position!.inMilliseconds <
                        _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
              ),

              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [_position==null?Container():Text(_printDuration(_position!),style: TextStyle(color: primaryColor,fontSize: 18.sp),),_duration==null?Container(): Text(_printDuration(_duration!),style: TextStyle(color: primaryColor,fontSize: 18.sp),)],
              ),
            ),
              SizedBox(
                width: width*0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        reverse();
                      },
                      child: Icon(
                        Icons.replay_10,
                        size: 55.sp,
                        color: Colors.white,

                      ),
                    ),
                    !isPlayed?GestureDetector(
                      onTap: (){
                        play();
                        print("PLAYED");
                      },
                      child: Icon(
                        Icons.play_arrow,
                        size: 55.sp,
                        color: Colors.white,

                      ),
                    ):GestureDetector(
                      onTap: (){
                        pause();
                        print("PAUSE");
                      },
                      child: Icon(
                        Icons.pause,
                        size: 55.sp,
                        color: Colors.white,

                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        forward();
                      },
                      child: Icon(
                        Icons.forward_10,
                        size: 55.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )

          ],
        ),
      ),
    );
  }
}
