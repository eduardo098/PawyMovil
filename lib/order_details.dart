import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'utils/utils.dart';
import 'models/orderitem.dart';
import 'order_comment.dart';

class OrderDetails extends StatefulWidget {
  String orderNumber;
  List<ItemOrden> orderItems;
  bool isCompleted;
  String serverUrl = "http://192.168.1.67";
  OrderDetails({this.orderNumber, this.orderItems});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  Future<ItemOrden> _orderDetails; 
  Future<ItemOrden> _orderState;
  List<ItemOrden> content;
  String serverUrl = "http://192.168.1.67";

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
    _orderDetails = fetchOrderDetails(widget.orderNumber);
    _orderState = fetchOrderDetails(widget.orderNumber);
    content = widget.orderItems;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child: ListView(
        shrinkWrap: true,
        primary: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          topBar(),
          title("Número de orden"),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20),
            child: Text(widget.orderNumber, style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w500, fontSize: 25)),
          ),
          title("Estado de la orden"),
          FutureBuilder(
            future: _orderDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var estado = snapshot.data.estadoOrden;
                var comentarios = snapshot.data.comentarios;
                return Column(
                  children: <Widget>[
                    orderStatusBar(estado),
                    Align(
                      alignment: Alignment.topLeft, 
                      child: title("Comentarios"),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        child: comentarios != null ? Text(
                          comentarios,
                          style: TextStyle(fontSize: 18, letterSpacing: 0.5)
                        ) : Text("Podrás dejar tu opinión una vez que recojas tu producto."),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft, 
                      child: title("Productos"),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      itemCount: widget.orderItems.length,            
                      itemBuilder: (BuildContext context, int index) {
                        return orderItem(widget.orderItems[index]);
                      },
                    ),
                    estado == "Completada" && comentarios == null ? Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: RaisedButton(  
                        color: Colors.blue[400],
                        onPressed: () {
                          Navigator.of(context).
                          push(MaterialPageRoute(builder: (context) => OrderComment(idOrden: snapshot.data.idOrden))).then((value) => value ? setState(() {_orderDetails = fetchOrderDetails(snapshot.data.idOrden);}) : null);
                        },
                        child: Text("DEJAR UN COMENTARIO", style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ) : Text(""),
                    estado == "Completada" && comentarios != null ? Text("")
                    : Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: RaisedButton(  
                        color: Colors.redAccent[400],
                        onPressed: () {
                          cancelAlertDialog("¿Estás seguro de querer cancelar la orden?");
                        },
                        child: Text("CANCELAR ORDEN", style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } 
          ),
        ],
      )
      )
    );
  }

  Widget orderStatusBar(String estado) {
    switch (estado) {
      case "Recibida": {
        return orderProgressBar(1, "Orden Recibida", Alignment.centerLeft);
      }
      break;

      case "En Preparacin": {
        return orderProgressBar(2, "En preparación", Alignment.center);
      }
      break;

      case "Completada": {
        widget.isCompleted = true;
        return orderProgressBar(3, "Completada", Alignment.centerRight);
      }
      break;
    }
  }
  void cancelAlertDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: double.maxFinite,
                child: Text(message)
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Si"),
                onPressed: () {
                  cancelOrder(widget.orderItems, widget.orderItems[0].id).then((value) {
                    if (value) {
                      Navigator.pop(context);
                    } else {
                      cancelAlertDialog("Ha ocurrido un error.");
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
      }
    );
    Navigator.pop(context, true);
  }


  Widget title(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 20),
      child: Text(text, style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.w500, fontSize: 15)),
    );
  }

  Widget orderProgressBar(int currentStep, String stepName, Alignment alignment) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          StepProgressIndicator(
              totalSteps: 3,
              currentStep: currentStep,
              selectedColor: Colors.greenAccent,
              unselectedColor: Colors.greenAccent[100],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Align(
              alignment: alignment,
              child: Text(stepName, style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w500, fontSize: 15)),
            ),
          )
        ],
      )
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
              child: Text("Detalles", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
            )
          ),
        ],
      )
    );
  }

  Widget orderItem(ItemOrden item) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width - 60,
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 130,
                  child: Image.network(
                  serverUrl + item.imgUrl,
                  fit: BoxFit.cover,
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(item.nombreProducto, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                      )
                    ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text("\$" + item.precioUnitario, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                          )
                        ),
                        Align(
                          child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 20, right: 30),
                              child: Text("Cantidad: " + item.cantidad, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
