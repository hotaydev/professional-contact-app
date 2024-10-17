import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/helpers/vCard/vcard.dart';
import 'package:professional_contact/helpers/vCard/vcard_parser.dart';
import 'package:professional_contact/widgets/layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  final Function goToView;
  final SharedPreferences preferences;

  const ProfileView({
    super.key,
    required this.goToView,
    required this.preferences,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late VCard vCard;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  void initState() {
    super.initState();
    vCard = VCardParser().parse(widget.preferences.getString('vCard') ?? '');

    // Initialize form data with existing vCard values
    _formData['profile.opt.firstName'] = vCard.firstName ?? '';
    _formData['profile.opt.middleName'] = vCard.middleName ?? '';
    _formData['profile.opt.lastName'] = vCard.lastName ?? '';
    _formData['profile.opt.org'] = vCard.organization ?? '';
    _formData['profile.opt.title'] = vCard.jobTitle ?? '';
    _formData['profile.opt.phone'] = vCard.cellPhone ?? '';
    _formData['profile.opt.email'] = vCard.email ?? '';
    _formData['profile.opt.url'] = vCard.url ?? '';
    _formData['profile.opt.notes'] = vCard.note ?? '';
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
              'profile.title'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              'profile.subtitle'.tr(),
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
                'profile.save'.tr(),
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
            labelText: field.tr(),
            floatingLabelStyle: WidgetStateTextStyle.resolveWith(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.focused)) {
                  return TextStyle(
                    color: Provider.of<ThemeHelper>(context, listen: false)
                                .getTheme() ==
                            ThemeType.light
                        ? Colors.blue.shade800
                        : Colors.blue.shade500,
                  );
                }
                return TextStyle();
              },
            ),
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Provider.of<ThemeHelper>(context, listen: false)
                            .getTheme() ==
                        ThemeType.light
                    ? Colors.blue.shade800
                    : Colors.blue.shade500,
                // width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Provider.of<ThemeHelper>(context, listen: false)
                            .getTheme() ==
                        ThemeType.light
                    ? Colors.blue.shade800
                    : Colors.blue.shade500,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onSaved: (value) {
            _formData[field] = value ?? '';
          },
        ),
      );
    }).toList();
  }

  Future<void> _saveVCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Assign form values to vCard properties
      vCard.firstName = _formData['profile.opt.firstName'];
      vCard.middleName = _formData['profile.opt.middleName'];
      vCard.lastName = _formData['profile.opt.lastName'];
      vCard.organization = _formData['profile.opt.org'];
      vCard.jobTitle = _formData['profile.opt.title'];
      vCard.cellPhone = _formData['profile.opt.phone'];
      vCard.email = _formData['profile.opt.email'];
      vCard.url = _formData['profile.opt.url'];
      vCard.note = _formData['profile.opt.notes'];

      String vCardString = vCard.getFormattedString();

      widget.preferences.setString('vCard', vCardString);

      // Use the mounted property to check if the widget is still in the tree
      if (mounted) {
        FocusManager.instance.primaryFocus?.unfocus(); // dismiss Keyboard

        widget.goToView(CurrentView.home);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade500,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(milliseconds: 2000),
            content: Text(
              'profile.saved'.tr(),
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
