import '../../core/core.dart';

/*
 * @Author Champlain Marius Bakop
 * @email champlainmarius20@gmail.com
 * @github ChamplainLeCode
 * 
 */
void registeredRoute() {
  Route.on("/", "HomeController@index");

  Route.on("/security/validate/register", 'HomeController@validateInput');
}
