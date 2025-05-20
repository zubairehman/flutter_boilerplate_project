import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;

  const PasswordFieldWidget({
    Key? key,
    required this.textController,
    required this.errorText,
    this.hint,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
  }) : super(key: key);

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.textController,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onChanged,
        autofocus: false,
        textInputAction: widget.inputAction,
        obscureText: _obscureText,
        maxLength: 25,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
        decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.black26,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: widget.hintColor),
          errorText: widget.errorText,
          counterText: '',
          prefixIcon: Icon(Icons.lock, color: widget.iconColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: widget.iconColor,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.red,
              ),
        ),
      ),
    );
  }
}
