import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management_app/widgets/colors.dart';

void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: blackColor,
    textColor: whiteColor, 
    fontSize: 15.0,
    webPosition: "center",
  );
}
