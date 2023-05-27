import 'package:flutter/material.dart';
class CustomTextField extends StatefulWidget {
  CustomTextField(
      {super.key,
        required this.controller,
        this.icon=Icons.indeterminate_check_box_outlined,
        this.hintText = "",
        this.labelText = "",
        this.isObscureText = false,
        Function(dynamic value)? validator,
        IconData? suffixIcon,
        Function? suffixPressed});

  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final String labelText;
  final bool isObscureText;

  bool isPasswordShown = false;

  bool get isPasswordShownGetter => isPasswordShown;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.02),
        child: TextField(
          controller: widget.controller,
          keyboardType:
          widget.isObscureText ? TextInputType.number : TextInputType.name,
          obscureText: widget.isObscureText ? !widget.isPasswordShown : false,
          maxLength: widget.isObscureText ? 10 : 15,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(mediaQuery.size.height * 0.025),
            counterText: "",
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.black),
            hintText: widget.hintText,
            prefixIcon: Icon(widget.icon, color: Colors.black),
            suffixIcon: widget.isObscureText
                ? IconButton(
              icon: Icon(
                widget.isPasswordShown
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  widget.isPasswordShown = !widget.isPasswordShown;
                });
              },
            )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 3, color: Colors.black)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  width: 2, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ));
  }
}