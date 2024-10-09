import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/vCard/vcard.dart';
import 'package:professional_contact/main.dart';
import 'package:professional_contact/models/contact.dart';

class SettingsView extends StatefulWidget {
  final Function goToMainView;
  const SettingsView({super.key, required this.goToMainView});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final VCard vCard = VCard();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController middleNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController organizationController = TextEditingController();

  final TextEditingController birthdayController = TextEditingController();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController urlController = TextEditingController();

  final TextEditingController noteController = TextEditingController();

  final TextEditingController cellPhoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController workEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              buildTextField('First Name', firstNameController),
              buildTextField('Middle Name', middleNameController),
              buildTextField('Last Name', lastNameController),
              buildTextField('Organization', organizationController),
              buildTextField('Title / Role', titleController),
              buildTextField('Cell Phone', cellPhoneController),
              buildTextField('Email', emailController),
              buildTextField('Work Email', workEmailController),
              buildTextField('URL', urlController),
              buildTextField('Birthday (YYYY-MM-DD)', birthdayController),
              buildTextField('Notes', noteController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveVCard,
                child: Text('Save Contact Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // This method will gather all the user input and save it to the vCard
  Future<void> saveVCard() async {
    // Parse birthday and anniversary input
    DateTime? parseDate(String input) {
      try {
        return DateTime.parse(input);
      } catch (e) {
        return null;
      }
    }

    // Assign the values from TextFields to vCard properties
    vCard.firstName = firstNameController.text;
    vCard.middleName = middleNameController.text;
    vCard.lastName = lastNameController.text;
    vCard.organization = organizationController.text;
    vCard.birthday = parseDate(birthdayController.text);
    vCard.url = urlController.text;
    vCard.note = noteController.text;
    vCard.cellPhone = cellPhoneController.text;
    vCard.email = emailController.text;
    vCard.workEmail = workEmailController.text;
    vCard.jobTitle = titleController.text;

    // TODO: Add address information

    vCard.version = '4.0';

    // After setting the values, get the formatted string
    String vCardString = vCard.getFormattedString();

    await isar.writeTxn(() async {
      Contact? savedContact = await isar.collection<Contact>().get(1);
      savedContact ??= Contact();
      savedContact.vCard = vCardString;

      await isar.collection<Contact>().put(savedContact);
    });

    widget.goToMainView();
    // TODO: Show success toast
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    organizationController.dispose();
    birthdayController.dispose();
    titleController.dispose();
    urlController.dispose();
    noteController.dispose();
    cellPhoneController.dispose();
    emailController.dispose();
    workEmailController.dispose();
    super.dispose();
  }
}
