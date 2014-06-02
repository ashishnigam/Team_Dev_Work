 (function (){
  var val = 10;
  return val;
  })();


var PrintHello = function(args){
    
    var result = "Hello! " + args;
    return result;
};

var willCallObjcMethod = function(args){
    
    var result= args + " & Objc";
    objcMethodCall(result);
    
};

var objcCallByName = function(args){
    
    args("Hi! I am good :)");
    
};