import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sppl_assignment/common/widgets/buttons.dart';
import 'package:sppl_assignment/common/widgets/loading_alert_dialog.dart';
import 'package:sppl_assignment/common/widgets/text_form_field.dart';
import 'package:sppl_assignment/screens/home.dart';

/// Contact Form
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
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  PlatformFile? documentFile,imageFile;


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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ValueListenableBuilder<bool>(valueListenable: isLoading, builder: (BuildContext context, value, Widget? child) {
          return Visibility(visible: value == true,child: const ShowLoadingAlertDialog(),);
        },),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormFieldShow(editingController: nameController, keyboardType: TextInputType.text,textName: 'Name',),
                TextFormFieldShow(editingController: contactNumberController, keyboardType: TextInputType.number,textName: 'Phone Number',),
                TextFormFieldShow(editingController: addressController, keyboardType: TextInputType.multiline,textName: 'Address',maxLines: null,textInputAction: TextInputAction.newline,),
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
                   Row(
                     children: [
                       Visibility(visible: documentFile != null,
                           child: Expanded(child: Padding(
                             padding: const EdgeInsets.only(top: 20),
                             child: Text('Pdf : ${documentFile?.name}'),
                           ))),
                       Visibility(visible: imageFile != null,
                         child: Expanded(child: Padding(
                           padding: const EdgeInsets.only(top: 20),
                           child: Text('Image : ${imageFile?.name}'),
                         )),
                       ),
                     ],
                   ),
                 ],
               ),
                OutlinedButtonShow(buttonName: 'Submit', onPressedFunction: (){

                  if(_formKey.currentState!.validate()) {
                    // insertData(name: nameController.text, contactNumber: contactNumberController.text, address: addressController.text);
                    if(documentFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document File is not selected')));
                    }
                    else {
                      if(imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image File is not selected')));
                      }
                      else {
                        uploadFiles(name: nameController.text, contactNumber: contactNumberController.text, address: """${addressController.text}""");
                      }
                    }
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }


    /// Upload Files eg - PDF , Image
   uploadFiles({required String name,required String contactNumber,required String address}) {

     isLoading.value = true;
    final metaDataImage = SettableMetadata(contentType: 'image/jpeg');
    final metaDataPdf = SettableMetadata(contentType: 'application/pdf');
    final storageRef = FirebaseStorage.instance.ref();

    Reference imageReference = storageRef.child("images/${DateTime.now()}.jpg");
    Reference pdfReference = storageRef.child("documents/${DateTime.now()}.pdf");

    UploadTask uploadImage = imageReference.putFile(File(imageFile!.path!),metaDataImage);
    UploadTask uploadDocument = pdfReference.putFile(File(documentFile!.path!),metaDataPdf);

     // String imageUrl = await imageReference.getDownloadURL(),documentUrl = await pdfReference.getDownloadURL();


  /// Listen states when uploading files
    uploadImage.snapshotEvents.listen((event) async{
      switch(event.state) {
        case TaskState.paused:
          break;
        case TaskState.running:
          break;
        case TaskState.success:
          if(uploadDocument.snapshot.state == TaskState.success) {
            insertData(name: name, contactNumber: contactNumber, address: address, imageUrl: await imageReference.getDownloadURL(), documentUrl: await pdfReference.getDownloadURL());
        }
          else {
            uploadDocument.snapshotEvents.listen((eventSecond) async{
              switch(eventSecond.state) {
                case TaskState.paused:
                  break;
                case TaskState.running:
                  break;
                case TaskState.success:
                  insertData(name: name, contactNumber: contactNumber, address: address, imageUrl: await event.ref.getDownloadURL(), documentUrl: await eventSecond.ref.getDownloadURL());
                  break;
                case TaskState.canceled:
                  break;
                case TaskState.error:
                  break;
              }
            });
          }
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          break;
      }
    });

  }

   ///  Connect To Firebase
    insertData({required String name,required String contactNumber,required String address,required String imageUrl,required String documentUrl}) {

      final databaseRef = FirebaseDatabase.instance.ref().child('Users');
      final String key = databaseRef.push().key!;

      Map<String,dynamic> users = {
        'id' : key,
        "name" : name,
        "contactNumber" : contactNumber,
        "address" : address,
        "imageFile" : imageUrl,
        "documentFile" : documentUrl,
      };

      databaseRef.child(key).set(users);

      isLoading.value = false;

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);


    }

    /// Pick Pdf Document From Local Storage
   pickDocument() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf"]); //Only PDF document files will be picked in the file picker

    if (pickedFile == null) {
      documentFile = null;
    } else {
      PlatformFile pickedDocument = pickedFile.files.first;
      documentFile =  pickedDocument;
    }
    setState(() {

    });
  }

  /// Pick Image From Local Storage
    pickImage() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image, // Only images will be picked in the file picker
    );

    if (pickedFile == null) {
      imageFile = null;
    } else {
      PlatformFile pickedImage = pickedFile.files.first;
       imageFile = pickedImage;
    }
    setState(() {

    });
  }

}
