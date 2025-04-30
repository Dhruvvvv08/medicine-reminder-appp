import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitledInputField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? labelText;
  final Function? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isAutoCompleteEnabled;
  final double? width;
  final String? errorText;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final Color? backgroundColor;
  final TextInputType keyboardType;
  final TextEditingController? textEditingController;
  final Color? textColor;
  final bool isTextObscured;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final Function? onSuffixClick;
  final bool isAutoFocus;
  final String? validator;
  final bool isFinalKeyboard;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final Widget? prefix;
  final bool readOnly;
  final bool enable;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validators;
  final Iterable<String>? autoFillHints;
  final int? maxLength;

  const TitledInputField({
    Key? key,
    this.title,
    this.hintText = "Please Enter",
    this.onTap,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.width,
    this.suffix,
    this.backgroundColor,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textEditingController,
    this.isAutoCompleteEnabled = true,
    this.textColor,
    this.isTextObscured = false,
    this.isSuffixIcon = false,
    this.suffixIcon,
    this.onSuffixClick,
    this.isAutoFocus = false,
    this.validator,
    this.isFinalKeyboard = false,
    this.focus,
    this.nextFocus,
    this.prefix,
    this.maxLines = 1,
    this.readOnly = false,
    this.enable = true,
    this.inputFormatters,
    this.labelText = '',
    this.validators,
    this.maxLength,
    this.autoFillHints,
  }) : super(key: key);

  @override
  _TitledInputFieldState createState() =>
      _TitledInputFieldState(isTextObscured);
}

class _TitledInputFieldState extends State<TitledInputField> {
  bool _isTextObscured = false;
  bool isValidValue = true;

  _TitledInputFieldState(bool isTextObscured) {
    _isTextObscured = isTextObscured;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${widget.title ?? ''} ",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        // Text("${widget.title ?? ''} *",
        //     style: const TextStyle(
        //       color: Color(0xff747474),
        //       fontSize: 15,
        //       fontFamily: "Poppins",
        //       fontWeight: FontWeight.w500,
        //     )),
        const SizedBox(height: 6),
        TextFormField(
          autofillHints: widget.autoFillHints,
          maxLength: widget.maxLength,
          enabled: widget.enable,
          readOnly: widget.readOnly,
          autofocus: widget.isAutoFocus,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          textInputAction:
              widget.isFinalKeyboard
                  ? TextInputAction.done
                  : TextInputAction.next,
          //cursorColor: kNormalColor,
          textCapitalization: widget.textCapitalization,
          obscureText: widget.isTextObscured,

          validator:
              widget.validators == null
                  ? (value) => value?.isEmpty ?? false ? widget.validator : null
                  : widget.validators,
          focusNode: widget.focus,
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          onChanged: (text) {
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
          },
          onFieldSubmitted: (v) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(v);
            }
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            }
          },
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            counterText: '',
            prefix: widget.prefix,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 0,
            ),
            border: InputBorder.none, // <-- no visible border
            enabledBorder: const UnderlineInputBorder(
              // <-- a simple underline
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              // <-- underline on focus
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: "Poppins",
              color: Color(0xFF222222),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            filled: false, // <-- remove filling color
            suffixIcon:
                widget.suffixIcon != null
                    ? GestureDetector(
                      onTap: () {
                        if (widget.onSuffixClick != null) {
                          widget.onSuffixClick!();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: widget.suffixIcon,
                      ),
                    )
                    : null,
            suffix: widget.suffix,
            errorText: widget.errorText,
            errorMaxLines: 2,
          ),
          controller: widget.textEditingController,
          maxLines: widget.maxLines,
        ),
      ],
    );
  }
}
