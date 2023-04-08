import 'package:cloud_functions/cloud_functions.dart';
import 'package:csce315_project3_13/Services/general_helper.dart';

class reports_helper
{

  general_helper gen_helper = general_helper();

  Future<double> get_z_report(String date) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getZReport');
    final res = await getter.call({'date': date});
    List<dynamic> data = res.data;

    if(data.length == 0) {
      return 0.0;
    } else {
      String money = data[0]['sales'];
      double amount = double.parse(money.substring(1, money.length));
      return amount;
    }
  }

  Future<void> update_x_report(double amount) async
  {
    String date = await gen_helper.get_current_date();
    double new_amount = (await generate_z_report(date) + amount);

    if(new_amount - amount == 0) {
      HttpsCallable updater = FirebaseFunctions.instance.httpsCallable('makeZReport');
      print(date + "    new  ${new_amount}");
      await updater.call({
        'date': date,
        'amount': new_amount
      });
    } else {
      HttpsCallable updater = FirebaseFunctions.instance.httpsCallable('updateXReport');
      print(date + "     ${new_amount}");
      await updater.call({
        'date': date,
        'amount': new_amount
      });
    }

  }
}