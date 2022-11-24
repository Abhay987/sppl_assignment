import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sppl_assignment/common/widgets/buttons.dart';
import 'package:sppl_assignment/common/widgets/text_form_field.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({Key? key}) : super(key: key);

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    contactNumberController.dispose();
    nameController.dispose();
    addressController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormFieldShow(editingController: nameController, keyboardType: TextInputType.text,textName: 'Name',),
                TextFormFieldShow(editingController: contactNumberController, keyboardType: TextInputType.number,textName: 'Phone Number',),
                TextFormFieldShow(editingController: addressController, keyboardType: TextInputType.multiline,textName: 'Address',maxLines: null,),
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text('Upload',style: TextStyle(fontSize: 18),),
                   const SizedBox(height: 20,),
                   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                     ElevatedButtonShow(buttonName: 'PDF', onPressedFunction: () async{
                     await  pickDocument();
                     }),
                     ElevatedButtonShow(buttonName: 'Image', onPressedFunction: () async{
                      await pickImage();
                     }),
                   ],),
                 ],
               ),
                OutlinedButtonShow(buttonName: 'Submit', onPressedFunction: (){
                  if(_formKey.currentState!.validate()) {

                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> pickDocument() async {
    final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf"]); //Only PDF document files will be picked in the file picker

    if (pickedFile == null) {
      return null;
    } else {
      final pickedDocument = pickedFile.files.first;
      return File(pickedDocument.path!);
    }
  }


  Future<File?> pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image, // Only images will be picked in the file picker
    );

    if (pickedFile == null) {
      return null;
    } else {
      final pickedImage = pickedFile.files.first;
      return File(pickedImage.path!);
    }
  }

}
