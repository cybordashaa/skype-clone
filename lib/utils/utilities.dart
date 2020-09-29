class Utils{
  static String getUsername(String email){
    return "Live ${email.split('@')[0]}";
  }
}