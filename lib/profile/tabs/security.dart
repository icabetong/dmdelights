import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _onChangePassword() async {
    final auth = Infrastructure.auth;
    final email = auth.currentUser?.email;
    if (email == null) {
      throw Exception('Email cannot be null');
    }

    final password = await _onPromptPassword();
    if (password == null) {
      return;
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    try {
      final response =
          await auth.currentUser?.reauthenticateWithCredential(credential);

      final newpassword = await _onPromptNewPassword();
      if (newpassword == null) {
        throw Exception();
      }

      await auth.currentUser?.updatePassword(newpassword);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Translations.of(context)!.feedback_profile_updated),
      ));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Translations.of(context)!.feedback_error_generic),
          ));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Translations.of(context)!.feedback_error_generic),
          ));
          break;
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Translations.of(context)!.feedback_error_generic),
      ));
    }
  }

  Future<String?> _onPromptNewPassword() async {
    final passwordController = TextEditingController();
    final repasswordController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_enter_new_password),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: Translations.of(context)!.field_password,
                ),
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: Translations.of(context)!.field_retype_password,
                ),
                obscureText: true,
                controller: repasswordController,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_change),
              onPressed: () {
                final password = passwordController.text;
                final repassword = repasswordController.text;
                if (password == repassword) {
                  Navigator.pop(context, password);
                }
              },
            ),
            TextButton(
              child: Text(Translations.of(context)!.button_cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _onPromptPassword() async {
    final passwordController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_enter_old_password),
          content: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: Translations.of(context)!.field_password,
            ),
            obscureText: true,
            controller: passwordController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_continue),
              onPressed: () {
                Navigator.pop(context, passwordController.text);
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
                onPressed: _onChangePassword,
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
