import 'package:flutter/material.dart';

class TextFormFieldShow extends StatelessWidget {
  final TextEditingController editingController;
  final TextInputType keyboardType;
  final String textName;
  final bool isDisabled;
  final int? maxLines;
  final TextInputAction textInputAction;
  const TextFormFieldShow({Key? key,required this.editingController,required this.keyboardType,this.textName = "",this.isDisabled = false,this.maxLines = 1,this.textInputAction = TextInputAction.next}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      enabled: isDisabled ? false : true,
      textAlign: textName.isEmpty ? TextAlign.center : TextAlign.start,
      keyboardType: keyboardType,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: textName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),

        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red,width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.blueGrey,width: 2),
        ),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),

        ),
        focusedErrorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.blueGrey,width: 2),
        ),
      ),
      controller: editingController,
      textInputAction: textInputAction,
      onChanged: (value) {
        if (value.length == 1 && textName.isEmpty) {
          FocusScope.of(context).nextFocus();
        }
      },
      validator: (value) {
        if (value!.trim().isEmpty || value == 'null' || value == 'NULL') {
          return '* Required $textName';
        } else if (value.length != 10 &&
            textName.contains('Number') &&
            textName != "GST Number") {
          return 'Enter valid Phone Number';
        } else if ((!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) &&
            textName == "Email") {
          return 'Please enter a valid Email';
        } else {
          return null;
        }
      },
      autofocus: false,
    );
  }
}
