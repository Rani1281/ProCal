class AuthPageDesign {
  AuthPageDesign({required this.title, required this.onPressed, required this.buttonText, this.bottomText, this.bottonTextDestination});

  final String title;
  final void Function() onPressed;
  final String buttonText;
  final String? bottomText;
  final String? bottonTextDestination;


}