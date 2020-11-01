local protolua = { }

local metaClass = { }
local metaStatic = { }

function protolua.withName(class, name)
  class.name = name
  return class
end

function protolua.extend(class, base)
  class.base = base
  return class
end

function protolua.withConstructor(class, constructor)
  class.constructor = constructor
  return class
end

function protolua.mixin(class, mixin)
  if type(mixin) == "string" then
    mixin = require(mixin)
  end
  local count = 0
  for i = 1, #class.mixins do
    if class.mixins[i] == mixin then
      return class
    end
    count = i
  end
  class.mixins[count + 1] = mixin
  return class
end

function protolua.new(class, args)
  local instance = class.base and class.base:new(args) or { }
  
  for _, mixin in pairs(class.mixins) do
    for k, v in pairs(mixin.proto) do
      instance[k] = v
    end
  end
  
  for k, v in pairs(class.proto) do
    instance[k] = v
  end
  
  instance.class = class
  
  if class.constructor then
    class.constructor(instance, args)
  end
  
  return instance
end

function protolua.class()
  local class = { }
  
  class.proto = { class = class }
  class.static = { class = class }
  class.mixins = { }
  
  class.new = protolua.new
  class.withName = protolua.withName
  class.extend = protolua.extend
  class.withConstructor = protolua.withConstructor
  class.mixin = protolua.mixin
  
  setmetatable(class, metaClass)
  setmetatable(class.static, metaStatic)
  
  return class
end

function protolua.isExactType(class, instance)
  return class == instance.class
end

function protolua.isType(class, instance)
  local otherClass = instance.class
  while otherClass do
    if class == otherClass then
      return true
    end
    otherClass = otherClass.base
  end
  return false
end

function metaStatic.__index(table, key)
  local base = table.class.base
  return base and base.static[key]
end

function metaClass.__call(func, ...)
  return func.proto
end

return protolua
