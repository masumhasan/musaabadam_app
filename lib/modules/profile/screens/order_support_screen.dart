import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'dart:io';

import 'package:musaab_adam/core/widgets/custom_button.dart';

class OrderSupportScreen extends StatefulWidget {

  const OrderSupportScreen({super.key});

  @override
  State<OrderSupportScreen> createState() => _OrderSupportScreenState();
}

class _OrderSupportScreenState extends State<OrderSupportScreen> {

  String categoryTag = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {

    categoryTag = Get.arguments;

    super.initState();
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Order Support', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Tag Title
            Text(
              categoryTag,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Description Field
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Image Upload Area
            Center(
              child: _selectedImage == null
                  ? _buildUploadPlaceholder()
                  : _buildImagePreview(),
            ),
            const Spacer(),

            // Submit Button
            CustomButton(
                label: AppStrings.submit,
              buttonHeight: 40.h,
              onPressed: (){

              },
            ),
            const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12, top: 8),
                child: Text('Optional', style: TextStyle(color: Color(0xFF0089B6), fontWeight: FontWeight.w500)),
              ),
            ),
            const Icon(Icons.image_outlined, color: Color(0xFF0089B6), size: 30),
            const SizedBox(height: 5),
            const Text('Upload Photos', style: TextStyle(color: Color(0xFF0089B6))),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          width: 250,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}