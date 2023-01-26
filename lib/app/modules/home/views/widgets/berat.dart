import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class Berat extends GetView<HomeController> {
  const Berat({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: false,
              controller: controller.beratController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: "Berat Barang",
                  hintText: "Berat Barang",
                  border: OutlineInputBorder()),
              onChanged: (value) => controller.ubahBerat(value),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 150,
            child: DropdownSearch<String>(
              popupProps: const PopupProps.bottomSheet(
                  showSelectedItems: true, showSearchBox: true),
              items: const [
                "ton",
                "kwintal",
                "ons",
                "lbs",
                "pound",
                "kg",
                "hg",
                "dag",
                "gram",
                "dg",
                "cg",
                "mg"
              ],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    labelText: "Satuan Berat", border: OutlineInputBorder()),
              ),
              onChanged: (value) => controller.ubahSatuan(value!),
              selectedItem: "gram",
            ),
          )
        ],
      ),
    );
  }
}
