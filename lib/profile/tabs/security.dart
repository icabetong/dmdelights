import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class SecurityTab extends StatefulWidget {
  const SecurityTab({Key? key}) : super(key: key);

  @override
  _SecurityTabState createState() => _SecurityTabState();
}

class _SecurityTabState extends State<SecurityTab> {
  TextStyle get _header =>
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle get _subtitle => const TextStyle(color: Colors.grey, fontSize: 14);

  Future<void> _onResetPassword() async {
    final email = Infrastructure.auth.currentUser?.email;

    if (email == null) {
      return;
    }

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_reset_password),
          content: Text(
            Translations.of(context)!.dialog_reset_password_message(email),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_send),
              onPressed: () async {
                await Infrastructure.auth.sendPasswordResetEmail(email: email);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Translations.of(context)!.feedback_recovery_email_sent,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(Translations.of(context)!.button_cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ThemeComponents.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.of(context)!.secure_your_account,
              style: _header,
            ),
            Text(
              Translations.of(context)!.secure_your_account_subtitle,
              style: _subtitle,
            ),
            OutlinedButton(
                onPressed: () {},
                child: Text(Translations.of(context)!.button_continue)),
            SizedBox(height: ThemeComponents.defaultSpacing),
            Text(
              Translations.of(context)!.recover_your_account,
              style: _header,
            ),
            Text(
              Translations.of(context)!.recover_your_account_subtitle,
              style: _subtitle,
            ),
            OutlinedButton(
                onPressed: _onResetPassword,
                child: Text(Translations.of(context)!.button_continue)),
            SizedBox(height: ThemeComponents.defaultSpacing),
          ],
        ),
      ),
    );
  }
}
