class Execution
{
  String name;
  String race;
  Float age;
  String sex;
  String crime;
  String method;
  Float  year;
  String state;
  
   Execution(String line)
  {
    String[] parts = line.split(",");
    name = parts[0];
    race = parts[1];
    age = Float.parseFloat(parts[2]);
    sex = parts[3];
    crime = parts[4];
    method = parts[5];
    year = Float.parseFloat(parts[6]);
    state = parts[7];
  }  
}
