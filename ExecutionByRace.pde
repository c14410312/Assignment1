class ExecutionByRace
{
  float white;
  float black;
  float hispanic;
  float nativeAmer;
  
  ExecutionByRace(String line)
  {
    String[] parts = line.split(",");
    white = Float.parseFloat(parts[0]);
    black = Float.parseFloat(parts[1]);
    hispanic = Float.parseFloat(parts[2]);
    nativeAmer = Float.parseFloat(parts[3]);
  }
}
