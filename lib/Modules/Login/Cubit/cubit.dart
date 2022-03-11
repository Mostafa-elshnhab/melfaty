import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mlfaty_share/Models/UserModel/user_model.dart';
import 'package:mlfaty_share/Shared/componants/reusable/constants.dart';

import 'States.dart';

class LoginCubit extends Cubit<LogiStates> {
  LoginCubit() : super(InitialLoginState());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isShow = true;
  void ChangePasswordIcon() {
    isShow = !isShow;
    emit(ChangePasswordState());
  }
  void signInWithGoogle() async {
    emit(LoginGoogleLodaingState());
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      crateUser(email: value.user!.email, name:value.user!.displayName,image: value.user!.photoURL,uId: value.user!.uid );
      uId = value.user!.uid;
      emit(LoginGoogleScssesState(value.user!.uid));
    }).catchError((error){
      emit(LoginGoogleErrorState(error));


    });
  }
  void crateUser(
      {required String? name,
        required String? email,
        required String? uId,
        required String? image,
      }) {
    UserModel model = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: '',
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
  void Login({required email, required password}) {
    emit(LoginLodaingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      uId = value.user!.uid;
      emit(LoginScssesState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErorrState(error.toString()));
    });
  }
}
