import 'package:get/get.dart';
import 'package:supabase_app_demo/utils/export.dart';
import 'custom_pdf_widget.dart';

class PDFMessageWidget extends StatelessWidget {
  final String pdfThumbnailUrl;
  final String fileName;

  const PDFMessageWidget({
    super.key,
    required this.pdfThumbnailUrl,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          CustomPdfView(
            pdfUrl: pdfThumbnailUrl,
            pdfName: fileName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 200.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        fileName,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'PDF Document',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.picture_as_pdf, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
