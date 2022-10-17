import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ChatAppDetailAppBar extends StatefulWidget {
   String id = "111";
   String userid ;
   ChatAppDetailAppBar({required this.id,required this.userid});
 
  @override
  State<ChatAppDetailAppBar> createState() => _ChatAppDetailAppBarState();
}

class _ChatAppDetailAppBarState extends State<ChatAppDetailAppBar> {
  @override
  late String name;
  late String backgroundimgage;
  late String status;
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.id).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          name = "Name not Written By User";
          backgroundimgage = "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png";
          status = "offline";
        }else{
         DocumentSnapshot data  = (snapshot.data! as dynamic);
         name = data['name'];
          backgroundimgage = data['url'];
         status = data['status'];
        }
        return  AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                 const SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage : NetworkImage(backgroundimgage),
                    maxRadius: 20,
                  ),
                 const SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(name,style:const TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                       const SizedBox(height: 6,),
                        Text(status,style:const TextStyle(color: Colors.black, fontSize: 13),),
                      ],
                    ),
                  ),
                   
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {
               await Navigator.pushNamed(context,"/FriendsProfile",arguments: {"userid" :widget.userid,"friendid" : widget.id});
            },
          )
        
                ],
              ),
            ),
          ),
        );
      }
  ); 
  }
}