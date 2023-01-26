import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../city_model.dart';
import '../../controllers/home_controller.dart';

class Kota extends GetView<HomeController> {
  const Kota({super.key, required this.provId, required this.tipe});

  final int provId;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        clearButtonProps: const ClearButtonProps(isVisible: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                label: Text(tipe == "asal"
                    ? "Kota / Kabupaten Asal"
                    : "Kota / Kabupaten Tujuan"),
                border: const OutlineInputBorder())),
        asyncItems: (String filter) async {
          Uri uri = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=$provId");

          try {
            final response = await http.get(uri,
                headers: {"key": " 6f2809518477c7ee921de5f8c426a1b3 "});

            var data = jsonDecode(response.body) as Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];

            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var listAllCity = data["rajaongkir"]["results"] as List<dynamic>;

            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (e) {
            print(e);
            return List<City>.empty();
          }
        },
        popupProps: PopupProps.menu(
            showSearchBox: true,
            itemBuilder: (context, item, bool) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "${item.type} ${item.cityName}",
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }),
        itemAsString: (item) => "${item.type} ${item.cityName}",
        onChanged: (City? data) {
          if (data != null) {
            if (tipe == "asal") {
              controller.kotaAsalId.value = int.parse(data.cityId!);
            } else {
              controller.kotaTujuanId.value = int.parse(data.cityId!);
            }
          } else {
            if (tipe == "asal") {
              controller.kotaAsalId.value = 0;
            } else {
              controller.kotaTujuanId.value = 0;
            }
          }
          controller.showButton();
        },
      ),
    );
  }
}
