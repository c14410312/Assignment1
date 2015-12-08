class MethodTotal
{
  String state;
  Float hanging;
  Float shot;
  Float injection;
  Float electrocution;
   MethodTotal(String line)
  {
    String[] parts = line.split(",");
    state = parts[0];
    hanging = Float.parseFloat(parts[1]);
    shot = Float.parseFloat(parts[2]);
    injection = Float.parseFloat(parts[3]);
    electrocution = Float.parseFloat(parts[4]);
  }  
  
}
