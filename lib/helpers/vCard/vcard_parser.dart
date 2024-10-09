import 'vcard.dart';

class VCardParser {
  VCard parse(String vCardString) {
    final vCard = VCard();
    final lines = vCardString.split('\r\n');

    for (var line in lines) {
      if (line.isEmpty || line.startsWith('BEGIN') || line.startsWith('END')) {
        continue;
      }

      final parts = line.split(':');
      if (parts.length < 2) {
        continue; // Skip malformed lines
      }

      final key = parts[0].trim();
      final value = parts.sublist(1).join(':').trim();

      switch (key) {
        case 'VERSION':
          vCard.version = value;
          break;
        case 'FN':
          vCard.formattedName = value;
          break;
        case 'N':
          _parseName(value, vCard);
          break;
        case 'NICKNAME':
          vCard.nickname = value;
          break;
        case 'GENDER':
          vCard.gender = value;
          break;
        case 'UID':
          vCard.uid = value;
          break;
        case 'BDAY':
          vCard.birthday = _parseDate(value);
          break;
        case 'ANNIVERSARY':
          vCard.anniversary = _parseDate(value);
          break;
        case 'EMAIL':
          _addEmail(value, vCard);
          break;
        case 'TEL':
          _addPhone(value, vCard);
          break;
        case 'ADR':
          _parseAddress(value, vCard.homeAddress);
          break;
        case 'ORG':
          vCard.organization = value;
          break;
        case 'TITLE':
          vCard.jobTitle = value;
          break;
        case 'ROLE':
          vCard.role = value;
          break;
        case 'URL':
          _addUrl(value, vCard);
          break;
        case 'NOTE':
          vCard.note = value;
          break;
        case 'X-SOCIALPROFILE':
          _addSocialProfile(value, vCard);
          break;
        // Additional fields can be added here
      }
    }

    return vCard;
  }

  void _parseName(String value, VCard vCard) {
    final nameParts = value.split(';');
    if (nameParts.length >= 5) {
      vCard.lastName = nameParts[0].trim();
      vCard.firstName = nameParts[1].trim();
      vCard.middleName = nameParts[2].trim();
      vCard.namePrefix = nameParts[3].trim();
      vCard.nameSuffix = nameParts[4].trim();
    }
  }

  DateTime? _parseDate(String value) {
    if (value.length == 8) {
      return DateTime.parse(
          '${value.substring(0, 4)}-${value.substring(4, 6)}-${value.substring(6, 8)}');
    }
    return null;
  }

  void _addEmail(String value, VCard vCard) {
    final emailType = _extractEmailType(value);
    final emailAddress = _extractEmailAddress(value);

    if (emailType == 'WORK') {
      vCard.workEmail = vCard.workEmail ?? [];
      vCard.workEmail.add(emailAddress);
    } else {
      vCard.email = vCard.email ?? [];
      vCard.email.add(emailAddress);
    }
  }

  void _addPhone(String value, VCard vCard) {
    final phoneType = _extractPhoneType(value);
    final phoneNumber = _extractPhoneNumber(value);

    switch (phoneType) {
      case 'CELL':
        vCard.cellPhone = vCard.cellPhone ?? [];
        vCard.cellPhone.add(phoneNumber);
        break;
      case 'HOME':
        vCard.homePhone = vCard.homePhone ?? [];
        vCard.homePhone.add(phoneNumber);
        break;
      case 'WORK':
        vCard.workPhone = vCard.workPhone ?? [];
        vCard.workPhone.add(phoneNumber);
        break;
      // Additional phone types can be handled here
    }
  }

  void _parseAddress(String value, MailingAddress address) {
    final addressParts = value.split(';');
    if (addressParts.length >= 6) {
      address.label = addressParts[0].split(';').length > 1
          ? addressParts[0].split(';')[1].trim()
          : '';
      address.street = addressParts[2].trim();
      address.city = addressParts[3].trim();
      address.stateProvince = addressParts[4].trim();
      address.postalCode = addressParts[5].trim();
      address.countryRegion = addressParts[6].trim();
    }
  }

  void _addUrl(String value, VCard vCard) {
    if (value.contains('type=WORK')) {
      vCard.workUrl = value.split(':')[1].trim();
    } else {
      vCard.url = value.trim();
    }
  }

  void _addSocialProfile(String value, VCard vCard) {
    final parts = value.split(':');
    if (parts.length > 1) {
      final type = parts[0].split(';')[1].trim();
      vCard.socialUrls[type] = parts[1].trim();
    }
  }

  String _extractEmailType(String value) {
    return value.contains('type=')
        ? value.split(';')[1].split('=')[1].trim()
        : 'HOME';
  }

  String _extractEmailAddress(String value) {
    return value.split(':')[1].trim();
  }

  String _extractPhoneType(String value) {
    return value.contains('TYPE=')
        ? value.split('TYPE=')[1].split(':')[0].trim()
        : 'CELL';
  }

  String _extractPhoneNumber(String value) {
    return value.split(':')[1].trim();
  }
}
