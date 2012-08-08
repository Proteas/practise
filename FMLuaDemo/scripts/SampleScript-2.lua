
-- Lua Functions
function SayHello()
   print("say hello called from objc")
end


-- with msg
function SayHello2(msg)
    print(msg)
end


-- with dict
function SayHello3(msgDict)
    msg = msgDict["msg"]
    print(msg)
end


-- with object
function SayHello4(obj)
    obj:sayHello(toobjc("hello from lua"))
end


-- return string
function SayHello5()
    return "raw string from lua"
end


-- return objc string
function SayHello6()
    return toobjc("objc string from lua")
end


-- call c function
function SayHello7()
    return showMsg("hi")
end
