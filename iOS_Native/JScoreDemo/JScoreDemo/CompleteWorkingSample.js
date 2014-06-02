var initiateJSObj = function(params){
    
    var colorVal;
    var button;
    var GlobalObj = {
        'xy'      : 5,
        'yx'      : 60,
        'x'       : 10,
        'y'       : 20,
        'division': function()
                    {
                        return GlobalObj.yx/GlobalObj.xy;
                    },
        'multiply': function(parms)
                    {
                        var result;
                        if(parms)
                        {
                            result = GlobalObj.x * GlobalObj.y * parms;
                        }else{
                            result = GlobalObj.x * GlobalObj.y;
                        }
                      //  this.rs = result;
                        if(!this.rs)
                        {
                            alert("Multiplication Result = "+result);
                            return result;
                        }
                        
                        return this;
                    }
        };
    
    GlobalObj.addLabel = function(parms)
    {
        var rgb = {
        red:255.0,
        green:67.0,
        blue:70.0
        };
        colorVal = makeNSColor(rgb);
        alert("WOW color coding works");
        return colorVal;
    };
    
    var rect = {
    top:80.0,
    left:170.0,
    width:130.0,
    height:100.0
    };
    
    var callback1 = function(args){
        alert(args);
        
        // will not work, as i have not exposed any method or property named tintColor in JSExport protocol.
        // Thats why Appc needs to wrap all the functionality.
        // Hyperloop-JS is an approach to remove this drawback and enhance performance.
        
        button.tintColor = colorVal;
    };
    
    GlobalObj.willCreateButton = function(parms)
    {
        if(!button){
            button = createButton(rect);
        }
        alert(button);
        
        button.onClick(callback1);
        
        return button;
    };
    
    var callback2 = function(args){
        alert(args);
        
        // will not work, as i have not exposed any method or property named tintColor in JSExport protocol.
        // Thats why Appc needs to wrap all the functionality.
        // Hyperloop-JS is an approach to remove this drawback and enhance performance.
        
    };
    var buttonUsingClass;
    GlobalObj.useClassCreateButton = function(parms)
    {
        var buttonRect = {
        top:80.0,
        left:20.0,
        width:130.0,
        height:100.0,
        title:"Bingo, Wonders around here"
        };
        
        if(!buttonUsingClass){
            buttonUsingClass = Button.createButton(buttonRect);
        }
        
        alert(buttonUsingClass);
        
        buttonUsingClass.onClick(callback2);
        
        return buttonUsingClass;
    };
    
    GlobalObj.willRemoveButton = function(parms)
    {
        if(parms == 'class')
        {
            buttonUsingClass.removeButton();
            buttonUsingClass = null;
            return true;
        }else
        {
            button.removeButton();
            button = null;
        }
    
    };
    
    return GlobalObj;
}