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

  String? validate(String value, String title){
    if(value.trim().isEmpty){
      return "Please enter your $title";
    }
    return null;
  }

  
  String? validateAge(String value){
    if(value.trim().isEmpty){
      return "Please enter your age";
    }
    else if(int.tryParse(value)==null){
      return "Please enter a numeric value";
    }
    if(int.parse(value) < 0 || int.parse(value) > 150){
      return "Please enter age more than 0 and less than 150";
    }
    return null;
  }

}