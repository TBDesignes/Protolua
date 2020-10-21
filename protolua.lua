local protolua = { }

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


function protolua.new(class, args)
  local instance = nil
  
  if class.base then
    instance = class.base:new(args)
  else
    instance = { }
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
  
  class.new = protolua.new
  class.withName = protolua.withName
  class.extend = protolua.extend
  class.withConstructor = protolua.withConstructor
  
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
  if base then
    return base.static[key]
  end
end

return protolua
