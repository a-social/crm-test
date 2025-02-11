import 'package:crm_k/database/mongodb.dart';

Future<void> main() async {
  await MongoDB.connect();
  await MongoDB.importFromJson("database/data/customuers.json");
  await MongoDB.getAdmins();
  await MongoDB.getCustomers();
}
