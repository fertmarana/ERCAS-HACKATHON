import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subiupressao_app/files/models/bloodPressure.dart';
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
  List<String> newLine;

  yText = 0;

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
    y: 15,
  );

  page = writeLine(
    page: page,
    darkMode: darkMode,
    lines: [
      "Nascimento: ${DateFormat('dd/MM/yyyy').format(user.birth)}",
      "Gênero: ${user.gender.name}",
    ],
    upgrade: true,
    y: 15,
  );

  page = writeLine(
    page: page,
    darkMode: darkMode,
    lines: [
      "Altura: ${user.height}cm",
      "Peso: ${user.weight}kg",
    ],
    upgrade: true,
    y: 15,
  );

  newLine = [];
  if (user.cpf != "") newLine.add("CPF: ${user.cpf}");
  if (user.healthInsurance != "")
    newLine.add("Plano de saúde: ${user.healthInsurance}");

  if (newLine.length > 0)
    page = writeLine(
      page: page,
      darkMode: darkMode,
      lines: newLine,
      upgrade: true,
      y: 15,
    );

  newLine = [];
  if (user.cardiacSituation != "")
    newLine.add("Situação cardíaca: ${user.cardiacSituation}");
  if (user.bloodPressure.diastolic != -1 && user.bloodPressure.systolic != -1)
    newLine.add("Pressão usual: ${user.bloodPressure.toString()}");

  if (newLine.length > 0)
    page = writeLine(
      page: page,
      darkMode: darkMode,
      lines: newLine,
      upgrade: true,
      y: 15,
    );

  return document;
}

Future<PdfDocument> addBloodPressurePage({
  User user,
  bool darkMode,
  PdfDocument document,
}) async {
  PdfPage page = document.pages.add();
  PdfGrid grid = PdfGrid();
  List<BloodPressure> data = user.monthBloodPressure;

  if (darkMode) {
    page = await applyDarkMode(page: page);
  }

  if (data.length == 0) {
    writeTitle(
      page: page,
      darkMode: darkMode,
      title: "No measurements were done this month!",
      upgradeY: false,
      x: page.size.width / 2,
      y: page.size.height / 3,
    );

    return document;
  }

  BloodPressure last = data.last;

  PdfStringFormat format = PdfStringFormat(
    alignment: PdfTextAlignment.center,
    lineAlignment: PdfVerticalAlignment.bottom,
  );

  PdfGridCellStyle headerStyle = PdfGridCellStyle(
    format: format,
    textBrush: PdfBrushes.white,
  );

  PdfGridCellStyle cellStyle = PdfGridCellStyle(
    backgroundBrush: PdfBrushes.black,
    font: PdfStandardFont(PdfFontFamily.timesRoman, 11),
    format: format,
    textBrush: PdfBrushes.white,
  );

  grid.columns.add(count: 2);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.cells[0].value = "Dia";
  header.cells[1].value = "Pressão Média";

  int dayCounter = 1;
  data.forEach((element) {
    // if (grid.rows.count > 1) {
    //   for (int i = grid.rows.count; i < element.time.day; i++) {
    //     PdfGridRow row = grid.rows.add();

    //     row.cells[0].value = i.toString();
    //     row.cells[1].value = 'N/A';
    //   }

    //   PdfGridRow row = grid.rows.add();
    //   row.cells[0].value = "x"; // "${element.time.day}";
    //   row.cells[1].value = "${element.toString()}";
    // } else {
    //   for (int i = 1; i < element.time.day; i++) {
    //     PdfGridRow row = grid.rows.add();

    //     row.cells[0].value = i.toString();
    //     row.cells[1].value = 'N/A';
    //   }

    //   PdfGridRow row = grid.rows.add();
    //   row.cells[0].value = "x"; // "${element.time.day}";
    //   row.cells[1].value = "${element.toString()}";
    // }

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = "${dayCounter}";
    row.cells[1].value = "${element.toString()}";
    dayCounter++;
  });

  PdfGridRow row = grid.rows.add();
  user.dayBloodPressure.forEach(
    (element) {
      row.cells[0].value = "x";
      row.cells[1].value = element.toString();
    },
  );

  for (int i = 0; i < grid.columns.count; i++) {
    header.cells[i].style = cellStyle;
  }

  for (int i = 0; i < grid.rows.count; i++) {
    for (int j = 0; j < grid.columns.count; j++) {
      grid.rows[i].cells[j].style = cellStyle;
    }
  }

  grid.style = PdfGridStyle(
    cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
    backgroundBrush: PdfBrushes.blue,
    textBrush: PdfBrushes.white,
    font: PdfStandardFont(PdfFontFamily.timesRoman, 11),
  );

  grid.draw(page: page, bounds: const Rect.fromLTRB(1, 5, 1, 1));

  return document;
}

Future<PdfPage> applyDarkMode({PdfPage page}) async {
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
  xText = 15;

  lines.forEach((line) {
    Size stringSize = font.measureString(line);

    page.graphics.drawString(
      line,
      font,
      brush: darkMode ? PdfBrushes.white : PdfBrushes.black,
      bounds: Rect.fromLTWH(
        xText,
        yText + y,
        stringSize.width,
        stringSize.height,
      ),
    );

    xText += stringSize.width + spaceInterval;
  });

  if (upgrade) {
    yText += y + font.measureString(lines[0]).height;
  }

  return page;
}

int getSpaceInterval(List<String> lines, PdfFont font, double pageWidth) {
  int spaces = lines.length > 1 ? lines.length - 1 : lines.length;
  double totalStringWidth = 30; // Margins width

  lines.forEach((element) {
    totalStringWidth += font.measureString(element).width;
  });

  if (totalStringWidth > pageWidth) {
    throw Exception("Line width is bigger than page width!");
  }

  int spaceWidth = ((pageWidth - totalStringWidth) / spaces).floor();

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
