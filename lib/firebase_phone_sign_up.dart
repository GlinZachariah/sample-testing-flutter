

import 'dart:async';
import 'dart:developer';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class FirebasePhoneSignUp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    log('Phone OTP page is initialized ');
    final phone = ModalRoute.of(context)!.settings.arguments as String;
    _sendOtp(phone);
    return Material(
      child: OtpTextField(
        numberOfFields: 6,
        borderColor: Color(0xFF512DA8),
        //set to true to show as box or false to show as dash
        showFieldAsBox: true,
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here
        },
        //runs when every textfield is filled
        onSubmit: (String verificationCode){
          _verifyPhoneNumber(phone, verificationCode);
          // showDialog(
          //     context: context,
          //     builder: (context){
          //       return AlertDialog(
          //         title: Text("Verification Code"),
          //         content: Text('Code entered is $verificationCode'),
          //       );
          //     }
          // );


        }, // end onSubmit
      ),
    );
  }
   FirebasePhoneSignUp({super.key,required phone});

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _sendOtp(String phone) async{
    log('Sending otp to mobile : $phone');
    await auth.signInWithPhoneNumber(phone);
  }

  Future<void> _verifyPhoneNumber(String phoneNumber,String smsCode,) async {
    log('calling verify phone Number with phoneNumber : $phoneNumber');
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log('The provided phone number : $phoneNumber is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        // String smsCode = 'xxxx';
        log('Send verification Id as : $verificationId');

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }




}