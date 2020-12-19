import 'dart:async';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.


class DbHandler{
   static Database _database;

   static Future<Database> getDatabase() async{
     WidgetsFlutterBinding.ensureInitialized();
     if(_database == null){
       _database = await openDatabase(
         join(await getDatabasesPath(), 'watt_calculator.db')
       );
       criarTabelas();
       seedDatabase();
     }

     criarTabelas();
     return _database;
   }

   static criarTabelas(){
     _database.execute("CREATE TABLE IF NOT EXISTS aparelho(id primary key, nome text, potencia_kw real);");
     _database.execute("CREATE TABLE IF NOT EXISTS aparelhoconsumo(id primary key, horasAoDia real, aparelho_id integer, FOREIGN KEY(aparelho_id) REFERENCES aparelho(id));");
   }

   static seedDatabase(){
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Chuveiro', 5.0)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Ar condicionado', 1.6)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Geladeira', 0.35)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Televisor', 0.2)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Computador', 0.35)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Lâmpada led', 0.006)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Máquina lavar', 3.5)");
     _database.execute("Insert into aparelho (nome, potencia_kw) Values ('Aquecedor', 1.5)");
   }
}


