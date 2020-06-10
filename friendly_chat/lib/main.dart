import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData.light(),
      home: FriendlyChat(),
    );
  }
}

class FriendlyChat extends StatefulWidget {
  @override
  _FriendlyChatState createState() => _FriendlyChatState();
}


class _FriendlyChatState extends State<FriendlyChat> with TickerProviderStateMixin{

  TextEditingController _textEditingController = new TextEditingController();
  List<ChatMessage> _messages = <ChatMessage>[];
  bool isComposing = false;

  void _handleSubmitted(String text){
    _textEditingController.clear();
    ChatMessage _message = new ChatMessage(
      text: text,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 600),),
    );
    setState(() {
      _messages.insert(0, _message);
      _message.animationController.forward();
    });

  }

  Widget _builtTextComposer(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: _textEditingController,
              onSubmitted: isComposing ? _handleSubmitted : null,  //modified
              onChanged: (String text){
                setState(() {
                  isComposing = text.length > 0;
                });
              },
              style: TextStyle(height: 1.5, fontSize: 18.0,),

              decoration: InputDecoration(hintText: 'Type a message', border: InputBorder.none),
            ),
          ),
        ),
        Container(
          child: IconButton(icon: Icon(Icons.send),
            onPressed: isComposing? () => _handleSubmitted(_textEditingController.text) : null,
            color: Theme.of(context).accentColor,),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friendly Chat'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor),
              child: _builtTextComposer(),
            ),
        ],
      )
    );
  }

  @override
  void dispose(){
    for(ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String _name = 'Hari';
  final AnimationController animationController;
  ChatMessage({this.text, this.animationController}){
  }
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController, curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
              child: CircleAvatar(child: Text(_name[0]),),
            ),
            
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subtitle,),
                  SizedBox(height: 8.0,),
                  Text(text, style: Theme.of(context).textTheme.body1,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



