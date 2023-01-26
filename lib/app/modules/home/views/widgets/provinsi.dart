import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controllers/home_controller.dart';
import '../../province_model.dart';

class Provinsi extends GetView<HomeController> {
  const Provinsi({super.key, required this.tipe});

  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        clearButtonProps: const ClearButtonProps(isVisible: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                label:
                    Text(tipe == "asal" ? "Provinsi Asal" : "Provinsi Tujuan"),
                border: OutlineInputBorder())),
        asyncItems: (String filter) async {
          Uri uri = Uri.parse("https://api.rajaongkir.com/starter/province");

          try {
            final response = await http.get(uri,
                headers: {"key": " 6f2809518477c7ee921de5f8c426a1b3 "});

            var data = jsonDecode(response.body) as Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];

            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var listAllProvince =
                data["rajaongkir"]["results"] as List<dynamic>;

            var models = Province.fromJsonList(listAllProvince);
            return models;
          } catch (e) {
            print(e);
            return List<Province>.empty();
          }
        },
        popupProps: PopupProps.menu(
            showSearchBox: true,
            itemBuilder: (context, item, bool) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "${item.province}",
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }),
        itemAsString: (item) => item.province!,
        onChanged: (Province? data) {
          if (data != null) {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.provAsalId.value = int.parse(data.provinceId!);
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.provTujuanId.value = int.parse(data.provinceId!);
            }
          } else {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = true;
              controller.provAsalId.value = 0;
            } else {
              controller.hiddenKotaTujuan.value = true;
              controller.provTujuanId.value = 0;
            }
          }
          controller.showButton();
        },
      ),
    );
  }
}
