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
    formattedVCardString += 'VERSION:${vCard.version}${nl()}';

    String formattedName = vCard.formattedName ?? '';

    if ((vCard.formattedName ?? '').isEmpty) {
      formattedName =
          '${vCard.firstName} ${vCard.middleName} ${vCard.lastName}';
    }

    formattedVCardString += 'FN:${e(formattedName)}${nl()}';
    formattedVCardString +=
        'N:${e(vCard.lastName)};${e(vCard.firstName)};${e(vCard.middleName)};;${nl()}';

    if (vCard.email != null) {
      formattedVCardString += 'EMAIL;type=HOME:${e(vCard.email)}${nl()}';
    }

    if (vCard.cellPhone != null) {
      formattedVCardString +=
          'TEL;VALUE=uri;TYPE="voice,cell":tel:${e(vCard.cellPhone)}${nl()}';
    }

    if (vCard.jobTitle != null) {
      formattedVCardString += 'TITLE:${e(vCard.jobTitle ?? '')}${nl()}';
    }

    if (vCard.organization != null) {
      formattedVCardString += 'ORG:${e(vCard.organization ?? '')}${nl()}';
    }

    if (vCard.url != null) {
      formattedVCardString += 'URL:${e(vCard.url ?? '')}${nl()}';
    }

    if (vCard.note != null) {
      formattedVCardString += 'NOTE:${e(vCard.note ?? '')}${nl()}';
    }

    formattedVCardString += 'REV:${DateTime.now().toIso8601String()}${nl()}';

    formattedVCardString += 'END:VCARD${nl()}';
    return formattedVCardString;
  }
}
