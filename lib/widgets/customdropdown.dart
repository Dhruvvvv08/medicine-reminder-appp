import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:healthmvp/Utils/colors.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> data;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String hintText;
  final Widget? title;
  final bool showError;
  final bool isLoading;
  const CustomDropdown({
    Key? key,
    required this.data,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    this.title,
    this.showError = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) title!,
          // if (title != null)
          //   Text(
          //     title ?? "",
          //     style: TextStyle(
          //       color: showError ? const Color(0xff2B338C) : const Color(0xFF6C7278),
          //       fontSize: 12,
          //       fontFamily: "Plus Jakarta Sans",
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          if (title != null) const SizedBox(height: 6),
          Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kf0f9ff,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: const Color(0xff727977), width: 1),
            ),
            child: Builder(
              builder: (context) {
                if (data == null) {
                  return const SizedBox();
                }
                if (isLoading) {
                  return const LinearProgressIndicator();
                }
                return DropdownButtonFormField2<String>(
                  isDense: true,
                  isExpanded: true,
                  decoration: InputDecoration(
                    isDense: true,

                    contentPadding: const EdgeInsets.only(
                      left: 12, // Horizontal padding for left
                      right: 12, // Horizontal padding for right
                      top: 7, // Top padding added (adjust the value as needed)
                      bottom:
                          0, // Bottom padding (can be adjusted if necessary)
                    ),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color:
                          showError
                              ? const Color(0xff2B338C)
                              : const Color(0xff79747E),
                      fontSize: 15,
                      overflow: TextOverflow.clip,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,

                      height:
                          2.5, // Adjust the line height to help center the text vertically
                    ),
                  ),
                  value: selectedValue,
                  items:
                      data.map((String items) {
                        return DropdownMenuItem<String>(
                          value: items,
                          child: Padding(
                            padding: const EdgeInsets.only(),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                items,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.clip,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: onChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                );

                // DropdownButtonFormField2<String>(
                //   isDense: true,
                //   decoration: InputDecoration(
                //     isDense: true,
                //     contentPadding: const EdgeInsets.only(
                //       left: 12,  // Horizontal padding for left
                //       right: 12, // Horizontal padding for right
                //       top: 9,    // Top padding added (adjust the value as needed)
                //       bottom: 0, // Bottom padding (can be adjusted if necessary)
                //     ),
                //     // Hides the underline by setting the `border` to `InputBorder.none`
                //     // contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0,),
                //     // // Hides the underline by setting the `border` to `InputBorder.none`
                //     border: InputBorder.none,
                //     hintText: hintText,
                //     hintStyle: TextStyle(
                //       color: showError ? const Color(0xff2B338C) : const Color(0xff79747E),
                //       fontSize: 12,
                //       overflow: TextOverflow.clip,
                //       fontFamily: "Montserrat",
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                //   // Initial Value
                //   value: selectedValue,
                //   // Icon for dropdown arrow
                //   // icon: Padding(
                //   //   padding: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
                //   //   child: Image(image: AssetImage("images/Arrow Down.png")),
                //   // ),
                //   // Items list
                //   items: data.map((String items) {
                //     return DropdownMenuItem<String>(
                //       value: items,
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 12),
                //         child: Text(
                //           items,
                //           softWrap: true,
                //           style: const TextStyle(
                //             fontSize: 12,
                //             overflow: TextOverflow.clip,
                //             fontFamily: "Montserrat",
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     );
                //   }).toList(),
                //   // Callback when the user selects an item
                //   onChanged: onChanged,
                //   // Optional: Validation callback
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'This field cannot be empty';
                //     }
                //     return null;
                //   },
                // );

                //   DropdownButtonHideUnderline(
                //   child: DropdownButton(
                //       isDense: true,
                //       underline: Container(),
                //       hint: Container(
                //         margin: const EdgeInsets.only(left: 12, top: 3),
                //         child: Text(
                //           hintText,
                //           softWrap: true,
                //           style: TextStyle(
                //             color:
                //                 showError ? const Color(0xff2B338C) : const Color(0xff79747E),
                //             fontSize: 12,
                //             overflow: TextOverflow.clip,
                //             fontFamily: "Montserrat",
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //       // Initial Value
                //       value: selectedValue,
                //
                //       // Down Arrow Icon
                //       icon: Padding(
                //         padding: const EdgeInsets.only(right: 20,top: 13,bottom: 13),
                //         child: Image(image: AssetImage("images/Arrow Down.png")),
                //       ),
                //
                //       // Array list of items
                //       items: data.map((String items) {
                //         return DropdownMenuItem(
                //           value: items,
                //           child: Padding(
                //             padding: const EdgeInsets.only(left: 12),
                //             child: Text(
                //               items,
                //               softWrap: true,
                //               style: const TextStyle(
                //                 fontSize: 12,
                //                 overflow: TextOverflow.clip,
                //                 fontFamily: "Montserrat",
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //       // After selecting the desired option,it will
                //       // change button value to selected value
                //       onChanged: onChanged),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
