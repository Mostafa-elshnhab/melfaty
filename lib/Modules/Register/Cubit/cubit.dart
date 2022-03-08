import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlfaty_share/Models/UserModel/user_model.dart';
import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';

import 'States.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitialRegisterState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isShow = true;
  void ChangePasswordIcon() {
    isShow = !isShow;
    emit(ChangeRegisterPasswordState());
  }

  void Register(
      {required String name,
      required String email,
      required String phone,
      required String password}) {
    emit(RegisterLodaingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      uId = value.user!.uid;
      crateUser(
          name: name,
          email: email,
          phone: phone,
          uId: value.user!.uid,
          cover:
              'https://image.freepik.com/free-vector/young-people-smiling-blue-background_18591-52402.jpg',
          image:
              'https://image.freepik.com/free-vector/pop-art-fashion-beautiful-woman-cartoon_18591-52376.jpg',
          bio: 'write your bio ..');
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void crateUser(
      {required String name,
      required String email,
      required String phone,
      required String uId,
      required String image,
      required String cover,
      required String bio}) {
    UserModel model = UserModel(
        uId: uId,
        name: name,
        email: email,
        phone: phone,
        isVerified: false,
       );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
