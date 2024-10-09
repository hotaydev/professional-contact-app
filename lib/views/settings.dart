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
  VCard vCard = VCard();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController personalPhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    vCard = VCardParser().parse(widget.vCard);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Fill your information",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            "This information will be used to generate your professional contact card",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          buildTextField('First Name', firstNameController),
          buildTextField('Middle Name', middleNameController),
          buildTextField('Last Name', lastNameController),
          buildTextField('Organization', organizationController),
          buildTextField('Title / Role', titleController),
          buildTextField('Phone Number', personalPhoneController),
          buildTextField('Email', emailController),
          buildTextField('URL', urlController),
          buildTextField('Notes', noteController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveVCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Smaller border radius
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 18,
              ), // Adjust padding for a rectangular shape
              elevation: 5, // Optional: add shadow for 3D effect
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
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    switch (labelText) {
      case 'First Name':
        controller.text = vCard.firstName ?? "";
        break;
      case 'Middle Name':
        controller.text = vCard.middleName ?? "";
        break;
      case 'Last Name':
        controller.text = vCard.lastName ?? "";
        break;
      case 'Organization':
        controller.text = vCard.organization ?? "";
        break;
      case 'Title / Role':
        controller.text = vCard.jobTitle ?? "";
        break;
      case 'Phone Number':
        controller.text = vCard.cellPhone ?? "";
        break;
      case 'Email':
        controller.text = vCard.email ?? "";
        break;
      case 'URL':
        controller.text = vCard.url ?? "";
        break;
      case 'Notes':
        controller.text = vCard.note ?? "";
        break;
    }

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
    // Assign the values from TextFields to vCard properties
    vCard.firstName = firstNameController.text;
    vCard.middleName = middleNameController.text;
    vCard.lastName = lastNameController.text;
    vCard.organization = organizationController.text;
    vCard.url = urlController.text;
    vCard.note = noteController.text;
    vCard.cellPhone = personalPhoneController.text;
    vCard.email = emailController.text;
    vCard.jobTitle = titleController.text;
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
    titleController.dispose();
    urlController.dispose();
    noteController.dispose();
    personalPhoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
