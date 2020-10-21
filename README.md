# Protolua
A flexible lua OOP implementation. I developed this module to achieve a powerful and flexible way to use prototyping in lua.

Here's the declaration and use of a basic class

```lua
local protolua = require "protolua"
local Character = protolua.class()  -- Character class

Character.proto.name = "no name"  -- declare an object field in the 'proto' class table
Character.proto.age = 0

function Character.proto:printSummary()  -- declare an object method in the 'proto' class table
  print("Name: " .. self.name)
  print("Age: " .. self.age)
end

local character1 = Character:new()  -- instancing a new Character from its 'proto'
character1.name = "Mark"    -- modifying the field
character1.age = 22
character1:printSummary()  -- calling the method
```

Static class members
```lua
Character.static.legalAge = 18  -- declare a static field
function Character.static.checkAge(character)  -- declare a static method
  return character.age >= Character.static.legalAge
end

local check = Character.static.checkAge(character1)  -- calling the method
```

Additional features
```lua
local function constructor(this, args)  -- default constructor gets a 'this' instance and the 'args' table 
  this.name = args.name
  this.age = args.age
end

-- Verbose syntax
Character.base = AnyClass  -- base class from which 'proto' and 'static' members are derived
Character.name = "Character"  -- class name
Character.constructor = constructor

-- Short syntax
Character:extend(AnyClass):withName("Character"):withConstructor(constructor)

--use of default constructor
local character2 = Character:new { name = "John", age = 19 }  -- constructor is called inside of 'new' function
```

Reflection
```lua
print(character1.class.name)  -- >> 'Character'

for k, v in pairs(character1.class.proto) do
  print("Member " .. k .. " of type " .. type(v)) 
end

print(protolua.isType(Character, character1)) -- >> true
print(protolua.isExactType(Character, anyBaseClassInstance))  -- >> false
```
