import 'package:first_app/constans.dart'; // Ensure TikTokColors is properly defined here
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String id;
  ProfilePage({required this.username, required this.email, required this.id});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _FnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _LnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  File? _avatarImage;

  @override
  void initState() {
    super.initState();
    _FnameController.text = widget.username;
    _LnameController.text = '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthdateController.text =
            "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: TikTokColors.white)),
        backgroundColor: TikTokColors.primaryBlack,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: TikTokColors.gray2,
                  backgroundImage:
                      _avatarImage != null ? FileImage(_avatarImage!) : null,
                  child: _avatarImage == null
                      ? Icon(Icons.person, size: 60, color: TikTokColors.white)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.username, // Display the username dynamically
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: TikTokColors.accentPink,
                ),
              ),
              Text(
                widget.email, // Display the email dynamically
                style: TextStyle(color: TikTokColors.gray2, fontSize: 16),
              ),
              SizedBox(height: 30),
              _buildEditableField("First Name", _FnameController, Icons.person),
              _buildEditableField("Last Name", _LnameController, Icons.person),
              _buildEditableField("Phone", _phoneController, Icons.phone),
              _buildBirthdateField(),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [TikTokColors.accentPink, TikTokColors.accentBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print(_avatarImage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: TikTokColors.accentPink),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: TikTokColors.gray,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
          isDense: true,
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildBirthdateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: _birthdateController,
            decoration: InputDecoration(
              labelText: "Birthdate",
              prefixIcon:
                  Icon(Icons.calendar_today, color: TikTokColors.accentPink),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: TikTokColors.gray,
              contentPadding: EdgeInsets.symmetric(vertical: 18),
              isDense: true,
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
