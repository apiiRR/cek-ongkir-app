import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/berat.dart';
import 'widgets/kota.dart';
import 'widgets/provinsi.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkos Kirim'),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Provinsi(
              tipe: "asal",
            ),
            Obx(() => controller.hiddenKotaAsal.isTrue
                ? const SizedBox()
                : Kota(provId: controller.provAsalId.value, tipe: "asal")),
            const Provinsi(
              tipe: "tujuan",
            ),
            Obx(() => controller.hiddenKotaTujuan.isTrue
                ? const SizedBox()
                : Kota(provId: controller.provTujuanId.value, tipe: "tujuan")),
            const Berat(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: DropdownSearch<Map<String, dynamic>>(
                clearButtonProps: const ClearButtonProps(isVisible: true),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, bool) => Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      item["name"],
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                itemAsString: (item) => item["name"],
                items: const [
                  {"code": "jne", "name": "Jalur Nugraha Ekakurir (JNE)"},
                  {"code": "tiki", "name": "Titipan Kilat (TIKI)"},
                  {
                    "code": "pos",
                    "name": "Perusahaan Opsional Surat (POS Indonesia)"
                  }
                ],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      labelText: "Tipe Kurir",
                      hintText: "pilih tipe kurir...",
                      border: OutlineInputBorder()),
                ),
                onChanged: (value) {
                  if (value != null) {
                    controller.kurir.value = value["code"];
                    controller.showButton();
                  } else {
                    controller.hiddenButton.value = true;
                    controller.kurir.value = "";
                  }
                },
              ),
            ),
            Obx(() => controller.hiddenButton.isTrue
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: () => controller.ongkosKirim(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Colors.red.shade900),
                    child: const Text("CEK ONGKOS KIRIM"),
                  ))
          ],
        ),
      ),
    );
  }
}
