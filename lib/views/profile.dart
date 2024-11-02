import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/premium.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/helpers/vCard/vcard.dart';
import 'package:professional_contact/helpers/vCard/vcard_parser.dart';
import 'package:professional_contact/widgets/layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? _profileImage;

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

    if ((vCard.photo ?? '').isNotEmpty) {
      setState(() {
        _profileImage = vCard.photo;
      });
    }
  }

  Future<void> setImage(
      String userAccountOrImageUrl, String socialMedia) async {
    final socialMediaLowercase = socialMedia.toLowerCase();

    if (socialMediaLowercase == 'network url') {
      // TODO: check if it's a real image URL
      setState(() {
        _profileImage = userAccountOrImageUrl;
      });
      return;
    }
    final String apiUrl = const String.fromEnvironment(
        'PROFILE_IMAGE_API'); // Ensure your env setup includes this

    final Map<String, String> body = {
      'account_type': socialMediaLowercase,
      'identifier': userAccountOrImageUrl
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['photo'] != null) {
          setState(() {
            _profileImage = responseData['photo'];
          });
        } else {
          print("Failed to retrieve photo: ${responseData['error']}");
        }
      } else {
        print('Failed to retrieve photo, status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
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
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _chooseProfileImageIfPremiumApp(context, setImage);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: _profileImage != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: _profileImage!,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.grey.shade700,
                              ),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey.shade700,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
      vCard.photo = _profileImage;

      String vCardString = vCard.getFormattedString();

      widget.preferences.setString('vCard', vCardString);

      if (mounted) {
        FocusManager.instance.primaryFocus
            ?.unfocus(); // Ensure Keyboard dismissal

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

  Future<void> _chooseProfileImageIfPremiumApp(
      BuildContext context,
      Future<void> Function(String userAccountOrImageUrl, String socialImage)
          setImage) async {
    bool isPremium = VersionHelper().isPremium();

    if (isPremium) {
      _chooseProfileImage(context, setImage);
    } else {
      _upgradeToUseWarning(context);
    }
  }

  Future<void> _upgradeToUseWarning(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Available on Premium Version',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 20),
                Text(
                  'You can add a profile image to your contact card and add any image to the QR Code with the premium version.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Provider.of<ThemeHelper>(context, listen: false)
                                      .getTheme() ==
                                  ThemeType.light
                              ? Colors.blue.shade50
                              : Colors.blue.shade500.withOpacity(0.2),
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      overlayColor: Colors.blue,
                    ),
                    onPressed: () {
                      // TODO: Open the premium version on the store
                    },
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          'Download the Premium Version',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _chooseProfileImage(
      BuildContext context,
      Future<void> Function(String userAccountOrImageUrl, String socialImage)
          setImage) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Profile Image',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _buildImageOption(context, 'Mastodon',
                    'assets/images/social/mastodon.png', setImage),
                _buildImageOption(context, 'GitHub',
                    'assets/images/social/github.png', setImage),
                _buildImageOption(context, 'Gravatar',
                    'assets/images/social/gravatar.png', setImage),
                _buildImageOption(context, 'Network URL', '', setImage),
                SizedBox(height: 16),
                Text(
                  'We use images over the internet, so any URL would work.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImageFromSocialMedia(
    BuildContext context,
    String image,
    String socialMedia,
    Future<void> Function(String userAccountOrImageUrl, String socialImage)
        setImage,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SocialMediaImageDialog(
          image: image,
          socialMedia: socialMedia,
          setImage: setImage,
        );
      },
    );
  }

  Widget _buildImageOption(
      BuildContext context,
      String label,
      String imagePath,
      Future<void> Function(String userAccountOrImageUrl, String socialImage)
          setImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              Provider.of<ThemeHelper>(context, listen: false).getTheme() ==
                      ThemeType.light
                  ? Colors.blue.shade50
                  : Colors.blue.shade500.withOpacity(0.2),
          side: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          overlayColor: Colors.blue,
        ),
        onPressed: () async {
          await _getImageFromSocialMedia(context, imagePath, label, setImage);
        },
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade800.withOpacity(0.2),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: (imagePath.isNotEmpty)
                    ? ClipOval(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.link,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
              ),
            ),
            Spacer(),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Spacer(),
            SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}

class SocialMediaImageDialog extends StatefulWidget {
  final String image;
  final String socialMedia;
  final Future<void> Function(String userAccountOrImageUrl, String socialImage)
      setImage;

  const SocialMediaImageDialog({
    super.key,
    required this.image,
    required this.socialMedia,
    required this.setImage,
  });
  @override
  State<SocialMediaImageDialog> createState() => _SocialMediaImageDialogState();
}

class _SocialMediaImageDialogState extends State<SocialMediaImageDialog> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade800.withOpacity(0.2),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: (widget.image.isNotEmpty)
                    ? ClipOval(
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.link,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Get image from ${widget.socialMedia}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: widget.image.isNotEmpty
                      ? 'Account or Username'
                      : 'URL of the image',
                  floatingLabelStyle: WidgetStateTextStyle.resolveWith(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.focused)) {
                        return TextStyle(
                          color:
                              Provider.of<ThemeHelper>(context, listen: false)
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
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // TODO: add loading animation in the button
                await widget.setImage(_textController.text, widget.socialMedia);
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                elevation: 5,
              ),
              child: Text(
                'Use this image',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
