import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/vCard/vcard.dart';
import 'package:professional_contact/helpers/vCard/vcard_parser.dart';
import 'package:professional_contact/main.dart';
import 'package:professional_contact/models/contact.dart';

class SettingsView extends StatefulWidget {
  final Function goToMainView;
  final String vCard;

  const SettingsView({
    super.key,
    required this.goToMainView,
    required this.vCard,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late VCard vCard;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  void initState() {
    super.initState();
    vCard = VCardParser().parse(widget.vCard);

    // Initialize form data with existing vCard values
    _formData['First Name'] = vCard.firstName ?? "";
    _formData['Middle Name'] = vCard.middleName ?? "";
    _formData['Last Name'] = vCard.lastName ?? "";
    _formData['Organization'] = vCard.organization ?? "";
    _formData['Title / Role'] = vCard.jobTitle ?? "";
    _formData['Phone Number'] = vCard.cellPhone ?? "";
    _formData['Email'] = vCard.email ?? "";
    _formData['URL'] = vCard.url ?? "";
    _formData['Notes'] = vCard.note ?? "";
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: screenHeight * 0.05,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Fill your information",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              "This information will be used to generate your professional contact card. All fields are optional.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ..._buildFormFields(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                elevation: 5,
              ),
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return _formData.keys.map((field) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          initialValue: _formData[field],
          decoration: InputDecoration(
            labelText: field,
            border: OutlineInputBorder(),
          ),
          onSaved: (value) {
            _formData[field] = value ?? "";
          },
        ),
      );
    }).toList();
  }

  Future<void> _saveVCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Assign form values to vCard properties
      vCard.firstName = _formData['First Name'];
      vCard.middleName = _formData['Middle Name'];
      vCard.lastName = _formData['Last Name'];
      vCard.organization = _formData['Organization'];
      vCard.jobTitle = _formData['Title / Role'];
      vCard.cellPhone = _formData['Phone Number'];
      vCard.email = _formData['Email'];
      vCard.url = _formData['URL'];
      vCard.note = _formData['Notes'];
      vCard.version = '4.0';

      String vCardString = vCard.getFormattedString();

      await isar.writeTxn(() async {
        Contact? savedContact = await isar.collection<Contact>().get(1);
        savedContact ??= Contact();
        savedContact.vCard = vCardString;

        await isar.collection<Contact>().put(savedContact);
      });

      // Use the mounted property to check if the widget is still in the tree
      if (mounted) {
        widget.goToMainView();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade600,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              "Information Saved!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }
}
