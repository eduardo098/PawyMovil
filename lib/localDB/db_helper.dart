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
        "${productoID} INTEGER,"
        "${shoppingCartName} TEXT,"
        "${shoppingCartPrice} DOUBLE,"
        "${shoppingCartQuantity} INTEGER"
        ")"
      );
    });
  }

  insertItem(Producto producto, int cantidad) async {
    final db = await database;
    var res = await db.query("$shoppingCartTable", where: "$shoppingCartName = ?", whereArgs: [producto.nombreProducto]);
    if (res.isNotEmpty) {
      var res = await db.update("${shoppingCartTable}", producto.toMapTest(),
      where: "$shoppingCartName = ?", whereArgs: [producto.nombreProducto]);

      return res;
    } else {
      var res = await db.rawInsert(
        "INSERT INTO ${shoppingCartTable}"
        "(${productoID}, ${shoppingCartName}, ${shoppingCartPrice}, ${shoppingCartQuantity})"
        " VALUES (?, ?, ?, ?)", [producto.idProducto, producto.nombreProducto, double.parse(producto.precio), cantidad]
      );

      return res;
    }
  }

  getAllProducts() async {
    final db = await database;
    var res = await db.query(shoppingCartTable);
    List<Producto> list =
        res.isNotEmpty ? res.map((c) => Producto.fromMapTest(c)).toList() : [];
    return list;
  }

  deleteProduct(int id) async {
    final db = await database;
    db.delete("$shoppingCartTable", where: "_id = ?", whereArgs: [id]);
  }
}