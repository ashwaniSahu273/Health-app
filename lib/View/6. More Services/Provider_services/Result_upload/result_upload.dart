import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'result_upload_controller.dart';
// import 'pdf_viewer_screen.dart';

class ResultUpload extends StatelessWidget {
  ResultUpload({Key? key}) : super(key: key);

  final ResultUploadController controller = Get.put(ResultUploadController());

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
          // controller.pickFile();
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
        child: Obx(() {
          return GridView.builder(
            itemCount: controller.pdfData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    Get.to(() => PdfViewerScreen(
                        pdfUrl: controller.pdfData[index]["url"]));
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
                          child: Text(controller.pdfData[index]["name"]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PDFDocument>(
      future: PDFDocument.fromURL(pdfUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading PDF"));
        } else {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: PDFViewer(
                document: snapshot.data!,
              ),
            ),
          );
        }
      },
    );
  }
}
