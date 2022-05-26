import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wit_canteen_app/components.dart';
import 'package:wit_canteen_app/screens/home.dart';

import '../globals.dart';

class IDupload extends StatefulWidget {
  const IDupload({Key? key}) : super(key: key);

  @override
  State<IDupload> createState() => _IDuploadState();
}

class _IDuploadState extends State<IDupload> {
  bool submitting = false;
  bool loading = false;
  String? downloadUrl = 'null';
  Future<void> upload() async {
    final _storage = FirebaseStorage.instance;
    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      var fileName = result!.paths.toString().split('/').last;
      if (result != null) {
        setState(() {
          submitting = true;
        });
        try {
          var snapshot = await _storage
              .ref()
              .child('$fileName-${FirebaseAuth.instance.currentUser!.uid}')
              .putFile(File(result.files.first.path!));
          downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {});
        } catch (e) {
          setState(() {
            submitting = false;
          });
          showToast("Some error occured");
        }
        try {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'id': downloadUrl});
          showToast("Document uploaded");
          setState(() {
            submitting = false;
          });
        } catch (e) {
          setState(() {
            submitting = false;
          });
          showToast("Some error occured");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: getHeight(context),
          width: getWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getHeight(context) * 0.1,
              ),
              Container(
                width: getWidth(context) * 0.76,
                child: Text(
                  'Upload ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Bold',
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 30),
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.02,
              ),
              Container(
                width: getWidth(context) * 0.7,
                child: Text(
                  'Please upload a valid College ID to complete sign up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Regular',
                      color: Colors.black.withOpacity(0.2),
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.1,
              ),
              InkWell(
                onTap: () {
                  upload();
                },
                child: Container(
                  height: getWidth(context) * 0.5,
                  width: getWidth(context) * 0.5,
                  decoration: BoxDecoration(
                      border: downloadUrl != 'null'
                          ? Border.all(color: color, width: 2)
                          : Border.all(width: 0, color: Colors.transparent),
                      color: color2,
                      borderRadius: BorderRadius.circular(26)),
                  child: downloadUrl != 'null'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Image.network(
                            downloadUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Colors.black.withOpacity(0.2),
                        ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              submitting
                  ? Container(
                      width: getWidth(context) * 0.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            backgroundColor: color2,
                            color: color,
                            minHeight: 6,
                          )))
                  : Container(
                      height: 6,
                      width: getWidth(context) * 0.5,
                      color: Colors.transparent,
                    ),
              SizedBox(
                height: getHeight(context) * 0.19,
              ),
              MaterialButton(
                  elevation: 0,
                  splashColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onPressed: () async {
                    if (downloadUrl != 'null') {
                      setState(() {
                        loading = true;
                      });
                      try {
                        var userDoc = await FirebaseFirestore.instance
                            .collection("Users")
                            .where('id', isEqualTo: downloadUrl)
                            .get();
                        if (userDoc.docs.length == 1) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.rightToLeft,
                                child: Home()),
                            ((route) => false),
                          );
                          showToast("You're now signed up");
                        } else {
                          setState(() {
                            loading = false;
                          });
                          showToast('Upload ID failed\nPlease try again');
                        }
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                        showToast('Error\nPlease try again');
                      }
                    }
                  },
                  color: downloadUrl != 'null'
                      ? color
                      : Colors.black.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    height: 50,
                    width: getWidth(context) * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent),
                    child: Center(
                        child: loading
                            ? CircularProgress(
                                size: 20,
                                color: Colors.white,
                              )
                            : Text(
                                'Next',
                                style: TextStyle(
                                  fontFamily: 'Bold',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
