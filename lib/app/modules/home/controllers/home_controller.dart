import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../kurir_model.dart';

class HomeController extends GetxController {
  var hiddenKotaAsal = true.obs;
  var provAsalId = 0.obs;
  var kotaAsalId = 0.obs;
  var hiddenKotaTujuan = true.obs;
  var provTujuanId = 0.obs;
  var kotaTujuanId = 0.obs;
  var hiddenButton = true.obs;
  var kurir = "".obs;

  double berat = 0.0;
  String satuan = "gram";

  late TextEditingController beratController;

  void ongkosKirim() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");

    try {
      final response = await http.post(url, body: {
        "origin": "${kotaAsalId.value}",
        "destination": "${kotaTujuanId.value}",
        "weight": "$berat",
        "courier": kurir.value
      }, headers: {
        "key": "6f2809518477c7ee921de5f8c426a1b3",
        "content-type": "application/x-www-form-urlencoded"
      });

      var data = jsonDecode(response.body) as Map<String, dynamic>;
      var result = data["rajaongkir"]["results"] as List<dynamic>;

      var listAllKurir = Kurir.fromJsonList(result);
      var kurir0 = listAllKurir[0];

      Get.defaultDialog(
          title: kurir0.name,
          content: Column(
            children: kurir0.costs
                .map((e) => ListTile(
                      title: Text(e.service),
                      subtitle: Text("Rp.${e.cost[0].value}"),
                      trailing: Text(kurir0.code != "pos"
                          ? "${e.cost[0].etd} HARI"
                          : e.cost[0].etd),
                    ))
                .toList(),
          ));
    } catch (err) {
      print(err);
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: err.toString());
    }
  }

  void showButton() {
    if (kotaAsalId.value != 0 &&
        kotaTujuanId.value != 0 &&
        berat > 0 &&
        kurir.value != "") {
      hiddenButton.value = false;
    } else {
      hiddenButton.value = true;
    }
  }

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    String cekSatuan = satuan;
    switch (cekSatuan) {
      case "ton":
        berat = berat * 1000000;
        break;
      case "kwintal":
        berat = berat * 100000;
        break;
      case "ons":
        berat = berat * 1000;
        break;
      case "lbs":
        berat = berat * 2204.62;
        break;
      case "pound":
        berat = berat * 2204.62;
        break;
      case "kg":
        berat = berat * 1000;
        break;
      case "hg":
        berat = berat * 100;
        break;
      case "dag":
        berat = berat * 10;
        break;
      case "gram":
        berat = berat * 1;
        break;
      case "dg":
        berat = berat / 10;
        break;
      case "cg":
        berat = berat / 100;
        break;
      case "mg":
        berat = berat / 1000;
        break;
      default:
    }

    print("$berat gram");
    showButton();
  }

  void ubahSatuan(String value) {
    berat = double.tryParse(beratController.text) ?? 0;
    switch (value) {
      case "ton":
        berat = berat * 1000000;
        break;
      case "kwintal":
        berat = berat * 100000;
        break;
      case "ons":
        berat = berat * 1000;
        break;
      case "lbs":
        berat = berat * 2204.62;
        break;
      case "pound":
        berat = berat * 2204.62;
        break;
      case "kg":
        berat = berat * 1000;
        break;
      case "hg":
        berat = berat * 100;
        break;
      case "dag":
        berat = berat * 10;
        break;
      case "gram":
        berat = berat * 1;
        break;
      case "dg":
        berat = berat / 10;
        break;
      case "cg":
        berat = berat / 100;
        break;
      case "mg":
        berat = berat / 1000;
        break;
      default:
    }

    satuan = value;
    print("$berat gram");
    showButton();
  }

  @override
  void onInit() {
    beratController = TextEditingController(text: "$berat");
    super.onInit();
  }

  @override
  void onClose() {
    beratController.dispose();
    super.onClose();
  }
}
