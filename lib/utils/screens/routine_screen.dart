import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Daily Skincare',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SkincareItem(
              title: 'Cleanser',
              subtitle: 'Cetaphil Gentle Skin Cleanser',
              time: '8:00 PM',
            ),
            SkincareItem(
              title: 'Toner',
              subtitle: 'Thayers Witch Hazel Toner',
              time: '8:02 PM',
            ),
            SkincareItem(
              title: 'Moisturizer',
              subtitle: 'Kiehl’s Ultra Facial Cream',
              time: '8:04 PM',
            ),
            SkincareItem(
              title: 'Sunscreen',
              subtitle: 'Supergoop Unseen Sunscreen',
              time: '8:06 PM',
            ),
            SkincareItem(
              title: 'Lip Balm',
              subtitle: 'Glossier Birthday Balm Dotcom',
              time: '8:08 PM',
            ),
          ],
        ),
      ),
    );
  }
}

class SkincareItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String time;

  const SkincareItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  _SkincareItemState createState() => _SkincareItemState();
}

class _SkincareItemState extends State<SkincareItem> {
  bool _isChecked = false;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _timeSelected = false;
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
      });

      try {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child('images/${DateTime.now().toIso8601String()}_${image.name}');
        final uploadTask = imageRef.putFile(File(image.path));

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
        });

        final downloadUrl = await (await uploadTask).ref.getDownloadURL();
        await _firestore.collection('skincare_routines').doc(widget.title).update({
          'imageUrl': downloadUrl,
        });
        print('Image uploaded to Firebase Storage');
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
  }

  void _onCameraButtonPressed() async {
    await _pickImage(ImageSource.camera);
  }

  void _onGalleryButtonPressed() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _updateCheckState(bool value) async {
    setState(() {
      _isChecked = value;
      if (!_isChecked) {
        _image = null;
        _timeSelected = false;
        _selectedTime = TimeOfDay.now();
      }
    });

    try {
      final documentRef = _firestore.collection('skincare_routines').doc(widget.title);

      if (_isChecked) {
        await documentRef.set({
          'title': widget.title,
          'subtitle': widget.subtitle,
          'time': _selectedTime.format(context),
          'isChecked': _isChecked,
          'timestamp': Timestamp.fromDate(DateTime.now()),
          if (_image != null) 'imageUrl': await _uploadImageToFirebase(),
        });
      } else {
        await documentRef.update({
          'isChecked': _isChecked,
          'time': FieldValue.delete(),
          'imageUrl': FieldValue.delete(),
          'timestamp': Timestamp.fromDate(DateTime.now()),
        });
      }
    } catch (e) {
      print('Failed to update data: $e');
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_image == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().toIso8601String()}_${_image!.name}');
      final uploadTask = imageRef.putFile(File(_image!.path));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      final downloadUrl = await (await uploadTask).ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeSelected = true;
      });
      _updateCheckState(_isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              if (value != null) {
                _updateCheckState(value);
              }
            },
            checkColor: Colors.white,
            activeColor: Colors.pink,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: Color.fromRGBO(150, 79, 102, 1),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (_image != null)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Choose Image Source'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _onCameraButtonPressed();
                              },
                              child: const Text('Camera'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _onGalleryButtonPressed();
                              },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.grey),
                ),
              const SizedBox(width: 4.0),
              if (_timeSelected)
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                )
              else
                TextButton(
                  onPressed: _selectTime,
                  child: const Text('Select Time'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
