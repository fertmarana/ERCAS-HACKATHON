import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Future<PdfPage> buildReportCover(PdfDocument document) async {
//   PdfPage page = document.pages.add();
//   Size pageSize = page.getClientSize();

//   page = await nightMode(page);

//   page.graphics.drawImage(
//     PdfBitmap((await readImageData('SubiuPressao_contorno.png'))),
//     Rect.fromCenter(
//       center: Offset(pageSize.width / 2, pageSize.height / 2),
//       width: 400,
//       height: 400,
//     ),
//     // Rect.fromLTWH(300, -50, 200, 200),
//   );

//   return page;
// }
