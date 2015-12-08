class ExecutionByState
{
  String state;
  float total;
  String stateAbr;
  
  ExecutionByState(String line)
  {
    String[] parts = line.split(",");
    state = parts[0];
    total = Float.parseFloat(parts[1]);
    stateAbr = parts[2];
  }
}
