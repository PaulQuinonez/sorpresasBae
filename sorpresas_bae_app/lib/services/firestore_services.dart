import 'package:sorpresas_bae_app/consts/consts.dart';

class FirestorServices {
  //OBTENEMOS LOS DATOS DEL USUARIO
  static getUser(uid) {
    var user = firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
    return user;
  }

  //OBTENEMOS LOS PRODUCTOS SEGUN LA CATEGORIA
  static getProducts(category) {
    return firestore
        .collection(productCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }
}
