/// Represents an employee object with basic information such as ID, name, email, role, UID, and hourly rate.
class employee{

  late int id;
  late String name;
  late String email;
  late String role;
  late String uid;
  late double hourly_rate;

  /// Creates an employee with default values.
  employee.defaultConstructor(){
    this.id = 0;
    this.name = "";
    this.email = "";
    this.role = "";
    this.uid = "";
    this.hourly_rate = 0.0;
  }

  /// Creates an employee with the given values for its attributes.
  employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.uid,
    required this.hourly_rate,
  });




}