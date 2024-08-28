import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../utils/export.dart';

class CustomPdfView extends StatefulWidget {
  final String pdfUrl;
  final String pdfName;
  const CustomPdfView({
    super.key,
    required this.pdfUrl,
    required this.pdfName,
  });
  @override
  State<CustomPdfView> createState() => _CustomPdfViewState();
}

class _CustomPdfViewState extends State<CustomPdfView> {
  final PdfViewerController pdfViewerController = PdfViewerController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 17.sp,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 50.h,
          title: Text(
            widget.pdfName,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.white,
              fontSize: 17.sp,
            ),
          ),
        ),
        body: SafeArea(
          bottom: true,
          top: true,
          child: SfPdfViewer.network(
            widget.pdfUrl,
            currentSearchTextHighlightColor: Colors.white,
            otherSearchTextHighlightColor: Colors.white,
            controller: pdfViewerController,
            initialScrollOffset: Offset.zero,
            pageLayoutMode: PdfPageLayoutMode.single,
            interactionMode: PdfInteractionMode.selection,
            scrollDirection: PdfScrollDirection.horizontal,
            initialZoomLevel: 1,
            maxZoomLevel: 4,
            pageSpacing: 5,
            canShowScrollHead: true,
            enableTextSelection: true,
            enableDoubleTapZooming: true,
            enableHyperlinkNavigation: true,
            enableDocumentLinkAnnotation: true,
            canShowPageLoadingIndicator: true,
            canShowPaginationDialog: true,
            canShowHyperlinkDialog: true,
            canShowPasswordDialog: true,
            canShowScrollStatus: true,
            canShowSignaturePadDialog: true,
            onZoomLevelChanged: (PdfZoomDetails details) {},
            onTap: (PdfGestureDetails pdfDetail) {},
            onDocumentLoaded: (PdfDocumentLoadedDetails load) {},
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails loadFailed) {
              Utility.showSnackbar(loadFailed.description);
            },
            onPageChanged: (PdfPageChangedDetails pageChange) {},
            onTextSelectionChanged:
                (PdfTextSelectionChangedDetails textSelectionText) {},
            onHyperlinkClicked:
                (PdfHyperlinkClickedDetails hyperLinkClicked) {},
            onFormFieldFocusChange: (PdfFormFieldFocusChangeDetails changes) {},
            onFormFieldValueChanged: (PdfFormFieldValueChangedDetails
                pdfFormFieldValueChangedDetails) {},
          ),
        ),
      ),
    );
  }
}
