import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorpresas_bae_app/consts/consts.dart';
import 'package:sorpresas_bae_app/controllers/profile_controller.dart';
import 'package:sorpresas_bae_app/widgets_common/bg_widget.dart';
import 'package:sorpresas_bae_app/widgets_common/custom_textfield.dart';
import 'package:sorpresas_bae_app/widgets_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(),
            body: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SI LA IMAGEN URL Y EL CONTROLADOR PATH ES VACIO
                  data['imagenUrl'] == '' && controller.profileImgPath.isEmpty
                      ? Image.asset(imgProfile2, width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                      //SI DARA IMAGE URL NO ES VACIO PERO EL CONTROLADOR SI
                      : data['imagenUrl'] != '' &&
                              controller.profileImgPath.isEmpty
                          ? Image.network(
                              data['imagenUrl'],
                              width: 100,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          //SI AMBOS SON VACIOS
                          : Image.file(
                              File(controller.profileImgPath.value),
                              width: 100,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                  10.heightBox,
                  ourButton(
                      color: lightColor,
                      onPress: () {
                        controller.changeImage(context);
                      },
                      textColor: Colors.black87,
                      title: "Cambiar"),
                  const Divider(),
                  20.heightBox,
                  customTextField(
                    controller: controller.nameController,
                    hint: nameHint,
                    title: name,
                    isPass: false,
                  ),
                  10.heightBox,
                  customTextField(
                    controller: controller.oldpassController,
                    hint: passwordHint,
                    title: oldpass,
                    isPass: true,
                  ),
                  10.heightBox,
                  customTextField(
                    controller: controller.newpassController,
                    hint: passwordHint,
                    title: newpass,
                    isPass: true,
                  ),
                  20.heightBox,
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : SizedBox(
                          width: context.screenWidth - 60,
                          child: ourButton(
                              color: lightColor,
                              onPress: () async {
                                controller.isloading(true);
                                //SI IMAGE NO ESTA SELECCIONADA
                                if (controller
                                    .profileImgPath.value.isNotEmpty) {
                                  await controller.uploadProfileImage();
                                } else {
                                  controller.profileImageLink =
                                      data['imagenUrl'];
                                }

                                //SI LA ANTIGUA CONTRASEÑA ES IGUAL A LA DE LA BD
                                if (data['password'] ==
                                    controller.oldpassController.text) {
                                  await controller.changeAuthPassword(
                                      email: data['email'],
                                      password:
                                          controller.oldpassController.text,
                                      newpassword:
                                          controller.newpassController.text);

                                  await controller.updateProfile(
                                    imgUrl: controller.profileImageLink,
                                    name: controller.nameController.text,
                                    password: controller.newpassController.text,
                                  );
                                  VxToast.show(context,
                                      msg: "Perfil Actualizado!");
                                } else {
                                  VxToast.show(context,
                                      msg: "Contraseña Actual Invalida!");
                                  controller.isloading(false);
                                }
                              },
                              textColor: Colors.black87,
                              title: "Save"),
                        ),
                ],
              )
                  .box
                  .white
                  .shadowSm
                  .padding(const EdgeInsets.all(16))
                  .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                  .rounded
                  .make(),
            )));
  }
}
