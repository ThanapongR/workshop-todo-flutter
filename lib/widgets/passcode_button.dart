import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/passcode_provider.dart';
import 'package:todo_app/utilities/constants.dart';

class PassCodeButton extends StatelessWidget {
  final String title;

  const PassCodeButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 72.0,
      height: 72.0,
      decoration: const BoxDecoration(
        color: kGreyColor,
        shape: BoxShape.circle,
      ), // LinearGradientBoxDecoration
      child: InkWell(
        customBorder: const CircleBorder(),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black54,
            ),
          ),
        ),
        onTap: () async {
          context.read<PasscodeProvider>().addPasscode(context, title);
        },
      ), // Red will correctly spread over gradient
    );
  }
}
