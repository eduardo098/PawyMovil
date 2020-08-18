import "package:flutter/material.dart";
import "utils/utils.dart";

class OrderComment extends StatefulWidget {
  String idOrden;
  OrderComment({this.idOrden});
  @override
  _OrderCommentState createState() => _OrderCommentState();
}

class _OrderCommentState extends State<OrderComment> {
  TextEditingController commentController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          topBar(),
          Container(
            height: 400,
            color: Colors.white60,
            padding: EdgeInsets.all(10.0),
            child: new ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 400.0,
              ),
              child: new Scrollbar(
                child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: SizedBox(
                    height: 390.0,
                    child: new TextField(
                      controller: commentController,
                      maxLines: 100,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe tu comentario aquí',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            child: RaisedButton(  
                color: Colors.blue[400],
                onPressed: () {
                addComment(commentController.text, widget.idOrden);  
                Navigator.pop(context, true);
              },
              child: Text("Enviar comentario", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.greenAccent),
              )
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Deja un comentario", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
            )
          ),
        ],
      )
    );
  }
}