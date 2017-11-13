--[[
  lovemain.lua
  -- Launching script --
  version: 17.11.12
  Copyright (C) 2016, 2017 Jeroen P. Broks
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]

------ 

--[[
      Project: -- title --
      
      This file contains all the basic stuff you need
      to get a Love-Game of created with the LoveBuilder 
      on the road.
      
      This script is put into a love project by a small
      builder utility, and only gets stuff running. It
      is not part of the project itself.
      
      A note about "viral" licenses (such as the GNU GPL).
      This file is NOT part of the game itself. It has been
      added to this game by my builder to make it possible for
      the game to run at all. So yeah, this file may contain the
      link to the GNU GPL files, but actually the GNU licensed
      game is using this file and not the other way around.
      
      This file adds some stuff the game needs and runs it.
      That's all. :)
      
      Therefore, this file itself, is and remains zLib licensed,
      while the game it runs may have a GNU GPL or even an
      "All Rights Reserved" license. Games that are Public Domain
      do also not affect this. And the copyright of this file
      will always remain under the name of Jeroen P. Broks, 
      no matter who wrote the game itself.
      
      Basically, if you use a commercial compiler to compile
      a GNU licensed program, the stuff the compiler adds to it
      doesn't become GNU licenced either. This file is much the
      same ;)      
      
]]      


builddate    = "-- builddate --"
gametitle    = "-- title --"
buildversion = "-- version --" 

love.window.setTitle("-- title --")

-- Importer
function j_love_import(afile,keepcase)
  local file = upper(afile)
  if keepcase then file=afile end
  if left(file,1)=="/" then file=right(file,len(file)-1) end
  --[[ simple version
	local mychunk = love.filesystem.load(file)
	return mychunk()
	]]
	-- --[[ expanded version
	local ok,mychunk = pcall(love.filesystem.load,file) 
	ok = ok or assert(ok,"Import compile error:"..file.."\n"..mychunk)
	local ret
	ok,ret = pcall(mychunk)
	ok = ok or assert(ok,"Import runtime error:"..file.."\n"..ret)
	return ret
	--]]
end

-- Some simple functions nearly allmystuff needs

-- Boolean features
boolyn = { [true] = "yes", [false] =  "no" }
boolbt = { [true] =     1, [false] =     0 }
boolon = { [true] =  "on", [false] = "off" }

-- Table features -- 
function each(a) -- BLD: Can be used if you only need the values in a nummeric indexed tabled. (as ipairs will always return the indexes as well, regardeless if you need them or not)
local i=0
if type(a)~="table" then
   print("Each received a "..type(a).."!",255,0,0)
   return nil
   end
return function()
    i=i+1
    if a[i] then return a[i] end
    end
end

function ieach(a) -- BLD: Same as each, but now in reversed order
local i=#a+1
if type(a)~="table" then
   print("IEach received a "..type(a).."!",255,0,0)
   return nil
   end
return function()
    i=i-1
    if a[i] then return a[i] end
    end
end

--[[

    This function is written by Michal Kottman.
    http://stackoverflow.com/questions/15706270/sort-a-table-in-lua

]]
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- misc

function valstr(a)
return ({
   ['nil'] = function(a) return 'nil' end,
   ['number'] = function(a) return ''..a end,
   ['string'] = function(a) return a end,
   ['boolean'] = function(a) return ({[true]='true', [false]='false'})[a] end,
   ['function'] = function(a) return("valstr does not support functions") end,
   ['table'] = function(a) return('Valstr does not support tables') end})[type(a)](a)
end

strval = valstr

--[[
  
  This function was written by Wookai
  http://stackoverflow.com/questions/2282444/how-to-check-if-a-table-contains-an-element-in-lua
  
]]
function tablecontains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end





function isorcontains(v,e)
if type(v)=="table" then return tablecontains(v,e) end
return v==e
end     

--[[ The name of the person who came up with this is unknown,
      however he placed this script here:
      
      http://stackoverflow.com/questions/1426954/split-string-in-lua
      
]]      

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function cprintf(a,b)
print(printf(a,b))
end

function len(a)
local k,v
local ret=0
if type(a)=="table" then
  --for k,v in ipairs(a) do
  --    ret = ret + 1
  --    end
  return #a
  end
return string.len(a.."") -- the .."" is to make sure this is string formatted! ;)  
end


-- String features --
upper = string.upper
lower = string.lower
chr = string.char
printf = string.format
replace = string.gsub
rep = string.rep
substr = string.sub


function left(s,l)
return substr(s,1,l)
end

function right(s,l)
local ln = l or 1
local st = s or "nostring"
-- return substr(st,string.len(st)-ln,string.len(st))
return substr(st,-ln,-1)
end 

function mid(s,o,l)
local ln=l or 1
local of=o or 1
local st=s or ""
return substr(st,of,(of+ln)-1)
end 


function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
-- from PiL2 20.4

function findstuff(haystack,needle) -- BLD: Returns the position on which a substring (needle) is found inside a string or (array)table (haystrack). If nothing if found it will return nil.<p>Needle must be a string if haystack is a string, if haystack is a table, needle can be any type.
local ret = nil
local i
for i=1,len(haystack) do
    if type(haystack)=='table'  and needle==haystack[i] then ret = ret or i end
    if type(haystack)=='string' and needle==mid(haystack,i,len(needle)) then ret = ret or i end
    -- rint("finding needle: "..needle) if ret then print("found at: "..ret) end print("= Checking: "..i.. " >> "..mid(haystack,i,len(needle)))
    end
return ret    
end

function safestring(s)
local allowed = "qwertyuiopasdfghjklzxcvbnmmQWERTYUIOPASDFGHJKLZXCVBNM 12345678890-_=+!@#$%^&*():;/<>[]{}.,"
local i
local safe = true
local alt = ""
for i=1,len(s) do
    safe = safe and (findstuff(allowed,mid(s,i,1))~=nil)
    alt = alt .."\\"..string.byte(mid(s,i,1),1)
    end
-- print("DEBUG: Testing string"); if safe then print("The string "..s.." was safe") else print("The string "..s.." was not safe and was reformed to: "..alt) end    
local ret = { [true] = s, [false]=alt }
-- print("returning "..ret[safe])
return ret[safe]     
end 

-- Serializing
function TRUE_SERIALIZE(vname,vvalue,tabs,noenter)
local ret = ""
local work = {
                ["nil"]        = function() return "nil" end,
                ["number"]     = function() return vvalue end,
                ["function"]   = function() return "'!ERROR! -- I cannot handle functions!'" end,
                ["string"]     = function() return "\""..safestring(vvalue).."\"" end,
                ["boolean"]    = function() return ({[true]="true",[false]="false"})[vvalue] end,
                ["table"]      = function()
                                 local titype
                                 local tindex = {
                                                   ["number"]     = function(v) return v end,
                                                   ["boolean"]    = function(v) return ({[true]="true",[false]="false"})[v] end,
                                                   ["string"]     = function(v) return "\""..safestring(v).."\"" end
                                 }
                                 local wrongindex = function() print("!ERROR! Type "..titype.." can not be used as a table in serializing") return "!WRONGINDEX" end
                                 local ret = "{"
                                 local k,v
                                 local result
                                 local notfirst
                                 for k,v in pairs(vvalue) do
                                     if notfirst then ret = ret .. ",\n" else notfirst=true ret = ret .."\n" end
                                     titype = type(k)
                                     result = (tindex[titype] or wrongindex)(k)
                                     -- print(titype.."/"..k)
                                     ret = ret .. TRUE_SERIALIZE("["..result.."]",v,(tabs or 0)+1,true)
                                     end
                                 if notfirst then    
                                   ret = ret .."\n"    
                                   for i=1,(tabs or 0) do ret = ret .."\t" end   
                                   for i=1,len(vname.." = ") do ret = ret .. " " end
                                   end 
                                 ret = ret .. "}"  
                                 return ret  
                                 end 
                                   
             }             
local letsgo = work[type(vvalue)] or function() print("!ERROR! Unknown type. Cannot serialize","Variable,"..vname..";Type Value,"..type(vvalue)) return "whatever" end
local i
for i=1,(tabs or 0) do ret = ret .."\t" end
if vname then 
   ret = ret .. vname .." = "..letsgo()
   else
   ret = letsgo()
   end 
if not noenter then ret = ret .."\n" end
return ret
end


function serialize(vname,variableitself)
local ret = ""
local v = variableitself 
if vname then 
   v = v or _G[vname] 
   if type(vname)~='string' then print("First variable must be the name to return in the serializer string") end
   end
ret = TRUE_SERIALIZE(vname,v)
-- JBCSYSTEM.Returner(ret)
return ret
end

function sval(a)
return 
  (({
     ['string']=function() return a end,
     ['number']=function() return a end,
     ['boolean']=function() if a then return 'true' else return 'false' end     end
  })[type(a)] or function() return "<< "..type(a).." >>" end)()
end  




-- import iloveyou --
