
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_chat/Pages/chatDetailAppbar.dart';
import 'package:my_chat/Pages/chatmessage.dart';
import 'package:my_chat/Services/messagecrud.dart';
import 'package:my_chat/Services/localstorage.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  late String friendId;
  late String userId;
  late String roomId;
  ChatDetailPage({required this.friendId}) {
    userId = localStorage.getuserid();
    int user = int.parse(userId);
    int friend = int.parse(friendId);
    if (user > friend) {
      int temp = user;
      user = friend;
      friend = temp;
    }
    roomId = user.toString() + friendId.toString();
    print(roomId);
  }
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final text = TextEditingController();
  var messages = MessageCrud();
   final snackBar = SnackBar(
            backgroundColor: Colors.blue[50],
            duration: const Duration(seconds: 200),
            content: const Text('Your File Is Uploading Don\'t do Any thing',style: TextStyle(color: Colors.blue),),
            
          );
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
      
      resizeToAvoidBottomInset:false,
      
      body: Padding(
        padding: EdgeInsets.only(
         bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Container(
              child: ChatAppDetailAppBar(id: widget.friendId,userid: widget.userId),
            ),
            SizedBox(
              height: h * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: chatmessages(friendId: widget.friendId),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                       onChanged: (String value){
                        print("DONe -- " + MediaQuery.of(context).viewInsets.bottom.toString());
                      },
                      controller: text,
                     
                      
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    heroTag: "#select",
                    onPressed: () {},
                    child: SpeedDial(
                      //Speed dial menu

                      icon: Icons.add, //icon on Floating action button
                      activeIcon:
                          Icons.close, //icon when menu is expanded on button
                      backgroundColor: Colors.blue, //background color of button
                      foregroundColor:
                          Colors.white, //font color, icon color in button
                      activeBackgroundColor:
                          Colors.blue, //background color when menu is expanded
                      activeForegroundColor: Colors.white,
                      buttonSize: const Size(45, 45), //button size
                      visible: true,
                      closeManually: false,
                      curve: Curves.linear,

                      onOpen: () =>
                          print('OPENING DIAL'), // action when menu opens
                      onClose: () =>
                          print('DIAL CLOSED'), //action when menu closes

                      elevation: 0, //shadow elevation of button
                      shape: const CircleBorder(), //shape of button

                      children: [
                        SpeedDialChild(
                          child: const Icon(Icons.file_copy),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          label: 'Files',
                          labelStyle: const TextStyle(fontSize: 18.0),
                          onTap: () async{
                                FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: true,
                              allowedExtensions: ['mp4','mp3','mkv','pdf','doc','docs','execl'],
                            );

                            if (result != null) {
                              String path = result.files.first.path ?? "";
                              ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds : 10),
                                  content: const Text('File Selected',style: TextStyle(color: Colors.black),),
                                  action: SnackBarAction(
                                    label: 'Send',
                                    textColor: Colors.black,
                                    onPressed: () async {
                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      await messages.sendFileMessage(widget.roomId, widget.userId, widget.friendId, path);
                                       // ignore: use_build_context_synchronously
                                       ScaffoldMessenger.of(context).clearSnackBars();
                                    },
                                    
                                  ),
                                ),
                              );
                            }
                            else{}
                          },
                          onLongPress: () => print('SECOND CHILD LONG PRESS'),
                        ),
                        SpeedDialChild(
                          //speed dial child
                          child: const Icon(Icons.gif),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          label: 'GIF',
                          labelStyle: const TextStyle(fontSize: 18.0),
                          onTap: () async {
                              FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: true,
                              allowedExtensions: ['gif'],
                            );

                            if (result != null) {
                              String path = result.files.first.path ?? "";
                              ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds : 10),
                                  content: const Text('File Selected',style: TextStyle(color: Colors.black),),
                                  action: SnackBarAction(
                                    label: 'Send',
                                    textColor: Colors.black,
                                    onPressed: () async {
                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      await messages.sendFileMessage(widget.roomId, widget.userId, widget.friendId, path);
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                    },
                                    
                                  ),
                                ),
                              );
                            }
                            else{}
                            
                          },
                          onLongPress: () => print('GIF'),
                        ),
                        
                        SpeedDialChild(
                          child: const Icon(Icons.image),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          label: 'Image',
                          labelStyle: const TextStyle(fontSize: 18.0),
                          onLongPress: () => print('THIRD CHILD'),
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: true,
                              allowedExtensions: ['jpg', 'png', 'jpeg'],
                            );

                            if (result != null) {
                              String path = result.files.first.path ?? "";
                              ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds : 10),
                                  content: const Text('File Selected',style: TextStyle(color: Colors.black),),
                                  action: SnackBarAction(
                                    label: 'Send',
                                    textColor: Colors.black,
                                    onPressed: () async {
                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      await messages.sendFileMessage(widget.roomId, widget.userId, widget.friendId, path);
                                       ScaffoldMessenger.of(context).clearSnackBars();
                                    },
                                    
                                  ),
                                ),
                              );
                            }
                            else{}
                          },
                        ),

                        //add more menu item childs here
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: "#send",
                    onPressed: () {
                      if (text.text.isNotEmpty) {
                        messages.sendTextMessage(widget.roomId, widget.userId,
                            widget.friendId, text.text);
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.send,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
