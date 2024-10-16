import 'vcard.dart';

class VCardParser {
  String decode(String? value) {
    if (value != null) {
      return value
          .replaceAll('\\n', '\n')
          .replaceAll('\\,', ',')
          .replaceAll('\\;', ';');
    }
    return '';
  }

  VCard parse(String vCardString) {
    VCard vCard = VCard();

    if (vCardString.isEmpty) {
      return vCard;
    }

    List<String> lines = vCardString.split(RegExp(r'\r\n|\n|\r'));

    for (String line in lines) {
      if (line.startsWith('FN:')) {
        vCard.formattedName = decode(line.substring(3));
      } else if (line.startsWith('N:')) {
        List<String> nameParts = line.substring(2).split(';');
        vCard.lastName = decode(nameParts[0]);
        vCard.firstName = decode(nameParts.length > 1 ? nameParts[1] : '');
        vCard.middleName = decode(nameParts.length > 2 ? nameParts[2] : '');
      } else if (line.startsWith('EMAIL;TYPE=INTERNET:')) {
        vCard.email = decode(line.substring(20));
      } else if (line.startsWith('TEL;TYPE=CELL:')) {
        vCard.cellPhone = decode(line.substring(14));
      } else if (line.startsWith('TITLE:')) {
        vCard.jobTitle = decode(line.substring(6));
      } else if (line.startsWith('ORG:')) {
        vCard.organization = decode(line.substring(4));
      } else if (line.startsWith('URL:')) {
        vCard.url = decode(line.substring(4));
      } else if (line.startsWith('NOTE:')) {
        vCard.note = decode(line.substring(5));
      }
    }

    return vCard;
  }
}
