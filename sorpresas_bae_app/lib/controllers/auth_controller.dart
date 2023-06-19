import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorpresas_bae_app/consts/consts.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

  //TEXTCONTROLLERS
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //LOGIN
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }

    return userCredential;
  }

  //REGISTRO
  Future<UserCredential?> registroMethod({email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }

    return userCredential;
  }

  //MÉTODO DE ALMACENAMIENTO DE DATOS
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);

    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imagenUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'whishlist_count': "00",
      'order_count': "00",
    });
  }

  //METODO CERRAR SESION
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
