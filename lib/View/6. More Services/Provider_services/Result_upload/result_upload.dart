// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';

class ResultUpload extends StatefulWidget {
  const ResultUpload({super.key});

  @override
  State<ResultUpload> createState() => _ResultUploadState();
}

class _ResultUploadState extends State<ResultUpload> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];

  Future<String> uploadpdf(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadpdf(fileName, file);
      await _firebaseFirestore
          .collection("pdfs")
          .add({"name": fileName, "url": downloadLink});
      print("PDF UPLOADED");
    }
  }

  void getAllPdf() async {
    final results = await _firebaseFirestore.collection("pdfs").get();
    pdfData = results.docs.map((e) => e.data()).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purple,
        centerTitle: true,
        title: Text("Upload Result here".tr),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.purple,
        onPressed: () {
          pickFile();
        },
        child: const Icon(Icons.upload),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          itemCount: pdfData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  Get.to(
                      () => PdfViewerScreen(Pdfurl: pdfData[index]["url"]));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/logo/harees_logo.png",
                        height: 120,
                        width: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(pdfData[index]["name"]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String Pdfurl;
  const PdfViewerScreen({
    Key? key,
    required this.Pdfurl,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  void initializePdf() async {
    document = await PDFDocument.fromURL(widget.Pdfurl);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: document != null
            ? PDFViewer(
                document: document!,
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
