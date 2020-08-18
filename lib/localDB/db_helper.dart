import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawyapp/models/product.dart';

class DatabaseHelper {
  static final _databaseVersion = 1;

  static final shoppingCartTable = "shopping_cart";

  static final shoppingCartID = "_id";
  static final productoID = "id_producto";
  static final shoppingCartImage = "img_url";
  static final shoppingCartName = "nombre_producto";
  static final shoppingCartPrice = "precio";
  static final shoppingCartQuantity = "cantidad";

  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();

  static Database _database;
  
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pawylocal.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${shoppingCartTable} ("
        "${shoppingCartID} INTEGER PRIMARY KEY,"
        "${shoppingCartImage} TEXT,"
        "${productoID} INTEGER,"
        "${shoppingCartName} TEXT UNIQUE,"
        "${shoppingCartPrice} DOUBLE,"
        "${shoppingCartQuantity} INTEGER"
        ")"
      );
    });
  }

  insertItem(Producto producto, int cantidad) async {
    final db = await database;

    var name = producto.nombreProducto;

    var checkIfExists = await db.rawQuery("SELECT COUNT(*) FROM $shoppingCartTable WHERE $shoppingCartName = '$name'");

    int count = Sqflite.firstIntValue(checkIfExists);

    if(count > 0) {
      var res = await db.rawUpdate(
        "UPDATE $shoppingCartTable "
        "SET $shoppingCartQuantity = $shoppingCartQuantity + $cantidad "
        "WHERE $shoppingCartName = '$name'"
      );

      return res;
    } else {
      var res = await db.rawInsert(
        "INSERT INTO ${shoppingCartTable}"
        "(${shoppingCartImage}, ${productoID}, ${shoppingCartName}, ${shoppingCartPrice}, ${shoppingCartQuantity})"
        " VALUES (?, ?, ?, ?, ?)", [producto.imgUrl, producto.idProducto, producto.nombreProducto, double.parse(producto.precio), cantidad]
      );

      return res;
    }

  }

  Future<List> getAllProducts() async {
    final db = await database;
    var res = await db.query(shoppingCartTable);
    List<Producto> list =
        res.isNotEmpty ? res.map((c) => Producto.fromMapTest(c)).toList() : [];
    return list;
  }


  getAllProductsList() async {
    final db = await database;
    var res = await db.query(shoppingCartTable);
    List<Producto> list =
        res.isNotEmpty ? res.map((c) => Producto.fromMapTest(c)).toList() : [];
    return list;
  }

  getCount() async {
    //database connection
    final db = await database;
    var x = await db.rawQuery("SELECT COUNT (*) FROM $shoppingCartTable");
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  getTotal() async {
    final db = await database;

    var query = await db.rawQuery("SELECT SUM(cantidad*precio) FROM $shoppingCartTable");

    String total = query.first.values.first.toString();
    
    return double.tryParse(total);
  }

  deleteProduct(int id) async {
    final db = await database;
    db.delete("$shoppingCartTable", where: "_id = ?", whereArgs: [id]);
  }

  deleteAllProducts() async {
    final db = await database;
    db.delete("$shoppingCartTable");
  }
}