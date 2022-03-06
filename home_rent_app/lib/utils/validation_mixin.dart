class ValidationMixin{
  // String? Function(String?)?
  String? validateEmail(String value){
    if(value.trim().isEmpty){
      return "Please enter your email address";
    }
    return null;
  }

  String? validatePassword(String value,{bool isConfirmed =false, String confirmedValue = ""}){
    if(value.trim().isEmpty){
      return "Please enter your password";
    }
    if(isConfirmed){
      if(value != confirmedValue){
        return "Your password didn't match";

      }
    }
    return null;
  }

}