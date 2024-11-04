import 'vcard.dart';

class VCardFormatter {
  String e(String? value) {
    if ((value != null) && (value.isNotEmpty)) {
      return value
          .replaceAll(RegExp(r'/\n/g'), '\\n')
          .replaceAll(RegExp(r'/,/g'), '\\,')
          .replaceAll(RegExp(r'/;/g'), '\\;');
    }
    return '';
  }

  String nl() {
    return '\r\n';
  }

  String getFormattedString(VCard vCard) {
    String formattedVCardString = '';
    formattedVCardString += 'BEGIN:VCARD${nl()}';
    formattedVCardString += 'VERSION:3.0${nl()}';

    String formattedName = vCard.formattedName ?? '';

    if ((vCard.formattedName ?? '').isEmpty) {
      formattedName =
          '${vCard.firstName} ${(vCard.middleName ?? '').isNotEmpty ? '${vCard.middleName} ' : ''}${vCard.lastName}';
    }

    formattedVCardString += 'FN:${e(formattedName)}${nl()}';
    formattedVCardString +=
        'N:${e(vCard.lastName)};${e(vCard.firstName)};${e(vCard.middleName)};;${nl()}';

    if ((vCard.email ?? '').isNotEmpty) {
      formattedVCardString += 'EMAIL;TYPE=INTERNET:${e(vCard.email)}${nl()}';
    }

    if ((vCard.cellPhone ?? '').isNotEmpty) {
      formattedVCardString += 'TEL;TYPE=CELL:${e(vCard.cellPhone)}${nl()}';
    }

    if ((vCard.jobTitle ?? '').isNotEmpty) {
      formattedVCardString += 'TITLE:${e(vCard.jobTitle ?? '')}${nl()}';
    }

    if ((vCard.organization ?? '').isNotEmpty) {
      formattedVCardString += 'ORG:${e(vCard.organization ?? '')}${nl()}';
    }

    if ((vCard.url ?? '').isNotEmpty) {
      formattedVCardString += 'URL:${e(vCard.url ?? '')}${nl()}';
    }

    if ((vCard.note ?? '').isNotEmpty) {
      formattedVCardString += 'NOTE:${e(vCard.note ?? '')}${nl()}';
    }

    formattedVCardString += 'END:VCARD${nl()}';
    return formattedVCardString;
  }
}
