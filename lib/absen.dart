import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

TextEditingController _controllerNama = TextEditingController();
TextEditingController _controllerNIM = TextEditingController();
TextEditingController _controllerUbahNama = TextEditingController();
TextEditingController _controllerUbahNIM = TextEditingController();

_hapus() {
  _controllerNIM.text = '';
  _controllerNama.text = '';
}

final snackBarGagal = SnackBar(
  content: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("Data nim dan nama tidak boleh kosong",
        textAlign: TextAlign.center),
  ),
);

class PageAbsen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference users = fireStore.collection('users');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.cyan[700],
          title: Text("INFORMATIKA E 2019"),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 7 / 10,
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.dialpad),
                              labelText: "NIM"),
                          controller: _controllerNIM,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width * 7 / 10,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.person),
                              labelText: "Nama Lengkap"),
                          controller: _controllerNama,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // tambah data disini
                        if (_controllerNIM.text == '' ||
                            _controllerNama.text == '') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarGagal);
                        } else
                          users.add({
                            'nama': _controllerNama.text,
                            'nim': int.tryParse(_controllerNIM.text) ?? 0,
                          });
                        _controllerNama.text = '';
                        _controllerNIM.text = '';
                      },
                      child: Text("Kirim"),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.cyan[200]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.cyan[400],
                              border: Border(
                                right: BorderSide(color: Colors.black),
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Text("NIM",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.cyan[400],
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Text(
                                "Nama Mahasiswa",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                              stream: users.snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                      children: snapshot.data!.docs
                                          .map<Widget>(
                                            (e) => DataMahasiswa(
                                              e['nim'],
                                              e['nama'],
                                              onEdit: () {
                                                users.doc(e.id).update({
                                                  'nim': int.tryParse(
                                                          _controllerUbahNIM
                                                              .text) ??
                                                      0,
                                                  'nama':
                                                      _controllerUbahNama.text,
                                                });
                                              },
                                              klikEdit: () {
                                                _controllerUbahNIM.text =
                                                    e['nim'].toString();
                                                _controllerUbahNama.text =
                                                    e['nama'].toString();
                                              },
                                              onDelete: () {
                                                users.doc(e.id).delete();
                                              },
                                            ),
                                          )
                                          .toList());
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class DataMahasiswa extends StatelessWidget {
  final String nama;
  final int nim;
  final Function onEdit;
  final Function onDelete;
  final Function klikEdit;

  DataMahasiswa(this.nim, this.nama,
      {required this.onEdit, required this.onDelete, required this.klikEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.cyan[200]),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.28,
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black))),
            child: Center(child: Text("$nim")),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 50,
              // width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: Center(child: Text("$nama")),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return HapusData(onDelete: onDelete);
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20),
            onPressed: () {
              klikEdit();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return UbahData(onEdit: onEdit);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class HapusData extends StatelessWidget {
  const HapusData({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: new Text("Are You sure want to delete "),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK DELETE!",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.red,
          // hapus data
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
        ),
        new RaisedButton(
          child: new Text(
            "CANCEL",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class UbahData extends StatelessWidget {
  final Function onEdit;

  const UbahData({Key? key, required this.onEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Ubah Data")),
      content: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * 1.5,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "NIM"),
              controller: _controllerUbahNIM,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.person),
                  labelText: "Nama Lengkap"),
              controller: _controllerUbahNama,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                _hapus();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Perbarui Data'),
              // edit data
              onPressed: () {
                onEdit();
                Navigator.of(context).pop();
                _controllerUbahNIM.text = '';
                _controllerUbahNama.text = '';
              },
            ),
          ],
        ),
      ],
    );
  }
}
