import 'vcard_formatter.dart';

class VCard {
  /// Cell phone number
  String? cellPhone;

  /// The address for private electronic mail communication
  String? email;

  /// First name
  String? firstName;

  /// Middle name
  String? middleName;

  /// Last name
  String? lastName;

  /// Formatted name string associated with the vCard object (will automatically populate if not set)
  String? formattedName;

  /// Specifies supplemental information or a comment that is associated with the vCard
  String? note;

  /// The name and optionally the unit(s) of the organization associated with the vCard object
  String? organization;

  /// Specifies the job title, functional position or function of the individual within an organization
  String? jobTitle;

  /// URL pointing to a website that represents the person in some way
  String? url;

  /// vCard version
  String version = '4.0';

  /// Get formatted vCard as String
  String getFormattedString() => VCardFormatter().getFormattedString(this);
}
