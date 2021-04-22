import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'WalletDescraption.dart';

class ChatPage extends StatefulWidget {


  // ChatPage(this.loginId, this.contactCustomerId,this.name);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var loginId;
  var contactCustomerId;
  String name;
  bool isShowSticker;
  String idsender;
  var respondata;
  var _user = types.User(id: "");
  /// Variables
  File imageFile;
  var base64Image;
  String length="10";


  void postmessage(String messages,var base64Image,String sticker) async {
    String SignApiUrl = "http://qsnap.net/api/customer_Chat_insert";
    print(SignApiUrl);
    var response = await http.post(SignApiUrl, body: {
      'senderId':loginId,
      'receiverId':contactCustomerId,
      'message': messages,
      'image': base64Image,
      'sticker': sticker,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body)["response"]["msg"];
    print('Response convert body: ${result}');
  }

  Future <List<types.Message>>  _getlistmsg() async {

      var url = 'http://qsnap.net/api/CustomerChat_messages?senderId=$loginId&receiverId=$contactCustomerId&length=$length&start=1';

    print(url);
    var response = await http.get(url);
     respondata = json.decode(response.body)["response"]["data"];
    print(respondata);
    setState(() {

      print(_user.id);
      print("_user.id");
      _messages = [];
    });


    print("respondata in$respondata");
    for (var u in respondata) {
      final textMessage = types.TextMessage(
        authorId: u["senderId"],
        id: u["chatId"],
        text:u["message"],
        timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
      );
      print("message----->");
      print(u["message"]);
      if(u["image"]==""){
        _messages.insert(0, textMessage);
        print("ininin");
        print("ininin$_messages");}
      else if(u["message"]==""){
        print("hi hassan");
        // ignore: missing_required_param

        final message = types.ImageMessage(
          authorId: u["senderId"],
          id: u["chatId"],
          timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
          uri: u["image"],
          imageName: "hi",
          size: 20,


        );
        _messages.insert(0, message);
      }


    }

    print("out out out");

    print("ssssssssssssssssss$_messages");
    return _messages;
  }

  Future <List<Stickers>>  _getstickers() async {
    var url = 'http://qsnap.net/api/stickers';
    print(url);
    var response = await http.get(url);
    var respondata = json.decode(response.body)["response"]["data"];
    print(respondata);

    print("respondata in$respondata");
    List<Stickers> list = [];

    for (var u in respondata) {

      Stickers x = Stickers(u["id"],u["sticker"]);
      list.add(x);
    }
    for (var c in list) {
      print(c.sticker);
    }
    print("out out out");

    print("list$list");
    return list;
  }
  List<types.Message> _messages;

  Timer _Timer;

  @override
  void initState() {

    super.initState();
    _loadMessages();
    const fiveSec = const Duration(seconds: 5);
    _Timer=new Timer.periodic(fiveSec, (Timer t) {
      _getlistmsg();
    });
    _getlistmsg();
    isShowSticker = false;
  }
@override
  void dispose() {
    _Timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  emojiContainer();
                },
                child:  Align(
                  alignment: Alignment.center,
                  child: Text('Sticker'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Align(
                  alignment: Alignment.center,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleFilePressed(types.FileMessage message) async {
    await OpenFile.open(message.uri);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().getImage(

      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final imageName = result.path.split('/').last;
      final message = types.ImageMessage(
        authorId: _user.id,
        height: image.height.toDouble(),
        id: Uuid().v4(),
        imageName: imageName,
        size: bytes.length,
        timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
        uri: result.path,
        width: image.width.toDouble(),
      );

      setState(() {
        imageFile = File(result.path);
        print("imageFile----------------------------->$imageFile");

        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print(imageBytes);
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        // print(base64Image);
        postmessage("",base64Image,"");
      });

      _addMessage(message);
    } else {
      // User canceled the picker
    }
  }


  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final currentMessage = _messages[index] as types.TextMessage;
    final updatedMessage = currentMessage.copyWith();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      authorId: _user.id,
      id: Uuid().v4(),
      text: message.text,
      timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    );
    postmessage(message.text,"","");
    _addMessage(textMessage);
  }

  void emojiContainer() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child:FutureBuilder(
            future: _getstickers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null)  {

            return Center(
                child: CircularProgressIndicator(
                  backgroundColor:Colors.black,
                  valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffffd800)),
                )
            );
          }else{
return GridView.builder(
    gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
    itemCount: snapshot.data.length,

    itemBuilder: (context, i){
return
  FlatButton(
    onPressed: () {
      Navigator.pop(context);
      postmessage("","",snapshot.data[i].id);
    },
    child: Image.network(
      snapshot.data[i].sticker,
        width: 50.0,
        height: 50.0,
      fit: BoxFit.cover,
    ),
  );
    });
          }

        }) ,
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
          padding: EdgeInsets.all(5.0),
          height: 200.0,
        );
      },
    );
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      _messages = messages;
      print("hi--->$_messages");
    });
  }


  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    print(args["sender_id"]);
    name=args["receiver_name"];
    loginId=args["sender_id"];
    _user.id=loginId;
    contactCustomerId=args["receiverId"];
    if(_messages == null||_messages.length == 0)  {
      return Center(
          child: CircularProgressIndicator(
            backgroundColor:Colors.black,
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffffd800)),
          )
      );
    }else if(_messages.isNotEmpty){
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xff000000),
            centerTitle: true,
            elevation: 3,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xffffd800),
                size: 25,
              ),
              onPressed: () {
                _Timer.cancel();
                Navigator.pop(context);
                // print("widget--->");
                // print(widget.id);
                // print(widget.contactCustomerId);
                // print(widget.loginId);
                // Navigator.pushReplacement(context,  MaterialPageRoute(
                //     builder: (context) =>
                //         WalletDescraption(widget.id,0,widget.contactCustomerId, widget.loginId)),
                // );
              },
            ),
//        toolbarHeight: 65,
            title: Text(name),
bottom:PreferredSize(
          child: Container(
       padding: EdgeInsets.only(bottom: 5),

            child: FlatButton(
                onPressed: () {
                  setState(() {
                    length="-1";
                    _getlistmsg();
                  });


                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color(0xffffd800),
                padding: EdgeInsets.all(5),
                child: Text(
                  "Load All Messages",
                  style: TextStyle(
                      color:Colors.black , fontSize: 14),
                )),
            color: Color(0xff000000),
            height: 30.0,
          ),
            preferredSize: Size.fromHeight(20.0)) ,
          ),
          body: Chat(
            messages: _messages,
            onAttachmentPressed: _handleAtachmentPressed,
            onFilePressed: _handleFilePressed,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: _user,

          ),
        ),
        onWillPop: onBackPress,
      );
    }

  }



  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      _Timer.cancel();
      Navigator.pop(context);
    }

    return Future.value(false);
  }
}
class MSG{
  String id;
  String senderId;
  String receiverId;
  String datetime;
  String message;
  String image;
  MSG(this.id, this.senderId, this.receiverId, this.datetime, this.message,this.image);
}


class Stickers{
  String id;
  String sticker;

  Stickers(this.id, this.sticker);
}