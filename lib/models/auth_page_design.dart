
class AuthPageModel {
  AuthPageModel({required this.title, required this.onPressed, required this.buttonText, this.bottomText, this.bottomTextDestination});

  final String title;
  final void Function() onPressed;
  final String buttonText;
  final String? bottomText;
  final AuthPages? bottomTextDestination;

}

enum AuthPages {
  signUp,
  logIn,
  reAuth,
}