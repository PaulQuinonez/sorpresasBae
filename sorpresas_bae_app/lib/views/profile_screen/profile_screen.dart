import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorpresas_bae_app/consts/consts.dart';
import 'package:sorpresas_bae_app/consts/list.dart';
import 'package:sorpresas_bae_app/controllers/auth_controller.dart';
import 'package:sorpresas_bae_app/controllers/profile_controller.dart';
import 'package:sorpresas_bae_app/services/firestore_services.dart';
import 'package:sorpresas_bae_app/views/auth_screen/login_screen.dart';
import 'package:sorpresas_bae_app/views/profile_screen/components/details_card.dart';
import 'package:sorpresas_bae_app/views/profile_screen/edit_profile_screen.dart';
import 'package:sorpresas_bae_app/widgets_common/bg_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
        child: Scaffold(
      body: StreamBuilder(
        stream: FirestorServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];

            return SafeArea(
              child: Column(
                children: [
                  // EDITAR PERRFIL BOTON
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        )).onTap(() {
                      controller.nameController.text = data['name'];
                      Get.to(() => EditProfileScreen(
                            data: data,
                          ));
                    }),
                  ),

                  // DETALLES DEL USUARIO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        data['imagenUrl'] == ''
                            ? Image.asset(imgProfile2,
                                    width: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make()
                            : Image.network(data['imagenUrl'],
                                    width: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                        10.widthBox,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${data['name']}"
                                .text
                                .fontFamily(semibold)
                                .black
                                .make(),
                            "${data['email']}".text.black.make()
                          ],
                        )),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                            color: Colors.black,
                          )),
                          onPressed: () async {
                            await Get.put(AuthController())
                                .signoutMethod(context);
                            Get.offAll(() => const LoginScreen());
                          },
                          child: logout.text.fontFamily(semibold).black.make(),
                        )
                      ],
                    ),
                  ),
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      detailsCard(
                          count: data['cart_count'],
                          title: "En tu carrito",
                          width: context.screenWidth / 3.4),
                      detailsCard(
                          count: data['whishlist_count'],
                          title: "En tu wishlist",
                          width: context.screenWidth / 3.4),
                      detailsCard(
                          count: data['order_count'],
                          title: "Tus ordenes",
                          width: context.screenWidth / 3.4),
                    ],
                  ),

                  // SECCION DE BOTONES
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: lightGrey,
                      );
                    },
                    itemCount: profileButtonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.asset(
                          profileButtonsIcon[index],
                          width: 22,
                        ),
                        title: profileButtonList[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                      );
                    },
                  )
                      .box
                      .white
                      .rounded
                      .margin(const EdgeInsets.all(12))
                      .padding(const EdgeInsets.symmetric(horizontal: 16))
                      .shadowSm
                      .make()
                      .box
                      .make(),
                ],
              ),
            );
          }
        },
      ),
    ));
  }
}
