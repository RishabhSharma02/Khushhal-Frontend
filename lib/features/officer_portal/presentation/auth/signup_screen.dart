/// New officer sign-up, step 1 of 2 (Officer Portal 5i).
library;

import 'package:flutter/material.dart';

import '../../data/officer_demo_data.dart';
import '../theme/officer_palette.dart';
import '../widgets/labeled_field.dart';
import '../widgets/officer_buttons.dart';
import '../widgets/status_chip.dart';
import 'widgets/auth_scaffold.dart';

/// Collects name, employee ID and posting pincode before moving on to
/// [SetPasswordScreen].
///
/// The employee-ID and pincode "verified" chips are shown as already
/// confirmed, matching the mock — there is no live register to check
/// against.
class SignupScreen extends StatefulWidget {
  /// Creates the sign-up screen.
  const SignupScreen({
    super.key,
    required this.onContinue,
    required this.onSignIn,
  });

  /// Called with the entered email once "Continue" is tapped.
  final ValueChanged<String> onContinue;

  /// Called when "Sign in" is tapped instead.
  final VoidCallback onSignIn;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _name = TextEditingController(
    text: OfficerDemoData.officer.fullName,
  );
  final TextEditingController _employeeId = TextEditingController(
    text: OfficerDemoData.officer.employeeId,
  );
  final TextEditingController _pincode = TextEditingController(
    text: OfficerDemoData.officer.pincode,
  );
  final TextEditingController _email = TextEditingController(
    text: OfficerDemoData.officer.email,
  );

  @override
  void dispose() {
    _name.dispose();
    _employeeId.dispose();
    _pincode.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create new account',
      subtitle: 'Step 1 of 2 · your details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabeledField(label: 'FULL NAME', controller: _name),
          const SizedBox(height: 14),
          LabeledField(
            label: 'EMPLOYEE ID',
            controller: _employeeId,
            trailing: const StatusChip(
              label: '✓ verified',
              tone: OfficerTone.green,
              dense: true,
            ),
            helperText: 'Checked against the department register',
          ),
          const SizedBox(height: 14),
          LabeledField(
            label: 'PINCODE (POSTING AREA)',
            controller: _pincode,
            keyboardType: TextInputType.number,
            trailing: StatusChip(
              label:
                  '${OfficerDemoData.officer.block}, ${OfficerDemoData.officer.state} ✓',
              tone: OfficerTone.green,
              dense: true,
            ),
            helperText: 'Sets your default block & enterprise list',
          ),
          const SizedBox(height: 14),
          LabeledField(label: 'EMAIL', controller: _email),
          const SizedBox(height: 16),
          OfficerPrimaryButton(
            label: 'Continue · set password →',
            onPressed: () => widget.onContinue(_email.text),
          ),
          const SizedBox(height: 14),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
                ),
                GestureDetector(
                  onTap: widget.onSignIn,
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: OfficerPalette.forest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
