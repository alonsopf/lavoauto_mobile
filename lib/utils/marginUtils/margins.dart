part of "margin_imports.dart";


class XMargin extends StatelessWidget {
  final double x;
  const XMargin(this.x, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}

class YMargin extends StatelessWidget {
  final double y;
  const YMargin(this.y, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}
extension CustomContext on BuildContext {
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}
extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                )),
                onPressed: () {
                  onPressed();
                },
                child: Container()),
          )
        ],
      );
}
