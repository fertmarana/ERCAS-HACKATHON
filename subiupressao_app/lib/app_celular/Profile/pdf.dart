import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subiupressao_app/files/models/user.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

double xText = 0;
double yText = 0;

PdfDocument presetDocument() {
  var document = new PdfDocument();

  document.pageSettings.orientation = PdfPageOrientation.portrait;

  document.pageSettings.margins.left = 2.5;
  document.pageSettings.margins.right = 2.5;
  document.pageSettings.margins.top = 1;
  document.pageSettings.margins.bottom = 1;

  return document;
}

Future<PdfDocument> addCover({
  bool darkMode,
  String coverImageName,
  PdfDocument document,
}) async {
  var currentPage = document.pages.add();

  if (darkMode) {
    currentPage = await applyDarkMode(page: currentPage);
  }

  var imageAsBytes = await readImageData(coverImageName);
  var decodedImage = await decodeImageFromList(imageAsBytes);

  currentPage.graphics.drawImage(
    PdfBitmap(imageAsBytes),
    Rect.fromCenter(
      center: Offset(
        currentPage.size.width / 2,
        currentPage.size.height / 2,
      ),
      width: decodedImage.width.toDouble(),
      height: decodedImage.height.toDouble(),
    ),
  );

  return document;
}

Future<PdfDocument> addUserInfoPage({
  User user,
  bool darkMode,
  PdfDocument document,
}) async {
  var page = document.pages.add();

  if (darkMode) {
    page = await applyDarkMode(page: page);
  }

  page = writeTitle(
    page: page,
    darkMode: darkMode,
    title: "Relatório Mensal",
    upgradeY: true,
    x: page.size.width / 2,
    y: 25,
  );

  page = writeLine(
    page: page,
    darkMode: darkMode,
    lines: ["Nome: ${user.name}"],
    upgrade: true,
    y: 10,
  );

  page = writeLine(
    page: page,
    darkMode: darkMode,
    lines: [
      "Altura: ${user.height}cm",
      "Peso: ${user.weight}kg",
    ],
    upgrade: true,
    y: 10,
  );

  return document;
}

Future<PdfPage> applyDarkMode({
  PdfPage page,
}) async {
  var imageData = await readImageData("black_background.jpeg");

  page.graphics.drawImage(
    PdfBitmap(imageData),
    Rect.fromCenter(
      center: Offset(
        page.size.width / 2,
        page.size.height / 2,
      ),
      width: page.size.width,
      height: page.size.height,
    ),
  );

  return page;
}

PdfPage writeTitle({
  PdfPage page,
  bool darkMode,
  String title,
  bool upgradeY,
  double x,
  double y,
}) {
  PdfFont font = PdfStandardFont(
    PdfFontFamily.timesRoman,
    32,
    style: PdfFontStyle.bold,
  );

  Size stringSize = font.measureString(title);

  page.graphics.drawString(
    title,
    font,
    brush: darkMode ? PdfBrushes.white : PdfBrushes.black,
    bounds: Rect.fromCenter(
      center: Offset(x, yText + y + stringSize.height / 2),
      width: stringSize.width,
      height: stringSize.height,
    ),
  );

  if (upgradeY) {
    yText += y + stringSize.height;
  }

  return page;
}

PdfPage writeLine({
  PdfPage page,
  bool darkMode,
  List<String> lines,
  bool upgrade,
  double y,
}) {
  PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
  int spaceInterval = getSpaceInterval(lines, font, page.size.width);
  int spaces = 0;

  lines.forEach((line) {
    Size stringSize = font.measureString(line);

    page.graphics.drawString(
      line,
      font,
      brush: darkMode ? PdfBrushes.white : PdfBrushes.black,
      bounds: Rect.fromCenter(
        center: Offset(15 + stringSize.width / 2 + spaces * spaceInterval,
            yText + y + stringSize.height / 2),
        width: stringSize.width,
        height: stringSize.height,
      ),
    );

    spaces++;
  });

  if (upgrade) {
    yText += y + font.measureString(lines[0]).height;
  }

  return page;
}

int getSpaceInterval(List<String> lines, PdfFont font, double totalWidth) {
  int spaces = lines.length > 1 ? lines.length - 1 : lines.length;
  double totalStringWidth = 0;

  lines.forEach((element) {
    totalStringWidth += font.measureString(element).width;
  });

  int spaceWidth = ((totalWidth - totalStringWidth) / spaces).floor();

  return spaceWidth;
}

Future<Uint8List> readImageData(String name) async {
  final data = await rootBundle.load('imagens/pdf/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<void> saveAndLaunchFile({String fileName, PdfDocument document}) async {
  List<int> bytes = document.save();
  document.dispose();

  final path = (await getExternalStorageDirectory()).path;
  final file = File('$path/$fileName');

  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open('$path/$fileName');
}
