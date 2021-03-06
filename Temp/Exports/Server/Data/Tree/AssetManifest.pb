
��������"Crossbow Impact Projectile Alignedb�
� ����َ��F*�����َ��F"Crossbow Impact Projectile Aligned"  �?  �?  �?(�����B2
���¢�ć�Z e   Apz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����¢�ć�
Impact Geo"
 ΁�8  �?  �?  �?(����َ��F2
���坬���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����坬���Fantasy Crossbow Bolt 01"

��o�  �7   �?  �?  �?(���¢�ć�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

؇��򦔨.08(�
 
NoneNone
X؇��򦔨.Fantasy Crossbow Bolt 01R0
StaticMeshAssetRefsm_weap_fan_bolt_cross_001
�N��������jsonZ�N�N--
-- json.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode

local escape_char_map = {
  [ "\\" ] = "\\",
  [ "\"" ] = "\"",
  [ "\b" ] = "b",
  [ "\f" ] = "f",
  [ "\n" ] = "n",
  [ "\r" ] = "r",
  [ "\t" ] = "t",
}

local escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(escape_char_map) do
  escape_char_map_inv[v] = k
end


local function escape_char(c)
  return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end


local function encode_nil(val)
  return "null"
end


local function encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then error("circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        error("invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      error("invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"

  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        error("invalid table: mixed or invalid key types")
      end
      table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


local function encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


local type_func_map = {
  [ "nil"     ] = encode_nil,
  [ "table"   ] = encode_table,
  [ "string"  ] = encode_string,
  [ "number"  ] = encode_number,
  [ "boolean" ] = tostring,
}


encode = function(val, stack)
  local t = type(val)
  local f = type_func_map[t]
  if f then
    return f(val, stack)
  end
  error("unexpected type '" .. t .. "'")
end


function json.encode(val)
  return ( encode(val) )
end


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

local space_chars   = create_set(" ", "\t", "\r", "\n")
local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals      = create_set("true", "false", "null")

local literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


local function next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


local function decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error( string.format("%s at line %d col %d", msg, line_count, col_count) )
end


local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string.format("invalid unicode codepoint '%x'", n) )
end


local function parse_unicode_escape(s)
  local n1 = tonumber( s:sub(1, 4),  16 )
  local n2 = tonumber( s:sub(7, 10), 16 )
   -- Surrogate pair?
  if n2 then
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return codepoint_to_utf8(n1)
  end
end


local function parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      decode_error(str, j, "control character in string")

    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                 or str:match("^%x%x%x%x", j + 1)
                 or decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. parse_unicode_escape(hex)
        j = j + #hex
      else
        if not escape_chars[c] then
          decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. escape_char_map_inv[c]
      end
      k = j + 1

    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
  local x = next_char(str, i, delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


local function parse_literal(str, i)
  local x = next_char(str, i, delim_chars)
  local word = str:sub(i, x - 1)
  if not literals[word] then
    decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return literal_map[word], x
end


local function parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = next_char(str, i, space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


local function parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = next_char(str, i, space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      decode_error(str, i, "expected string for key")
    end
    key, i = parse(str, i)
    -- Read ':' delimiter
    i = next_char(str, i, space_chars, true)
    if str:sub(i, i) ~= ":" then
      decode_error(str, i, "expected ':' after key")
    end
    i = next_char(str, i + 1, space_chars, true)
    -- Read value
    val, i = parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


local char_func_map = {
  [ '"' ] = parse_string,
  [ "0" ] = parse_number,
  [ "1" ] = parse_number,
  [ "2" ] = parse_number,
  [ "3" ] = parse_number,
  [ "4" ] = parse_number,
  [ "5" ] = parse_number,
  [ "6" ] = parse_number,
  [ "7" ] = parse_number,
  [ "8" ] = parse_number,
  [ "9" ] = parse_number,
  [ "-" ] = parse_number,
  [ "t" ] = parse_literal,
  [ "f" ] = parse_literal,
  [ "n" ] = parse_literal,
  [ "[" ] = parse_array,
  [ "{" ] = parse_object,
}


parse = function(str, idx)
  local chr = str:sub(idx, idx)
  local f = char_func_map[chr]
  if f then
    return f(str, idx)
  end
  decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = parse(str, next_char(str, 1, space_chars, true))
  idx = next_char(str, idx, space_chars, true)
  if idx <= #str then
    decode_error(str, idx, "trailing garbage")
  end
  return res
end


return json
�
���ܼ���NPCHealthBarb�

�
 �������*��������NPCHealthBar"  �?  �?  �?(�����B2���ܰ���������ϣ�P��������pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *����ܰ����NPCHealthBar"
  H�   �?  �?  �?(�������Z3

cs:Fill���������

cs:Label���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��ᓥ��'*������ϣ�PGroup"
  �B  ��  �?  �?  �?(�������2�ڏ������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ڏ����BG"$

��L�*3��&�+7
�#<�>
׃?(�����ϣ�PZR
(
ma:Shared_BaseMaterial:id�
��¬�J
&
ma:Shared_BaseMaterial:color�%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

����ﳬ�08�
 *���������Fill"
  
�#<�G�=  �?(�����ϣ�PZW
(
ma:Shared_BaseMaterial:id�
��¬�J
+
ma:Shared_BaseMaterial:color�
  �?%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

����ﳬ�08�
 *���������Label"$

웉? � �   ��G?�G?�G?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�u
	100 / 100  �?  �?  �?%  �?%  �?-  �?2$
"mc:ecoretexthorizontalalign:center:"
 mc:ecoretextverticalalign:center
NoneNone
G��¬�JOpaque EmissiveR(
MaterialAssetReffxma_opaque_emissive
F����ﳬ�Cube - Bottom-AlignedR!
StaticMeshAssetRefsm_cube_001
���ᓥ��'NPCHealthBarZ��	--[[
	NPCHealthBar
	by: standardcombo
	v0.9.0
	
	Works in conjunction with a data provider that is passed into SetDataProvider().
	
	Expects implementation of the interface:
		GetHealt()
		GetMaxHealth()
		GetTeam()
--]]

local FILL_BAR = script:GetCustomProperty("Fill"):WaitForObject()
local LABEL = script:GetCustomProperty("Label"):WaitForObject()

script.parent:LookAtLocalView()
script.parent.visibility = Visibility.FORCE_OFF

local _data = nil


-- Expects a script with specific functions, allowing different scripts to be passed
function SetDataProvider(data)
	_data = data
end


function Tick()
	if not _data then return end
	
	local hp = _data:GetHealth()
	local maxHP = _data:GetMaxHealth()
	
	if hp <= 0 or hp >= maxHP then
		script.parent.visibility = Visibility.FORCE_OFF
		return
		
	else
		script.parent.visibility = Visibility.INHERIT
	end
	
	LABEL.text = CoreMath.Round(hp) .. " / " .. CoreMath.Round(maxHP)
	
	local percent = hp / maxHP
	percent = CoreMath.Clamp(percent, 0, 1)
	
	local scale = FILL_BAR:GetScale()
	scale.z = percent
	FILL_BAR:SetScale(scale)
	
	FILL_BAR.team = _data:GetTeam()
end

�

cs:Fill� 

cs:Label� 
�
cs:Fill:tooltipjuReference to the UI Image that represents the filled bar. The script will scale the bar to show percentage of health.
j
cs:Label:tooltipjVReference to the UI Text object that will draw the number of hitpoints inside the bar.
�ӡ�������WeaponReticleUIClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local SEGMENTS_ROOT = script:GetCustomProperty("SegmentsRoot"):WaitForObject()

-- User exposed properties
local START_ANGLE = COMPONENT_ROOT:GetCustomProperty("StartAngle")
local EXTRA_RADIUS = COMPONENT_ROOT:GetCustomProperty("ExtraRadius")

local LOCAL_PLAYER = Game.GetLocalPlayer()
local ANGLE = 360 / #SEGMENTS_ROOT:GetChildren()
local RAD_ANGLE = math.pi * 2 / #SEGMENTS_ROOT:GetChildren()

function Tick()
    local spread = LOCAL_PLAYER.currentSpread + EXTRA_RADIUS
    local deg = START_ANGLE
    local rad = math.pi / 2
    for _,seg in pairs(SEGMENTS_ROOT:GetChildren()) do
        seg.rotationAngle = deg
        seg.x = math.cos(rad) * spread
        seg.y = math.sin(rad) * spread
        deg = deg + ANGLE
        rad = rad + RAD_ANGLE
    end
end
��؁��Ё��Arrowb�
� ��ã�׳*���ã�׳Arrow"   ?   ?   ?(֮���ћ�$2U�����ˍ�f������������ܜĨ�`�Ű۝�ۖ��ѵĂ��A�����ʮ����롱'���������ꮸ¡��Қpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ˍ�fPrism - 3-Sided"

���B lQ@ [��>[��>��=(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *����������Cylinder"
��A����W�]=�]=�z�?(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������m088�
 *����ܜĨ�`Prism - 3-Sided"

o����@ [��>[��>��<(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *��Ű۝�ۖ�Prism - 3-Sided"

t=+���@ [��>[��>��<(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *��ѵĂ��APrism - 3-Sided"

��}���@ [��>[��>��<(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *������ʮPrism - 3-Sided"$

o����@���B[��>[��>��<(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *�����롱'Prism - 3-Sided"$

t=+���@���B[��>[��>��<(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *����������Prism - 3-Sided"$

��}���@���B[��>[��>��<(��ã�׳Z+
)
ma:Shared_BaseMaterial:id���̬�Ӌ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 *�ꮸ¡��ҚPrism - 3-Sided"

���B B�@ ��>��>�b�=(��ã�׳Z+
)
ma:Shared_BaseMaterial:id�����ے���pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ߐw088�
 
NoneNone
@����ے���Magic GlassR$
MaterialAssetReffxmi_magic_glass
=������mCylinderR%
StaticMeshAssetRefsm_cylinder_002
C��̬�Ӌ��Metal Gold 01R%
MaterialAssetRefmi_metal_gold_001
A�����ߐwPrism - 3-SidedR"
StaticMeshAssetRefsm_prism_001
���쉔����,Fantasy Castle Wall 01 - Door Basic Templateb�
� ̱�𽙗��*�̱�𽙗��,Fantasy Castle Wall 01 - Door Basic Template"  �?  �?  �?(�҈�绺�K2����Ә����ԃ܉��ߟz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����Ә���#Fantasy Castle Wall 01 - Doorway 01"
    �?  �?  �?(̱�𽙗��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ƚҥ���088�
 *��ԃ܉��ߟBasic Door - Castle"$

  �C  B����  �?  �?  �?(̱�𽙗��2�����м��ঐ��Л�������ܞ��Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������м��ServerContext"
    �?  �?  �?(�ԃ܉��ߟ2�����΀�����׌ό��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������΀��BasicDoorControllerServer"
    �?  �?  �?(�����м��Z�
 
cs:ComponentRoot��ԃ܉��ߟ

cs:RotationRoot������ܞ��
"
cs:RotatingTrigger������ئ��
 
cs:StaticTrigger����׌ό��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ԝ�ݨ*����׌ό��StaticTrigger"

  �B  C   �?ff�?  @@(�����м��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�ঐ��Л��ClientContext"
  /C   �?  �?  �?(�ԃ܉��ߟ2��������Ө�ޱ����풴�&Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�����BasicDoorControllerClient"
    �?  �?  �?(ঐ��Л��Z]

cs:RotationRoot������ܞ��

cs:OpenSound�����Ө�ޱ

cs:CloseSound�
����풴�&z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ڦ�ױ��*�����Ө�ޱHelper_DoorOpenSound"
    �?  �?  �?(ঐ��Л��Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*�����풴�&Helper_DoorCloseSound"
    �?  �?  �?(ঐ��Л��ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*������ܞ��RotationRoot"
    �?  �?  �?(�ԃ܉��ߟ2��˗��� �����ئ��Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���˗��� Geo_StaticContext"
    �?  �?  �?(�����ܞ��2
���������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Fantasy Castle Door 01"
 ���B  �?  �?  �?(��˗��� z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������088�
 *������ئ��RotatingTrigger"

  �B  C   �?ff�?  @@(�����ܞ��Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box@
TemplateAssetRef,Fantasy_Castle_Wall_01_-_Door_Basic_Template
S������Fantasy Castle Door 01R,
StaticMeshAssetRefsm_ts_fan_cas_door_001
r����㹩)Object Domestic Doors & Creaks Set 01 SFX
R9
AudioBlueprintAssetRefsfxabp_object_domestic_door_ref
��ڦ�ױ��BasicDoorControllerClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local ROTATION_ROOT = script:GetCustomProperty("RotationRoot"):WaitForObject()
local OPEN_SOUND = script:GetCustomProperty("OpenSound"):WaitForObject()
local CLOSE_SOUND = script:GetCustomProperty("CloseSound"):WaitForObject()

-- Variable
local previousRotation = 0.0

-- float GetDoorRotation()
-- Gives you the current rotation of the door
function GetDoorRotation()
	local result = ROTATION_ROOT:GetRotation().z / 90.0

	if math.abs(result) < 0.01 then
		return 0.0
	end

	return result
end

-- nil Tick(float)
-- Plays sounds when the door begins opening or finishes closing
function Tick(deltaTime)
	local doorRotation = GetDoorRotation()

	if doorRotation ~= 0.0 and previousRotation == 0.0 and OPEN_SOUND then
		OPEN_SOUND:Play()
	end

	if doorRotation == 0.0 and previousRotation ~= 0.0 and CLOSE_SOUND then
		CLOSE_SOUND:Play()
	end

	previousRotation = doorRotation
end

-- Initialize
previousRotation = GetDoorRotation()

�4���ԝ�ݨBasicDoorControllerServerZ�4�4--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[
Doors operate in the relative space of the root of the component. In that space, they rotate around the Z axis, and the
default closed state has the door along the YZ plane.
This broadcasts custom events DoorOpened(CoreObject) and DoorClosed(CoreObject)
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local ROTATION_ROOT = script:GetCustomProperty("RotationRoot"):WaitForObject()
local ROTATING_TRIGGER = script:GetCustomProperty("RotatingTrigger"):WaitForObject()
local STATIC_TRIGGER = script:GetCustomProperty("StaticTrigger"):WaitForObject()

-- User exposed properties
local AUTO_OPEN = COMPONENT_ROOT:GetCustomProperty("AutoOpen")
local TIME_OPEN = COMPONENT_ROOT:GetCustomProperty("TimeOpen")		-- Only used with AutoOpen
local OPEN_LABEL = COMPONENT_ROOT:GetCustomProperty("OpenLabel")	-- Only used without AutoOpen
local CLOSE_LABEL = COMPONENT_ROOT:GetCustomProperty("CloseLabel")	-- Only used without AutoOpen
local SPEED = COMPONENT_ROOT:GetCustomProperty("Speed")
local RESET_ON_ROUND_START = COMPONENT_ROOT:GetCustomProperty("ResetOnRoundStart")

-- Check user properties
if TIME_OPEN < 0.0 then
    warn("TimeOpen cannot be negative")
    TIME_OPEN = 0.0
end

if SPEED <= 0.0 then
    warn("Speed must be positive")
    SPEED = 450.0
end

-- Constants
-- If the door auto-opens, we only care if someone is standing in the way to prevent closing.
-- If it is manually opened and closed, we care if someone is in range of the door to operate it.
local TRIGGER = nil

if AUTO_OPEN then
	TRIGGER = STATIC_TRIGGER
else
	TRIGGER = ROTATING_TRIGGER
end

local USE_DEBOUNCE_TIME = 0.2			-- Time after using that a player can't use again

-- Variables
-- Rotation is 1.0 for +90 degree rotation, 0.0 for closed, -1.0, for -90 degree rotation
local targetDoorRotation = 0.0
local playerLastUseTimes = {}			-- Player -> float
local autoCloseTime = 0.0

-- float GetDoorRotation()
-- Gives you the current rotation of the door
function GetDoorRotation()
	local result = ROTATION_ROOT:GetRotation().z / 90.0

	if math.abs(result) < 0.01 then
		return 0.0
	end

	return result
end

-- nil SetCurrentRotation(float)
-- Snap instantly to the given rotation
function SetCurrentRotation(rotation)
	targetDoorRotation = rotation
	ROTATION_ROOT:SetRotation(Rotation.New(0.0, 0.0, 90.0 * rotation))
end

-- nil SetTargetRotation(float)
-- Sets the rotation that the door should move to (at SPEED)
function SetTargetRotation(rotation)
	targetDoorRotation = rotation
	ROTATION_ROOT:RotateTo(Rotation.New(0.0, 0.0, 90.0 * rotation), 90.0 * math.abs(targetDoorRotation - GetDoorRotation()) / SPEED, true)
end

-- nil ResetDoor()
-- Instantly snaps the door to the closed state
function ResetDoor()
	SetCurrentRotation(0.0)
end

-- nil OpenDoor(Player)
-- Opens the door away from the given player
function OpenDoor(player)
	local geoQuaternion = Quaternion.New(ROTATION_ROOT:GetWorldRotation())
	local relativeX = geoQuaternion:GetForwardVector()
	local playerOffset = player:GetWorldPosition() - ROTATION_ROOT:GetWorldPosition()

	-- Figure out which direction is away from the player
	if playerOffset .. relativeX > 0.0 then
		SetTargetRotation(1.0)
	else
		SetTargetRotation(-1.0)
	end

	Events.Broadcast("DoorOpened", COMPONENT_ROOT)
end

-- nil CloseDoor()
-- Closes the door, even if it was only partially open
function CloseDoor()
	SetTargetRotation(0.0)
end

-- nil OnBeginOverlap(Trigger, CoreObject)
-- Handles the player overlapping if AutoOpen is true
function OnBeginOverlap(trigger, other)
	if other:IsA("Player") then
		if GetDoorRotation() == 0.0 then							-- Can't auto open if the door isn't closed
			OpenDoor(other)

			autoCloseTime = time() + TIME_OPEN
		end
	end
end

-- nil OnInteracted(Trigger, CoreObject)
-- Handles the player using the door if AutoOpen is false
function OnInteracted(trigger, player)
	if playerLastUseTimes[player] and playerLastUseTimes[player] + USE_DEBOUNCE_TIME > time() then
		return
	end

	playerLastUseTimes[player] = time()

	if GetDoorRotation() == 0.0 then								-- Door is closed
		OpenDoor(player)

		TRIGGER.interactionLabel = CLOSE_LABEL
	else															-- Door is open or moving, clsoe it
		CloseDoor()
	end
end

-- nil OnRoundStart()
-- Handles the roundStartEvent
function OnRoundStart()
	ResetDoor()
end

-- nil Tick(float)
-- Handle closing the door with AutoOpen, and changing interaction label back to open
function Tick(deltaTime)
	if AUTO_OPEN and targetDoorRotation ~= 0.0 then
		for _, player in pairs(Game.GetPlayers()) do				-- Don't close the door if someone is standing in it
			if TRIGGER:IsOverlapping(player) then
				autoCloseTime = time() + TIME_OPEN					-- and delay closing
				return
			end
		end

		if autoCloseTime > time() then
			return
		end

		CloseDoor()
	end

	if targetDoorRotation == 0.0 and GetDoorRotation() == 0.0 then
		if not AUTO_OPEN then
			TRIGGER.interactionLabel = OPEN_LABEL
		end

		Events.Broadcast("DoorClosed", COMPONENT_ROOT)
	end
end

-- Initialize
if AUTO_OPEN then
	TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)
	TRIGGER.isInteractable = false

	for _, player in pairs(Game.GetPlayers()) do
		if TRIGGER:IsOverlapping(player) then
			OnBeginOverlap(TRIGGER, player)
		end
	end
else
	TRIGGER.interactedEvent:Connect(OnInteracted)
	TRIGGER.isInteractable = true
end

if RESET_ON_ROUND_START then
	Game.roundStartEvent:Connect(OnRoundStart)
end

h��Ƚҥ���#Fantasy Castle Wall 01 - Doorway 01R4
StaticMeshAssetRefsm_ts_fan_cas_wall_001_door_01
B��ݔ��ך�LightMovementZ$"print(Player.GetCurrentPosition())
�,ќ������ArrowTrapAutomaticb�+
�+ �ۦ��*��ۦ��	ArrowTrap"  �?  �?  �?(�����B2s�球��������㹨��B����ڧ�Ԕ��������쿨����������/����������Ц����̥��8������϶�Υ��©�ħ������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��球�����	ShootDart"$
 �"�N0���H�   �?  �?  �?(�ۦ��Z�

cs:DamageAmounte  �B

cs:WaitTimee  �?

cs:ShootTimee  �>

cs:TriggerHit�����ڧ�Ԕ

cs:Arrow��؁��Ё��

cs:ShootSound���������

cs:ArrowTrigger�����ڧ�Ԕ

cs:ArrowPos�
�����/

cs:ArrowEndPos������

cs:ArrowPos2�
�����Ц�

cs:ArrowEndPos2�
���̥��8

cs:ArrowPos3�������϶�

cs:ArrowEndPos3�Υ��©pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ܨ甽*����㹨��BArrowDamage"$
 �"�N0���H�   �?  �?  �?(�ۦ��ZU

cs:ShootDart��球�����

cs:TriggerHit�����ڧ�Ԕ

cs:DamageAmounte  �Bpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ɓ����*�����ڧ�Ԕ
TriggerHit"

�'���;C �"?4�:@8a@(�ۦ��pz
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���������+Recurve Bow Fire Release Arrow Heavy 01 SFX"

  z�  �B   �?  �?  �?(�ۦ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�#
���������5  �?=  ��E  ��Xx�*�쿨�����Cube - bottom aligned"

\��t�   �?  �?��t@(�ۦ��Z+
)
ma:Shared_BaseMaterial:id��蚩�����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *������/ArrowPos"

  ����ݿ   �?  �?  �?(�ۦ��2	٧�����Apz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�٧�����A	ArrowHole"$
 @3>  HBP�r�   �?  �?  �?(�����/2��웛��������ȫpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���웛���Cube - bottom aligned"

 03� me� ɠ>�m�>L�>(٧�����AZ+
)
ma:Shared_BaseMaterial:id������˃��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *������ȫPipe - 4-Sided Thick")
 03> me@��JA���B���>���>��<>(٧�����AZ*
(
ma:Shared_BaseMaterial:id�
��л܁��&pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�Ԥ�ۖ���088�
 *������ArrowEndPos"

  HD��ݿ   �?  �?  �?(�ۦ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Ц�	ArrowPos2"

  ���=�B   �?  �?  �?(�ۦ��2	�����߾�bZ|

cs:ArrowPos2�
�����Ц�

cs:ArrowEndPos2�
���̥��8

cs:ArrowPos3�������϶�

cs:ArrowEndPos3�Υ��©pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������߾�b	ArrowHole"$
 @3>  HB@�r�   �?  �?  �?(�����Ц�2Ї�ɘ�������ӡ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ї�ɘ����Cube - bottom aligned"

 03� me� ɠ>�m�>L�>(�����߾�bZ+
)
ma:Shared_BaseMaterial:id������˃��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *����ӡ��Pipe - 4-Sided Thick")
 03> me@��JA���B���>���>��<>(�����߾�bZ*
(
ma:Shared_BaseMaterial:id�
��л܁��&pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�Ԥ�ۖ���088�
 *����̥��8ArrowEndPos2"

  HD�=�B   �?  �?  �?(�ۦ��Z|

cs:ArrowPos2�
�����Ц�

cs:ArrowEndPos2�
���̥��8

cs:ArrowPos3�������϶�

cs:ArrowEndPos3�Υ��©pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������϶�	ArrowPos3"

  ���V�C   �?  �?  �?(�ۦ��2	���Ώ���qZ|

cs:ArrowPos2�
�����Ц�

cs:ArrowEndPos2�
���̥��8

cs:ArrowPos3�������϶�

cs:ArrowEndPos3�Υ��©pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����Ώ���q	ArrowHole"$
 @3>  HB@�r�   �?  �?  �?(������϶�2���ƴ�����Ǯ�����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ƴ����Cube - bottom aligned"

 03� me� ɠ>�m�>L�>(���Ώ���qZ+
)
ma:Shared_BaseMaterial:id������˃��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *��Ǯ�����Pipe - 4-Sided Thick")
 03> me@��JA���B���>���>��<>(���Ώ���qZ*
(
ma:Shared_BaseMaterial:id�
��л܁��&pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�Ԥ�ۖ���088�
 *�Υ��©ArrowEndPos3"

  HD�kC   �?  �?  �?(�ۦ��Z|

cs:ArrowPos2�
�����Ц�

cs:ArrowEndPos2�
���̥��8

cs:ArrowPos3�������϶�

cs:ArrowEndPos3�Υ��©pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ħ������Cube - bottom aligned"

\���J� �O?Il�?�Gf@(�ۦ��Z+
)
ma:Shared_BaseMaterial:id��蚩�����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 
NoneNone�;*9I modified the arrow trap by LanaLux to shoot automaticly�
R��л܁��&Bricks Stone Block 01R-
MaterialAssetRefmi_bricks_stone_block_001
T�Ԥ�ۖ���Pipe - 4-Sided ThickR/
StaticMeshAssetRefsm_pipe_4_sided_thick_001
T�����˃��Rubber Dot Panels 01R/
MaterialAssetRefmi_scf_rubber_panels_001_uv
C�蚩�����Bone RawR*
MaterialAssetRefmi_bone_raw_001_uv_ref
G���ġ����Cube - bottom alignedR!
StaticMeshAssetRefsm_cube_001
����������+Recurve Bow Fire Release Arrow Heavy 01 SFXRE
AudioAssetRef4sfx_recurve_bow_fire_release_arrow_heavy_01a_Cue_ref
Ɓ����ArrowDamageZ

����ܨ甽	ShootDartZ��local triggerHit = script:GetCustomProperty("TriggerHit"):WaitForObject()
local arrow = script:GetCustomProperty("Arrow")
local shootSound = script:GetCustomProperty("ShootSound"):WaitForObject()

local arrowEndPosObj = script:GetCustomProperty("ArrowEndPos"):WaitForObject()
local arrowPosObj = script:GetCustomProperty("ArrowPos"):WaitForObject()
local arrowEndPosObj2 = script:GetCustomProperty("ArrowEndPos2"):WaitForObject()
local arrowPosObj2 = script:GetCustomProperty("ArrowPos2"):WaitForObject()
local arrowEndPosObj3 = script:GetCustomProperty("ArrowEndPos3"):WaitForObject()
local arrowPosObj3 = script:GetCustomProperty("ArrowPos3"):WaitForObject()

local arrowPos = arrowPosObj:GetWorldPosition()
local arrowEndPos = arrowEndPosObj:GetWorldPosition()

local arrowPos2 = arrowPosObj2:GetWorldPosition()
local arrowEndPos2 = arrowEndPosObj2:GetWorldPosition()

local arrowPos3 = arrowPosObj3:GetWorldPosition()
local arrowEndPos3 = arrowEndPosObj3:GetWorldPosition()

local waitTime = script:GetCustomProperty("WaitTime")
local shootTime = script:GetCustomProperty("ShootTime")

arrowOn = false

local arrowObj = nil
local arrowObj2 = nil
local arrowObj3 = nil
local inProgress=false

local arrowTrigger = script:GetCustomProperty("ArrowTrigger"):WaitForObject()

local DAMAGE_AMT = script:GetCustomProperty("DamageAmount")

local damage = Damage.New(DAMAGE_AMT)



local function Shoot()
	if inProgress~=true then
		inProgress=true
		
		shootSound:Play()
		
		local arrowScale = Vector3.New(0.7,0.7,0.7)
		
		arrowObj = World.SpawnAsset(arrow, {position = arrowPos, scale = arrowScale})
		arrowObj2 = World.SpawnAsset(arrow, {position = arrowPos2, scale = arrowScale})
		arrowObj3 = World.SpawnAsset(arrow, {position = arrowPos3, scale = arrowScale})
		
		triggerHit:MoveTo(arrowEndPos2, shootTime, false)
		arrowOn=true
		
		arrowObj:MoveTo(arrowEndPos, shootTime, true)
		arrowObj2:MoveTo(arrowEndPos2, shootTime, true)
		arrowObj3:MoveTo(arrowEndPos3, shootTime, true)
		
		Task.Wait(shootTime)	
		arrowOn=false
		
		arrowObj:Destroy()
		arrowObj2:Destroy()
		arrowObj3:Destroy()
		
		
		triggerHit:MoveTo(arrowPos2, 0)
		inProgress=false
	end
end


function OnBeginOverlap(arrowTrigger, other)
	if other:IsA("Player") then
			
		if Object.IsValid(other) and other:IsA("Player") and arrowOn then
				
			local objects = arrowTrigger:GetOverlappingObjects()
			for _, obj in pairs(objects) do
				if Object.IsValid(obj) and obj:IsA("Player") then
					obj:ApplyDamage(damage)
				end
			end	
		end
	end
end


local function RepeatShoot()

	Shoot()
	Task.Wait(waitTime)
	RepeatShoot()
	
end


arrowTrigger.beginOverlapEvent:Connect(OnBeginOverlap)

RepeatShoot()



����Ɓ����
FireSwitchZ��local switch = script.parent
local switchTrigger = script:GetCustomProperty("Trigger"):WaitForObject()
local firePosObj = script:GetCustomProperty("FirePosition"):WaitForObject()

local firePosTopObj = script:GetCustomProperty("FirePositionTop"):WaitForObject()
local firePos = firePosObj:GetWorldPosition()

local firePosTop = firePosTopObj:GetWorldPosition()
local fireBlast = script:GetCustomProperty("FireBlast")
local fireBlast2 = script:GetCustomProperty("FireBlast2")

local spawnedFire = nil

local spawnedFireTop = nil

local toggleRotation = switch:GetRotation()

local otherDir = script:GetCustomProperty("Dir")

fireOn = false


local function UpdateLabel()
	if fireOn == true then
		switchTrigger.interactionLabel = "Fire on top"
	else 
		switchTrigger.interactionLabel = "Fire on bottom"
	end
end

function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
end

local function OnSwitchInteraction()
	if fireOn == true then			
		switch:RotateTo(Rotation.New(30,0,0),0.5,true)	
		
		if otherDir then
			spawnedFireTop = World.SpawnAsset(fireBlast2, {position = firePosTop})	
		else
			spawnedFireTop = World.SpawnAsset(fireBlast, {position = firePosTop})	
		end
		if spawnedFire ~=  nil then
			spawnedFire:Destroy()
		end
	else 				
		switch:RotateTo(Rotation.New(150,0,0),0.5,true)		
		if otherDir then
			spawnedFire = World.SpawnAsset(fireBlast2, {position = firePos})	
		else
			spawnedFire = World.SpawnAsset(fireBlast, {position = firePos})	
		end		
		if spawnedFireTop ~= nil then
			spawnedFireTop:Destroy()
		end
	end
	fireOn = not fireOn
	UpdateLabel()
end


switchTrigger.interactedEvent:Connect(OnSwitchInteraction)

OnSwitchInteraction()

�����������NPCAIServerZ����--[[
	NPCAI - Server
	by: standardcombo
	v0.9.1
	
	Logical state machine for an enemy NPC. Works in conjunction with NPCAttackServer.
	
	Will walk over terrain and any objects to get to its objective. To mark objects as not walkable,
	add to each one a custom property called "Walkable" of type boolean and set to false.
--]]

-- Component dependencies
local MODULE = require( script:GetCustomProperty("ModuleManager") )
require ( script:GetCustomProperty("NPCManager") )
function NPC_MANAGER() return MODULE.Get("standardcombo.NPCKit.NPCManager") end
function NAV_MESH() return _G.NavMesh end


local ROOT = script:GetCustomProperty("Root"):WaitForObject()
local ROTATION_ROOT = script:GetCustomProperty("RotationRoot"):WaitForObject()
local COLLIDER = script:GetCustomProperty("Collider"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):GetObject()
local ATTACK_COMPONENT = script:GetCustomProperty("AttackComponent"):WaitForObject()

local MOVE_SPEED = ROOT:GetCustomProperty("MoveSpeed") or 400
local TURN_SPEED = ROOT:GetCustomProperty("TurnSpeed") or 2
local LOGICAL_PERIOD = ROOT:GetCustomProperty("LogicalPeriod") or 0.5
local RETURN_TO_SPAWN = ROOT:GetCustomProperty("ReturnToSpawn")
local VISION_HALF_ANGLE = ROOT:GetCustomProperty("VisionHalfAngle") or 0
local VISION_RADIUS = ROOT:GetCustomProperty("VisionRadius") or 2500
local HEARING_RADIUS = ROOT:GetCustomProperty("HearingRadius") or 1000
local SEARCH_BONUS_VISION = ROOT:GetCustomProperty("SearchBonusVision") or 5000
local SEARCH_DURATION = ROOT:GetCustomProperty("SearchDuration") or 6
local POSSIBILITY_RADIUS = ROOT:GetCustomProperty("PossibilityRadius") or 600
local CHASE_RADIUS = ROOT:GetCustomProperty("ChaseRadius") or 3500
local ATTACK_RANGE = ROOT:GetCustomProperty("AttackRange") or 1500
local ATTACK_CAST_TIME = ROOT:GetCustomProperty("AttackCast") or 0.5
local ATTACK_RECOVERY_TIME = ROOT:GetCustomProperty("AttackRecovery") or 1.5
local ATTACK_COOLDOWN = ROOT:GetCustomProperty("AttackCooldown") or 0
local OBJECTIVE_THRESHOLD_DISTANCE_SQUARED = 900

MAX_HEALTH = ROOT:GetCustomProperty("CurrentHealth")

local PATHING_STEP = MOVE_SPEED * LOGICAL_PERIOD + 10
local PATHING_STEP_SQUARED = PATHING_STEP * PATHING_STEP

local RAY_DISTANCE_FROM_GROUND = COLLIDER:GetPosition().z + 400
local RAY_DISTANCE_DOWN_VECTOR = Vector3.New(0, 0, -900)

local VISION_RADIUS_SQUARED = VISION_RADIUS * VISION_RADIUS
local HEARING_RADIUS_SQUARED = HEARING_RADIUS * HEARING_RADIUS
local SEARCH_RADIUS_SQUARED = (VISION_RADIUS + SEARCH_BONUS_VISION) * (VISION_RADIUS + SEARCH_BONUS_VISION)
local CHASE_RADIUS_SQUARED = CHASE_RADIUS * CHASE_RADIUS
local ATTACK_RANGE_SQUARED = ATTACK_RANGE * ATTACK_RANGE

local SPAWN_POSITION = ROOT:GetWorldPosition()

local DEAD_1_DURATION = 4
local DEAD_2_DURATION = 6

local STATE_SLEEPING = 0
local STATE_ENGAGING = 1
local STATE_ATTACK_CAST = 2
local STATE_ATTACK_RECOVERY = 3
local STATE_PATROLLING = 4
local STATE_LOOKING_AROUND = 5
local STATE_DEAD_1 = 6
local STATE_DEAD_2 = 7
local STATE_DISABLED = 8

local currentState = STATE_SLEEPING
local stateTime = 0

local logicStepDelay = 0
local target = nil
local moveObjective = nil
local nextMoveObjective = nil
local stepDestination = SPAWN_POSITION
local navMeshPath = nil
local searchStartPosition = nil
local searchEndPosition = nil
local searchTimeElapsed = -1
local searchPrecision = 1
local attackCooldown = 0

local temporaryVisionAngle = nil
local temporaryVisionRadius = nil
local temporaryHearingRadius = nil
	

function SetState(newState)
	--print("NewState = " .. newState)

	if (newState == STATE_SLEEPING) then
		ROTATION_ROOT:StopRotate()
		
	elseif (newState == STATE_ENGAGING) then
		--print("target = " .. tostring(target) .. ", moveSpeed = " .. tostring(MOVE_SPEED) .. ", attackRange = " .. ATTACK_RANGE)

		if (not IsWithinRangeSquared(target, ATTACK_RANGE_SQUARED)) then
			local targetPosition = target:GetWorldPosition()
			StepTowards(targetPosition)
		end
		
		if navMeshPath and #navMeshPath > 1 then
			local pos = ROOT:GetWorldPosition()
			local direction = navMeshPath[2] - pos
			local r = Rotation.New(direction, Vector3.UP)
			ROTATION_ROOT:RotateTo(r, GetRotateToTurnSpeed(), false)
		else
			ROTATION_ROOT:LookAtContinuous(target, true, TURN_SPEED)
		end

	elseif (newState == STATE_PATROLLING) then
		local targetPosition = moveObjective
		StepTowards(targetPosition)

		local pos = ROOT:GetWorldPosition()
		local direction = targetPosition - pos
		if navMeshPath and stepDestination then
			direction = stepDestination - pos
		end
		local r = Rotation.New(direction, Vector3.UP)
		ROTATION_ROOT:RotateTo(r, GetRotateToTurnSpeed(), false)

	elseif (newState == STATE_LOOKING_AROUND) then
		--
		
	elseif (newState == STATE_DEAD_1) then
		ROOT:StopMove()
		ROTATION_ROOT:StopRotate()
		SetCollision(false)

	elseif (newState == STATE_DEAD_2) then
		ROOT:MoveTo(ROOT:GetWorldPosition() + Vector3.New(0, 0, -500), DEAD_2_DURATION)

	elseif (newState == STATE_DISABLED) then
		ROOT:Destroy()
	end

	currentState = newState
	stateTime = 0
	
	if Object.IsValid(ROOT) then
		ROOT:SetNetworkedCustomProperty("CurrentState", newState)
	end
end


function Tick(deltaTime)
	stateTime = stateTime + deltaTime
	logicStepDelay = logicStepDelay - deltaTime
	attackCooldown = attackCooldown - deltaTime
	
	if (searchTimeElapsed >= 0) then
		searchTimeElapsed = searchTimeElapsed + deltaTime
	end
	
	if (currentState == STATE_ATTACK_CAST or currentState == STATE_ATTACK_RECOVERY) and
		not IsObjectAlive(target) then
		target = nil
		EngageNearest()
		if (not target) then
			ResumePatrol()
		end
		
	elseif currentState == STATE_ATTACK_CAST and stateTime >= ATTACK_CAST_TIME then
		ExecuteAttack()
		attackCooldown = ATTACK_COOLDOWN
		SetState(STATE_ATTACK_RECOVERY)
	
	elseif currentState == STATE_ATTACK_RECOVERY and stateTime >= ATTACK_RECOVERY_TIME then
		SetState(STATE_ENGAGING)
	end
	
	if currentState == STATE_ENGAGING then
		if (not IsObjectAlive(target)) then
			target = nil
			
		elseif IsWithinRangeSquared(target, ATTACK_RANGE_SQUARED) then
			if attackCooldown <= 0 then
				SetState(STATE_ATTACK_CAST)
			end
		else
			UpdateMovement(deltaTime)
		end
		
	elseif currentState == STATE_PATROLLING then
		UpdateMovement(deltaTime)

	elseif (currentState == STATE_DEAD_1 and stateTime >= DEAD_1_DURATION) then
		SetState(STATE_DEAD_2)

	elseif (currentState == STATE_DEAD_2 and stateTime >= DEAD_2_DURATION) then
		SetState(STATE_DISABLED)
	end

	if logicStepDelay <= 0 then
		logicStepDelay = LOGICAL_PERIOD

		if currentState == STATE_SLEEPING then
			EngageNearest()

		elseif currentState == STATE_ENGAGING then
			local chaseRadiusSquared = CHASE_RADIUS_SQUARED
			if (searchTimeElapsed >= 0 and searchTimeElapsed < SEARCH_DURATION * 4) then
				chaseRadiusSquared = SEARCH_RADIUS_SQUARED
			else
				searchTimeElapsed = -1
			end
			
			--print("chaseRadiusSquared = " .. chaseRadiusSquared .. ", searchTimeElapsed = " .. searchTimeElapsed)
			
			if IsWithinRangeSquared(target, chaseRadiusSquared) then
				SetState(STATE_ENGAGING)
			else
				EngageNearest()

				if (not target) then
					--print("ResumePatrol 1")
					ResumePatrol()
				end
			end
			
		elseif currentState == STATE_PATROLLING then
			local pos = ROOT:GetWorldPosition()
			local delta = pos - moveObjective
			delta.z = 0
			if (delta.sizeSquared < OBJECTIVE_THRESHOLD_DISTANCE_SQUARED) then
				--print("OBJECTIVE REACHED")
				if nextMoveObjective then
					moveObjective = nextMoveObjective
					nextMoveObjective = nil
					SetState(STATE_PATROLLING)
					
				elseif RETURN_TO_SPAWN and moveObjective ~= SPAWN_POSITION then
					moveObjective = SPAWN_POSITION
					SetState(STATE_PATROLLING)
				else
					SetState(STATE_SLEEPING)
				end
			else
				EngageNearest()

				if (not target) then
					SetState(STATE_PATROLLING)
				end
			end
			
		elseif currentState == STATE_LOOKING_AROUND then
			if (searchTimeElapsed >= SEARCH_DURATION) then
				--print("ResumePatrol 2")
				ResumePatrol()
			else
				EngageNearest()
				if (not target) then
					DoLookAround()
				end
			end
		end
	end
	
	UpdateTemporaryProperties(deltaTime)
end

function ResumePatrol()
	--print("ResumePatrol")

	target = nil
	
	if moveObjective then
		SetState(STATE_PATROLLING)
		
	elseif RETURN_TO_SPAWN then
		SetObjective(SPAWN_POSITION)
		
	else
		SetState(STATE_SLEEPING)
	end
end


function SetObjective(pos)
	--print("SetObjective = " .. tostring(pos))
	if (currentState == STATE_PATROLLING) then
		nextMoveObjective = pos
		
	elseif (not target) then
		moveObjective = pos
		SetState(STATE_PATROLLING)
	end
end


function ExecuteAttack()
	if ATTACK_COMPONENT then
		ATTACK_COMPONENT.context.Attack(target)
	end
end


function StepTowards(targetPosition)
	local pos = ROOT:GetWorldPosition()
	
	if NAV_MESH() then
		navMeshPath = NAV_MESH().FindPath(pos, targetPosition)
		if navMeshPath and #navMeshPath > 1 then
			table.remove(navMeshPath, 1)
			stepDestination = navMeshPath[1]
			return
		end
	end
	navMeshPath = nil
	-- No NavMesh available, fallback
	
	-- Calculate step destination
	local direction = targetPosition - pos

	if (direction.sizeSquared > PATHING_STEP_SQUARED) then
		direction = direction:GetNormalized() * PATHING_STEP
	end

	local rayStart = pos + direction
	rayStart.z = rayStart.z + RAY_DISTANCE_FROM_GROUND

	--print("pos = " .. tostring(pos) .. ", targetPosition = " .. tostring(targetPosition) .. ", rayStart = " .. tostring(rayStart))

	local hitResult = nil
	repeat
		local rayEnd = rayStart + RAY_DISTANCE_DOWN_VECTOR
		hitResult = World.Raycast(rayStart, rayEnd, {ignorePlayers = true})
		
		local isWalkable
		if hitResult then
			isWalkable = IsObjectWalkable(hitResult.other)
	
			if (not isWalkable) then
				rayStart = hitResult:GetImpactPosition() + Vector3.New(0,0,-0.5)
			end
		end
	until hitResult == nil or hitResult.other == nil or isWalkable

	if hitResult then
		--print("HitResult.other = " .. tostring(hitResult.other))

		local groundPos = hitResult:GetImpactPosition()
		stepDestination = groundPos
	else
		stepDestination = targetPosition
	end
end


local overlappingObjects = {}

function UpdateMovement(deltaTime)
	local pos = ROOT:GetWorldPosition()
	
	-- Test overlap against other objects and adjust
	if TRIGGER then
		local overlaps = overlappingObjects
		for i,other in ipairs(overlaps) do
			local triggerPos = TRIGGER:GetWorldPosition()
			local otherPos = other:GetWorldPosition()
			local v = triggerPos - otherPos
			v.z = 0
			local distance = v.size
			local radii = 50 * (other:GetWorldScale().y + TRIGGER:GetWorldScale().y)
			local removeAmount = radii - distance
			if (removeAmount > 0) then
				v = v / distance * removeAmount * 0.5
				pos = pos + v
				ROOT:SetWorldPosition(pos)
			end
		end
	end
	
	-- Move forward
	if navMeshPath then
		local moveAmount = MOVE_SPEED * deltaTime
		while moveAmount > 0 do
			stepDestination = navMeshPath[1]
			local moveV = stepDestination - pos
			local distance = moveV.size
			
			if (distance <= moveAmount) then
				pos = stepDestination

				table.remove(navMeshPath, 1)
				if #navMeshPath > 0 then
					moveAmount = moveAmount - distance
				else
					navMeshPath = nil
					moveAmount = 0
				end
			else
				pos = pos + moveV / distance * moveAmount
				moveAmount = 0
			end
		end
	else
		local moveV = stepDestination - pos
		local distance = moveV.size
		local moveAmount = MOVE_SPEED * deltaTime
		
		if (distance <= moveAmount) then
			pos = stepDestination
		else
			pos = pos + moveV / distance * moveAmount
		end
	end
	ROOT:SetWorldPosition(pos)
end


function EngageNearest()
	target = nil
	
	local enemy = FindNearestEnemy()
	if enemy then
		target = enemy

		SetState(STATE_ENGAGING)
	end
end

function FindNearestEnemy()
	local myPos = ROOT:GetWorldPosition()
	local forwardVector = ROTATION_ROOT:GetWorldRotation() * Vector3.FORWARD
	local myTeam = GetTeam()
	
	local nearestEnemy = nil
	local nearestDistSquared = 9999999999
	
	-- Players
	for _,enemy in ipairs(Game.GetPlayers()) do
		if (enemy.team ~= myTeam and not enemy.isDead) then
			local canSee,distSquared = CanSeeEnemy(enemy, myPos, forwardVector, nearestDistSquared)
			if canSee then
				nearestDistSquared = distSquared
				nearestEnemy = enemy
				--print("Distance to enemy = " .. tostring(math.sqrt(nearestDistSquared)))
			end
		end
	end
	
	-- Other NPCs
	local enemyNPCs = NPC_MANAGER().GetEnemies(myTeam)
	for _,enemy in ipairs(enemyNPCs) do
		if enemy.context.IsAlive() then
			local canSee,distSquared = CanSeeEnemy(enemy, myPos, forwardVector, nearestDistSquared)
			if canSee then
				nearestDistSquared = distSquared
				nearestEnemy = enemy
				--print("Distance to enemy = " .. tostring(math.sqrt(nearestDistSquared)))
			end
		end
	end
	return nearestEnemy
end

function CanHear(noisePos)
	local myPos = ROOT:GetWorldPosition()
	local delta = noisePos - myPos
	local distSquared = delta.sizeSquared
	if (distSquared < GetHearingRadiusSquared()) then
		return true
	end
	return false
end

function CanSeeEnemy(enemy, myPos, forwardVector, nearestDistSquared)
	local enemyPos = enemy:GetWorldPosition()
	local delta = enemyPos - myPos
	local distSquared = delta.sizeSquared
	
	if (distSquared > nearestDistSquared) then
		return false, distSquared
	end
	
	local canSeeFromDistance = (distSquared <= GetVisionRadiusSquared())
		
	-- Is searching
	if (not canSeeFromDistance and
		currentState == STATE_LOOKING_AROUND and
		distSquared < SEARCH_RADIUS_SQUARED and
		SEARCH_RADIUS_SQUARED > GetVisionRadiusSquared()) then
		
		local p = (distSquared - GetVisionRadiusSquared()) / (SEARCH_RADIUS_SQUARED - GetVisionRadiusSquared())
		p = CoreMath.Lerp(0.5 / searchPrecision, 1, p)
		local rng = math.random()
		if (rng >= p) then
			canSeeFromDistance = true
		end
		--print("rng = " .. rng .. ", p = " .. p)
	end
	
	-- Angle vision in front
	if (canSeeFromDistance and
		GetVisionHalfAngle() > 0 and GetVisionHalfAngle() < 360) then

		local distance = math.sqrt(distSquared)
		local directionToEnemy = delta / distance
		local angle = Angle(directionToEnemy, forwardVector)
		if (angle > GetVisionHalfAngle()) then
			canSeeFromDistance = false
		end
	end
	
	-- Test if there is something obstructing the view. If searching for the enemy ignore this constraint
	local ENEMY_RADIUS = 150 -- TODO
	if (canSeeFromDistance and 
		(currentState ~= STATE_LOOKING_AROUND or (searchEndPosition - enemyPos).size > 400) and
		distSquared > ENEMY_RADIUS * ENEMY_RADIUS) then
		
		local rayStart = script:GetWorldPosition()
		local rayEnd = enemyPos - delta:GetNormalized() * ENEMY_RADIUS
		local myTeam = GetTeam()
				
		local hitResult = World.Raycast(rayStart, rayEnd, {ignorePlayers = true, ignoreTeams = myTeam})
		if hitResult then
			canSeeFromDistance = false
			
			--CoreDebug.DrawLine(rayStart, rayEnd, {duration = 1, color = Color.RED})
		else
			--CoreDebug.DrawLine(rayStart, rayEnd, {duration = 1, color = Color.WHITE})
		end
	end
	
	--print("dist = " .. tostring(math.sqrt(distSquared)) .. ", " .. tostring(distSquared) .. ", " .. tostring(GetVisionRadiusSquared()))
	return canSeeFromDistance, distSquared
end

function Angle(normV1, normV2)
	local value = normV1 .. normV2
	value = CoreMath.Clamp(value, -1, 1)
	return math.acos(value) * 57.29578
end


function IsWithinRangeSquared(enemy, rangeSquared)
	if Object.IsValid(enemy) then
		local pos = ROOT:GetWorldPosition()
		local enemyPos = enemy:GetWorldPosition()
		local delta = pos - enemyPos
		return (delta.sizeSquared < rangeSquared)
	end
	return false
end

function GetVisionHalfAngle()
	if temporaryVisionAngle ~= nil then
		return temporaryVisionAngle.value
	end
	return VISION_HALF_ANGLE
end

function GetVisionRadiusSquared()
	if temporaryVisionRadius ~= nil then
		return temporaryVisionRadius.value
	end
	return VISION_RADIUS_SQUARED
end

function GetHearingRadiusSquared()
	if temporaryHearingRadius ~= nil then
		return temporaryHearingRadius.value
	end
	return HEARING_RADIUS_SQUARED
end

function SetTemporaryVisionHalfAngle(angle, duration)
	temporaryVisionAngle = {value = angle, timeRemaining = duration}
end

function SetTemporaryVisionRadius(radius, duration)
	temporaryVisionRadius = {value = radius, timeRemaining = duration}
end

function SetTemporaryHearingRadius(radius, duration)
	temporaryHearingRadius = {value = radius, timeRemaining = duration}
end

function UpdateTemporaryProperties(deltaTime)
	temporaryVisionAngle = UpdateTemporary(temporaryVisionAngle, deltaTime)
	temporaryVisionRadius = UpdateTemporary(temporaryVisionRadius, deltaTime)
	temporaryHearingRadius = UpdateTemporary(temporaryHearingRadius, deltaTime)
end

function UpdateTemporary(property, deltaTime)
	if property ~= nil then
		property.timeRemaining = property.timeRemaining - deltaTime
		if property.timeRemaining <= 0 then
			return nil
		end
	end
	return property
end

function SetCollision(enabled)
	if enabled then
		COLLIDER.collision = Collision.INHERIT
	else
		COLLIDER.collision = Collision.FORCE_OFF
	end
end

function IsObjectAlive(obj)
	if Object.IsValid(obj) then
		if obj:IsA("Player") then
			return (not obj.isDead)
		end
		
		if obj.context and obj.context.IsAlive then
			return obj.context.IsAlive()
		end
	end
	return false
end

function IsAlive()
	return currentState < STATE_DEAD_1
end


function OnObjectDamaged(id, prevHealth, dmgAmount, impactPosition, impactRotation, sourceObject)
	if (currentState == STATE_SLEEPING or currentState == STATE_PATROLLING or currentState == STATE_LOOKING_AROUND) then
		if Object.IsValid(sourceObject) and GetObjectTeam(sourceObject) ~= GetTeam() and 
			IsObjectAlive(sourceObject) and CanHear(impactPosition) then
			Search(impactPosition, sourceObject:GetWorldPosition())
		end
	end
end

function Search(fromPos, toPos)
	--print("Search")
	searchStartPosition = fromPos
	searchEndPosition = toPos
	searchTimeElapsed = 0
	
	if (currentState == STATE_LOOKING_AROUND) then
		searchPrecision = searchPrecision * 2
	else
		searchPrecision = 1
	end
	
	DoLookAround()
	SetState(STATE_LOOKING_AROUND)
end

function DoLookAround()
	local t = 1
	if (SEARCH_DURATION > 0) then
		t = searchTimeElapsed / SEARCH_DURATION
	end
	local searchPos = Vector3.Lerp(searchStartPosition, searchEndPosition, t)
	local area = math.ceil(POSSIBILITY_RADIUS / searchPrecision)
	searchPos.x = searchPos.x + math.random(-area, area)
	searchPos.y = searchPos.y + math.random(-area, area)
	
	local myPos = ROOT:GetWorldPosition()
	local forward = searchPos - myPos
	local rot = Rotation.New(forward, Vector3.UP)
	
	ROTATION_ROOT:RotateTo(rot, GetRotateToTurnSpeed(), false)
end

function GetRotateToTurnSpeed()
	local turnTime = 0.25
	if TURN_SPEED > 0 then
		turnTime = 1 / TURN_SPEED
	end
	return turnTime
end


function IsObjectWalkable(object)
	if object == nil then return false end
	
	local isWalkable, hasProperty = object:GetCustomProperty("Walkable")
	if (hasProperty and not isWalkable) then
		return false
	end
	return true
end


function OnObjectDestroyed(id)
	if IsAlive() then
		local myId = ROOT:GetCustomProperty("ObjectId")
		if (myId == id) then
			SetState(STATE_DEAD_1)
		end
	end
end

local damagedListener = Events.Connect("ObjectDamaged", OnObjectDamaged)
local destroyedListener = Events.Connect("ObjectDestroyed", OnObjectDestroyed)

function Cleanup()
	--print("Cleanup()")
	if damagedListener then
		damagedListener:Disconnect()
		damagedListener = nil
	end
	if destroyedListener then
		destroyedListener:Disconnect()
		destroyedListener = nil
	end
end

function OnDestroyed(obj)
	--print("OnDestroyed()")
	Cleanup()
end
ROOT.destroyEvent:Connect(OnDestroyed)



function OnBeginOverlap(whichTrigger, other)
	if other == COLLIDER then return end
	if other:IsA("StaticMesh") then
		if not IsObjectWalkable(other) then
			table.insert(overlappingObjects, other)
		end
	end
end

function OnEndOverlap(whichTrigger, other)
	for i,obj in ipairs(overlappingObjects) do
		if other == obj then
			table.remove(overlappingObjects, i)
			break
		end
	end
end

if TRIGGER then
	TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)
	TRIGGER.endOverlapEvent:Connect(OnEndOverlap)
end


function GetTeam()
	return ROOT:GetCustomProperty("Team")
end

function GetObjectTeam(object)
	if object.team ~= nil then
		return object.team
	end
	local templateRoot = object:FindTemplateRoot()
	if templateRoot then
		return templateRoot:GetCustomProperty("Team")
	end
	return nil
end


function OnPropertyChanged(object, propertyName)
	if (propertyName == "Team") then
		HandleTeamChanged()
	end
end

function HandleTeamChanged()
	COLLIDER.team = GetTeam()
end
HandleTeamChanged()

ROOT.networkedPropertyChangedEvent:Connect(OnPropertyChanged)


NPC_MANAGER().Register(script)
NPC_MANAGER().RegisterCollider(script, COLLIDER)


�	

cs:ModuleManager�
���憐��1

cs:NPCManager�
��������2

cs:Root� 

cs:RotationRoot� 

cs:Collider� 


cs:Trigger� 

cs:AttackComponent� 
h
cs:NPCManager:tooltipjOReference to the NPC Manager allows the NPC to register itself into the system.
n
cs:Root:tooltipj[A reference to the root of the template, where most of the NPC's custom properties are set.
�
cs:RotationRoot:tooltipj�Group to rotate towards the target enemy or movement direction. Often this is the same as the template root, but not necessarily (e.g. A tower is stationary, but an internal part may be the rotation root)
�
cs:Collider:tooltipj�Reference to the NPC's collider static mesh. This is the object that will be impacted by enemy weapons. It's usually invisible, with collision enabled.
�
cs:Trigger:tooltipj�Reference to the NPC's avoidance trigger. This trigger detects other objects and helps keep the NPC from walking through other NPCs, giving them some basic flock behavior.
�
cs:AttackComponent:tooltipj�Reference to the NPC's attack script. The separation between the NPCAI and NPCAttack scripts allows for a greater variety of NPC's with different types of attack.
���������2
NPCManagerZ��--[[
	NPC Manager
	by: standardcombo
	v0.9.0
	
	Provides bookkeeping on all NPCs contained in a game.
--]]

-- Registers itself into the global table
local API = {}
_G["standardcombo.NPCKit.NPCManager"] = API


local allNPCs = {}
local npcColliders = {}


function API.Register(npc)
	if (not allNPCs[npc]) then
		allNPCs[npc] = true
		
		npc.destroyEvent:Connect(OnDestroyed)
	end
end


function API.RegisterCollider(npc, collider)
	npcColliders[collider] = npc
end


function API.FindScriptForCollider(collider)
	return npcColliders[collider]
end


function API.GetEnemies(team)
	local enemies = {}
	for npc,_ in pairs(allNPCs) do
		local npcTeam = npc.context.GetTeam()
		if (npcTeam ~= team) then
			table.insert(enemies, npc)
		end
	end
	return enemies
end


function API.FindInSphere(position, radius, parameters)
	local result = {}
	local radiusSquared = radius*radius
	
	for npc,_ in pairs(allNPCs) do
		local npcPos = npc:GetWorldPosition()
		local distanceSquared = (position - npcPos).sizeSquared
		if distanceSquared <= radiusSquared then
			table.insert(result, npc)
		end
	end
	return result
end


function OnDestroyed(obj)
	-- Clear collider references
	for collider,npc in pairs(npcColliders) do
		if npc == obj then
			npcColliders[collider] = nil
		end
	end
	-- Clear NPC reference
	if allNPCs[obj] then
		allNPCs[obj] = nil
	end
end



����憐��1ModuleManagerZ��--[[
	Module Manager
	v1.0.3
	by: standardcombo
	
	Promotes de-coupling of systems by providing a thin access to
	namespaces that can be registered in the global table.
	
	For instance, the Loot Drop Factory registers itself into the
	global table at _G.standardcombo.NPCKit.LOOT_DROP_FACTORY.
	Instead of using `require()` or searching the hierarchy to
	find the Loot Drop Factory, use the Module Manager to get it.
	
	Usage example:
	
local MODULE = require( script:GetCustomProperty("ModuleManager") )
function LOOT_DROP_FACTORY() return MODULE.Get("standardcombo.NPCKit.LootDropFactory") end
	
--]]

local API = {}

local modules = {}


function API.Get_Optional(self, path)
	return Get_Internal(self, path, true)
end

function API.Get(self, path, isOptionalModule)
	return Get_Internal(self, path, isOptionalModule)
end

function Get_Internal(self, path, isOptionalModule)
	if self ~= API then
		path = self
	end
	
	if path == nil then
		error("Expected module path, received 'nil' instead.", 3)
		return
	end
	
	if modules[path] then
		return modules[path]
	end
	
	if _G[path] then
		modules[path] = _G[path]
		return modules[path]
	end
	
	local namespaces = {CoreString.Split(path, ".")}
	
	local theModuleTable = _G
	for i,value in ipairs(namespaces) do
		if not theModuleTable[value] then
			if (not isOptionalModule) then
				error("Missing module '" .. path ..
				"'. Check spelling or import it from Community Content.", 3)
			end
			return nil
		end
		theModuleTable = theModuleTable[value]
	end
	modules[path] = theModuleTable
	return modules[path]
end

return API


���������Generic Sound Pickupb�
� ���®�߭�*����®�߭�Generic Sound Pickup"  �?  �?  �?(�����B2
���������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������Weapon Pickup SFX"
    �?  �?  �?(���®�߭�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�#
����ͺ۵�5  �?=  aEE  �Cx�
NoneNone
D����ͺ۵�Weapon Pickup SFXR"
AudioAssetRefsfx_weapon_pickup
3����Վ���Stone Floor - Castle����נ�݉� 
V���נ�݉�Stone Stair StepsR4
MaterialAssetRef mi_trims_stone_stairs_01_default
n��☉����Custom Foundation - No Gradient�=���ˑ����0

gradient falloffe  �?

gradient shifte    
Y���ˑ����Foundation TileR9
MaterialAssetRef%mi_ts_fan_cas_wall_outer_found_uv_ref
L���𱼥��BG Flat 001	R0
PlatformBrushAssetRefBackgroundNoOutline_020
p��������'Fantasy Castle Wall 03 Half - Window 03R8
StaticMeshAssetRef"sm_ts_fan_cas_wall_half_003_win_03
������ϳ��	FireBlastb�
� �������o*��������o	FireBlast"  �?  �?  �?(����Ӿ���2
��䏢�ܭ�Z


cs:Trigger�
����Ǭ�hpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���䏢�ܭ�	FireBlast"
�B�p=BĆ
B (�������o2
�͎������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��͎������FX"
    �?  �?  �?(��䏢�ܭ�2¸´�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�¸´����FX"$
�5�@bz��.;A ���=���=���=(�͎������Z�
(
bp:Volume Type�
mc:evfxvolumetype:2

bp:Emissive Booste���A

bp:Lifee e@
#
bp:Particle Scale Multipliereچ�>


bp:Densitye   A


bp:Gravitye    

bp:Wind Speedr  HDz(
&mc:ecollisionsetting:inheritfromparent�
mc:evisibilitysetting:forceon�

��������Y �*��������%Fire Torch Ignite Whoosh Quick 01 SFX"
  �a�>�a�>�a�>(�͎������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%
��ܑ��쿰5  �?=  ��E  ��Xx�
NoneNone
u��ܑ��쿰%Fire Torch Ignite Whoosh Quick 01 SFXR?
AudioAssetRef.sfx_fire_torch_ignite_whoosh_quick_01a_Cue_ref
K��������YFire Volume VFXR,
VfxBlueprintAssetReffxbp_fire_volume_vfx
��٧��Ҍ��	FireBlastb�
� �������o*��������o	FireBlast"  �?  �?  �?(����Ӿ���2
��䏢�ܭ�Z


cs:Trigger�
����Ǭ�hpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���䏢�ܭ�	FireBlast"
�B�p=BĆ
B (�������o2
�͎������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��͎������FX"
    �?  �?  �?(��䏢�ܭ�2¸´�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�¸´����FX"$
�5�@bz��.;A ���=���=���=(�͎������Z�
(
bp:Volume Type�
mc:evfxvolumetype:2

bp:Emissive Booste���A

bp:Lifee e@
#
bp:Particle Scale Multipliereچ�>


bp:Densitye   A


bp:Gravitye    

bp:Wind Speedr  HDz(
&mc:ecollisionsetting:inheritfromparent�
mc:evisibilitysetting:forceon�

��������Y �*��������%Fire Torch Ignite Whoosh Quick 01 SFX"
  �a�>�a�>�a�>(�͎������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%
��ܑ��쿰5  �?=  ��E  ��Xx�
NoneNone
��Â�����%Fantasy Candle Lit - Holder 02 (Prop)b�
� ���㹬���*����㹬���tm_fan_candle_holder_002_lit_01"  �?  �?  �?(�����B2�����̓�X둪���(z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������̓�XClientContext"$
 �? G�?�AC   �?  �?  �?(���㹬���2����𮣼��������Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�����𮣼Candle Flame VFX"
 0p�   @@  @@  @@(�����̓�Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���������QPoint Light"

 0p>X��@   �?  �?  �?(�����̓�Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�M  �?  �?:?���>%  �?%  �@* 2)  �D  �BM�A  �B%   AU @�E]  zD*�둪���(Floor Candle Holder 02"
    �?  �?  �?(���㹬���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����σ���088�
 3
TemplateAssetReftm_fan_candle_holder_002_lit_01
d����σ���Floor Candle Holder 02R=
StaticMeshAssetRef'sm_prop_fantasy_candle_holder_floor_002
F��������Candle Flame VFXR&
StaticMeshAssetReffxsm_candleflame
�޳���̞��Custom Frosted Glass�~���������q

color�6��=��R>%  �?

Claritye  �?

	Thicknesse    

	Roughnesse��>

Metallice  �?

Speculare^^I?
D���������Frosted GlassR&
MaterialAssetReffxma_frosted_glass
�������ȥ�Minion Impact Effectb�
� ��ގ�ӷ��*���ގ�ӷ��ClientContext"  �?  �?  �?(�����B2Ǌ����ړ]������ē)z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�Ǌ����ړ]Gibs Explosion VFX"
    �?  �?  �?(��ގ�ӷ��Z

bp:Enable BlobsP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ь�+ �*�������ē)Impact Player Body Hit 01 SFX"
    �?  �?  �?(��ގ�ӷ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�$

��������d5��@=  aEEB&�CXx�
NoneNone
b��������dImpact Player Body Hit 01 SFXR5
AudioAssetRef$sfx_impact_player_bodyhit_01_Cue_ref
O�����Ь�+Gibs Explosion VFXR-
VfxBlueprintAssetReffxbp_bloody_explosion
�삢�����
Scoreboardb�
� ������ͬ4*�������ͬ4
Scoreboard"  �?  �?  �?(�٬�����q2	��������
Z�


cs:Bindingjability_extra_0

cs:ShowAtRoundEndP

cs:RoundEndDuratione  �@
W
cs:RoundEndDuration:tooltipj8How long to show at the end of round if "ShowAtRoundEnd"
u
cs:ShowAtRoundEnd:tooltipjXWhether to show this for a limited time at the end of round (without pressing a binding)
L
cs:Binding:tooltipj6Which binding players press to bring up the scoreboardz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������
ClientContext"
    �?  �?  �?(������ͬ42�ޤ�ږ���ܒꜭ���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��ޤ�ږ���ScoreboardControllerClient"
    �?  �?  �?(��������
Zw

cs:ComponentRoot�
������ͬ4

	cs:Canvas�ܒꜭ���

cs:Panel���η�ͷ��

cs:LineTemplate�݅����ޫ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ç�������*�ܒꜭ���Canvas"
    �?  �?  �?(��������
2
��η�ͷ��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*���η�ͷ��Panel"
    �?  �?  �?(ܒꜭ���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�i�	�:

mc:euianchor:middlecenter� �>


mc:euianchor:middlecenter

mc:euianchor:middlecenter
TemplateAssetRef
Scoreboard
�݅����ޫ�Helper_ScoreboardLineb�
� �׈���*��׈���Helper_ScoreboardLine"  �?  �?  �?(���������2ݛ����ߑ���������'��������Zl

cs:Icon�
��������'

cs:Name�
�����Ř�O

cs:KillsText�
��������M

cs:DeathsText���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�b�:

mc:euianchor:middlecenter� �8


mc:euianchor:topcenter

mc:euianchor:topcenter*�ݛ����ߑ�
Background"
    �?  �?  �?(�׈���Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent����:

mc:euianchor:middlecenterPX�

ؿ���ώH%   ?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*���������'Icon"
    �?  �?  �?(�׈���2	�����Ř�OZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�~�%  HB:

mc:euianchor:middlecenterX�

ؿ���ώH%   ?�:


mc:euianchor:middleleft

mc:euianchor:middleleft*������Ř�OName"
    �?  �?  �?(��������'Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���%  pA:

mc:euianchor:middlecenter�4  �?  �?  �?%  �?"
mc:etextjustify:left(0�;


mc:euianchor:middleleft

mc:euianchor:middleright*���������Deaths"
    �?  �?  �?(�׈���2	��������MZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���%  H�:

mc:euianchor:middlecenter�5  �?  �?  �?%  �?"
mc:etextjustify:right(0�<


mc:euianchor:middleright

mc:euianchor:middleright*���������MKills"
    �?  �?  �?(��������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���:

mc:euianchor:middlecenter�5  �?  �?  �?%  �?"
mc:etextjustify:right(0�;


mc:euianchor:middleright

mc:euianchor:middleleft
NoneNone
Nؿ���ώHBackground Flat 020	R+
PlatformBrushAssetRefBackgroundFlat_020
�-Ç�������ScoreboardControllerClientZ�-�---[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local CANVAS = script:GetCustomProperty("Canvas"):WaitForObject()
local PANEL = script:GetCustomProperty("Panel"):WaitForObject()
local LINE_TEMPLATE = script:GetCustomProperty("LineTemplate")

-- User exposed properties
local BINDING = COMPONENT_ROOT:GetCustomProperty("Binding")
local SHOW_AT_ROUND_END = COMPONENT_ROOT:GetCustomProperty("ShowAtRoundEnd")
local ROUND_END_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundEndDuration")

-- Check user properties
if SHOW_AT_ROUND_END and ROUND_END_DURATION <= 0.0 then
    warn("RoundEndDuration must be positive")
    ROUND_END_DURATION = 5.0
end

-- Constants
local LOCAL_PLAYER = Game.GetLocalPlayer()
local FRIENDLY_COLOR = Color.New(0.0, 0.25, 1.0)
local ENEMY_COLOR = Color.New(1.0, 0.0, 0.0)

-- Variables
local headerLine = nil
local playerLines = {}
local atRoundEnd = false
local roundEndTime = 0.0
local bindingDown = false

-- nil OnBindingPressed(Player, string)
-- Keep track of the binding state to show the scoreboard 
function OnBindingPressed(player, binding)
    if binding == BINDING then
        bindingDown = true
    end
end

-- nil OnBindingReleased(Player, string)
-- Keep track of the binding state to show the scoreboard 
function OnBindingReleased(player, binding)
    if binding == BINDING then
        bindingDown = false
    end
end

-- nil OnPlayerJoined(Player)
-- Add a line to the scoreboard when a player joins
function OnPlayerJoined(player)
    local newLine = World.SpawnAsset(LINE_TEMPLATE, {parent = PANEL})
    newLine.y = newLine.height * (#playerLines + 1)
    table.insert(playerLines, newLine)
end

-- nil OnPlayerLeft(Player)
-- Remove a line when a player leaves
function OnPlayerLeft(player)
    playerLines[#playerLines]:Destroy()
    playerLines[#playerLines] = nil
end

-- nil OnRoundEnd()
-- Handles showing the scoreboard if ShowAtRoundEnd is selected
function OnRoundEnd()
    roundEndTime = time()
    atRoundEnd = true
end

-- bool ComparePlayers(Player, Player)
-- Comparing function that sets the sorting order
function ComparePlayers(player1, player2)
    -- First sort by team
    if player1.team ~= player2.team then
        return player1.team < player2.team
    end

    -- Second we use kills
    if player1.kills ~= player2.kills then
        return player1.kills > player2.kills
    end

    -- Third we use deaths
    if player1.deaths ~= player2.deaths then
        return player1.deaths < player2.deaths
    end

    -- Use name to ensure consistent order for players that are tied
    return player1.name < player2.name
end

-- nil Tick(float)
-- Update visibility and displayed information
function Tick(deltaTime)
    if atRoundEnd and time() - roundEndTime > ROUND_END_DURATION then
        atRoundEnd = false
    end

    if bindingDown or atRoundEnd then
        CANVAS.visibility = Visibility.INHERIT

        local players = Game.GetPlayers() 
        table.sort(players, ComparePlayers)

        for i, player in ipairs(players) do
            local teamColor = FRIENDLY_COLOR

            if player ~= LOCAL_PLAYER and Teams.AreTeamsEnemies(player.team, LOCAL_PLAYER.team) then
                teamColor = ENEMY_COLOR
            end

            local line = playerLines[i]
            line:GetCustomProperty("Icon"):WaitForObject():SetImage(player)
            line:GetCustomProperty("Name"):WaitForObject().text = player.name
            line:GetCustomProperty("Name"):WaitForObject():SetColor(teamColor)
            line:GetCustomProperty("KillsText"):WaitForObject().text = tostring(player:GetResource("hearts"))
            line:GetCustomProperty("DeathsText"):WaitForObject().text = tostring(player.deaths)
        end
    else
        CANVAS.visibility = Visibility.FORCE_OFF
    end
end

-- Initialize
CANVAS.visibility = Visibility.FORCE_OFF

headerLine = World.SpawnAsset(LINE_TEMPLATE, {parent = PANEL})
headerLine:GetCustomProperty("Icon"):WaitForObject().visibility = Visibility.FORCE_OFF
headerLine:GetCustomProperty("Name"):WaitForObject().text = "Name"
headerLine:GetCustomProperty("KillsText"):WaitForObject().text = "Hearts"
headerLine:GetCustomProperty("DeathsText"):WaitForObject().text = "Deaths"

Game.playerLeftEvent:Connect(OnPlayerLeft)
Game.playerJoinedEvent:Connect(OnPlayerJoined)
LOCAL_PLAYER.bindingPressedEvent:Connect(OnBindingPressed)
LOCAL_PLAYER.bindingReleasedEvent:Connect(OnBindingReleased)

if SHOW_AT_ROUND_END then
    Game.roundEndEvent:Connect(OnRoundEnd)
end

���Ӵ�����Generic Sound Out Of Ammob�
� ��������*���������Generic Sound Out Of Ammo"  �?  �?  �?(�����B2
��������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���������$Dry Fire Click Generic Clicky 01 SFX"
    �?  �?  �?(��������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"

������.5  �?=  �DE  �Cx�
NoneNone
b������.$Dry Fire Click Generic Clicky 01 SFXR.
AudioAssetRefsfx_clicky_dryfire_01_Cue_ref
����������Massage Triggersbc
S �ʿ�騑�f*G�ʿ�騑�fTemplateBundleDummy"
    �?  �?  �?�Z

���Ս���
NoneNone��
 ea33c91352744f48917d55f16480288f c7306b5515514d95bd7ff6fb2be11343Iscender"1.0.0*\Some triggers that let you show messages by Interaction or by walking through a trigger zone
�k���Ս���MessageTriggersb�j
�j ���ի��*����ի��MessageTriggers"  �?  �?  �?(�����B2$���ڴ�����ϊ��Ӈ'�ߘՄ���Eˠ����~z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ڴ���MessageTrigger"

��A  ��   �?  �?  �?(���ի��2	�����ߟ�pZ�
�

cs:messagej�Die Luft ist schwer und dein Atem stockt. War das ein Kratzen in der Wand? Du bist nicht mehr sicher, ob du noch Recht bei Sinnen bist.

cs:duratione  �@

cs:OneTimeOnlyPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�MessageTrigger*������ߟ�pClientContext"
    �?  �?  �?(���ڴ���2���ƚ�������蟝�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����ƚ���Message Banner"
    �?  �?  �?(�����ߟ�p2��ۆ����R��������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ۆ����RMessageBannerClient"
    �?  �?  �?(���ƚ���Z�
 
cs:ComponentRoot����ƚ���

	cs:Canvas���������

cs:Panel�
�ģ�̞��3


cs:TextBox����������


cs:Trigger��������ߥ
 
cs:MessageTrigger�
���ڴ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��ī�治8*���������BannerCanvas"
    �?  �?  �?(���ƚ���2	�ģ�̞��3Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*��ģ�̞��3Panel"
    �?  �?  �?(��������2צؚ���g���������Z z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�h��-|�wB:

mc:euianchor:middlecenter� �8


mc:euianchor:topcenter

mc:euianchor:topcenter*�צؚ���g
Background"
    �?  �?  �?(�ģ�̞��3Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*����������
BannerText"
    �?  �?  �?(�ģ�̞��3Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���d:

mc:euianchor:middlecenterPX�D
Message Banner  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*�����蟝�MessageTrigger"
    �?  �?  �?(�����ߟ�p2��ⱅ✷��������ߥz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ⱅ✷�	Plattform"
    �@  �@���=(����蟝�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��������ߥTrigger"
  �A   �@  �@  �@(����蟝�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���ϊ��Ӈ'MessageTriggerInteractable"

��C�  ��   �?  �?  �?(���ի��2
�������ͤZE


cs:messagejEine Sphäre.

cs:duratione   @

cs:OneTimeOnlyP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�MessageTriggerInteractable*��������ͤClientContext"
    �?  �?  �?(��ϊ��Ӈ'2���ڐ�h����ǜ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����ڐ�hMessage Banner"
    �?  �?  �?(�������ͤ2��������Z�ڳ𼪹�+Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ZMessageBannerInteractable"
    �?  �?  �?(���ڐ�hZ�

cs:ComponentRoot�
���ڐ�h

	cs:Canvas�
�ڳ𼪹�+

cs:Panel��������


cs:TextBox�јԊ����


cs:Trigger�΢�������
 
cs:MessageTrigger�
��ϊ��Ӈ'z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������*��ڳ𼪹�+BannerCanvas"
    �?  �?  �?(���ڐ�h2
�������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*��������Panel"
    �?  �?  �?(�ڳ𼪹�+2����ϱјԊ����Z z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�g�d->��B:

mc:euianchor:middlecenter� �8


mc:euianchor:topcenter

mc:euianchor:topcenter*�����ϱ
Background"
    �?  �?  �?(�������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*�јԊ����
BannerText"
    �?  �?  �?(�������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���d:

mc:euianchor:middlecenterPX�D
Message Banner  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*�����ǜ���MessageTrigger"
    �?  �?  �?(�������ͤ2
΢�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�΢�������Trigger"
  �B   �?  �?  �?(����ǜ���2	���Ġ��{Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�#"08*
mc:etriggershape:sphere*����Ġ��{Sphere"
    �?  �?  �?(΢�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��ߘՄ���EMessageTriggerBook"$
  D��C�  ��   �?  �?  �?(���ի��2
�٨������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�MessageTriggerBook*��٨������ClientContext"
    �?  �?  �?(�ߘՄ���E2������ŕ)̋�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�������ŕ)Message Banner"
    �?  �?  �?(�٨������2�����ɺ�_���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ɺ�_MessageManagerBook"
    �?  �?  �?(������ŕ)Z�

cs:ComponentRoot�
������ŕ)

	cs:Canvas����������


cs:Trigger�
�������


cs:Messages�ԣ�����
!
cs:ContinueAbility�
��������6z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������M*����������BannerCanvas"
    �?  �?  �?(������ŕ)2
ԣ�����Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*�ԣ�����Messages"
    �?  �?  �?(���������2��Ϛ�ŭ�������˝����̙����*z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Messages*���Ϛ�ŭ��Panel 1"
    �?  �?  �?(ԣ�����2���������â�������΄���Z z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�l�P%  HB-  �B:

mc:euianchor:middlecenter� �8


mc:euianchor:topcenter

mc:euianchor:topcenter*��������
Background"
    �?  �?  �?(��Ϛ�ŭ��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*���â����
BannerText"
    �?  �?  �?(��Ϛ�ŭ��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���d:

mc:euianchor:middlecenterPX�A
Hello there  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*����΄���ContinuePanel"
    �?  �?  �?(��Ϛ�ŭ��2򒰠��φ�����؀��xZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�hx2%  4�:

mc:euianchor:middlecenter� �:


mc:euianchor:topcenter

mc:euianchor:bottomright*�򒰠��φ�
Background"
    �?  �?  �?(���΄���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*�����؀��x
BannerText"
    �?  �?  �?(���΄���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���'-  ��:

mc:euianchor:middlecenterPX�=
press E  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*������˝��Panel 2"
    �?  �?  �?(ԣ�����2��򓓽���������l����威��Z z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�l�d%  HB-  �B:

mc:euianchor:middlecenter� �8


mc:euianchor:topcenter

mc:euianchor:topcenter*���򓓽�
Background"
    �?  �?  �?(�����˝��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*���������l
BannerText"
    �?  �?  �?(�����˝��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���d:

mc:euianchor:middlecenterPX�D
General Kenoby  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*�����威��ContinuePanel"
    �?  �?  �?(�����˝��2���Ԥ�ܪ����������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�hx2%  4�:

mc:euianchor:middlecenter� �:


mc:euianchor:topcenter

mc:euianchor:bottomright*����Ԥ�ܪ�
Background"
    �?  �?  �?(����威��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*����������
BannerText"
    �?  �?  �?(����威��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���'-  ��:

mc:euianchor:middlecenterPX�=
press E  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*���̙����*Panel 3"
    �?  �?  �?(ԣ�����2��ٚ������������m���������Z z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�l�d%  HB-  �B:

mc:euianchor:middlecenter� �8


mc:euianchor:topcenter

mc:euianchor:topcenter*���ٚ�����
Background"
    �?  �?  �?(��̙����*Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*��������m
BannerText"
    �?  �?  �?(��̙����*Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���d:

mc:euianchor:middlecenterPX�?
	Good day.  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*����������ContinuePanel"
    �?  �?  �?(��̙����*2փ�۷���Җ�����QZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�hx2%  4�:

mc:euianchor:middlecenter� �:


mc:euianchor:topcenter

mc:euianchor:bottomright*�փ�۷��
Background"
    �?  �?  �?(���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�y��:

mc:euianchor:middlecenterPX�
���𱼥��%333? �4


mc:euianchor:topleft

mc:euianchor:topleft*��Җ�����Q
BannerText"
    �?  �?  �?(���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���'-  ��:

mc:euianchor:middlecenterPX�=
press E  �?  �?  �?%  �?"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*�̋�������MessageTrigger"
    �?  �?  �?(�٨������2	�������
z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������
Trigger"
  �B   �?  �?  �?(̋�������2
���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�#"08*
mc:etriggershape:sphere*����������Sphere"
    �?  �?  �?(�������
z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ˠ����~ReadBookAbility"

  �C ��D   �?  �?  �?(���ի��2������������܊�ظ���������6pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
pelvis���������*����������PickupTrigger"
    �?  �?  �?(ˠ����~pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����܊�ظ�PlayerConnection"$
 0�Eв�B  H�   �?  �?  �?(ˠ����~pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ͭ�����k*���������6ContinueAbility"
    �?  �?  �?(ˠ����~pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��*& 08J
mc:eabilitysetfacing:aim2& 08J
mc:eabilitysetfacing:aim:,���= 08J
mc:eabilitysetfacing:noneB,��L= 08J
mc:eabilitysetfacing:noneZ
mc:egameaction:extraaction_32
NoneNone�^*\Some triggers that let you show messages by Interaction or by walking through a trigger zone�
��ͭ�����kPlayerConnectionZ��local EQUIPMENT = script.parent


local equiped = false



function OnPlayerJoined(player)
	player.canMount = false
	
	if not equiped then
		EQUIPMENT:Equip(player)
		equiped = true
	end
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)


�	������MMessageManagerBookZ��-- Internal custom properties
local CANVAS = script:GetCustomProperty("Canvas"):WaitForObject()

local trigger = script:GetCustomProperty("Trigger"):WaitForObject()
local pages = script:GetCustomProperty("Messages"):WaitForObject():GetChildren()
local maxPages = #pages
local continueAbility = script:GetCustomProperty("ContinueAbility"):WaitForObject()


-- Constant variables
local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local active = false
local currentPage = 1 


function OnInteracted()

	if not active then
		active = true
		currentPage = 1
		pages[currentPage].visibility = Visibility.INHERIT
    end	
end


function Continue()
	if active then
		pages[currentPage].visibility = Visibility.FORCE_OFF
	
		if currentPage == maxPages then
			active = false
			currentPage = 0
		else
			currentPage = currentPage + 1
			pages[currentPage].visibility = Visibility.INHERIT
		end
	end
end


-- Initialize
for i = 1, maxPages do
	pages[i].visibility = Visibility.FORCE_OFF
end
		
trigger.interactedEvent:Connect(OnInteracted)
continueAbility.castEvent:Connect(Continue)
:������ȬSphereR#
StaticMeshAssetRefsm_sphere_002
�
��������MessageBannerInteractableZ�	�	
-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local CANVAS = script:GetCustomProperty("Canvas"):WaitForObject()
local PANEL = script:GetCustomProperty("Panel"):WaitForObject()
local TEXT_BOX = script:GetCustomProperty("TextBox"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()

local ROOT = script:GetCustomProperty("MessageTrigger"):WaitForObject()

-- User exposed properties
local MESSAGE = ROOT:GetCustomProperty("message")
local DURATION = ROOT:GetCustomProperty("duration")

local DEFAULT_DURATION = 3

local ONETIMEONLY = script:GetCustomProperty("OneTimeOnly")


-- Constant variables
local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local appeared = false

-- nil OnBannerMessageEvent(string, <float>)
-- Handles a client side banner message event
function OnInteracted()

	if not (appeared and ONETIMEONLY) then
		appeared = true
		PANEL.visibility = Visibility.INHERIT
    	TEXT_BOX.text = MESSAGE
    	Task.Wait(DURATION)
    	PANEL.visibility = Visibility.FORCE_OFF
    end
		
end


-- Initialize
PANEL.visibility = Visibility.FORCE_OFF
TRIGGER.interactedEvent:Connect(OnInteracted)
6��������CubeR!
StaticMeshAssetRefsm_cube_002
�	��ī�治8MessageBannerClientZ�	�	
-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local CANVAS = script:GetCustomProperty("Canvas"):WaitForObject()
local PANEL = script:GetCustomProperty("Panel"):WaitForObject()
local TEXT_BOX = script:GetCustomProperty("TextBox"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()

local ROOT = script:GetCustomProperty("MessageTrigger"):WaitForObject()

-- User exposed properties
local MESSAGE = ROOT:GetCustomProperty("message")
local DURATION = ROOT:GetCustomProperty("duration")

local DEFAULT_DURATION = 3

local ONETIMEONLY = script:GetCustomProperty("OneTimeOnly")


-- Constant variables
local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local appeared = false

-- nil OnBannerMessageEvent(string, <float>)
-- Handles a client side banner message event
function OnBeginOverlap()

	if not appeared then
		appeared = true
		PANEL.visibility = Visibility.INHERIT
    	TEXT_BOX.text = MESSAGE
    	Task.Wait(DURATION)
    	PANEL.visibility = Visibility.FORCE_OFF
    end
		
end


-- Initialize
PANEL.visibility = Visibility.FORCE_OFF
TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)
���������Message Bannerb�
� ט���ؤ��*�ט���ؤ��Message Banner"  �?  �?  �?(�������X2
���������Zm

cs:DefaultDuratione  @@
P
cs:DefaultDuration:tooltipj2Default duration of a message if none is specifiedz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������MessageBannerClient"
    �?  �?  �?(ט���ؤ��2��ϊ���A������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���ϊ���AMessageBannerClient"
    �?  �?  �?(���������ZW
 
cs:ComponentRoot�ט���ؤ��

cs:Panel����������


cs:TextBox�
��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ȝ��Ґ�\*�������BannerCanvas"
    �?  �?  �?(���������2
���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*����������Panel"
    �?  �?  �?(������2	��������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�m�d-  z�:

mc:euianchor:middlecenter� �>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*���������
BannerText"
    �?  �?  �?(���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���d:

mc:euianchor:middlecenter�D
Message Banner  �?  �?  �?%  �?2"
mc:etextjustify:center(�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter"
TemplateAssetRefMessage_Banner
��ȝ��Ґ�\MessageBannerClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[
Displays text associated with the BannerMessage() event that takes the following forms:

BannerMessage(String message)
BannerMessage(String message, float duration)
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local PANEL = script:GetCustomProperty("Panel"):WaitForObject()
local TEXT_BOX = script:GetCustomProperty("TextBox"):WaitForObject()

-- User exposed properties
local DEFAULT_DURATION = COMPONENT_ROOT:GetCustomProperty("DefaultDuration")

-- Check user properties
if DEFAULT_DURATION <= 0.0 then
    warn("DefaultDuration must be positive")
    DEFAULT_DURATION = 2.0
end

-- Variables
local messageEndTime = 0.0

-- nil OnBannerMessageEvent(string, <float>)
-- Handles a client side banner message event
function OnBannerMessageEvent(message, duration)
    if duration then
        messageEndTime = time() + duration
    else
        messageEndTime = time() + DEFAULT_DURATION
    end

    PANEL.visibility = Visibility.INHERIT
    TEXT_BOX.text = message
end

-- nil Tick(float)
-- Hides the banner when the message has expired
function Tick(deltaTime)
    if time() > messageEndTime then
        PANEL.visibility = Visibility.FORCE_OFF
    end
end

-- Initialize
PANEL.visibility = Visibility.FORCE_OFF
Events.Connect("BannerMessage", OnBannerMessageEvent)

�Յ�������
Spike Trapbf
V ��화����*I��화����TemplateBundleDummy"
    �?  �?  �?�Z
��㏺����
NoneNone��
 518365c43af64a758d28c4536c2e3aff c1e8a85866ac4c7aa318c7ae6dd61093banksii"1.0.0*2Spike trap with kill zone, fits 8m x 8m floor tile
�P��㏺����
Spike Trapb�P
�P ��������p*���������p
Spike Trap"   ?   ?   ?(�����B2������ɖ�Q��Օ����j󻚫ؒ������֔������ί��3�씶��̂������+���ۤۙ�������������ˊąŷ��ދ�ۓ��o��ٶ��ȕ`ᠧ샿��\��ҁ�������������߻�������߿������Ƴ��������⪟�����������ϛ㏚�=�������ڥ�ȯ�����^��ƃ��̈́��Ŏ�푑�ːİ��߭�����í���ȃ��������ۋ����n��Ⅶ������������ٹ�׶���V����Ӹ�H�������n����������Ď���ؤ��򫣐������ĥ��+z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ɖ�QFantasy Sword Blade 04".
�[�CP(�����@
�{A�8����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Օ����jFantasy Sword Blade 04"3
��hC`�M����@=/n������d�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�󻚫ؒ��Fantasy Sword Blade 04"$

�	CP(���&@��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�����֔���Fantasy Sword Blade 04"3
��B�l� /�?s���P�?� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����ί��3Fantasy Sword Blade 04"3
�[��@l�� /�?s���#��� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��씶��̂�Fantasy Sword Blade 04".
�jB������@
����9����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *������+Fantasy Sword Blade 04"3
 �+A�3[����@=/n��)�f�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����ۤۙ��Fantasy Sword Blade 04")

�@��@dW�
�&@���#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����������Fantasy Sword Blade 04"3
�2�C���� /�?s����C��>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ˊąŷ�Fantasy Sword Blade 04".
H�5C�T�B���@
�%C�<����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��ދ�ۓ��oFantasy Sword Blade 04"3
��oC ŏA���@=/n���C�l�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ٶ��ȕ`Fantasy Sword Blade 04".

��C ��A�&@S�C�J!6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ᠧ샿��\Fantasy Sword Blade 04"3
%C �p� /�?s�����-�) �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ҁ�����Fantasy Sword Blade 04".

 �B RB�&@<�.��{�5��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�������Fantasy Sword Blade 04"3
 ��A ������@=/n���.��k�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���߻�����Fantasy Sword Blade 04".
@��� �B���@
8��:����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���߿���Fantasy Sword Blade 04".
@b�� �iA���@
��%C;����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����Ƴ���Fantasy Sword Blade 04"3
('��@}�����@=/n��9C�l�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *������⪟�Fantasy Sword Blade 04"3
 �F���O� /�?s�����C� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���������Fantasy Sword Blade 04".

 �6�����&@�>Cs�$6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ϛ㏚�=Fantasy Sword Blade 04".
�Y)��|�����@
�1�A�>����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��������ڥFantasy Sword Blade 04"3
H���p������@=/n���2A�r�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��ȯ�����^Fantasy Sword Blade 04".

���� �6C�&@{��&�6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ƃ��̈́Fantasy Sword Blade 04"3
@,)��ĲB /�?s����x8�� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Ŏ�푑�Fantasy Sword Blade 04".

�]� z���&@��:��a:5��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ːİ��߭�Fantasy Sword Blade 04"3
�\�����B���@=/n�̅��i�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�����í���Fantasy Sword Blade 04"3
�o�@wC /�?s����E����>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ȃ������Fantasy Sword Blade 04".

pi�C`�C�&@��CF�6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ۋ����nFantasy Sword Blade 04"3
hC��'C /�?s���"C��>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Ⅶ���Fantasy Sword Blade 04"3
�OqC`˕C���@=/n��Cm�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����������Fantasy Sword Blade 04"3
xC iC /�?s�����1C$ �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ٹ�׶���VFantasy Sword Blade 04"3
 ǗAж�C���@=/n��1C�k�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�����Ӹ�HFantasy Sword Blade 04"3
�g�� �lC /�?s���<-�� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��������nFantasy Sword Blade 04".

�]�R�C�&@�v\��d�4��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���������Fantasy Sword Blade 04"3
 ��A��B���@=/n�w�B%q�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Ď���ؤFantasy Sword Blade 04"3
`���@S�B���@@�@�ׅBl����#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���򫣐���KillTrigger"

 =��  HC +��@� A��@(��������pZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����ĥ��+KillZoneServer"$
 ��A ��A9VgC   �?  �?  �?(��������pZA
?
cs:KillTrigger�,���񪑡���������ϼо���� �է�Ŝʟz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��῁���e
NoneNone�4*2Spike trap with kill zone, fits 8m x 8m floor tile�
���῁���eKillZoneServerZ��--[[
Copyright 2019 Manticore Games, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom property
local KILL_TRIGGER = script:GetCustomProperty("KillTrigger"):WaitForObject()

-- nil OnBeginOverlap(Trigger, Object)
-- Kills a player when they enter the trigger
function OnBeginOverlap(trigger, other)
    if other:IsA("Player") then
        other:Die()
    end
end

-- Connect trigger overlap event
KILL_TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

J��㥮ג��Bark Redwood 01R*
MaterialAssetRefmi_bark_redwood_001_uv
\Ө����Fantasy Sword Blade 04R5
StaticMeshAssetRefsm_weap_fan_blade_sword_004_ref
[�«������Bone Human Scattered 01R3
StaticMeshAssetRefsm_bones_human_scatter_01_ref
;ᄈ������Custom Foundation - Gradient����ˑ���� 
����ʮ�Ɗ�APISpectatorZ��--[[
Copyright 2019 Manticore Games, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[
The spectator API tracks which state the local player is in. It does not actually implement behavior such as controlling
the players camera or reacting to keybinds.
Valid states are:
    not spectating (default)
    spectating with a nil target (could be looking at your body, could be free cam)
    spectating a specific player

Spectating is a purely client-side concept.
Components that implement this API must also broadcast the following events:

IsSpectatingChanged(bool isSpectating)
SpectatingTargetChanged(Player oldTarget, Player newTarget)
--]]

local API = {}

-- nil SetPlayerIsSpectating(bool) [Client]
-- Set whether the local player is in spectator mode
function API.SetIsSpectating(isSpectating)
	_G.APISpectator_IsSpectating = isSpectating
end

-- bool IsPlayerSpectating() [Client]
-- Returns whether the local player is in spectator mode
function API.IsSpectating()
	if not _G.APISpectator_IsSpectating then
		return false
	end

	return _G.APISpectator_IsSpectating
end

-- nil SetPlayerSpectatorTarget(<Player>) [Client]
-- Set which player the local player  is spectating
function API.SetSpectatorTarget(player)
	_G.APISpectator_TargetPlayer = player
end

-- <Player> GetPlayerSpectatorTarget() [Client]
-- Returns which target the locaal player is spectating
function API.GetSpectatorTarget()
	if not _G.APISpectator_TargetPlayer then
		return nil
	end

	-- The target may have disconnected
	if not Object.IsValid(_G.APISpectator_TargetPlayer) then
		return nil
	end

	return _G.APISpectator_TargetPlayer
end

return API

������ϭ��ShotArrowScriptZ��-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local FantasyCrossbowBolt = script:GetCustomProperty("FantasyCrossbowBolt"):WaitForObject()
local CrossbowHitTrigger = script:GetCustomProperty("CrossbowHitTrigger"):WaitForObject()


-- Internal variables

local WasActivated = false

function OnBeginOverlap(trigger, other)
if (WasActivated == false) then
	if other:IsA("Player") then
	UI.PrintToScreen("String was activated")
		WasActivated = true
        FantasyCrossbowBolt:MoveTo(COMPONENT_ROOT:GetWorldPosition(), .1)
        Task.Wait(.15)
        FantasyCrossbowBolt:Destroy()
        end
	end
end

function OnBoltHit(trigger, other)
	if other:IsA("Player") then
        other:Die()
	end
end

-- Initialize
TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)
CrossbowHitTrigger.beginOverlapEvent:Connect(OnBoltHit)
[�����˞��Axe Spin VerticleZ97script.parent:RotateContinuous(Rotation.New(200, 0, 0))
`򯐡�폫�Bone Human Pile Straight 02R4
StaticMeshAssetRefsm_bones_human_pile_str_02_ref
����������,Fantasy Castle Wall 02 - Door Basic Templateb�
� ���ʠ���[*����ʠ���[,Fantasy Castle Wall 02 - Door Basic Template"  �?  �?  �?(�҈�绺�K2���ቯ������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ቯ���#Fantasy Castle Wall 02 - Doorway 01"
    �?  �?  �?(���ʠ���[z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��ɛ��أn088�
 *����������Basic Door - Castle"$

  �C  B����  �?  �?  �?(���ʠ���[2�����λ�ꑙ�ͅ������Σ�ݪ�Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������λ�ServerContext"
    �?  �?  �?(���������2����������������[Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������BasicDoorControllerServer"
    �?  �?  �?(�����λ�Z�
 
cs:ComponentRoot����������

cs:RotationRoot����Σ�ݪ�
"
cs:RotatingTrigger�𷰴脐��

cs:StaticTrigger�
��������[z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ԝ�ݨ*���������[StaticTrigger"

  �B  C   �?ff�?  @@(�����λ�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�ꑙ�ͅ���ClientContext"
  /C   �?  �?  �?(���������2ۜ������%����à�9�ݘ��ϕ�QZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�ۜ������%BasicDoorControllerClient"
    �?  �?  �?(ꑙ�ͅ���Z\

cs:RotationRoot����Σ�ݪ�

cs:OpenSound�
����à�9

cs:CloseSound�
�ݘ��ϕ�Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ڦ�ױ��*�����à�9Helper_DoorOpenSound"
    �?  �?  �?(ꑙ�ͅ���Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��ݘ��ϕ�QHelper_DoorCloseSound"
    �?  �?  �?(ꑙ�ͅ���ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*����Σ�ݪ�RotationRoot"
    �?  �?  �?(���������2��á����P𷰴脐��Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���á����PGeo_StaticContext"
    �?  �?  �?(���Σ�ݪ�2	���ԛ��DZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ԛ��DFantasy Castle Door 01"
 ���B  �?  �?  �?(��á����Pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������088�
 *�𷰴脐��RotatingTrigger"

  �B  C   �?ff�?  @@(���Σ�ݪ�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box@
TemplateAssetRef,Fantasy_Castle_Wall_02_-_Door_Basic_Template
g��ɛ��أn#Fantasy Castle Wall 02 - Doorway 01R4
StaticMeshAssetRefsm_ts_fan_cas_wall_002_door_01
�q�ͅ宐ד�NameplateControllerClientZ�q�q--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local AS = require(script:GetCustomProperty("API"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local NAMEPLATE_TEMPLATE = script:GetCustomProperty("NameplateTemplate")
local SEGMENT_SEPARATOR_TEMPLATE = script:GetCustomProperty("SegmentSeparatorTemplate")

-- User exposed properties
local SHOW_NAMES = COMPONENT_ROOT:GetCustomProperty("ShowNames")
local SHOW_HEALTHBARS = COMPONENT_ROOT:GetCustomProperty("ShowHealthbars")
local SHOW_ON_SELF = COMPONENT_ROOT:GetCustomProperty("ShowOnSelf")
local SHOW_ON_TEAMMATES = COMPONENT_ROOT:GetCustomProperty("ShowOnTeammates")
local MAX_DISTANCE_ON_TEAMMATES = COMPONENT_ROOT:GetCustomProperty("MaxDistanceOnTeammates")
local SHOW_ON_ENEMIES = COMPONENT_ROOT:GetCustomProperty("ShowOnEnemies")
local MAX_DISTANCE_ON_ENEMIES = COMPONENT_ROOT:GetCustomProperty("MaxDistanceOnEnemies")
local SHOW_ON_DEAD_PLAYERS = COMPONENT_ROOT:GetCustomProperty("ShowOnDeadPlayers")
local SCALE = COMPONENT_ROOT:GetCustomProperty("Scale")
local SHOW_NUMBERS = COMPONENT_ROOT:GetCustomProperty("ShowNumbers")
local ANIMATE_CHANGES = COMPONENT_ROOT:GetCustomProperty("AnimateChanges")
local CHANGE_ANIMATION_TIME = COMPONENT_ROOT:GetCustomProperty("ChangeAnimationTime")
local SHOW_SEGMENTS = COMPONENT_ROOT:GetCustomProperty("ShowSegments")
local SEGMENT_SIZE = COMPONENT_ROOT:GetCustomProperty("SegmentSize")

-- User exposed properties (colors)
local FRIENDLY_NAME_COLOR = COMPONENT_ROOT:GetCustomProperty("FriendlyNameColor")
local ENEMY_NAME_COLOR = COMPONENT_ROOT:GetCustomProperty("EnemyNameColor")
local BORDER_COLOR = COMPONENT_ROOT:GetCustomProperty("BorderColor")
local BACKGROUND_COLOR = COMPONENT_ROOT:GetCustomProperty("BackgroundColor")
local FRIENDLY_HEALTH_COLOR = COMPONENT_ROOT:GetCustomProperty("FriendlyHealthColor")
local ENEMY_HEALTH_COLOR = COMPONENT_ROOT:GetCustomProperty("EnemyHealthColor")
local DAMAGE_CHANGE_COLOR = COMPONENT_ROOT:GetCustomProperty("DamageChangeColor")
local HEAL_CHANGE_COLOR = COMPONENT_ROOT:GetCustomProperty("HealChangeColor") 
local HEALTH_NUMBER_COLOR = COMPONENT_ROOT:GetCustomProperty("HealthNumberColor") 

-- Check user properties
if MAX_DISTANCE_ON_TEAMMATES < 0.0 then
    warn("MaxDistanceOnTeammates cannot be negative")
    MAX_DISTANCE_ON_TEAMMATES = 0.0
end

if MAX_DISTANCE_ON_ENEMIES < 0.0 then
    warn("MaxDistanceOnEnemies cannot be negative")
    MAX_DISTANCE_ON_ENEMIES = 0.0
end

if SCALE <= 0.0 then
    warn("Scale must be positive")
    SCALE = 1.0
end

if CHANGE_ANIMATION_TIME <= 0.0 then
    warn("ChangeAnimationTime must be positive")
    CHANGE_ANIMATION_TIME = 1.0
end

if SEGMENT_SIZE <= 0.0 then
    warn("SegmentSize must be positive")
    SEGMENT_SIZE = 20.0
end

--Constants
-- In units of scale
local BORDER_WIDTH = 0.02
local NAMEPLATE_LAYER_THICKNESS = 0.01			-- To force draw order
local HEALTHBAR_WIDTH = 1.5
local HEALTHBAR_HEIGHT = 0.08

local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local nameplates = {}

-- Player GetViewedPlayer()
-- Returns which player the local player is spectating (or themselves if not spectating)
function GetViewedPlayer()
	local specatatorTarget = AS.GetSpectatorTarget()

	if AS.IsSpectating() and specatatorTarget then
		return specatatorTarget
	end

	return LOCAL_PLAYER
end

-- nil OnPlayerJoined(Player)
-- Creates a nameplate for the local player to see the target player's status
function OnPlayerJoined(player)
	local nameplateRoot = World.SpawnAsset(NAMEPLATE_TEMPLATE)

	nameplates[player] = {}
	nameplates[player].templateRoot = nameplateRoot
	nameplates[player].borderPiece = nameplateRoot:GetCustomProperty("BorderPiece"):WaitForObject()
	nameplates[player].backgroundPiece = nameplateRoot:GetCustomProperty("BackgroundPiece"):WaitForObject()
	nameplates[player].healthPiece = nameplateRoot:GetCustomProperty("HealthPiece"):WaitForObject()
	nameplates[player].changePiece = nameplateRoot:GetCustomProperty("ChangePiece"):WaitForObject()
	nameplates[player].healthText = nameplateRoot:GetCustomProperty("HealthText"):WaitForObject()
	nameplates[player].nameText = nameplateRoot:GetCustomProperty("NameText"):WaitForObject()

	-- For animating changes. Each change clobbers the previous state.
	nameplates[player].lastHealthFraction = 1.0
	nameplates[player].lastHealthTime = 0.0
	nameplates[player].lastFrameHealthFraction = 1.0

	-- Setup static properties
	nameplateRoot:AttachToPlayer(player, "nameplate")
	nameplateRoot:SetScale(Vector3.New(SCALE, SCALE, SCALE))

	-- Static properties on pieces
	nameplates[player].borderPiece:SetScale(Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH + 2.0 * BORDER_WIDTH, HEALTHBAR_HEIGHT + 2.0 * BORDER_WIDTH))
	nameplates[player].borderPiece:SetPosition(Vector3.New(-4.0 * NAMEPLATE_LAYER_THICKNESS, 0.0, 0.0))
	nameplates[player].borderPiece:SetColor(BORDER_COLOR)
	nameplates[player].backgroundPiece:SetScale(Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH, HEALTHBAR_HEIGHT))
	nameplates[player].backgroundPiece:SetPosition(Vector3.New(-3.0 * NAMEPLATE_LAYER_THICKNESS, 0.0, 0.0))
	nameplates[player].backgroundPiece:SetColor(BACKGROUND_COLOR)
	nameplates[player].healthText:SetPosition(Vector3.New(50.0 * NAMEPLATE_LAYER_THICKNESS, 0.0, 0.0))		-- Text must be 50 units ahead as it doesn't have thickness
	nameplates[player].healthText:SetColor(HEALTH_NUMBER_COLOR)
	nameplates[player].nameText.text = player.name

	nameplates[player].borderPiece.visibility = Visibility.FORCE_OFF
	nameplates[player].backgroundPiece.visibility = Visibility.FORCE_OFF
	nameplates[player].healthPiece.visibility = Visibility.FORCE_OFF
	nameplates[player].changePiece.visibility = Visibility.FORCE_OFF
	nameplates[player].healthText.visibility = Visibility.FORCE_OFF
	nameplates[player].nameText.visibility = Visibility.FORCE_OFF

	if SHOW_HEALTHBARS then
		nameplates[player].borderPiece.visibility = Visibility.INHERIT
		nameplates[player].backgroundPiece.visibility = Visibility.INHERIT
		nameplates[player].healthPiece.visibility = Visibility.INHERIT

		if ANIMATE_CHANGES then
			nameplates[player].changePiece.visibility = Visibility.INHERIT
		end

		if SHOW_NUMBERS then
			nameplates[player].healthText.visibility = Visibility.INHERIT
		end
	end

	if SHOW_NAMES then
		nameplates[player].nameText.visibility = Visibility.INHERIT
	end

	if SHOW_SEGMENTS then
		nameplates[player].segmentSeparators = {}
	end
end

-- nil OnPlayerLeft(Player)
-- Destroy their nameplate
function OnPlayerLeft(player)
	if SHOW_SEGMENTS then
		for _, segmentSeparator in pairs(nameplates[player].segmentSeparators) do
			segmentSeparator:Destroy()
		end
	end

	nameplates[player].templateRoot:Destroy()
	nameplates[player] = nil
end

-- bool IsNameplateVisible(Player)
-- Can we see this player's nameplate given team and distance properties?
function IsNameplateVisible(player)
	if player.isDead and not SHOW_ON_DEAD_PLAYERS then
		return false
	end

	if player == GetViewedPlayer() then
		return SHOW_ON_SELF
	end

	-- 0 distance is special, and means we always display them
	if player == GetViewedPlayer() or Teams.AreTeamsFriendly(player.team, GetViewedPlayer().team) then
		if SHOW_ON_TEAMMATES then
			local distance = (player:GetWorldPosition() - GetViewedPlayer():GetWorldPosition()).size
			if MAX_DISTANCE_ON_TEAMMATES == 0.0 or distance <= MAX_DISTANCE_ON_TEAMMATES then
				return true
			end
		end
	else
		if SHOW_ON_ENEMIES then
			local distance = (player:GetWorldPosition() - GetViewedPlayer():GetWorldPosition()).size
			if MAX_DISTANCE_ON_ENEMIES == 0.0 or distance <= MAX_DISTANCE_ON_ENEMIES then
				return true
			end
		end
	end

	return false
end

-- nil RotateNameplate(CoreObject)
-- Called every frame to make nameplates align with the local view
function RotateNameplate(nameplate)
	local quat = Quaternion.New(LOCAL_PLAYER:GetViewWorldRotation())
	quat = quat * Quaternion.New(Vector3.UP, 180.0)
	nameplate.templateRoot:SetWorldRotation(Rotation.New(quat))
end

-- nil Tick(float)
-- Update dynamic properties (ex. team, health, and health animation) of every nameplate
function Tick(deltaTime)
	for _, player in pairs(Game.GetPlayers()) do
		local nameplate = nameplates[player]

		if nameplate then
			-- We calculate visibility every frame to handle when teams change
			local visible = IsNameplateVisible(player)

			if not visible then
				nameplate.templateRoot.visibility = Visibility.FORCE_OFF
			else
				nameplate.templateRoot.visibility = Visibility.INHERIT
				RotateNameplate(nameplate)

				if SHOW_HEALTHBARS then
					local healthFraction = player.hitPoints / player.maxHitPoints
					local visibleHealthFraction = healthFraction			-- For animating changes

					-- Set size and position of change piece
					if ANIMATE_CHANGES then
						local timeSinceChange = CoreMath.Clamp(time() - nameplate.lastHealthTime, 0.0, CHANGE_ANIMATION_TIME)
						local timeScale = 1.0 - timeSinceChange / CHANGE_ANIMATION_TIME
						local changeFraction = timeScale * (nameplate.lastHealthFraction - healthFraction)
						nameplate.changePiece:SetScale(Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH * math.abs(changeFraction), HEALTHBAR_HEIGHT))

						if changeFraction == 0.0 then
							nameplate.changePiece.visibility = Visibility.FORCE_OFF
						else
							nameplate.changePiece.visibility = Visibility.INHERIT

							if changeFraction > 0.0 then		-- Player took damage
								local changePieceOffset = 50.0 * HEALTHBAR_WIDTH * (1.0 - changeFraction) - 100.0 * HEALTHBAR_WIDTH * healthFraction
								nameplate.changePiece:SetPosition(Vector3.New(-2.0 * NAMEPLATE_LAYER_THICKNESS, changePieceOffset, 0.0))
								nameplate.changePiece:SetColor(DAMAGE_CHANGE_COLOR)
							else								-- Player was healed	
								visibleHealthFraction = visibleHealthFraction + changeFraction
								local changePieceOffset = 50.0 * HEALTHBAR_WIDTH * (1.0 + changeFraction) - 100.0 * HEALTHBAR_WIDTH * visibleHealthFraction
								nameplate.changePiece:SetPosition(Vector3.New(-2.0 * NAMEPLATE_LAYER_THICKNESS, changePieceOffset, 0.0))
								nameplate.changePiece:SetColor(HEAL_CHANGE_COLOR)
							end
						end

						-- Detect health changes to set the animation state
						if healthFraction ~= nameplate.lastFrameHealthFraction then
							-- If you just respawned, don't show it like a big heal
							if nameplate.lastFrameHealthFraction == 0.0 then
								nameplate.lastHealthTime = 0.0
								nameplate.lastHealthFraction = healthFraction
							else
								nameplate.lastHealthTime = time()
								nameplate.lastHealthFraction = nameplate.lastFrameHealthFraction
							end
							
							nameplate.lastFrameHealthFraction = healthFraction
						end
					end

					-- Update segments
					if SHOW_SEGMENTS then
						local nSegmentSeparators = math.ceil(player.maxHitPoints / SEGMENT_SIZE) - 1
						local healthScale = (HEALTHBAR_WIDTH + BORDER_WIDTH) / player.maxHitPoints
						local segmentBaseOffset = 100.0 * (HEALTHBAR_WIDTH + BORDER_WIDTH) / 2

						for i = 1, nSegmentSeparators - #nameplate.segmentSeparators do
							local segmentSeparator = World.SpawnAsset(SEGMENT_SEPARATOR_TEMPLATE, {parent = nameplate.templateRoot})
							segmentSeparator:SetColor(BORDER_COLOR)
							table.insert(nameplate.segmentSeparators, segmentSeparator)
						end

						for i = nSegmentSeparators + 1, #nameplate.segmentSeparators do
							local segmentSeparator = nameplate.segmentSeparators[i]
							segmentSeparator.visibility = Visibility.FORCE_OFF
						end

						for i = 1, nSegmentSeparators do
							local segmentSeparator = nameplate.segmentSeparators[i]
							segmentSeparator.visibility = Visibility.INHERIT
							segmentSeparator:SetScale(Vector3.New(NAMEPLATE_LAYER_THICKNESS, BORDER_WIDTH, HEALTHBAR_HEIGHT + BORDER_WIDTH))
							segmentSeparator:SetPosition(Vector3.New(-1.0 * NAMEPLATE_LAYER_THICKNESS, segmentBaseOffset - 100.0 * i * SEGMENT_SIZE * healthScale, 0.0))
						end
					end

					-- Set size and position of health bar
					local healthPieceOffset = 50.0 * HEALTHBAR_WIDTH * (1.0 - visibleHealthFraction)
					nameplate.healthPiece:SetScale(Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH * visibleHealthFraction, HEALTHBAR_HEIGHT))
					nameplate.healthPiece:SetPosition(Vector3.New(-2.0 * NAMEPLATE_LAYER_THICKNESS, healthPieceOffset, 0.0))

					-- Update hit point number
					if SHOW_NUMBERS then
						nameplate.healthText.text = string.format("%.0f / %.0f", player.hitPoints, player.maxHitPoints)
					end
				end

				-- Update name and health color based on teams
				if SHOW_NAMES then
					local nameColor = nil
					local healthColor = nil

					if player == LOCAL_PLAYER or Teams.AreTeamsFriendly(player.team, LOCAL_PLAYER.team) then
						nameColor = FRIENDLY_NAME_COLOR
						healthColor = FRIENDLY_HEALTH_COLOR
					else
						nameColor = ENEMY_NAME_COLOR
						healthColor = ENEMY_HEALTH_COLOR
					end

					nameplate.nameText:SetColor(nameColor)
					nameplate.healthPiece:SetColor(healthColor)
				end
			end
		end
	end
end

-- Initialize
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
����暽��Generic Reticleb�
� ��������9*���������9Generic Reticle"  �?  �?  �?(�����B2����������À���&��ކ�����Z-

cs:ExtraRadiuse  pA

cs:StartAnglee  �Bpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*��������WeaponReticleUIClient"
    �?  �?  �?(��������9ZB

cs:ComponentRoot�
��������9

cs:SegmentsRoot���ކ�����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ӡ�������*����À���&Center"
    �?  �?  �?(��������9Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��:

mc:euianchor:middlecenter�#
���į�ԇ�  �?  �?  �?%��L?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*���ކ�����Segments"
    �?  �?  �?(��������92(������У�������ַ�����������ˢÑ���Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������УSegment"
    �?  �?  �?(��ކ�����Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��:

mc:euianchor:middlecenter�#
���į�ԇ�  �?  �?  �?%��L?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*��������ַSegment"
 �.e�  �?  �?  �?(��ކ�����Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��:

mc:euianchor:middlecenter�#
���į�ԇ�  �?  �?  �?%��L?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*����������Segment"
 �.e�  �?  �?  �?(��ކ�����Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��:

mc:euianchor:middlecenter�#
���į�ԇ�  �?  �?  �?%��L?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*���ˢÑ���Segment"
    �?  �?  �?(��ކ�����Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��:

mc:euianchor:middlecenter�#
���į�ԇ�  �?  �?  �?%��L?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter
NoneNone
O���į�ԇ�Background Flat 020	R+
PlatformBrushAssetRefBackgroundFlat_020
�Ц�������NPCHealthBarDataProviderClientZ��
--[[
	NPCHealthBarDataProvider - Client
	by: standardcombo
	v0.9.0
	
	Works in conjunction with NPCHealthBar. Sets itself as the data provider for the UI.
	Other objects could use the same health bar UI by implementing their own data
	providers.
	
	The health bar UI is spawned in relationship to the position of this script.
	Commonly, the script's Z position should be adjusted on a per-NPC basis.
	
	Implements the interface:
		GetHealt()
		GetMaxHealth()
		GetTeam()
--]]

local ROOT = script:GetCustomProperty("Root"):WaitForObject()

local HEALTH_BAR_TEMPLATE = script:GetCustomProperty("HealthBarTemplate")
local MAX_HEALTH = ROOT:GetCustomProperty("CurrentHealth")


function GetHealth()
	if Object.IsValid(ROOT) then
		return ROOT:GetCustomProperty("CurrentHealth")
	end
	return 0
end

function GetMaxHealth()
	return MAX_HEALTH
end

function GetTeam()
	if Object.IsValid(ROOT) then
		return ROOT:GetCustomProperty("Team")
	end
	return 0
end

-- Creates the health bar UI and places it as a child of this script
local hpBar = World.SpawnAsset(HEALTH_BAR_TEMPLATE, {parent = script})
Task.Wait()
local hpBarScript = hpBar:FindChildByType("Script")

-- Passes itself as the data provider, from which the health bar will ask for values.
hpBarScript.context.SetDataProvider(script.context)

�

cs:Root� 
$
cs:HealthBarTemplate����ܼ���
n
cs:Root:tooltipj[A reference to the root of the template, where most of the NPC's custom properties are set.
�
cs:HealthBarTemplate:tooltipj�Asset reference to the template that will be spawned as the health bar. The position of the health bar depends on the position of this script. Commonly, the script's Z position should be adjusted on a per-NPC basis.
�����Ʀ���RedHeartAbilityZ��local trigger = script.parent
local RedHeart = "RedHeart"
local GreenHeart = "GreenHeart"
local WhiteHeart = "WhiteHeart"
local propSoundEffect = script:GetCustomProperty("soundEffect"):WaitForObject()

function OnBeginOverlap(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": Begin Trigger Overlap with " .. other.name)
		end
end

function OnEndOverlap(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": End Trigger Overlap with " .. other.name)
	end
	
end

function OnInteracted(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": Trigger Interacted " .. other.name)
		if (other:GetResource(RedHeart) < 1)
		then 
			other:SetResource(RedHeart, 1)
			other.maxJumpCount = 2
			other:SetResource("hearts", 1)
			propSoundEffect:Play()
		end
	end
end

trigger.beginOverlapEvent:Connect(OnBeginOverlap)
trigger.endOverlapEvent:Connect(OnEndOverlap)
trigger.interactedEvent:Connect(OnInteracted)

�ߎ��깩�Crossbow Impact Surface Alignedb�
� ���ŀʍ��*����ŀʍ��Crossbow Impact Surface Aligned"  �?  �?  �?(�����B2	����ƃ��$Z e  @@pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�����ƃ��$
Impact Geo"
   ��  �?  �?  �?(���ŀʍ��2֮��޻������襬�-z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�֮��޻��Impact Ground Dirt 01 SFX"

��A  ��   �?  �?  �?(����ƃ��$Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�$

�������-5  �?=  aEE  �CXx�*�����襬�-Gun Impact Small VFX"
    �?  �?  �?(����ƃ��$z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ъ���� �
NoneNone
T��ъ����Gun Impact Small VFXR/
VfxBlueprintAssetReffxbp_gun_impact_dirt_sm
b�������-Impact Ground Dirt 01 SFXR9
AudioAssetRef(sfx_bullet_impact_ground_dirt_01_Cue_ref
����ӏ����ChanceToDestroyParentZ��--[[
	Chance to Destroy Parent
	v1.0
	by: standardcombo
	
	A simple script that has a chance to destroy its parent as soon as
	the script initializes.
--]]

local CHANCE = script:GetCustomProperty("ChanceToDestroy")

if math.random() < CHANCE then
	script.parent:Destroy()
end�

cs:ChanceToDestroyeff&?
c
cs:ChanceToDestroy:tooltipjEThe probability the parent object will be destroyed. Between 0 and 1.
�R�ܝ���	SpikeTrapb�Q
�Q �ː����9*��ː����9	SpikeTrap"  �?  �?  �?(�����B2�������½����ӵ�����ڪ��Â	Z,

cs:ActivationTimee   @

	cs:Damagee  �Bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������½SpikeTrapServer"
    �?  �?  �?(�ː����9Z9


cs:Trigger�����ӵ���

cs:SpikeTrap�
�ː����9z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���Ķ���:*�����ӵ���Trigger"
     @   @  �?(�ː����9Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���ڪ��Â	Geo"
    �?  �?  �?(�ː����92���������Ѐ���������������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������Cube"
     @   @  �>(��ڪ��Â	Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
�������� �
 *�Ѐ������SpikeVisuals"
  ��   �?  �?  �?(��ڪ��Â	2����Դ넉��䐲�݇��ǭ��ɘۢ�á���6�껼����3���ծ���m��ވ��ֳ����ށ�Ƿݢԯ���Ǐ�ک�������蟿�E�������ՙ���貫�����뤅�����ē���ě������ԫ������u��ߣ������������2�ǿξŰ�v�Ϧ��ڦ�N����ۆٻ���������f۽���������ײЉ��.ӣ���������ɦ�����㎸����"궪�����e�̓��ž���ʑ�����֪�о���ʏ�����$��Ё�㩚�؞���䘞iś؉������劵����ɐ����ٕ�������,Ԥ��׭��eб����݀����і�nZ z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*����Դ넉Cone"
   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���䐲�݇�Cone"

  ��   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��ǭ��ɘCone"

  H�   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ۢ�á���6Cone"

  ��   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��껼����3Cone"

  �A   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *����ծ���mCone"

  HB   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���ވ��Cone"

  �B   � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ֳ����ށCone"
  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��Ƿݢԯ��Cone"

  ��  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��Ǐ�ک���Cone"

  H�  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�����蟿�ECone"

  ��  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��������ՙCone"

  �A  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *����貫���Cone"

  HB  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���뤅���Cone"

  �B  pA ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���ē��Cone"

  �B  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��ě������Cone"

  ��  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ԫ������uCone"

  H�  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���ߣ����Cone"

  ��  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���������2Cone"

  �A  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��ǿξŰ�vCone"

  HB  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��Ϧ��ڦ�NCone"
  � ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�����ۆٻ�Cone"

  �B  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���������fCone"

  ��  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�۽�������Cone"

  H�  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���ײЉ��.Cone"

  ��  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ӣ�������Cone"

  �A  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���ɦ����Cone"

  HB  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��㎸����"Cone"
  p� ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�궪�����eCone"
   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��̓��ž��Cone"

  ��   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��ʑ�����Cone"

  H�   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�֪�о���Cone"

  ��   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ʏ�����$Cone"

  �A   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���Ё�㩚�Cone"

  HB   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�؞���䘞iCone"

  �B   B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ś؉����Cone"
  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *���劵����Cone"

  ��  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�ɐ����ٕCone"

  H�  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *��������,Cone"

  ��  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�Ԥ��׭��eCone"

  �A  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *�б����݀�Cone"

  HB  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *����і�nCone"

  �B  �B ��L>��L>  �?(Ѐ������Z*
(
ma:Shared_BaseMaterial:id�
������z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������t �
 *����������SpikeTrapClient"
    �?  �?  �?(��ڪ��Â	Zn

	cs:Offsetr  �B


cs:Trigger�����ӵ���

cs:SpikeTrap�
�ː����9

cs:SpikeVisuals�Ѐ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ܧچ�,
NoneNone�7*5Spike trap the damages a all players that stand on it�
�	���ܧچ�,SpikeTrapClientZ�	�	local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local SPIKE_TRAP = script:GetCustomProperty("SpikeTrap"):WaitForObject()
local OFFSET = script:GetCustomProperty("Offset")
local SPIKE_VISUALS = script:GetCustomProperty("SpikeVisuals"):WaitForObject()

local ACTIVATION_TIME = SPIKE_TRAP:GetCustomProperty("ActivationTime")

local isTriggered = false
local startPosZ = SPIKE_VISUALS:GetWorldPosition().z

function OnBeginOverlap(trigger, other)
	if Object.IsValid(other) and other:IsA("Player") and not other.isDead then
		if not isTriggered then
			Task.Wait(ACTIVATION_TIME)
			isTriggered = true
		end
	end
end

function Tick(dt)
	-- Move spike up
	if isTriggered and SPIKE_VISUALS:GetWorldPosition().z - startPosZ < math.abs(OFFSET.z) then
		SPIKE_VISUALS:SetWorldPosition( SPIKE_VISUALS:GetWorldPosition() + Vector3.New(0,0,1) * 800 * dt)
	else
		isTriggered = false
	end
	-- Move spike down
	if not isTriggered and (SPIKE_VISUALS:GetWorldPosition().z - startPosZ) > 2 then
		SPIKE_VISUALS:SetWorldPosition( SPIKE_VISUALS:GetWorldPosition() + Vector3.New(0,0,-1) * 200 * dt)
	end
end

TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

5��������tConeR!
StaticMeshAssetRefsm_cone_001
I������Metal Iron Rusted 02R%
MaterialAssetRefmi_metal_iron_003
����Ķ���:SpikeTrapServerZ��local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local SPIKE_TRAP = script:GetCustomProperty("SpikeTrap"):WaitForObject()

local ACTIVATION_TIME = SPIKE_TRAP:GetCustomProperty("ActivationTime")
local DAMAGE_AMT = SPIKE_TRAP:GetCustomProperty("Damage")

local isTriggered = false

local damage = Damage.New(DAMAGE_AMT)

function OnBeginOverlap(trigger, other)
	if Object.IsValid(other) and other:IsA("Player") then
		if not isTriggered then
			isTriggered = true
			Task.Wait(ACTIVATION_TIME)

			local objects = trigger:GetOverlappingObjects()
			for _, obj in pairs(objects) do
				if Object.IsValid(obj) and obj:IsA("Player") then
					obj:ApplyDamage(damage)
				end
			end	
		end
		isTriggered = false
	end
end

TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

�㾻����
Spike Trapbe
U ��화����*H��화����TemplateBundleDummy"
    �?  �?  �?�Z

��䦒���6
NoneNone��
 518365c43af64a758d28c4536c2e3aff c1e8a85866ac4c7aa318c7ae6dd61093banksii"1.0.0*2Spike trap with kill zone, fits 8m x 8m floor tile
�P��䦒���6
Spike Trapb�P
�P ��������p*���������p
Spike Trap"  �?  �?  �?(�����B2������ɖ�Q��Օ����j󻚫ؒ������֔������ί��3�씶��̂������+���ۤۙ�������������ˊąŷ��ދ�ۓ��o��ٶ��ȕ`ᠧ샿��\��ҁ�������������߻�������߿������Ƴ��������⪟�����������ϛ㏚�=�������ڥ�ȯ�����^��ƃ��̈́��Ŏ�푑�ːİ��߭�����í���ȃ��������ۋ����n��Ⅶ������������ٹ�׶���V����Ӹ�H�������n����������Ď���ؤ��򫣐������ĥ��+z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ɖ�QFantasy Sword Blade 04".
�[�CP(�����@
�{A�8����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Օ����jFantasy Sword Blade 04"3
��hC`�M����@=/n������d�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�󻚫ؒ��Fantasy Sword Blade 04"$

�	CP(���&@��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�����֔���Fantasy Sword Blade 04"3
��B�l� /�?s���P�?� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����ί��3Fantasy Sword Blade 04"3
�[��@l�� /�?s���#��� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��씶��̂�Fantasy Sword Blade 04".
�jB������@
����9����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *������+Fantasy Sword Blade 04"3
 �+A�3[����@=/n��)�f�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����ۤۙ��Fantasy Sword Blade 04")

�@��@dW�
�&@���#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����������Fantasy Sword Blade 04"3
�2�C���� /�?s����C��>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ˊąŷ�Fantasy Sword Blade 04".
H�5C�T�B���@
�%C�<����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��ދ�ۓ��oFantasy Sword Blade 04"3
��oC ŏA���@=/n���C�l�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ٶ��ȕ`Fantasy Sword Blade 04".

��C ��A�&@S�C�J!6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ᠧ샿��\Fantasy Sword Blade 04"3
%C �p� /�?s�����-�) �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ҁ�����Fantasy Sword Blade 04".

 �B RB�&@<�.��{�5��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�������Fantasy Sword Blade 04"3
 ��A ������@=/n���.��k�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���߻�����Fantasy Sword Blade 04".
@��� �B���@
8��:����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���߿���Fantasy Sword Blade 04".
@b�� �iA���@
��%C;����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����Ƴ���Fantasy Sword Blade 04"3
('��@}�����@=/n��9C�l�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *������⪟�Fantasy Sword Blade 04"3
 �F���O� /�?s�����C� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���������Fantasy Sword Blade 04".

 �6�����&@�>Cs�$6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ϛ㏚�=Fantasy Sword Blade 04".
�Y)��|�����@
�1�A�>����#@�03A��#@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��������ڥFantasy Sword Blade 04"3
H���p������@=/n���2A�r�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��ȯ�����^Fantasy Sword Blade 04".

���� �6C�&@{��&�6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ƃ��̈́Fantasy Sword Blade 04"3
@,)��ĲB /�?s����x8�� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Ŏ�푑�Fantasy Sword Blade 04".

�]� z���&@��:��a:5��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ːİ��߭�Fantasy Sword Blade 04"3
�\�����B���@=/n�̅��i�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�����í���Fantasy Sword Blade 04"3
�o�@wC /�?s����E����>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ȃ������Fantasy Sword Blade 04".

pi�C`�C�&@��CF�6��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���ۋ����nFantasy Sword Blade 04"3
hC��'C /�?s���"C��>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Ⅶ���Fantasy Sword Blade 04"3
�OqC`˕C���@=/n��Cm�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *����������Fantasy Sword Blade 04"3
xC iC /�?s�����1C$ �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�ٹ�׶���VFantasy Sword Blade 04"3
 ǗAж�C���@=/n��1C�k�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *�����Ӹ�HFantasy Sword Blade 04"3
�g�� �lC /�?s���<-�� �>��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *��������nFantasy Sword Blade 04".

�]�R�C�&@�v\��d�4��#@�03Ap2;@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���������Fantasy Sword Blade 04"3
 ��A��B���@=/n�w�B%q�@��#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���Ď���ؤFantasy Sword Blade 04"3
`���@S�B���@@�@�ׅBl����#@�03AX�@(��������pZ+
)
ma:Shared_BaseMaterial:id���㥮ג��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ө����088�
 *���򫣐���KillTrigger"$
�<�� =��4��B +��@� A��@(��������pZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����ĥ��+KillZoneServer"$
 ��A ��A9VgC   �?  �?  �?(��������pZA
?
cs:KillTrigger�,���񪑡���������ϼо���� �է�Ŝʟz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����â�b
NoneNone�4*2Spike trap with kill zone, fits 8m x 8m floor tile�
�����â�bKillZoneServerZ��--[[
Copyright 2019 Manticore Games, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom property
local KILL_TRIGGER = script:GetCustomProperty("KillTrigger"):WaitForObject()

-- nil OnBeginOverlap(Trigger, Object)
-- Kills a player when they enter the trigger
function OnBeginOverlap(trigger, other)
    if other:IsA("Player") then
        other:Die()
    end
end

-- Connect trigger overlap event
KILL_TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

�����㻣��BulletClientZ��--[[
Copyright 2019 Manticore Games, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[
	Spawns whizby sound as the projectile flies through a player.
 ]]

 -- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local WHIZBY_SOUND = script:GetCustomProperty("WhizbySound")
local MAX_WHIZBY_DISTANCE = script:GetCustomProperty("MaxWhizbyDistance")

-- Constant variables
local LOCAL_PLAYER = Game.GetLocalPlayer()

Task.Wait()

-- Variables
local lastPosition = COMPONENT_ROOT:GetWorldPosition()

-- Detects when to spawn the whizby sound
function UpdateProjectile()
	local startPosition = lastPosition
	local endPosition = COMPONENT_ROOT:GetWorldPosition()

	if WHIZBY_SOUND then
		local playerStartOffset = LOCAL_PLAYER:GetWorldPosition() - startPosition
		local playerEndOffset = LOCAL_PLAYER:GetWorldPosition() - endPosition
		local shotOffset = endPosition - startPosition

		if playerStartOffset .. shotOffset > 0.0 and playerEndOffset .. shotOffset < 0.0 then
			local cross = playerStartOffset ^ shotOffset
			local perpendicularDistance = cross.size / shotOffset.size

			if perpendicularDistance < MAX_WHIZBY_DISTANCE then
				local closestPoint = startPosition + shotOffset:GetNormalized() * (shotOffset:GetNormalized() .. playerStartOffset)
				World.SpawnAsset(WHIZBY_SOUND, {position = closestPoint})
			end
		end
	end

	lastPosition = endPosition
end

function Tick()
	UpdateProjectile()
end

(��������
Trim Stone���ɝ���- 
V��ɝ���-Stone Trim 01 (default)R/
MaterialAssetRefmi_stone_trims_blend_001_uv
����͙��̮Blankb�
� �ʰ��˺�*��ʰ��˺�Blank"  �?  �?  �?(�����Bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
NoneNone
�����Ã��DestructibleManagerZ��--[[
	Destructible Manager
	by: standardcombo, Chris C.
	v0.9.0
	
	Applies damage to non-player objects.
--]]

-- Registers itself into the global table
local API = {}
_G["standardcombo.NPCKit.DestructibleManager"] = API


local objectList = {}
local IDs = {}

local lastId = 0


function API.GetObjects()
	return objectList
end

function OnDestroyed(obj)
	local theScript = objectList[obj]
	IDs[theScript] = nil
	objectList[obj] = nil
end

function API.Register(theScript)
	local obj = theScript:FindTemplateRoot()
	if (obj == nil) then
		error("DestructibleObjectServer must be part of a template.  "..theScript.name.." is not a template. Maybe it's been deinstanced?")

	elseif (objectList[obj] == nil) then
		obj.destroyEvent:Connect(OnDestroyed)
		objectList[obj] = theScript
		local id = GetIdFor(theScript)
		return id
	else
		error("Multiple DestructibleObject scripts under the same object.  Don't do that.")
	end
	return -1
end

function API.GetRegisteredObject(object)
	local table = nil
	local obj = object:FindTemplateRoot()
	if obj ~= nil then
		return objectList[obj], obj
	end
	return nil, nil
end

function GetIdFor(theScript)
	local id = IDs[theScript]
	if id then
		return id
	end
	lastId = lastId + 1
	id = lastId

	IDs[theScript] = id
	return id
end

function API.DamageObject(object, dmg, source, position, rotation)
	--print("DamageObject() object = " .. tostring(object))

	if object ~= nil and object:IsA("CoreObject") then
		local theScript, obj = API.GetRegisteredObject(object)
		if theScript ~= nil then --and GetObjectTeam(object) ~= GetObjectTeam(source) then
			theScript.context.ApplyDamage(dmg, source, position, rotation)
		end
	end
end


��Ԧغ����Generic Impact Player Effectb�
� �ϲ���Ɲ*��ϲ���ƝClient Context"  �?  �?  �?(�����B2������ӱ�����ڣ�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�������ӱGeneric Player Impact VFX"
    �?  �?  �?(�ϲ���ƝZ

bp:color�
43s?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��;��i�*������ڣ�Bullet Body Impact SFX"
    �?  �?  �?(�ϲ���ƝZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"

�ȷ���Ǖm5  �?=  aEE  �Cx�
NoneNone
M�ȷ���ǕmBullet Body Impact SFXR'
AudioAssetRefsfx_bullet_impact_body
S��;��iGeneric Player Impact VFXR*
VfxBlueprintAssetReffxbp_player_impact
�
��������%Fantasy Candle Lit - Sconce 02 (Prop)b�	
�	 ғ�������*�ғ�������tm_fan_candle_sconce_002_lit_01"  �?  �?  �?(�����B2�ɮ�̋�:�����񛥟z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ɮ�̋�:ClientContext"$
   7@BB�/B   �?  �?  �?(ғ�������2������������������Ŷ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���������Candle Flame VFX"$
T!B [A��@   @@  @@  @@(�ɮ�̋�:z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�������Point Light"

 0p>X��@   �?  �?  �?(�ɮ�̋�:z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�M  �?  �?:?���>%  �?%  �@* 2)  �D  C�]B@8C%   AU @�E]  zD*�����Ŷ���Candle Flame VFX")
�;$�`fA��o@�:3B  @@  @@  @@(�ɮ�̋�:z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *������񛥟	Sconce 02"
    �?  �?  �?(ғ�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����瞞088�
 3
TemplateAssetReftm_fan_candle_sconce_002_lit_01
J�����瞞	Sconce 02R0
StaticMeshAssetRefsm_prop_fantasy_sconce_002
^���خ����Bricks Cobblestone Floor 01R2
MaterialAssetRefmi_brick_cobblestone_floor_001
`�ݚ������Bone Human Pile Straight 01R4
StaticMeshAssetRefsm_bones_human_pile_str_01_ref
L����继��Heart - PolishedR+
StaticMeshAssetRefsm_heart_polished_001
��낵��鏓
FireBlast2b�
� Ф������y*�Ф������y
FireBlast2"  �?  �?  �?(�����B2
���ʀ����Z


cs:Trigger�
����Ǭ�hpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ʀ����	FireBlast"
�B�p=BĆ
B (Ф������y2	��Ĩ����=pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���Ĩ����=FX"
    �?  �?  �?(���ʀ����2���մ��������޹�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����մ���FX"$
�5�@bz��.;A ���=���=���=(��Ĩ����=Z�
(
bp:Volume Type�
mc:evfxvolumetype:2

bp:Emissive Booste���A

bp:Lifee e@
#
bp:Particle Scale Multipliereچ�>


bp:Densitye   A


bp:Gravitye    

bp:Wind Speedr  H�z(
&mc:ecollisionsetting:inheritfromparent�
mc:evisibilitysetting:forceon�

��������Y �*������޹�%Fire Torch Ignite Whoosh Quick 01 SFX"
  �a�>�a�>�a�>(��Ĩ����=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%
��ܑ��쿰5  �?=  ��E  ��Xx�
NoneNone
���А����PlayerStartZ��local propPlayerLight = script:GetCustomProperty("PlayerLight")
function OnPlayerJoined(player)
	print("player joined: " .. player.name)
	--player:SetVisibility(false)
	--print(propPlayerLight.id)
	--local PlayerLight = World.SpawnAsset(propPlayerLight.id)
	--PlayerLight:AttachToPlayer(player, "head")	
	propPlayerLight:AttachToLocalView()
end

function OnPlayerLeft(player)
	print("player left: " .. player.name)
end

-- on player joined/left functions need to be defined before calling event:Connect()
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)

�!��������	QUESTDATAZ� � local jsonString = '[{"id":1,"Name":"Retrieve Edgars Lost Sword","RewardType":2,"RewardValue":"27A474BB3C283372","QuestDescText":"Adventurer I was exploring the old mines to the west when I dropped my sword in the cave below. Would you help find my sword?","QuestCompleteText":"Thank you! Here is a reward for your toubles.","ReqLevel":5,"ResName":"Q1","ResReq":1,"questText":"Find The Lost Sword"},{"id":2,"Name":"A Foxy Problem","RewardType":2,"RewardValue":"F459293E8B4A2BC9","QuestDescText":"The fields are overrun with fox! I will give you coin for each pelt you bring me.","QuestCompleteText":"Pleasure doing business with ya!","ReqLevel":1,"ResName":"Q2","ResReq":15,"questText":"Slay 15 Fox on the Farm"},{"id":3,"Name":"Mothers Den","RewardType":1,"RewardValue":550,"QuestDescText":"Thank you for helping my husband on the farm earlier but, may I request another favor? There is large den just south of the farm. Would you slay the mother of the den?","QuestCompleteText":"I am impressed! Thank you adventure.","ReqLevel":5,"ResName":"Q3","ResReq":1,"questText":"Slay The Mother Fox"},{"id":4,"Name":"Open Season","RewardType":1,"RewardValue":1000,"QuestDescText":"Hello traveler would you be willing to help gather some fox pelts? I will pay you coin for your services.","QuestCompleteText":"Thank you! Here is the coin as promised.","ReqLevel":1,"ResName":"Q4","ResReq":20,"questText":"Slay 20 Fox"},{"id":5,"Name":"Time To Die... Again!","RewardType":1,"RewardValue":6000,"QuestDescText":"Traveler we need your help! The dead walk amongst the living once more. They were spotted to the west at the old mine. Hurry time is of the essence! ","QuestCompleteText":"Thank you! Stone Haven will forever be in your debt.","ReqLevel":5,"ResName":"Q5","ResReq":20,"questText":"Slay 20 Undead"},{"id":6,"Name":"Wanted! Lich King","RewardType":1,"RewardValue":30000,"QuestDescText":"Wanted!","QuestCompleteText":"Bounty Has been Collected","ReqLevel":10,"ResName":"Q6","ResReq":1,"questText":"Slay The Lich King"},{"id":7,"Name":"Ghosts In The Graveyard","RewardType":1,"RewardValue":3000,"QuestDescText":"Wanted ghost exterminator! Hillcrest cemetery is riddled with ghosts sightings. Please take care of the problem.","QuestCompleteText":"Bounty Has been Collected","ReqLevel":5,"ResName":"Q7","ResReq":15,"questText":"Slay 15 Ghostly Apparitions"}]'
------------------------------------
--- DO NOT EDIT BELOW THIS LINE  ---
------------------------------------
QUESTDATA = {}

local json = require(script:GetCustomProperty("jSON"))
local newString = json.decode(jsonString)

--Magic Numbers
local questID = 1
local questName = 2
local rewardType = 3
local rewardValue = 4
local questDescText = 5
local questCompleteText = 6
local reqLevel = 7
local RES_NAME = 8
local RES_REQ = 9
local QUEST_DESC = 10

function QUESTDATA.GetItems()
    local questTable = {}

    for key, item in ipairs(newString) do
        local tempTable = {}
        for index, value in pairs(item) do
            if index == "id" then
                tempTable[questID] = value
            end
            if index == "Name" then
                tempTable[questName] = value
            end
            if index == "RewardType" then
                tempTable[rewardType] = value
            end
            if index == "RewardValue" then
                tempTable[rewardValue] = value
            end
            if index == "QuestDescText" then
                tempTable[questDescText] = value
            end
            if index == "QuestCompleteText" then
                tempTable[questCompleteText] = value
            end
            if index == "ReqLevel" then
                tempTable[reqLevel] = value
            end
            if index == "ResName" then
                tempTable[RES_NAME] = value
            end
            if index == "ResReq" then
                tempTable[RES_REQ] = value
            end
            if index == "questText" then
                tempTable[QUEST_DESC] = value
            end
        end
        questTable[key] = tempTable
    end
    return questTable
end

return QUESTDATA


cs:jSON���������
[��ӡ����Fantasy Castle Floor 01 4mR0
StaticMeshAssetRefsm_ts_fan_cas_floor_001_4m
����菪��Automatic Arrow Trapbf
V ��ע�­��*I��ע�­��TemplateBundleDummy"
    �?  �?  �?�Z
ќ������
NoneNone��
 0cdc5c8816d9453cb2c9f81eba2dd96e c7306b5515514d95bd7ff6fb2be11343Iscender"1.0.0*9I modified the arrow trap by LanaLux to shoot automaticly
������֩��ResourceDisplayClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local PANEL = script:GetCustomProperty("Panel"):WaitForObject()
local PROGRESS_BAR = script:GetCustomProperty("ProgressBar"):WaitForObject()
local TEXT_BOX = script:GetCustomProperty("TextBox"):WaitForObject()

-- User exposed properties
local RESOURCE_NAME = COMPONENT_ROOT:GetCustomProperty("ResourceName")
local ALWAYS_SHOW = COMPONENT_ROOT:GetCustomProperty("AlwaysShow")
local POPUP_DURATION = COMPONENT_ROOT:GetCustomProperty("PopupDuration")
local MAX_VALUE = COMPONENT_ROOT:GetCustomProperty("MaxValue")
local SHOW_PROGRESS_BAR = COMPONENT_ROOT:GetCustomProperty("ShowProgressBar")
local SHOW_TEXT = COMPONENT_ROOT:GetCustomProperty("ShowText")
local SHOW_MAX_IN_TEXT = COMPONENT_ROOT:GetCustomProperty("ShowMaxInText")

-- Check user properties
if RESOURCE_NAME == "" then
    error("ResourceName required")
end

if SHOW_PROGRESS_BAR and MAX_VALUE == 0 then
    warn("MaxValue (non-zero) required for ShowProgressBar")
    SHOW_PROGRESS_BAR = false
end

if SHOW_MAX_IN_TEXT and (not SHOW_TEXT or MAX_VALUE == 0) then
    warn("ShowMaxInText requires both ShowText and non-zero MaxValue")
    SHOW_MAX_IN_TEXT = false
end

-- Constants
local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local lastChangeTime = 0.0
local lastResource = 0

-- nil Tick(float)
-- Check for changes to our resource and update UI
function Tick(deltaTime)
    local resource = LOCAL_PLAYER:GetResource(RESOURCE_NAME)

    -- Update things if our resource changed
    if resource ~= lastResource then
        lastChangeTime = time()
        lastResource = resource
        PANEL.visibility = Visibility.INHERIT

        if SHOW_PROGRESS_BAR then
            PROGRESS_BAR.progress = resource / MAX_VALUE
        end

        if SHOW_TEXT then
            if SHOW_MAX_IN_TEXT then
                TEXT_BOX.text = string.format("%d / %d", resource, MAX_VALUE)
            else
                TEXT_BOX.text = string.format("%d", resource)
            end
        end
    end

    -- Hide the ui if it's been long enough and we aren't always showing
    if not ALWAYS_SHOW then
        if time() > lastChangeTime + POPUP_DURATION then
            PANEL.visibility = Visibility.FORCE_OFF
        end
    end
end

-- Initialize
if not SHOW_PROGRESS_BAR then
    PROGRESS_BAR.visibility = Visibility.FORCE_OFF
end

if not SHOW_TEXT then
    TEXT_BOX.visibility = Visibility.FORCE_OFF
end

if not ALWAYS_SHOW then
    PANEL.visibility = Visibility.FORCE_OFF
end

if ALWAYS_SHOW then
    PROGRESS_BAR.progress = 0.0
    TEXT_BOX.text = "0"
end

�鶽Ъ����FireTrapAutomaticb�
� ��������*���������FireTrapAutomatic"  �?  �?  �?(�����B2ӓ������f����І��՘�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ӓ������f
FireSwitch"$
 ����1�-:B�_A����qC (��������Z�

cs:FirePosition�
��������1

cs:FireBlast������ϳ��
!
cs:FirePositionTop�
���лՠ�


cs:DirP 

cs:FireBlast2�
�������;

cs:BlastDuratione  �@pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ä�����T*�����І�FireTrap")
,�����[�@��  �?  �?  �?(��������2$Ҳ������&��������1���Ӯ���j�А��呶gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ҳ������&ClientContext"$
���@rg���hEA   �?  �?  �?(����І�2	��㼂º�.z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���㼂º�.Geo"
    �?  �?  �?(Ҳ������&2���߮���t�����ˬPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����߮���tBase"
�I�A   �?U>?>�k�?(��㼂º�.Z+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *������ˬPSkull"

�I���b B �<@�<@�<@(��㼂º�.Z+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�皙�ח��088�
 *���������1Position"$
����s�w��>B   �?  �?  �?(����І�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Position*����Ӯ���j	StartFire"
r�������B  (����І�Z]

cs:DamageAmounte  �B


cs:Trigger�
�А��呶g

cs:FireSwitch�
ӓ������f


cs:DirPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������N*��А��呶gTrigger"$
4&�@A�+C ,�B   �?�Ԟ@  �?(����І�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*��՘�����FireTrapTop")
,���  �B@��  �?  �?  �?(��������2&��ۢ���c���лՠ��Ҏ����������ì���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ۢ���cClientContext"$
���@wg���hEA   �?  �?  �?(�՘�����2	������ĎKz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�������ĎKGeo"
    �?  �?  �?(��ۢ���c2���ڭ�����͌�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ڭ����Base"$
 ��7�I�A@��   �?U>?>�k�?(������ĎKZ+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *��͌�����Skull"

�I���b B �<@�<@�<@(������ĎKZ+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�皙�ח��088�
 *����лՠ�Position"$
A��s�w��>B   �?  �?  �?(�՘�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Position*��Ҏ������	StartFire"
8Rc� ����B  (�՘�����Zd

cs:DamageAmounte  �B


cs:Trigger�����ì���

cs:FireSwitch�
ӓ������f

cs:FireOnTopPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������N*�����ì���Trigger"$
���@�,C ,�B   �?�Ԟ@  �?(�՘�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box
NoneNone�T*RI modified the original fire trap by LanaLux toswitch after a given period of time�
�	��������N	StartFireZ�	�	local fireTrigger = script:GetCustomProperty("Trigger"):WaitForObject()
local DAMAGE_AMT = script:GetCustomProperty("DamageAmount")
local switchScript = script:GetCustomProperty("FireSwitch"):WaitForObject()
local damage = Damage.New(DAMAGE_AMT)
local fireOnTop = script:GetCustomProperty("FireOnTop")

function OnBeginOverlap(fireTrigger, other)
	if other:IsA("Player") then
		local fireOnLocal = switchScript.context.fireOn
		if fireOnTop then
			if Object.IsValid(other) and other:IsA("Player") and not fireOnLocal then
				UI.PrintToScreen("OVERLAPPING")		
				local objects = fireTrigger:GetOverlappingObjects()
				for _, obj in pairs(objects) do
					if Object.IsValid(obj) and obj:IsA("Player") then
						obj:ApplyDamage(damage)
					end
				end	
			end
		else 
			if Object.IsValid(other) and other:IsA("Player") and fireOnLocal then
				UI.PrintToScreen("OVERLAPPING")		
				local objects = fireTrigger:GetOverlappingObjects()
				for _, obj in pairs(objects) do
					if Object.IsValid(obj) and obj:IsA("Player") then
						obj:ApplyDamage(damage)
					end
				end	
			end
		end
	end
end
fireTrigger.beginOverlapEvent:Connect(OnBeginOverlap)
	
U�皙�ח��Bone Human Skull 01R1
StaticMeshAssetRefsm_bones_human_skull_01_ref
T���������Rock Obsidian 01R3
MaterialAssetRefmi_fresnel_rock_obsidian_001_uv
��������;
FireBlast2b�
� Ф������y*�Ф������y
FireBlast2"  �?  �?  �?(�����B2
���ʀ����Z


cs:Trigger�
����Ǭ�hpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ʀ����	FireBlast"
�B�p=BĆ
B (Ф������y2	��Ĩ����=pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���Ĩ����=FX"
    �?  �?  �?(���ʀ����2���մ��������޹�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����մ���FX"$
�5�@bz��.;A ���=���=���=(��Ĩ����=Z�
(
bp:Volume Type�
mc:evfxvolumetype:2

bp:Emissive Booste���A

bp:Lifee e@
#
bp:Particle Scale Multipliereچ�>


bp:Densitye   A


bp:Gravitye    

bp:Wind Speedr  H�z(
&mc:ecollisionsetting:inheritfromparent�
mc:evisibilitysetting:forceon�

��������Y �*������޹�%Fire Torch Ignite Whoosh Quick 01 SFX"
  �a�>�a�>�a�>(��Ĩ����=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%
��ܑ��쿰5  �?=  ��E  ��Xx�
NoneNone
�	�ä�����T
FireSwitchZ�	�	--Dependencies
local firePosObj = script:GetCustomProperty("FirePosition"):WaitForObject()
local firePosTopObj = script:GetCustomProperty("FirePositionTop"):WaitForObject()

local firePos = firePosObj:GetWorldPosition()
local firePosTop = firePosTopObj:GetWorldPosition()

local fireBlast = script:GetCustomProperty("FireBlast")

local spawnedFire = nil
local spawnedFireTop = nil

local duration = script:GetCustomProperty("BlastDuration")

fireOn = false


--this function changes which fireblast is active after an intervall of time
local function Switch()

	--if the bottom fire is on, we activate the top fire
	if fireOn == true then				
		
		spawnedFireTop = World.SpawnAsset(fireBlast, {position = firePosTop})
		
		if spawnedFire ~=  nil then
			spawnedFire:Destroy()
		end
	--if the top fire is on, we activate the bottom fire
	else
	
		spawnedFire = World.SpawnAsset(fireBlast, {position = firePos})
		
		if spawnedFireTop ~= nil then
			spawnedFireTop:Destroy()
		end
	end
	fireOn = not fireOn
	
	--we wait the given duration, before we switch again
	Task.Wait(duration)
	Switch()
	
end

Switch()

��е�ݰ���Crossbow Reload Soundb�
� �ӽ���b*��ӽ���bCrossbow Reload Sound"  �?  �?  �?(�����B2������������ȅ����Z e  @@pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������Crossbow Arrow Bolt Load 01 SFX"
    �?  �?  �?(�ӽ���bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%
��ɼհ��5  �?=  ��E  ��Xx�*����ȅ����#Crossbow Draw Pull Back Load 01 SFX"
    �?  �?  �?(�ӽ���bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%
��ꊽ��ö5���>=  ��E  ��Xx�
NoneNone
q��ꊽ��ö#Crossbow Draw Pull Back Load 01 SFXR=
AudioAssetRef,sfx_crossbow_draw_pull_back_load_01a_Cue_ref
i��ɼհ��Crossbow Arrow Bolt Load 01 SFXR9
AudioAssetRef(sfx_crossbow_arrow_bolt_load_01a_Cue_ref
����������Sky Nighttime 01b�
� �������ѽ*��������ѽSky Nighttime 01"  �?  �?  �?(�����B2/�ٖ�����y���ѧ���N����Ԗ��͂������Х����?Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ٖ�����yEnvironment Fog Default VFX"$
��0�����ꒌ�   �?  �?  �?(�������ѽZI
!
bp:Color� ��>�%�>UU	?%  �?


bp:Falloffe   ?


bp:Opacitye   ?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�â�����*����ѧ���NSky Dome")
  H�  ��  �B�s�B  �?  �?  �?(�������ѽZ�
&
bp:Cloud Shape�
mc:ecloudshapes:3
)
bp:Horizon Color�q > �0>��j>%��>
(
bp:Zenith Color��2�<���<  @=%[d;>
'
bp:Cloud Color���?ë??  �?%  �?
,
bp:Cloud Wisp Color�  �?  �?  �?%  �?
$
 bp:Use Sun Color for Cloud ColorP 

bp:Cloud Rim Brightnesse   B
!
bp:Cloud Detail Brightnesse   @

bp:Background CloudsP 

bp:Cloud Opacitye  �?
&
bp:Haze Color��>̸%>��*>%  �?
 
bp:Cloud Ambient Color�%  �?
!
bp:Sky Influence On Cloudse  �?
,
bp:High Cloud Color�  �?  �?  �?%  �?

bp:Haze Falloffe  �A

bp:High Cloud Opacitye���=

bp:High Cloud Speede��>

bp:High Cloud Brightnesse  �?
7
bp:High Cloud Index�
mc:ehighaltitudecloudshapes:1
 
bp:High Cloud Noise Scalee��L>

bp:Cloud Wisp Speede  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����ƺm*�����Ԗ��	Sun Light".

  H�  �C���Gu�@_�@  �?  �?  �?(�������ѽZ�

bp:Intensitye  �?
'
bp:Light Color�{.?��M?  �?%  �?

bp:Light Shaft BloomP 
!
bp:Light Shaft Bloom Scalee   @
%
bp:Light Shaft Bloom Thresholde   ?
2
bp:Light Shaft Bloom Tint��?��`?  �?%  �?

bp:Use TemperatureP 
*
bp:Sun Disc Color���=  �=@�=%  �?

bp:Sizee   A
"
bp:Shape�
mc:esundiscshapes:4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*�͂�����Skylight"

  zC  �C   �?  �?  �?(�������ѽZA

bp:IndexX
1
bp:Ambient Image�
mc:eambientcubemapssmall:5z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����*��Х����?	Star Dome"
    �?  �?  �?(�������ѽZ�

bp:Star Brightness e  �?

bp:Twinkle Mask Speede   ?

bp:Twinkle MaskX 

bp:Star AppearanceX 

bp:Star Tiling Densitye  �@

bp:Real StarsP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
㸆���ا�$
TemplateAssetRefSky_Nighttime_01
?㸆���ا�	Star DomeR%
BlueprintAssetRefCORESKY_StarDome
>�����SkylightR%
BlueprintAssetRefCORESKY_Skylight
?���������	Sun LightR%
BlueprintAssetRefCORESKY_SunLight
8�����ƺmSky DomeR 
BlueprintAssetRefCORESKY_Sky
T�â�����Environment Fog Default VFXR)
BlueprintAssetReffxbp_env_fog_default
e�������ˈ Fantasy Castle Stairs 01 - 150cmR4
StaticMeshAssetRefsm_ts_fan_cas_stairs_001_150cm
]̓�Вт��Fantasy Ability Teal 005	R4
PlatformBrushAssetRefUI_Fantasy_Ability_Teal_005
����؉�̭�Crossbow & string trapbc
S ������g*G������gTemplateBundleDummy"
    �?  �?  �?�Z

��������/
NoneNone��
 2c90f7bea4d5489c881477505f87fb37 23aefd0445e14eb4b5c51b5e1a0a2a9dJustAnotherDevv"1.0.0*4When string is activated crossbow shoots the player.
�P��������/
StringTrapb�O
�O ݫ�ڶ��
*�ݫ�ڶ��

StringTrap"  �?  �?  �?(�����B28�Ȗ����j������������š��������������˲����뒗�ȁ�Z.

cs:HealthChangee  �?

cs:ChangeRatee  �?pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
StringTrap*��Ȗ����jGeo"
    �?  �?  �?(ݫ�ڶ��
2���Ӈ蓌��վ�������������G��ƈ���� �텲���������������������ʢ����ĵť������ę������ꆲ�H޿�����������Ά���֓�ڿ�����򳬣���Ӏ���ɵl�����������顢��G�ͯ���5pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Geo*���Ӈ蓌�
StringMesh"
 
���B���B��L=��L=   A(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
��л����mpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��վ�����Cube - Rounded Bottom-Aligned"

  �C  H� ���=   ?  @?(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����·��*088�
 *���������GGear - generic large two-spoked"
 ��C���B��L>��L>��L>(�Ȗ����jpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *���ƈ���� Gear - generic large two-spoked")
 ��C �TA������B��L>��L>��L>(�Ȗ����jpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *��텲�����Gear - generic large two-spoked")
 ��C \�@�D�����B��L>��L>��L>(�Ȗ����jpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
仸�覣�088�
 *����������
StringMesh".
p!�C ��@d���
���B���B���<���<�}�<(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
ݑ������ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��������ʢHelix - 0.75"3
З�C  >��^@OϭB��3���3����=���=���=(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
��ͽ����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ö���ɰ088�
 *�����ĵť�Helix - 0.75"3
�ٲC  >��D@OϭB��3���3����=���=���=(�Ȗ����jZ+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ö���ɰ088�
 *������ę��Helix - 0.75"3
P�C  >`+@OϭB��3���3����=���=���=(�Ȗ����jZ+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ö���ɰ088�
 *�����ꆲ�HHelix - 0.75"3
 ��  ��`+@�̭B"я:��3����=���=���=(�Ȗ����jZ+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ö���ɰ088�
 *�޿�������Helix - 0.75"3
З�� �~���^@�̭B"я:��3����=���=���=(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
��ͽ����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ö���ɰ088�
 *�����Ά���Helix - 0.75"3
�ٷ�  ���D@�̭B"я:��3����=���=���=(�Ȗ����jZ+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ö���ɰ088�
 *�֓�ڿ���Cube - Rounded Bottom-Aligned"$

  ��  H���3����=   ?  @?(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����·��*088�
 *���򳬣���Gear - generic large two-spoked")
 ��C ���P����B��L>��L>��L>(�Ȗ����jpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *�Ӏ���ɵlGear - generic large two-spoked")
 ��C �9� �����B���>��L>���>(�Ȗ����jpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ħ����C088�
 *���������Pipe - 90-Degree Short"$
��C ����? ���=���=���=(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ʥ�ʕ���088�
 *����顢��GPipe"$
`�C }��`ː� ���=���=��L>(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ſ��088�
 *��ͯ���5Pipe - 90-Degree Short")
 �C R������  �B���=���=���=(�Ȗ����jZ*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ʥ�ʕ���088�
 *���������Trigger"
    �@���=���=(ݫ�ڶ��
pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�����š��Advanced Crossbow"$

 @��  p����B��?��?  �?(ݫ�ڶ��
2
�������Z�

cs:BaseDamagee  �B

cs:HeadshotDamagee  C

cs:EnableAutoReloadP

cs:EnableAimP
"
cs:AimBindingjability_secondary
)
cs:AimActiveStancej2hand_rifle_aim_hip
 
cs:AimWalkSpeedPercentagee���>

cs:AimZoomDistancee  HC

cs:SpreadStandPrecisione333?

cs:SpreadWalkPrecisione   ?

cs:SpreadJumpPrecisione���>

cs:SpreadCrouchPrecisione��L?
 
cs:SpreadSlidingPrecisione���>
 
cs:SpreadAimModifierBonuse���>

cs:PickupSound���������

cs:LowAmmoSound�
������3
"
cs:ReticleTemplate����暽��

cs:HideReticleOnAimP 
Q
cs:BaseDamage:tooltipj8Normal damage that this weapon will do to enemy players.
W
cs:HeadshotDamage:tooltipj:Headshot damage that this weapon will do to enemy players.
�
cs:AimBinding:tooltipjyKeybinding to hold and activate scope / zoom ability for the weapon. Default is "ability_secondary" (right mouse button).
{
!cs:AimWalkSpeedPercentage:tooltipjVPercentage walk speed reduction when player is aiming. Must be in the range of 0 to 1.
q
cs:AimActiveStance:tooltipjSAnimation stance when aiming with this weapon. Default is 2hand_rifle_aim_shoulder.
:
cs:AimZoomDistance:tooltipjCamera distance when aiming.
z
!cs:SpreadAimModifierBonus:tooltipjUAmount of % added to the spread precision when the player aims. Range between 0 to 1.
�
cs:SpreadStandPrecision:tooltipjqPrecision % when the player is standing without aim. Range between 0 to 1 (from least accurate to most accurate).
�
cs:SpreadWalkPrecision:tooltipjdPrecision % when the player is walking. Range between 0 to 1 (from least accurate to most accurate).
�
cs:SpreadJumpPrecision:tooltipjdPrecision % when the player is jumping. Range between 0 to 1 (from least accurate to most accurate).
�
 cs:SpreadCrouchPrecision:tooltipjfPrecision % when the player is crouching. Range between 0 to 1 (from least accurate to most accurate).
�
!cs:SpreadSlidingPrecision:tooltipjdPrecision % when the player is sliding. Range between 0 to 1 (from least accurate to most accurate).
�
cs:EnableAutoReload:tooltipj�If true the weapon the player will auto reload the ammo without player's input. Only reloads if the player has the ammo resource.
5
cs:EnableAim:tooltipjEnable aiming for the weapon.pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��

right_prop
��Ֆ��w��

󦺋��δ
������� 
���͗�ؐ"ߎ��깩�(2

  �B  �A:2hand_rifle_stanceB��Ӵ�����J�е�ݰ���R2hand_rifle_shootZ�������`j
��������p}  �?�  �>� P�G�
�֞���0�
mc:ereticletype:none��rounds��  zE�  �A�  HB�  �?����?�  �@���ī�ˉ���������*��������Client Context"
    �?  �?  �?(����š��2	棠����tZ pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *�棠����tGeo"
   �? �?  �?(�������2/љ��������ܻ�����썆����ƛ�ɦ��U�ʀ�鼖|Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�љ�������Fantasy Crossbow Bow 01"$
x��B �o>�bRA   �?  �?  �?(棠����tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�飙��ز08(�
 *��ܻ����Fantasy Crossbow Foregrip 01"

�DB(rA   �?  �?  �?(棠����tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ό؈���08(�
 *��썆����Fantasy Crossbow Grip 01"

 F�?�eA   �?  �?  �?(棠����tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ӫ���ܗ�08(�
 *�ƛ�ɦ��UFantasy Crossbow Stirrup 01"$

�B(rA����  �?  �?  �?(棠����tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ѻ�08(�
 *��ʀ�鼖|Fantasy Crossbow Stock 01"

 �]���A   �?  �?  �?(棠����tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������J08(�
 *���������ClientContext"
    �?  �?  �?(ݫ�ڶ��
pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�����˲��ShotArrowScript"
    �?  �?  �?(ݫ�ڶ��
Z�

cs:ComponentRoot�
ݫ�ڶ��



cs:Trigger�
��������
&
cs:FantasyCrossbowBolt���뒗�ȁ�
$
cs:CrossbowHitTrigger�
���ģ��#pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ϭ��*���뒗�ȁ�Fantasy Crossbow Bolt 01"$

 ���("A���B  �?  �?  �?(ݫ�ڶ��
2��Κ�������ģ��#pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

؇��򦔨.08(�
 *���Κ����Basic Projectile Trail VFX"
 ����  �?  �?  �?(��뒗�ȁ�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
悜������ �*����ģ��#CrossbowHitTrigger"$

 �A  �7������L=  @?��L=(��뒗�ȁ�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box
NoneNone�6*4When string is activated crossbow shoots the player.�
^悜������Basic Projectile Trail VFXR3
VfxBlueprintAssetReffxbp_basic_projectile_trail
Z������JFantasy Crossbow Stock 01R1
StaticMeshAssetRefsm_weap_fan_stock_cross_001
_������Ѻ�Fantasy Crossbow Stirrup 01R3
StaticMeshAssetRefsm_weap_fan_stirrup_cross_001
XӪ���ܗ�Fantasy Crossbow Grip 01R0
StaticMeshAssetRefsm_weap_fan_grip_cross_001
a�ό؈���Fantasy Crossbow Foregrip 01R4
StaticMeshAssetRefsm_weap_fan_foregrip_cross_001
W�飙��زFantasy Crossbow Bow 01R/
StaticMeshAssetRefsm_weap_fan_bow_cross_001
�������3Generic Low Ammo Soundb�
� ��ԙ�����*���ԙ�����Generic Low Ammo Sound"  �?  �?  �?(�����B2	��ᙈ鼾?Z e   @pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���ᙈ鼾?Low Ammo Sound"
    �?  �?  �?(��ԙ�����Z1
/
bp:Type�#
!mc:esfx_gunshot_assaultrifle_ak:8z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

���񵲼�Z�-  �B5��L?=  aEE  �C
NoneNone
o���񵲼�Z#Gunshot Assualt Rifle AK Set 01 SFX
R<
AudioBlueprintAssetRef"sfxabp_gunshot_assaultrifle_ak_ref
��֞���0Generic Impact Player Effectb�
� �ϲ���Ɲ*��ϲ���ƝGeneric Impact Player Effect"  �?  �?  �?(�����B2������ӱ�����ڣ�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�������ӱGeneric Player Impact VFX"
    �?  �?  �?(�ϲ���ƝZ

bp:color�
43s?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��;��i�*������ڣ�Bullet Body Impact SFX"
    �?  �?  �?(�ϲ���ƝZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"

�ȷ���Ǖm5  �?=  aEE  �Cx�
NoneNone
����͗�ؐGeneric Trailb�
� �᧷�����*��᧷�����Generic Trail"  �?  �?  �?(�����B2	�愯���nZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��愯���nBasic Projectile Trail VFX"
    �?  �?  �?(�᧷�����Zs
"
	bp:colorB�  �?  �?  �?%  �?
#
bp:Particle Scale Multipliere���>

bp:Lifee��L>

bp:Emissive Booste   ?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
悜�������
NoneNone
�������� Crossbow Muzzle Flashb�
� �����틲�*������틲�Crossbow Muzzle Flash"  �?  �?  �?(�����B2��ࣔ�����ʎ������Z e  �?pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���ࣔ����+Recurve Bow Fire Release Arrow Light 01 SFX"
    �?  �?  �?(�����틲�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�#
�����궳5  �?=  ��E  ��x�*��ʎ������+Recurve Bow Fire Release Arrow Heavy 01 SFX"
    �?  �?  �?(�����틲�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�#
���������5  �?=  ��E  ��x�
NoneNone
������궳+Recurve Bow Fire Release Arrow Light 01 SFXRF
AudioAssetRef5sfx_recurve_bow_fire_release_arrow_light_01a_Cue1_ref
�󦺋��δGeneric Bulletb�
� �ʼ�����*��ʼ�����Generic Bullet"  �?  �?  �?(�����B2�����������ԁ�ס�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������Bullet"
    �?  �?  �?(�ʼ�����Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
����آ߯�08(�
 *���ԁ�ס�BulletClient"
    �?  �?  �?(�ʼ�����Z^
 
cs:ComponentRoot������Ĕ�

cs:WhizbySound�
Ɣþ����I

cs:MaxWhizbyDistancee  zDz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����㻣��
NoneNone
�Ɣþ����IWhizby Soundb�
� ⋂�ȱ��*�⋂�ȱ��Whizby Sound"  �?  �?  �?(�����BZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!

����űȪ5  �?=  zEXx�
NoneNone
c����űȪ'Gunshot Bullet Flyby Passby Whiz 02 SFXR,
AudioAssetRefsfx_bullet_flyby_02_Cue_ref
b����آ߯�Modern Weapon - Bullet 01R8
StaticMeshAssetRef"sm_weap_modern_ammo_bullet_tip_001
6�����ſ��PipeR!
StaticMeshAssetRefsm_pipe_001
P�ʥ�ʕ���Pipe - 90-Degree ShortR)
StaticMeshAssetRefsm_pipe_curve90_001
U�Ħ����CGear - generic small solidR+
StaticMeshAssetRefsm_gen_gear_small_001
[��������Metal Diamond Plates 01R3
MaterialAssetRefmi_metal_rust_diamond-plate_001
G��ͽ����Metal Grates 02R(
MaterialAssetRefmi_scf_grates_004_uv
?��ö���ɰHelix - 0.75R"
StaticMeshAssetRefsm_helix_004
Xݑ������ Weapon - Basic Metal Darker�,ԁ������; 

color����=���=���=%  �?
Dԁ������;Metal Basic 01R&
MaterialAssetRefmi_metal_basic_001
^仸�覣� Gear - generic large four-spokedR-
StaticMeshAssetRefsm_gen_gear_001_spoke4x
Z���������Gear - generic smallR5
StaticMeshAssetRefsm_gen_gear_small_001_thin-hole
]���������Gear - generic large two-spokedR-
StaticMeshAssetRefsm_gen_gear_001_spoke2x
V����·��*Cube - Rounded Bottom-AlignedR)
StaticMeshAssetRefsm_cube_rounded_001
J��л����mWood Raw WhiteR,
MaterialAssetRefmi_wood_raw_white_001_uv
=��������CylinderR%
StaticMeshAssetRefsm_cylinder_002
�������⬁AnimatedMeshCostumeZ��--[[
	Animated Mesh Costume
	v1.0
	by: standardcombo
	
	Attaches objects to an NPC to customize its visuals.
	
	Automatically detects the animated mesh object that should be setup as
	its sibling in the hierarchy.
	
	Automatically detects siblings with names that match socket names on the
	animated mesh and attaches those groups to the mesh sockets.
	E.g. A group named "head" will attach to the animated mesh's head.
	
	Expects the animated mesh to be in the "bind" stance as the template is
	spawned. If the animated mesh is not in the "bind" stance, then
	attachments will appear out of place.
--]]

local MESH = script.parent:FindDescendantByType("AnimatedMesh")

local allObjects = script.parent:GetChildren()

for _,obj in ipairs(allObjects) do
	if obj:IsA("Folder") then
		local socketName = obj.name
		local pos = obj:GetWorldPosition()
		local rot = obj:GetWorldRotation()
		
		MESH:AttachCoreObject(obj, socketName)
		
		obj:SetWorldPosition(pos)
		obj:SetWorldRotation(rot)
	end
end
G����ӣ���Carpet Tile 01R(
StaticMeshAssetRefsm_carpet_tile_001
R��Е����|Fantasy Castle Wall 03R,
StaticMeshAssetRefsm_ts_fan_cas_wall_003
������ϊ�|	Headlightb�
� ڈ���򩯧*�ڈ���򩯧HeadlightParent"  �?  �?  �?(�ϴ�����v2	������Ez
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *Q������E	Headlight"
    �?  �?  �?(ڈ���򩯧2�����ԓ�����ζ�D�*������ԓ�attachflashlight"
    �?  �?  �?(������Ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ǚ�ؠ�t*�����ζ�Dflashlight001"
    �?  �?  �?(������Ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�~�MB  �?  �?  �?%  �?%  �@* 2Z  �EI#E"B  �A  �A%   A(5n��@=���AB%
#mc:espotlightprofile:basicspotlightU @�E]  zD
NoneNone��*�A light and a script that attaches it to the players head.  No Model.  Very simple template.  Add anywhere to level and it makes player have a headlight.  �
���Ǚ�ؠ�tattachflashlightZ��local flashlight001 = World.FindObjectByName("flashlight001")
flashlight001:AttachToLocalView()
--[[
local flashlight002 = World.FindObjectByName("flashlight002")
local light = World.SpawnAsset(flashlight002)

function OnPlayerJoined(player)
	flashlight002:AttachToPlayer(player, "head")
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
--]]
���ͽ����zWorking Headlight for Playerbc
S �������a*G�������aTemplateBundleDummy"
    �?  �?  �?�Z

�����ϊ�|
NoneNone��
 189ff2d9a9e246f39d8d1063be5f2c91 b516062f912c499c9e2678bdfc7e0af0debrebeuf01"1.0.0*�A light and a script that attaches it to the players head.  No Model.  Very simple template.  Add anywhere to level and it makes player have a headlight.  
�����ߧ��xNPCAIClientZ��--[[
	NPCAI - Client
	by: standardcombo
	v0.9.0
	
	The client counterpart for NPCAIServer. Controls the visuals of the NPC based on
	changes to its networked properties.
--]]

local ROOT = script:GetCustomProperty("Root"):WaitForObject()
local GEO_ROOT = script:GetCustomProperty("GeoRoot"):WaitForObject()

local MOVE_SPEED = ROOT:GetCustomProperty("MoveSpeed")
local TURN_SPEED = ROOT:GetCustomProperty("TurnSpeed")

local SLEEPING_ART = script:GetCustomProperty("Sleeping"):WaitForObject()
local ENGAGING_ART = script:GetCustomProperty("Engaging"):WaitForObject()
local ATTACKING_ART = script:GetCustomProperty("Attacking"):WaitForObject()
local PATROLLING_ART = script:GetCustomProperty("Patrolling"):WaitForObject()
local DEAD_ART = script:GetCustomProperty("Dead"):WaitForObject()
local FORWARD_NODE = script:GetCustomProperty("ForwardNode"):WaitForObject()

local STATE_SLEEPING = 0
local STATE_ENGAGING = 1
local STATE_ATTACK_CAST = 2
local STATE_ATTACK_RECOVERY = 3
local STATE_PATROLLING = 4
local STATE_LOOKING_AROUND = 5
local STATE_DEAD_1 = 6
local STATE_DEAD_2 = 7
local STATE_DISABLED = 8

local lastPosition = ROOT:GetWorldPosition()


function GetCurrentState()
	return ROOT:GetCustomProperty("CurrentState")
end

function GetHealth()
	return ROOT:GetCustomProperty("CurrentHealth")
end

local lastHealth = GetHealth()


function UpdateArt(state)
	SLEEPING_ART.visibility = Visibility.FORCE_OFF
	ENGAGING_ART.visibility = Visibility.FORCE_OFF
	ATTACKING_ART.visibility = Visibility.FORCE_OFF
	PATROLLING_ART.visibility = Visibility.FORCE_OFF
	DEAD_ART.visibility = Visibility.FORCE_OFF
	
	if (state == STATE_SLEEPING) then
		SLEEPING_ART.visibility = Visibility.INHERIT
		
	elseif (state == STATE_ENGAGING) then
		ENGAGING_ART.visibility = Visibility.INHERIT
		
	elseif (state == STATE_ATTACK_CAST or state == STATE_ATTACK_RECOVERY) then
		ATTACKING_ART.visibility = Visibility.INHERIT
		
	elseif (state == STATE_PATROLLING or state == STATE_LOOKING_AROUND) then
		PATROLLING_ART.visibility = Visibility.INHERIT
		
	else
		DEAD_ART.visibility = Visibility.INHERIT
	end
end
UpdateArt(GetCurrentState())


function OnPropertyChanged(object, propertyName)
	
	if (propertyName == "CurrentState") then
		UpdateArt(GetCurrentState())
		
	elseif (propertyName == "CurrentHealth") then
		local health = GetHealth()
		--
	end
end
ROOT.networkedPropertyChangedEvent:Connect(OnPropertyChanged)


function OnDestroyed(obj)
	GEO_ROOT:StopMove()
	GEO_ROOT:StopRotate()
	GEO_ROOT:Destroy()
end
ROOT.destroyEvent:Connect(OnDestroyed)


GEO_ROOT.parent = nil
GEO_ROOT:Follow(script, MOVE_SPEED)
GEO_ROOT:LookAtContinuous(FORWARD_NODE, true, TURN_SPEED)

�

cs:Root� 

cs:ForwardNode� 


cs:GeoRoot� 

cs:Sleeping� 

cs:Engaging� 

cs:Attacking� 

cs:Patrolling� 

cs:Dead� 
n
cs:Root:tooltipj[A reference to the root of the template, where most of the NPC's custom properties are set.
i
cs:ForwardNode:tooltipjOA Core Object in the client context that indicates the forward/face of the NPC.
�
cs:GeoRoot:tooltipj�The group under which is all the artwork for the NPC. At runtime it becomes detached from the whole template to avoid the network jitter and produce smooth movement of the NPC's visual parts.
H
cs:Sleeping:tooltipj1Group to keep visibile while the NPC is sleeping.
d
cs:Engaging:tooltipjMGroup to keep visibile while the NPC is moving towards and engaging an enemy.
T
cs:Attacking:tooltipj<Group to keep visibile while the NPC is executing an attack.
^
cs:Patrolling:tooltipjEGroup to keep visibile while the NPC is patrolling between waypoints.
A
cs:Dead:tooltipj.Group to keep visibile while the NPC is dying.
�	���ɲ���xGeneric Impact Surface Alignedb�	
�	 ��ІŔ��V*���ІŔ��VClient Context"  �?  �?  �?(�����B2%ذ��Ǩ.������������ݤ���`����Ǔ͐oZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�ذ��Ǩ.Decal Bullet Damage Stone"$
   ��=���)��A���=���=���=(��ІŔ��VZ+

bp:Fade Delaye  �@

bp:Fade Timee   @z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�������� *����������Impact Ground Dirt 01 SFX"
   ��  �?  �?  �?(��ІŔ��VZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�$

�������-5  �?=  aEE  �CXx�*����ݤ���`Gun Impact Small VFX"
   ��  �?  �?  �?(��ІŔ��VZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ъ�����*�����Ǔ͐oImpact Sparks VFX"
   �����>���>���>(��ІŔ��VZ�


bp:Densitye���>
#
bp:Particle Scale Multipliere   @
%
bp:Spark Line Scale Multipliere  �?

bp:Enable HotspotP

bp:Enable FlashP

bp:Enable Spark LinesP

bp:Enable SparksPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� �
NoneNone
L���������Impact Sparks VFXR*
VfxBlueprintAssetReffxbp_impact_sparks
]�������Decal Bullet Damage StoneR3
DecalBlueprintAssetRefbp_decal_bullet_stone_001
���������q
Nameplatesb�
� 縠������*�縠������
Nameplates"  �?  �?  �?(��������2
���ă߉��Z�

cs:ShowNamesP

cs:ShowHealthbarsP

cs:ShowOnSelfP

cs:ShowOnTeammatesP
 
cs:MaxDistanceOnTeammatese    

cs:ShowOnEnemiesP

cs:MaxDistanceOnEnemiese  �D

cs:ShowOnDeadPlayersP 

cs:Scalee  �?

cs:ShowNumbersP

cs:AnimateChangesP

cs:ChangeAnimationTimee���>

cs:ShowSegmentsP 

cs:SegmentSizee  �A
(
cs:FriendlyNameColor��>�=�Q8?%  �?
 
cs:EnemyNameColor�
hf�>%  �?
'
cs:BorderColor�Y94<Y94<Y94<%  �?
+
cs:BackgroundColor��>�>�>%  �?
*
cs:FriendlyHealthColor��>�=�Q8?%  �?
"
cs:EnemyHealthColor�
  �?%  �?
(
cs:DamageChangeColor�>
?�
>%  �?
&
cs:HealChangeColor��A�=�k?%  �?
-
cs:HealthNumberColor�  �?  �?  �?%  �?
a
cs:ShowNames:tooltipjIShow names as part of the nameplate. Default names are hidden either way.
=
cs:ShowOnSelf:tooltipj$Show a nameplate on the local player
:
cs:ShowOnTeammates:tooltipjShow nameplates on teammates
z
!cs:MaxDistanceOnTeammates:tooltipjUOnly show nameplates on teammates up to this distance away. 0 means always show them.
6
cs:ShowOnEnemies:tooltipjShow nameplates on enemies
v
cs:MaxDistanceOnEnemies:tooltipjSOnly show nameplates on enemies up to this distance away. 0 means always show them.
D
cs:ShowOnDeadPlayers:tooltipj$Show nameplates even on dead players
7
cs:Scale:tooltipj#Overall scale factor for nameplates
H
cs:ShowNumbers:tooltipj.Show numerical value for hitpoints and maximum
P
cs:AnimateChanges:tooltipj3Show animated region when a player's health changes
D
cs:ChangeAnimationTime:tooltipj"Duration of animated health change
A
cs:FriendlyNameColor:tooltipj!Name color for teammates and self
3
cs:EnemyNameColor:tooltipjName color for enemies
)
cs:BorderColor:tooltipjColor of border
D
cs:BackgroundColor:tooltipj&Color of space where health is missing
?
cs:FriendlyHealthColor:tooltipjColor of friendly health bars
9
cs:EnemyHealthColor:tooltipjColor of enemy health bars
G
cs:DamageChangeColor:tooltipj'Color for damage when animating changes
D
cs:HealChangeColor:tooltipj&Color for heals when animating changes
;
cs:HealthNumberColor:tooltipjColor of health number text
>
cs:ShowHealthbars:tooltipj!Whether to show healthbars at allz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ă߉��ClientContext"
    �?  �?  �?(縠������2	�������4Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��������4NameplateControllerClient"
    �?  �?  �?(���ă߉��Z�

cs:API����ʮ�Ɗ�
 
cs:ComponentRoot�縠������
#
cs:NameplateTemplate�
��ݽ�ԉF
*
cs:SegmentSeparatorTemplate�
��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ͅ宐ד�
TemplateAssetRef
Nameplates
���������Helper_SegmentSeparatorb�
� �ί�����*��ί�����ChicletSeparator"  �?  �?  �?(�����BZa
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?
(
ma:Shared_BaseMaterial:id�
��¬�Jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 
NoneNone
5������FCubeR!
StaticMeshAssetRefsm_cube_002
���ݽ�ԉFHelper_Nameplateb�
� �������*��������Helper_Nameplate"  �?  �?  �?(�����۬ǯ28ӵ����Ο	��������ׯ�����^�뒩���ׯ�ʛ��ְ�(㇐�����9Z�

cs:BorderPiece�
ӵ����Ο	
"
cs:BackgroundPiece���������

cs:HealthPiece�
ׯ�����^

cs:ChangePiece��뒩���ׯ

cs:HealthText�
�ʛ��ְ�(

cs:NameText�
㇐�����9z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�ӵ����Ο	BorderPiece"
    �?  �?  �?(�������Za
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?
(
ma:Shared_BaseMaterial:id�
��¬�Jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F08 8�
 *���������BackgroundPiece"
    �?  �?  �?(�������Za
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?
(
ma:Shared_BaseMaterial:id�
��¬�Jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F08 8�
 *�ׯ�����^HealthPiece"
    �?  �?  �?(�������Za
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?
(
ma:Shared_BaseMaterial:id�
��¬�Jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F08 8�
 *��뒩���ׯChangePiece"
    �?  �?  �?(�������Za
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?
(
ma:Shared_BaseMaterial:id�
��¬�Jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F08 8�
 *��ʛ��ְ�(
HealthText"
  ���>���>���>(�������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�m
HELLO WORLD  �?  �?  �?%  �?2$
"mc:ecoretexthorizontalalign:center:"
 mc:ecoretextverticalalign:center*�㇐�����9NameText"
  �A   �?  �?  �?(�������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�m
HELLO WORLD  �?  �?  �?%  �?2$
"mc:ecoretexthorizontalalign:center:"
 mc:ecoretextverticalalign:center
NoneNone
D����򬂁oChest Small OpenedR"
StaticMeshAssetRefsm_chest_002
�ړ������jTeleporterServerZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()

-- User exposed properties
local TARGET = COMPONENT_ROOT:GetCustomProperty("Target"):WaitForObject()
local DESTINATION_OFFSET = COMPONENT_ROOT:GetCustomProperty("DestinationOffset")
local TELEPORTER_COOLDOWN = COMPONENT_ROOT:GetCustomProperty("TeleporterCooldown")
local PER_PLAYER_COOLDOWN = COMPONENT_ROOT:GetCustomProperty("PerPlayerCooldown")

-- Check user properties
if TELEPORTER_COOLDOWN < 0.0 then
    warn("TeleporterCooldown cannot be negative")
    TELEPORTER_COOLDOWN = 0.0
end

if PER_PLAYER_COOLDOWN < 0.0 then
    warn("PerPlayerCooldown cannot be negative")
    PER_PLAYER_COOLDOWN = 0.0
end

-- Variables
local useTime = 0.0

-- nil OnBeginOverlap(Trigger, Object)
-- Teleport any player who touches this
function OnBeginOverlap(trigger, other)
	-- Make sure we don't enter an infinite loop
	if _G.TeleporterServer.isTeleporting then
		return
	end

	if useTime + TELEPORTER_COOLDOWN > time() then
		return
	end

	if other.serverUserData.TeleporterServer_TeleportTime then
		if other.serverUserData.TeleporterServer_TeleportTime + PER_PLAYER_COOLDOWN > time() then
			return
		end
	end

	_G.TeleporterServer.isTeleporting = true

	local destinationPosition = DESTINATION_OFFSET

	if TARGET then
		destinationPosition = destinationPosition + TARGET:GetWorldPosition()
	end

	other:SetWorldPosition(destinationPosition)

	Events.BroadcastToAllPlayers("PlayerTeleport_Internal", COMPONENT_ROOT:GetWorldPosition(), destinationPosition)

	useTime = time()
	other.serverUserData.TeleporterServer_TeleportTime = time()
	
	_G.TeleporterServer.isTeleporting = false
end

-- Initialize
TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

if not _G.TeleporterServer then
	_G.TeleporterServer = {}
	_G.TeleporterServer.isTeleporting = false
end

9����ֱۡhAmethystR!
MaterialAssetReffxmi_amethyst
X�������dBone Human Ribcage 01R3
StaticMeshAssetRefsm_bones_human_ribcage_01_ref
�������ǅb	Kill Zoneb�
� ��Η��*���Η��	Kill Zone"  �?  �?  �?(�������ɒ2�������ϼ���푈�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������ϼKillTrigger"
    �?  �?  �?(��Η��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����푈�KillZoneServer"
  ��   �?  �?  �?(��Η��Z 

cs:KillTrigger��������ϼz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ޠ���6
TemplateAssetRef	Kill_Zone
����ޠ���6KillZoneServerZ��--[[
Copyright 2019 Manticore Games, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom property
local KILL_TRIGGER = script:GetCustomProperty("KillTrigger"):WaitForObject()

-- nil OnBeginOverlap(Trigger, Object)
-- Kills a player when they enter the trigger
function OnBeginOverlap(trigger, other)
    if other:IsA("Player") then
        other:Die()
    end
end

-- Connect trigger overlap event
KILL_TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

���������`Resource Displayb�
� �қ©���*��қ©���Resource Display"  �?  �?  �?(��������2	����ه޺Z�

cs:ResourceNamejGems

cs:AlwaysShowP 

cs:PopupDuratione   @

cs:MaxValueX

cs:ShowProgressBarP 

cs:ShowTextP

cs:ShowMaxInTextP 
1
cs:ResourceName:tooltipjWhich resource to show
l
cs:AlwaysShow:tooltipjSWhether to always show, or just for a short duration whenever that resource changes
V
cs:PopupDuration:tooltipj:If not AlwaysShow, how long to show when there is a change
K
cs:MaxValue:tooltipj4The maximum value of this resource (or 0 for no max)
K
cs:ShowProgressBar:tooltipj-Whether to show a progress bar (requires max)
E
cs:ShowText:tooltipj.Whether to show text showing the current value
d
cs:ShowMaxInText:tooltipjHWhether to show the maximum in the text (requires ShowText and MaxValue)z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ه޺Client Context"
    �?  �?  �?(�қ©���2�������Ԉ����֏|Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��������ԈResourceDisplayClient"
    �?  �?  �?(����ه޺Zw
 
cs:ComponentRoot��қ©���

cs:Panel�
��В�ǻ�

cs:ProgressBar��֌�����


cs:TextBox��������Ļz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����֩��*�����֏|ResourceDisplayContainer"
    �?  �?  �?(����ه޺2	��В�ǻ�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*���В�ǻ�Panel"
    �?  �?  �?(����֏|2����ل����֌������������ĻZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�id}%  H�-  HB:

mc:euianchor:middlecenter� �6


mc:euianchor:topright

mc:euianchor:topright*�����ل���
Background"
    �?  �?  �?(��В�ǻ�2
��������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�tdd:

mc:euianchor:middlecenter�

ؿ���ώH%��L>�8


mc:euianchor:topcenter

mc:euianchor:topcenter*���������Icon"
    �?  �?  �?(����ل���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��FF:

mc:euianchor:middlecenter�#
ը�΁������t?z�>k>)<%  �?�>


mc:euianchor:middlecenter

mc:euianchor:middlecenter*��֌�����ProgressBar"
    �?  �?  �?(��В�ǻ�Z z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff��d:

mc:euianchor:middlecenter�,
��t?z�>k>)<%  �?   ?   ?   ?%  �?�>


mc:euianchor:bottomcenter

mc:euianchor:bottomcenter*��������ĻText"
    �?  �?  �?(��В�ǻ�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent��d:

mc:euianchor:middlecenter�A
Resource Text  �?  �?  �?%  �?
"
mc:etextjustify:center�>


mc:euianchor:bottomcenter

mc:euianchor:bottomcenter$
TemplateAssetRefResource_Display
<ը�΁����	Icon Gold	R"
PlatformBrushAssetRef	Icon_Gold
���������^TeamScoreDisplayClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties --
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local TEXT_BOX = script:GetCustomProperty("TextBox"):WaitForObject()

-- User exposed properties --
local TEAM = COMPONENT_ROOT:GetCustomProperty("Team")
local LABEL = COMPONENT_ROOT:GetCustomProperty("Label")
local SHOW_MAX_SCORE = COMPONENT_ROOT:GetCustomProperty("ShowMaxScore")
local MAX_SCORE = COMPONENT_ROOT:GetCustomProperty("MaxScore")

-- Check user properties
if TEAM < 0 or TEAM > 4 then
    warn("Team must be a valid team number (0-4)")
    TEAM = 1
end

if SHOW_MAX_SCORE and MAX_SCORE <= 0 then
    warn("MaxScore must be a positive")
    MAX_SCORE = 5
end

-- nil Tick(float)
-- Update the display
function Tick(deltaTime)
    local score = Game.GetTeamScore(TEAM)
    
    if SHOW_MAX_SCORE then
        TEXT_BOX.text = string.format("%s %d / %d", LABEL, score, MAX_SCORE)
    else
        TEXT_BOX.text = string.format("%s %d", LABEL, score)
    end
end

^��������^Bone Human Skull Pile 02R6
StaticMeshAssetRef sm_bones_human_skull_pile_02_ref
���Ӆ����[	Fire Trapbc
S ��������=*G��������=TemplateBundleDummy"
    �?  �?  �?�Z

���҆��D
NoneNone��
 a0c088fc7fe74070afd01431558f98bc 4201c90059e44d1e97e36e2c7bac5a23LanaLux"1.0.0*aFlick the switch to change which skull the fire is coming out of. Walk under it or jump over it. 
�'���҆��DFireTrapb�&
�& ������ؐ�*�������ؐ�FireTrap"  �?  �?  �?(�����B2������������������������\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������
FireSwitch")
����$+�   A@����Gn>�Gn>�Gn>(������ؐ�2&���蠕ث~�؉�ɋ�/��ڷ��������������Z*
(
ma:Building_WallInner:id����������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *����蠕ث~Geo"$
4v�B�t���C��   �?  �?  �?(�������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��؉�ɋ�/Cube - bottom aligned")
2v�B#/���C����3CG-@Ą!?�d�@(�������Z+
)
ma:Shared_BaseMaterial:id����������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *���ڷ�����Cube - bottom aligned"3
5v�Bu���C  @�  ��qCZD?��?��?(�������2
�ǭ���♼Z+
)
ma:Shared_BaseMaterial:id����������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *��ǭ���♼
FireSwitch"
   (��ڷ�����Z�


cs:Trigger����������

cs:FirePosition�
�����͘�i

cs:FireBlast��٧��Ҍ��

cs:TriggerTop�
������}
!
cs:FirePositionTop�
�̊��㞮


cs:DirP 

cs:FireBlast2��낵��鏓pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���Ɓ����*����������Trigger")
�_C҅rC�dc���3C턉@턉@턉@(�������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� "08*
mc:etriggershape:box*����������FireTrap")
,�����[�@��  �?  �?  �?(������ؐ�2&���π�鿋�����͘�i������ÿm̬�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����π�鿋ClientContext"$
���@rg���hEA   �?  �?  �?(���������2	�����ڒ�Zz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *������ڒ�ZGeo"
    �?  �?  �?(���π�鿋2��ߊ߯�m�¶��ꞩHz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ߊ߯�mBase"
�I�A   �?U>?>�k�?(�����ڒ�ZZ+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *��¶��ꞩHSkull"

�I���b B �<@�<@�<@(�����ڒ�ZZ+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�皙�ח��088�
 *������͘�iPosition"$
����s�w��>B   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Position*�������ÿm	StartFire"
r�������B  (���������Z_

cs:DamageAmounte  �B


cs:Trigger�̬�������

cs:FireSwitch��ǭ���♼


cs:DirPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ƒ���ңJ*�̬�������Trigger"$
4&�@A�+C ,�B   �?�Ԟ@  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���������\FireTrapTop")
,���h�C@��  �?  �?  �?(������ؐ�2%�ñ͏��؏�̊��㞮���ɢ܋�T������}z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ñ͏��؏ClientContext"$
���@wg���hEA   �?  �?  �?(��������\2	��������#z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���������#Geo"
    �?  �?  �?(�ñ͏��؏2����������Ό���ڌ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Base"
�I�A   �?U>?>�k�?(��������#Z+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ġ����088�
 *��Ό���ڌ�Skull"

�I���b B �<@�<@�<@(��������#Z+
)
ma:Shared_BaseMaterial:id����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�皙�ח��088�
 *��̊��㞮Position"$
A��s�w��>B   �?  �?  �?(��������\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Position*����ɢ܋�T	StartFire"
8Rc� ����B  (��������\Zd

cs:DamageAmounte  �B


cs:Trigger�
������}

cs:FireSwitch��ǭ���♼

cs:FireOnTopPz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ƒ���ңJ*�������}Trigger"$
���@�,C ,�B   �?�Ԟ@  �?(��������\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box
NoneNone�c*aFlick the switch to change which skull the fire is coming out of. Walk under it or jump over it. �
�	�Ƒ���ңJ	StartFireZ�	�	local fireTrigger = script:GetCustomProperty("Trigger"):WaitForObject()
local DAMAGE_AMT = script:GetCustomProperty("DamageAmount")
local switchScript = script:GetCustomProperty("FireSwitch"):WaitForObject()
local damage = Damage.New(DAMAGE_AMT)
local fireOnTop = script:GetCustomProperty("FireOnTop")

function OnBeginOverlap(fireTrigger, other)
	if other:IsA("Player") then
		local fireOnLocal = switchScript.context.fireOn
		if fireOnTop then
			if Object.IsValid(other) and other:IsA("Player") and not fireOnLocal then
				UI.PrintToScreen("OVERLAPPING")		
				local objects = fireTrigger:GetOverlappingObjects()
				for _, obj in pairs(objects) do
					if Object.IsValid(obj) and obj:IsA("Player") then
						obj:ApplyDamage(damage)
					end
				end	
			end
		else 
			if Object.IsValid(other) and other:IsA("Player") and fireOnLocal then
				UI.PrintToScreen("OVERLAPPING")		
				local objects = fireTrigger:GetOverlappingObjects()
				for _, obj in pairs(objects) do
					if Object.IsValid(obj) and obj:IsA("Player") then
						obj:ApplyDamage(damage)
					end
				end	
			end
		end
	end
end
fireTrigger.beginOverlapEvent:Connect(OnBeginOverlap)
	
j���������!Whitebox Wall 01 Doorway 01 FrameR8
StaticMeshAssetRef"sm_gen_whitebox_wall_001_doorframe
���ى���XPlayerSettingStartZ��local RedHeart = "RedHeart"
local GreenHeart = "GreenHeart"
local WhiteHeart = "WhiteHeart"
local hearts = "hearts"

function OnPlayerJoined(player)
	print("player joined: " .. player.name)
	player.canMount = false
	player:SetResource(RedHeart, 0)
	player:SetResource(GreenHeart, 0)
	player:SetResource(WhiteHeart, 0)
	player:SetResource(hearts, 0)
	--player:SetResource(RedHeart, 0)
end

function OnPlayerLeft(player)
	print("player left: " .. player.name)
end

-- on player joined/left functions need to be defined before calling event:Connect()
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)

���������U
Spike Trapb�
� յ��ı��=*�յ��ı��=TemplateBundleDummy"
    �?  �?  �?Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Z
�ܝ���
NoneNone��
 e5c529170c0d44108ccff52ba4d46764 5d708a5162584aa2874f913b4a02652f	codeHeavy"1.0.0*5Spike trap the damages a all players that stand on it
i��㓦ø�Q Magic Bright Light Reveal 01 SFXR9
AudioAssetRef(sfx_magic_bright_light_reveal_01_Cue_ref
Qա����ȫPGem SpinZ97script.parent:RotateContinuous(Rotation.New(0, 0, 200))
H��ۣ����O*Custom Base Material from Heart - Polished�����ҸԴ� 
L����ҸԴ�Heart (Default)R,
MaterialAssetRefmi_heart_polished_001_uv
�<���ï�ٞODoubleDoorControllerServerZ�<�<--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[
Doors operate in the relative space of the root of the component. In that space, they rotate around the Z axis, and the
default closed state has the door along the YZ plane. If the door auto-opens, we only care if someone is standing in the
way to prevent closing. If it is manually opened and closed, we care if someone is in range of the door to operate it.

This broadcasts custom events DoorOpened(CoreObject) and DoorClosed(CoreObject)
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local ROTATION_ROOT1 = script:GetCustomProperty("RotationRoot1"):WaitForObject()
local ROTATING_TRIGGER1 = script:GetCustomProperty("RotatingTrigger1"):WaitForObject()
local ROTATION_ROOT2 = script:GetCustomProperty("RotationRoot2"):WaitForObject()
local ROTATING_TRIGGER2 = script:GetCustomProperty("RotatingTrigger2"):WaitForObject()
local STATIC_TRIGGER1 = script:GetCustomProperty("StaticTrigger1"):WaitForObject()
local STATIC_TRIGGER2 = script:GetCustomProperty("StaticTrigger2"):WaitForObject()

-- User exposed properties
local AUTO_OPEN = COMPONENT_ROOT:GetCustomProperty("AutoOpen")
local TIME_OPEN = COMPONENT_ROOT:GetCustomProperty("TimeOpen")		-- Only used with AutoOpen
local OPEN_LABEL = COMPONENT_ROOT:GetCustomProperty("OpenLabel")	-- Only used without AutoOpen
local CLOSE_LABEL = COMPONENT_ROOT:GetCustomProperty("CloseLabel")	-- Only used without AutoOpen
local SPEED = COMPONENT_ROOT:GetCustomProperty("Speed")
local RESET_ON_ROUND_START = COMPONENT_ROOT:GetCustomProperty("ResetOnRoundStart")

-- Check user properties
if TIME_OPEN < 0.0 then
    warn("TimeOpen cannot be negative")
    TIME_OPEN = 0.0
end

if SPEED <= 0.0 then
    warn("Speed must be positive")
    SPEED = 450.0
end

-- Constants
local USE_DEBOUNCE_TIME = 0.2			-- Time after using that a player can't use again

-- Variables
-- Rotation is 1.0 for +90 degree rotation, 0.0 for closed, -1.0, for -90 degree rotation
local targetDoorRotation = 0.0
local playerLastUseTimes = {}			-- Player -> float
local autoCloseTime = 0.0

-- float GetDoorRotation()
-- Gives you the current rotation of the door
function GetDoorRotation()
	return ROTATION_ROOT1:GetRotation().z / 90.0
end

-- nil SetCurrentRotation(float)
-- Snap instantly to the given rotation
function SetCurrentRotation(rotation)
	targetDoorRotation = rotation
	ROTATION_ROOT1:SetRotation(Rotation.New(0.0, 0.0, 90.0 * rotation))
	ROTATION_ROOT2:SetRotation(Rotation.New(0.0, 0.0, -90.0 * rotation))
end

-- nil SetTargetRotation(float)
-- Sets the rotation that the door should move to (at SPEED)
function SetTargetRotation(rotation)
	targetDoorRotation = rotation
	ROTATION_ROOT1:RotateTo(Rotation.New(0.0, 0.0, 90.0 * rotation), 90.0 * math.abs(targetDoorRotation - GetDoorRotation()) / SPEED, true)
	ROTATION_ROOT2:RotateTo(Rotation.New(0.0, 0.0, -90.0 * rotation), 90.0 * math.abs(targetDoorRotation - GetDoorRotation()) / SPEED, true)
end

-- nil ResetDoor()
-- Instantly snaps the door to the closed state
function ResetDoor()
	SetCurrentRotation(0.0)
end

-- nil OpenDoor(Player)
-- Opens the door away from the given player
function OpenDoor(player, trigger)
	local rotationRoot = nil

	if trigger == ROTATING_TRIGGER1 or trigger == STATIC_TRIGGER1 then
		rotationRoot = ROTATION_ROOT1
	else
		rotationRoot = ROTATION_ROOT2
	end

	local geoQuaternion = Quaternion.New(rotationRoot:GetWorldRotation())
	local relativeX = geoQuaternion:GetForwardVector()
	local playerOffset = player:GetWorldPosition() - rotationRoot:GetWorldPosition()

	-- Figure out which direction is away from the player
	if playerOffset .. relativeX > 0.0 then
		SetTargetRotation(1.0)
	else
		SetTargetRotation(-1.0)
	end

	Events.Broadcast("DoorOpened", COMPONENT_ROOT)
end

-- nil CloseDoor()
-- Closes the door, even if it was only partially open
function CloseDoor()
	SetTargetRotation(0.0)
end

-- nil OnBeginOverlap(Trigger, CoreObject)
-- Handles the player overlapping if AutoOpen is true
function OnBeginOverlap(trigger, other)
	if other:IsA("Player") then
		if GetDoorRotation() == 0.0 then							-- Can't auto open if the door isn't closed
			OpenDoor(other, trigger)

			autoCloseTime = time() + TIME_OPEN
		end
	end
end

-- nil OnInteracted(Trigger, CoreObject)
-- Handles the player using the door if AutoOpen is false
function OnInteracted(trigger, player)
	if playerLastUseTimes[player] and playerLastUseTimes[player] + USE_DEBOUNCE_TIME > time() then
		return
	end

	playerLastUseTimes[player] = time()

	if GetDoorRotation() == 0.0 then								-- Door is closed
		OpenDoor(player, trigger)

		ROTATING_TRIGGER1.interactionLabel = CLOSE_LABEL
		ROTATING_TRIGGER2.interactionLabel = CLOSE_LABEL
	else															-- Door is open or moving, clsoe it
		CloseDoor()
	end
end

-- nil OnRoundStart()
-- Handles the roundStartEvent
function OnRoundStart()
	ResetDoor()
end

-- nil Tick(float)
-- Handle closing the door with AutoOpen, and changing interaction label back to open
function Tick(deltaTime)
	if AUTO_OPEN and targetDoorRotation ~= 0.0 then
		for _, player in pairs(Game.GetPlayers()) do				-- Don't close the door if someone is standing in it
			if STATIC_TRIGGER1:IsOverlapping(player) or STATIC_TRIGGER2:IsOverlapping(player) then
				autoCloseTime = time() + TIME_OPEN					-- and delay closing
				return
			end
		end

		if autoCloseTime > time() then
			return
		end

		CloseDoor()
	end

	if targetDoorRotation == 0.0 and GetDoorRotation() == 0.0 then
		if not AUTO_OPEN then
			ROTATING_TRIGGER1.interactionLabel = OPEN_LABEL
			ROTATING_TRIGGER2.interactionLabel = OPEN_LABEL
		end

		Events.Broadcast("DoorClosed", COMPONENT_ROOT)
	end
end

-- Initialize
if AUTO_OPEN then
	STATIC_TRIGGER1.beginOverlapEvent:Connect(OnBeginOverlap)
	STATIC_TRIGGER2.beginOverlapEvent:Connect(OnBeginOverlap)
	STATIC_TRIGGER1.isInteractable = false
	STATIC_TRIGGER2.isInteractable = false

	for _, player in pairs(Game.GetPlayers()) do
		if STATIC_TRIGGER1:IsOverlapping(player) then
			OnBeginOverlap(STATIC_TRIGGER1, player)
		end

		if STATIC_TRIGGER2:IsOverlapping(player) then
			OnBeginOverlap(STATIC_TRIGGER2, player)
		end
	end
else
	ROTATING_TRIGGER1.interactedEvent:Connect(OnInteracted)
	ROTATING_TRIGGER2.interactedEvent:Connect(OnInteracted)
	ROTATING_TRIGGER1.isInteractable = true
	ROTATING_TRIGGER2.isInteractable = true
end

if RESET_ON_ROUND_START then
	Game.roundStartEvent:Connect(OnRoundStart)
end

���������IFantasy Castle 01b��
�� ������ԍ�*�������ԍ�Fantasy Castle 01"  �?  �?  �?(�����B2��Ջ�ƪռ����⅞������������������������´���翵җ�I������҄�������Ӵ̷�����ڟ����官��������N��̧����K������ߒ���߯����@˚��ۚ��@�����꟏*�ş�Ϧ�꩚��οƱ�㿉�Ў����ڧ����ݤ镇���������������ߘ��O�����Ջ����⦍�a����������ݨ����T�������������������疷����ƽ����4��������Q�ߥ������󛽮������������Ⱦ�����)�ݩ����zz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Ջ�ƪռ�Floor Level"

  ��  HC   �?  �?  �?(������ԍ�2����쁷�������߻��菖������̥湃㯋����+ᬚ�����!�گ�����N�̿�����D��˼�����������ż������П��ȱ��2܄�������������~������Ǝ�ˈ�����ʸ��������־���������������¶����א֋��윔������:��忓ǭ�7��ٻϡ���Ľ������������ܝ�<��������|��Ӻ𺜊��ǽ�ݭ�g��������Ē����䩹�񛽻:�줽���ė�������������v�����9z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����쁷���Fantasy Castle Floor 01 - 8m"

  ��  �D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����߻Fantasy Castle Floor 01 - 8m"

  ��  D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���菖����Fantasy Castle Floor 01 - 8m"

  ��  z�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���̥湃Fantasy Castle Floor 01 - 8m"

  ��  H�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�㯋����+Fantasy Castle Floor 01 - 8m"

  �� �	E   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�ᬚ�����!Fantasy Castle Floor 01 - 8m"

  ��  ��   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��گ�����NFantasy Castle Floor 01 - 8m"

  ��  ��   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��̿�����DFantasy Castle Floor 01 - 8m"

  ��  z�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���˼����Fantasy Castle Floor 01 - 8m"

  ��  H�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������Fantasy Castle Floor 01 - 8m"

  ��  D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��ż������Fantasy Castle Floor 01 - 8m"

  ��  �D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�П��ȱ��2Fantasy Castle Floor 01 - 8m"

  �� �	E   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�܄������Fantasy Castle Floor 01 - 8m"

  ��  �D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��������~Fantasy Castle Floor 01 - 8m"

  ��  D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������Fantasy Castle Floor 01 - 8m"

  ��  z�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��Ǝ�ˈ��Fantasy Castle Floor 01 - 8m"

  ��  H�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����ʸ����Fantasy Castle Floor 01 - 8m"

  �� �	E   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����־���Fantasy Castle Floor 01 - 8m"

  ��  ��   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����������Fantasy Castle Floor 01 - 8m"

@��C  ��   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����¶����Fantasy Castle Floor 01 - 8m"

  �C  z�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�א֋��윔Fantasy Castle Floor 01 - 8m"

  �C  H�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������:Fantasy Castle Floor 01 - 8m"

  �C  D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���忓ǭ�7Fantasy Castle Floor 01 - 8m"

  �C  �D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���ٻϡ���Fantasy Castle Floor 01 - 8m"

  �C �	E   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�Ľ�������Fantasy Castle Floor 01 - 8m"

  �D  �D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������ܝ�<Fantasy Castle Floor 01 - 8m"

  �D  D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������|Fantasy Castle Floor 01 - 8m"

  �D  z�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���Ӻ𺜊�Fantasy Castle Floor 01 - 8m"

  �D  H�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��ǽ�ݭ�gFantasy Castle Floor 01 - 8m"

  �D �	E   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��������Fantasy Castle Floor 01 - 8m"

  �D  ��   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��Ē����Fantasy Castle Floor 01 - 8m"

  �D  ��   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�䩹�񛽻:Fantasy Castle Floor 01 - 8m"

  �D  z�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��줽���ėFantasy Castle Floor 01 - 8m"

  �D  H�   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������Fantasy Castle Floor 01 - 8m"

  �D  D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������vFantasy Castle Floor 01 - 8m"

  �D  �D   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������9Fantasy Castle Floor 01 - 8m"

  �D �	E   �?  �?  �?(�Ջ�ƪռ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����⅞���Doors"

  z�  HD   �?  �?  �?(������ԍ�2.ܓ������L�ܹ�����������Ֆ%��������ŏ���ӡ�.z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ܓ������L
Front Door"$
  �D  u� �^D   �?  �?  �?(���⅞���2%׶������A��ޮӾ��<�������������Ђ�[Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�׶������AServerContext"
    �?  �?  �?(ܓ������L2󡚎�����֯��ߙ�����⮢�cZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�󡚎�����DoubleDoorControllerServer"
    �?  �?  �?(׶������AZ�

cs:ComponentRoot�
ܓ������L
 
cs:RotationRoot1����������
"
cs:RotatingTrigger1�
�����⻊

cs:RotationRoot2�
����Ђ�[
#
cs:RotatingTrigger2���˭�񭡊
!
cs:StaticTrigger1�֯��ߙ��
 
cs:StaticTrigger2�
���⮢�cz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ï�ٞO*�֯��ߙ��StaticTrigger1"

  �B  C   �?ff�?  @@(׶������AZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����⮢�cStaticTrigger2"$

  �C  C�.�6  �?ff�?  @@(׶������AZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���ޮӾ��<ClientContext"
  /C   �?  �?  �?(ܓ������L21ŋ��Ŧ���������������װ�ݝ���ߟ螠��������DZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�ŋ��Ŧ���DoubleDoorControllerClient"
    �?  �?  �?(��ޮӾ��<Z�

cs:RotationRoot����������

cs:OpenSound1����������

cs:CloseSound1����װ�ݝ�

cs:OpenSound2���ߟ螠�

cs:CloseSound2�
�������Dz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ς����*����������Helper_DoorOpenSound"
  ��   �?  �?  �?(��ޮӾ��<Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*����װ�ݝ�Helper_DoorCloseSound"
  ��   �?  �?  �?(��ޮӾ��<ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*���ߟ螠�Helper_DoorOpenSound"$

  �C  ���.�  �?  �?  �?(��ޮӾ��<Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��������DHelper_DoorCloseSound"$

  �C  ���.�  �?  �?  �?(��ޮӾ��<ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*����������RotationRoot1"
    �?  �?  �?(ܓ������L2��˻���ؿ�����⻊Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���˻���ؿGeo_StaticContext"
    �?  �?  �?(���������2	�����%Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������%Fantasy Castle Door 02"
 ���B  �?  �?  �?(��˻���ؿz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
盁֞����088�
 *������⻊RotatingTrigger1"

  �B  C   �?ff�?  @@(���������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�����Ђ�[RotationRoot2"
  �C   �?  �?  �?(ܓ������L2ګ���ĵ����˭�񭡊Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ګ���ĵ��Geo_StaticContext"
   4C  �?  �?  �?(����Ђ�[2	ᐬ߀ܲ�AZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ᐬ߀ܲ�AFantasy Castle Door 02"
 ���B  �?  �?  �?(ګ���ĵ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
盁֞����088�
 *���˭�񭡊RotatingTrigger2"$

  ��  C��3�  �?ff�?  @@(����Ђ�[Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*��ܹ�����Castle Door".
 �ME  �C @]D
O˳>���B  �?  �?  �?(���⅞���2���ÿ���-��񦯰��8�������þZ�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ÿ���-ServerContext"
    �?  �?  �?(�ܹ�����2�͗���������Ȍ䳽qZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��͗������BasicDoorControllerServer"
    �?  �?  �?(���ÿ���-Z�

cs:ComponentRoot�
�ܹ�����

cs:RotationRoot��������þ
"
cs:RotatingTrigger�������爑

cs:StaticTrigger�
���Ȍ䳽qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ԝ�ݨ*����Ȍ䳽qStaticTrigger"

  �B  C   �?ff�?  @@(���ÿ���-Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���񦯰��8ClientContext"
  /C   �?  �?  �?(�ܹ�����2��ӌ��լ������������ׄ����KZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���ӌ��լ�BasicDoorControllerClient"
    �?  �?  �?(��񦯰��8Z]

cs:RotationRoot��������þ

cs:OpenSound����������

cs:CloseSound�
��ׄ����Kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ڦ�ױ��*����������Helper_DoorOpenSound"
    �?  �?  �?(��񦯰��8Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*���ׄ����KHelper_DoorCloseSound"
    �?  �?  �?(��񦯰��8ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��������þRotationRoot"
    �?  �?  �?(�ܹ�����2���Ɣ��
������爑Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����Ɣ��
Geo_StaticContext"
    �?  �?  �?(�������þ2	��޷��HZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���޷��HFantasy Castle Door 01"
 
 �BK˳�  �?  �?  �?(���Ɣ��
z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������088�
 *�������爑RotatingTrigger"

  �B  C   �?ff�?  @@(�������þZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�������Ֆ%Castle Door"3
 ИE  �C @]DO˳>���B�/e�  �?  �?  �?(���⅞���2֍ɏ�˔�9�������ʆѨ�򞜧�:Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�֍ɏ�˔�9ServerContext"
    �?  �?  �?(������Ֆ%2ɖ���㘠�ҕ�ᣑ��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ɖ���㘠�BasicDoorControllerServer"
    �?  �?  �?(֍ɏ�˔�9Z�

cs:ComponentRoot�
������Ֆ%

cs:RotationRoot�
Ѩ�򞜧�:
"
cs:RotatingTrigger�������
 
cs:StaticTrigger�ҕ�ᣑ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ԝ�ݨ*�ҕ�ᣑ��StaticTrigger"

  �B  C   �?ff�?  @@(֍ɏ�˔�9Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*��������ʆClientContext"
  /C   �?  �?  �?(������Ֆ%2����ޡ��̚��ۍ��0ؤ��έȥAZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�����ޡ��BasicDoorControllerClient"
    �?  �?  �?(�������ʆZ[

cs:RotationRoot�
Ѩ�򞜧�:

cs:OpenSound�
̚��ۍ��0

cs:CloseSound�
ؤ��έȥAz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ڦ�ױ��*�̚��ۍ��0Helper_DoorOpenSound"
    �?  �?  �?(�������ʆZc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*�ؤ��έȥAHelper_DoorCloseSound"
    �?  �?  �?(�������ʆZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*�Ѩ�򞜧�:RotationRoot"
    �?  �?  �?(������Ֆ%2��޲���3������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���޲���3Geo_StaticContext"
    �?  �?  �?(Ѩ�򞜧�:2	��ʅ����#Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ʅ����#Fantasy Castle Door 01"
 
 �BK˳�  �?  �?  �?(��޲���3z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������088�
 *�������RotatingTrigger"

  �B  C   �?ff�?  @@(Ѩ�򞜧�:Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���������Castle Door"3
 `BE  �� @]DO˳> ���/e2  �?  �?  �?(���⅞���2���򒦞d�ɶ�����c�֛�۱���Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����򒦞dServerContext"
    �?  �?  �?(��������2������Л���������oZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������Л�BasicDoorControllerServer"
    �?  �?  �?(���򒦞dZ�
 
cs:ComponentRoot���������

cs:RotationRoot��֛�۱���
"
cs:RotatingTrigger�������ز�

cs:StaticTrigger�
��������oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ԝ�ݨ*���������oStaticTrigger"

  �B  C   �?ff�?  @@(���򒦞dZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*��ɶ�����cClientContext"
  /C   �?  �?  �?(��������2��勥ΐԘ�����骁�����Ǩ���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *���勥ΐԘBasicDoorControllerClient"
    �?  �?  �?(�ɶ�����cZ^

cs:RotationRoot��֛�۱���

cs:OpenSound������骁�

cs:CloseSound�����Ǩ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ڦ�ױ��*������骁�Helper_DoorOpenSound"
    �?  �?  �?(�ɶ�����cZc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*�����Ǩ���Helper_DoorCloseSound"
    �?  �?  �?(�ɶ�����cZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��֛�۱���RotationRoot"
    �?  �?  �?(��������2��������������ز�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������Geo_StaticContext"
    �?  �?  �?(�֛�۱���2	η�����PZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�η�����PFantasy Castle Door 01"
 
 �BK˳�  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������088�
 *�������ز�RotatingTrigger"

  �B  C   �?ff�?  @@(�֛�۱���Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�ŏ���ӡ�.Castle Door"3
 0�E  �� @]DO˳> ���/e2  �?  �?  �?(���⅞���2�ŏ��˗������Ђ�Π��Ƭ�����Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ŏ��˗��ServerContext"
    �?  �?  �?(ŏ���ӡ�.2���������Ç���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������BasicDoorControllerServer"
    �?  �?  �?(�ŏ��˗��Z�

cs:ComponentRoot�
ŏ���ӡ�.

cs:RotationRoot���Ƭ�����
!
cs:RotatingTrigger�
��������

cs:StaticTrigger�
���Ç���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ԝ�ݨ*����Ç���StaticTrigger"

  �B  C   �?ff�?  @@(�ŏ��˗��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*�����Ђ�ΠClientContext"
  /C   �?  �?  �?(ŏ���ӡ�.2������߿>�����ޢ�]ӥߊ�����Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *�������߿>BasicDoorControllerClient"
    �?  �?  �?(����Ђ�ΠZ]

cs:RotationRoot���Ƭ�����

cs:OpenSound�
�����ޢ�]

cs:CloseSound�ӥߊ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ڦ�ױ��*������ޢ�]Helper_DoorOpenSound"
    �?  �?  �?(����Ђ�ΠZc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*�ӥߊ�����Helper_DoorCloseSound"
    �?  �?  �?(����Ђ�ΠZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*���Ƭ�����RotationRoot"
    �?  �?  �?(ŏ���ӡ�.2��ƹ�������������Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ƹ�����Geo_StaticContext"
    �?  �?  �?(��Ƭ�����2	��������AZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������AFantasy Castle Door 01"
 
 �BK˳�  �?  �?  �?(��ƹ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������088�
 *���������RotatingTrigger"

  �B  C   �?ff�?  @@(��Ƭ�����Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����������
Foundation"
    �?  �?  �?(������ԍ�2�α�ֲ�������������������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��α�ֲ���Foundation 01"
  H�   �?  �?  �?(���������2��崄����D�嬘�����ڥ�Ə���,�ҁ����Ʌ���������������Ն͒������������������ޤ�����Ӷ��������ᬇɞ���ƛ�������Δ������Թ����������:��������������À%������ʀz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��崄����D!Fantasy Castle Wall Foundation 01"$

  �  �����B  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��嬘�����!Fantasy Castle Wall Foundation 01"$

  �  �����B  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *�ڥ�Ə���,!Fantasy Castle Wall Foundation 01"$

  �  �C���B  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��ҁ��!Fantasy Castle Wall Foundation 01"$

  �  �����B  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���Ʌ�����!Fantasy Castle Wall Foundation 01"$

  ������3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *����������!Fantasy Castle Wall Foundation 01"$

  ������3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��Ն͒���!Fantasy Castle Wall Foundation 01"$

  �C����3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���������!Fantasy Castle Wall Foundation 01"$

  �D  ���3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��������ޤ*Fantasy Castle Wall Foundation 01 - Curved"$

   �  ���3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��˚����088�
 *������Ӷ��!Fantasy Castle Wall Foundation 01"$

  �  �D���B  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *�������ᬇ!Fantasy Castle Wall Foundation 01"$

  �D  ���3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *�ɞ���ƛ��*Fantasy Castle Wall Foundation 01 - Curved"$

  E   � ��  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��˚����088�
 *������Δ��!Fantasy Castle Wall Foundation 01"$

  �  ����3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *�����Թ��!Fantasy Castle Wall Foundation 01"$

  H�  �C  ��  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���������:!Fantasy Castle Wall Foundation 01"$

  z�  �C  ��  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���������!Fantasy Castle Wall Foundation 01"$

  H�  ����3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *�������À%!Fantasy Castle Wall Foundation 01"$

  ��  �C  ��  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *�������ʀ!Fantasy Castle Wall Foundation 01"$

  z�  ����3C  �?  �?  �?(�α�ֲ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���������Foundation 02"
  H���3C  �?  �?  �?(���������2s��������ȷ�����ϙ�É�m���쮐��¸��Ԭ�����ܗ���������ū�������������������û�������ܛ�����W�ꃢ۴���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������!Fantasy Castle Wall Foundation 01"$

  �  �����B  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��ȷ����!Fantasy Castle Wall Foundation 01"$

  �  �����B  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��ϙ�É�m!Fantasy Castle Wall Foundation 01"$

 ����C���B  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *����쮐�!Fantasy Castle Wall Foundation 01"$

�� �����B  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��¸��Ԭ��!Fantasy Castle Wall Foundation 01"$

 ������3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *����ܗ����!Fantasy Castle Wall Foundation 01"$

 ������3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *������ū��!Fantasy Castle Wall Foundation 01"$

 �C����3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���������!Fantasy Castle Wall Foundation 01"$

  �D  ���3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *����������*Fantasy Castle Wall Foundation 01 - Curved"$

� � ���3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��˚����088�
 *�û������!Fantasy Castle Wall Foundation 01"$

 �D����3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *��ܛ�����W*Fantasy Castle Wall Foundation 01 - Curved"$

  E� � ��  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��˚����088�
 *��ꃢ۴���!Fantasy Castle Wall Foundation 01"$

 ����D���B  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����Ҕ088�
 *���������bFoundation Pillars"
  H�   �?  �?  �?(���������2���߇����G��ԫ��Ҫ⡙��ش����΢庸э�Ճ�������۵��Y�����������ݵΤ�GǓ������ᎏ��ǔ��ج���Ӟ���������������������߽�����Ӆ͒����������ޟ�Ćܻ�l��������#����������ۃ����ר�����o�������mڸ���ӱ���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���߇����G-Fantasy Castle Wall Foundation 01 - Pillar 01"$

  �  �����B  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���ԫ��Ҫ-Fantasy Castle Wall Foundation 01 - Pillar 01"$

  �  �D���B  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *�⡙��ش��-Fantasy Castle Wall Foundation 01 - Pillar 01"$

  �  ����B  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���΢庸э-Fantasy Castle Wall Foundation 01 - Pillar 01"$

  � �	D���B  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *��Ճ������-Fantasy Castle Wall Foundation 01 - Pillar 01")
  �D �  �9��3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *��۵��Y-Fantasy Castle Wall Foundation 01 - Pillar 01")
  D �  �9��3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���������-Fantasy Castle Wall Foundation 01 - Pillar 01")
  � �  �9��3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *����ݵΤ�G-Fantasy Castle Wall Foundation 01 - Pillar 01")
 ���  �  �9��3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *�Ǔ�����-Fantasy Castle Wall Foundation 01 - Pillar 01")
  �� @E   :   �  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *��ᎏ��ǔ�-Fantasy Castle Wall Foundation 01 - Pillar 01")
��� E   :   �  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *��ج���Ӟ-Fantasy Castle Wall Foundation 01 - Pillar 01")
 D E   :   �  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���������-Fantasy Castle Wall Foundation 01 - Pillar 01")
  �D  E   :   �  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *����������-Fantasy Castle Wall Foundation 01 - Pillar 01")
  E  �D  �9 ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *�����߽��-Fantasy Castle Wall Foundation 01 - Pillar 01")
 E  D  �9 ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *����Ӆ͒��-Fantasy Castle Wall Foundation 01 - Pillar 01")
  E  �  �9 ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���������-Fantasy Castle Wall Foundation 01 - Pillar 01")
  E ���  �9 ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *�ޟ�Ćܻ�l-Fantasy Castle Wall Foundation 01 - Pillar 01")
  ��  ��   ���3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���������#-Fantasy Castle Wall Foundation 01 - Pillar 01")
  ��  �C   �  ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���������-Fantasy Castle Wall Foundation 01 - Pillar 01"$

 Є�  ����3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���ۃ����-Fantasy Castle Wall Foundation 01 - Pillar 01"$

 @5�  ����3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *�ר�����o-Fantasy Castle Wall Foundation 01 - Pillar 01"$

 Є� �C  ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *��������m-Fantasy Castle Wall Foundation 01 - Pillar 01"$

 @5�  �C  ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *�ڸ���ӱ-Fantasy Castle Wall Foundation 01 - Pillar 01"$

  a�  ����3C  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *����������-Fantasy Castle Wall Foundation 01 - Pillar 01"$

  a� �C  ��  �?  �?  �?(��������bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߟ����088�
 *���������Floor 01"

  z�  HD   �?  �?  �?(������ԍ�2
���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Floor 01 Ground"
    �?  �?  �?(��������2��������������Ȋ��������Q���̘������������(�������������ܕ����݁����������Mȱ�۹Ų�Bȶ������T���������������ފe���˨��o��������s���厊��(�򖹣���5����䉵�<�������:�����︕�������U������?����̊Յs��͉��������皊��ڀԛ����e�ֻ��������Ҡ��]�ݟ���յz׹��ķ�	���Ȟ̹����껁���i��Ҭ����M߉���������������!�������"z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������,Fantasy Castle Floor 01 - Curved 4m Inverted")
  E  HD �TD��3C  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��B!?V.?�X!?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����Ȋ���Fantasy Castle Floor 01 - 8m")
  HE  � �TD����  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��Ga?T�V?��P?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������QFantasy Castle Floor 01 - 8m")
  �E  � �TD����  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��Ga?T�V?��P?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����̘����Fantasy Castle Floor 01 - 8m"$
  HE  � �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������(Fantasy Castle Floor 01 - 8m"$
  �E  � �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color���K?~�<?T.?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������Fantasy Castle Floor 01 - 8m"$
  �E  �� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������ܕ�Fantasy Castle Floor 01 - 8m"$
  �E  �� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����݁���Fantasy Castle Floor 01 - 8m"$
  zE  �� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��������MFantasy Castle Floor 01 - 8m")
  zE  �� �TD����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�ȱ�۹Ų�BFantasy Castle Floor 01 - 8m"$
  E  �� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�ȶ������TFantasy Castle Floor 01 - 8m"$
  �D  �� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����������Fantasy Castle Floor 01 - 8m"$
  �D  H� �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color��B!?V.?�X!?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������ފeFantasy Castle Floor 01 - 8m")
  E  �� �TD���B  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��Ga?T�V?��P?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����˨��oFantasy Castle Floor 01 - 8m"$
  zE  H� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������sFantasy Castle Floor 01 - 8m"$
  HE  H� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����厊��(Fantasy Castle Floor 01 - 8m"$
  �E  H� �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color���K?~�<?T.?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��򖹣���5Fantasy Castle Floor 01 - 8m"$
  �E  H� �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����䉵�<Fantasy Castle Floor 01 - 8m"

  �E �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��������:Fantasy Castle Floor 01 - 8m")
  �E  H� �TD���B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *������︕�Fantasy Castle Floor 01 - 8m"

  zE �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color���K?~�<?T.?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������UFantasy Castle Floor 01 - 8m"

  HE �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������?Fantasy Castle Floor 01 - 8m"

  E �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����̊ՅsFantasy Castle Floor 01 - 8m"

  �D �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���͉����Fantasy Castle Floor 01 - 8m"$
  �D  HD �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color��Ga?T�V?��P?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����皊��Fantasy Castle Floor 01 - 8m")
  HE  HD �TD����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�ڀԛ����eFantasy Castle Floor 01 - 8m"$
  zE  HD �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color��Ga?T�V?��P?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��ֻ�����Fantasy Castle Floor 01 - 8m"$
  HE  HD �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����Ҡ��]Fantasy Castle Floor 01 - 8m"$
  �E  HD �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��ݟ���յzFantasy Castle Floor 01 - 8m"$
  �E  HD �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color��Ga?T�V?��P?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�׹��ķ�	Fantasy Castle Floor 01 - 8m")
  �E  �D �TD����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����Ȟ̹��Fantasy Castle Floor 01 - 8m"$
  zE  �D �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���껁���iFantasy Castle Floor 01 - 8m"$
  HE  �D �TD   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���Ҭ����MFantasy Castle Floor 01 - 8m"$
  E  �D �TD   �?  �?  �?(���������Z2
0
ma:Building_Floor:color���K?~�<?T.?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�߉�������,Fantasy Castle Floor 01 - Curved 4m Inverted")
  �E  HD �TD���B  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��B!?V.?�X!?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *���������!,Fantasy Castle Floor 01 - Curved 4m Inverted")
  �E  � �TD���  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��B!?V.?�X!?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��������",Fantasy Castle Floor 01 - Curved 4m Inverted")
  E  � �TD ��  �?  �?  �?(���������Z2
0
ma:Building_Floor:color��B!?V.?�X!?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����´��
Front Wall"
 �TD   �?  �?  �?(������ԍ�2zݴ�����˜���쏼��>������a��޺�󐏃�ɒ��������蠂ї��������������������غ���e���ϒ���F���Ů�ڕ7����ѐ�Y�뫅�͛��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ݴ�����˜Fantasy Castle Wall 01"$

  �  �����B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *����쏼��>'Fantasy Castle Wall 04 - Window 01 Base"$

  �  �����B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *�������a'Fantasy Castle Wall 04 - Window 01 Base"$

  �  �C���B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *���޺�󐏃Fantasy Castle Wall 01"$

  �  �D���B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *��ɒ�����#Fantasy Castle Wall 01 - Doorway 02"$

  �  �����B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������s088�
 *����蠂ї�Fantasy Castle Wall 02")
  �  ��  D���B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������q088�
 *��������&Fantasy Castle Wall 04 - Window 01 Top")
  �  ��  D���B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ʨ�����088�
 *����������"Fantasy Castle Wall 02 - Window 01")
  �  ��  D���B  �?  �?  �?(����´��2����ǃ��B���鶁�ؙz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�݌�����088�
 *�����ǃ��BCastle Part - Window 01"

 �C  �9   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *����鶁�ؙ*Fantasy Castle Wall 02 - Window 01 - Glass")
 �C  �9 ��C�������=  @ `@(���������Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *����غ���e&Fantasy Castle Wall 04 - Window 01 Top")
  �  �C  D���B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ʨ�����088�
 *����ϒ���FFantasy Castle Wall 02")
  �  �D  D���B  �?  �?  �?(����´��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������q088�
 *����Ů�ڕ7Front Wall Pillars"
    �?  �?  �?(����´��2t����ɷ�����������hɴ����Ğ��������䱬��ɉ��򳧇ʰ��I����̉���������҂Ƈ����˔���ʘ˺��q������������Ɋ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ɷ���Fantasy Castle Pillar 01 Base"$

  �  �����B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *���������hFantasy Castle Pillar 01 Cap")
  �  �� �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�ɴ����Ğ�Fantasy Castle Pillar 01 Top")
  �  �� �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *��������Fantasy Castle Pillar 01 Base"$

  �  �����B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�䱬��ɉ��Fantasy Castle Pillar 01 Cap")
  �  �� �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�򳧇ʰ��IFantasy Castle Pillar 01 Top")
  �  �� �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *�����̉���Fantasy Castle Pillar 01 Base"$

  �  �C���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�������҂Fantasy Castle Pillar 01 Cap")
  �  �C �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�Ƈ����˔�Fantasy Castle Pillar 01 Top")
  �  �C �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���ʘ˺��qFantasy Castle Pillar 01 Base"$

  �  �D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�������Fantasy Castle Pillar 01 Cap")
  �  �D �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�������Ɋ�Fantasy Castle Pillar 01 Top")
  �  �D �"D���B  �?  �?  �?(���Ů�ڕ7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *�����ѐ�Y*Fantasy Castle Wall 04 - Window 01 - GLASS"$
  �  H�  �C ���=   @   A(����´��Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��뫅�͛��*Fantasy Castle Wall 04 - Window 01 - GLASS"$
  �  HD  �C ���=   @   A(����´��Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��翵җ�IEntrance"$
 @��  ��  H�   �?  �?  �?(������ԍ�2%��ݕ�Ź��ʙ��ϳ�gⳏ��ˈ��˦�����(z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ݕ�Ź�Entrance Steps"

  ��  H�   �?  �?  �?(�翵җ�I2�Ǽ��܂��V�������������ǿ�������������������ܛ��֦����݊�ҥ�ܪ������ڣ��҇�'�����塋��������^��������_��؜��t������ɨ����������������������������ˆз�:�Ľ䥟���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ǽ��܂��V#Fantasy Castle Stairs 01 - Straight")
 ��C ��� ��C���B  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��ܕ���088�
 *��������#Fantasy Castle Stairs 01 - Straight")
 ��C ��C ��C���B  ��  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��ܕ���088�
 *�������ǿ�*Fantasy Castle Stairs Spiral 03 - Large 3m"$

 ��� ������B  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��싍���088�
 *���������*Fantasy Castle Stairs Spiral 03 - Large 3m"$

 ��� ��C���B  ��  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��싍���088�
 *����������$Fantasy Castle Bannister 01 - Spiral")
 ��� ��C  �B���B  ��  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ŵ���\088�
 *��ܛ��֦��$Fantasy Castle Bannister 01 - Spiral")
 ��� ���  �B���B  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ŵ���\088�
 *���݊�ҥ/Fantasy Castle Stairs Spiral Wall 01 - Straight"$

  �A �������  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��á��Г{088�
 *��ܪ�����&Fantasy Castle Bannister 01 - Straight")
  �A ���  �C���B  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ڣ��҇�'&Fantasy Castle Bannister 01 - Straight")
  �A  �B  �C���B  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *������塋Fantasy Castle Floor 02")
 ��C ���  �C��3�  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���������^Fantasy Castle Floor 02")
  �A ��C  �C��/7  �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���������_/Fantasy Castle Stairs Spiral Wall 01 - Straight"$

 ��C �����3C  �?  �?  �?(��ݕ�Ź�ZF
$
ma:Shared_Detail3:id�ᄈ������

ma:Shared_Detail3:vtilee�̌?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��á��Г{088�
 *���؜��t"Fantasy Castle Bannister 01 - Post"$
 ��� @5�  �A   �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�������ɨ�"Fantasy Castle Bannister 01 - Post"$
 ��� ���  �A   �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���������"Fantasy Castle Bannister 01 - Post"$
 ��� �ZD  �A   �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���������"Fantasy Castle Bannister 01 - Post"$
 ��� `�D  �A   �?  �?  �?(��ݕ�Ź�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���������Whitebox Wall 01 Triangle")
 ��D ���  �C��3�  �?  @?  �?(��ݕ�Ź�Z�
(
ma:Building_WallInner:id���☉����
"
ma:Building_WallInner:vtilee\��?
)
ma:Building_WallInner2:id���☉����
#
ma:Building_WallInner2:vtilee\��?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������ëp088�
 *����ˆз�:Whitebox Wall 01 Triangle")
 ��D ��C  �C��3�  �?  @?  �?(��ݕ�Ź�Z�
(
ma:Building_WallInner:id���☉����
"
ma:Building_WallInner:vtilee\��?
)
ma:Building_WallInner2:id���☉����
#
ma:Building_WallInner2:vtilee\��?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������ëp088�
 *��Ľ䥟���/Fantasy Castle Stairs Spiral Wall 01 - Straight"$

 ��C ��C��3C  �?  �?  �?(��ݕ�Ź�ZF
$
ma:Shared_Detail3:id�ᄈ������

ma:Shared_Detail3:vtilee�̌?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��á��Г{088�
 *��ʙ��ϳ�gEntrance Path"$
 ��D  �� �TD   �?  �?  �?(�翵җ�I2����ݏň�a��㿜�����̢�����ꅜ���·�ȱ��?���������󢯶�����Ʒ���S볚�ɹ��������-�⟅��רv��Ϊ���Pϖ��ǖ����������9���絉�ޭ��搟����⠡挞N����Ҵῃ����������Ǫ̧������̃���_�յ��鴒�â��لȚٔ������<��؟�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ݏň�aFantasy Castle Floor 01 - 8m")
  �C  ��  HB���B  �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���㿜��Fantasy Castle Floor 01 - 8m")
  ��  ��  HB���B  �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����̢���Fantasy Castle Floor 01 - 8m")
 ���  ��  HB���B  �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���ꅜ��&Fantasy Castle Bannister 01 - Straight"

 ���  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��·�ȱ��?&Fantasy Castle Bannister 01 - Straight"

 �;�  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���������&Fantasy Castle Bannister 01 - Straight"

  HB  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��󢯶���&Fantasy Castle Bannister 01 - Straight"

  ��  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���Ʒ���S&Fantasy Castle Bannister 01 - Straight"

 �TD  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�볚�ɹ��&Fantasy Castle Bannister 01 - Straight"

  �C  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�������-&Fantasy Castle Bannister 01 - Straight"

  �C  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��⟅��רv&Fantasy Castle Bannister 01 - Straight"

 �;�  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���Ϊ���P&Fantasy Castle Bannister 01 - Straight"

  HB  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�ϖ��ǖ��&Fantasy Castle Bannister 01 - Straight"

  ��  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���������9&Fantasy Castle Bannister 01 - Straight"

 �TD  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *����絉�&Fantasy Castle Bannister 01 - Straight"

 ���  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�ޭ��搟��"Fantasy Castle Bannister 01 - Post"

  �  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���⠡挞N"Fantasy Castle Bannister 01 - Post"

 �AD  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�����Ҵῃ"Fantasy Castle Bannister 01 - Post"

 ��C  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *����������"Fantasy Castle Bannister 01 - Post"

  H�  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��Ǫ̧����"Fantasy Castle Bannister 01 - Post"

 ��D  ��   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���̃���_"Fantasy Castle Bannister 01 - Post"

 ��D  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��յ��鴒�"Fantasy Castle Bannister 01 - Post"

 �AD  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�â��لȚ"Fantasy Castle Bannister 01 - Post"

 ��C  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�ٔ������<"Fantasy Castle Bannister 01 - Post"

  H�  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���؟�����"Fantasy Castle Bannister 01 - Post"

  �  �C   �?  �?  �?(�ʙ��ϳ�gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�ⳏ��ˈ�	Pillar 02"

  z� ���   �?  �?  �?(�翵җ�I2'����лѤ�������Ћ�ѵ����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����лѤFantasy Castle Pillar 02 - Base"
    �?  �?  �?(ⳏ��ˈ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *�������Fantasy Castle Pillar 02 - Mid"
  �C   �?  �?  �?(ⳏ��ˈ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *��Ћ�ѵ�Fantasy Castle Pillar 02 - Top"
  D   �?  �?  �?(ⳏ��ˈ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *����������Group"
    �?  �?  �?(ⳏ��ˈ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��˦�����(	Pillar 02"

  z� ��C   �?  �?  �?(�翵җ�I2'����������р��9����ȼ�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������Fantasy Castle Pillar 02 - Base"
    �?  �?  �?(�˦�����(z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *���р��9Fantasy Castle Pillar 02 - Mid"
  �C   �?  �?  �?(�˦�����(z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *�����ȼ��Fantasy Castle Pillar 02 - Top"
  D   �?  �?  �?(�˦�����(z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *����������Group"
    �?  �?  �?(�˦�����(z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������҄�Floor 02"$
  �  �� @�D   �?  �?  �?(������ԍ�2	���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ف���Battlement Trim"
  D   �?  �?  �?(������҄�2]㒸�Պ��l����Ɩ��cǦ������7����������ć����XȜ������&������ٗ���م������ر�����١������4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�㒸�Պ��l#Fantasy Castle Trim - Battlement 01"
  �����B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�����Ɩ��c#Fantasy Castle Trim - Battlement 01"
  H����B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�Ǧ������7#Fantasy Castle Trim - Battlement 01"
  HD���B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���������#Fantasy Castle Trim - Battlement 01"
  �D���B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���ć����X#Fantasy Castle Trim - Battlement 01"
 ���B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�Ȝ������& Fantasy Castle Trim - Parapet 01"
  �����B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�������ٗ Fantasy Castle Trim - Parapet 01"
  H����B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *����م���� Fantasy Castle Trim - Parapet 01"
  H����B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *���ر����� Fantasy Castle Trim - Parapet 01"
  HD���B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�١������4 Fantasy Castle Trim - Parapet 01"
  �D���B  �?  �?  �?(���ف���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�������	Back Wall"$

  HB  HD����  �?  �?  �?(������ԍ�2�΢���XḰ���>뷘����������=�å��Ұ����������謅�������ô�k���Ӧ訝8�못�ӭ����ֈ���_ڳ��ܺҰ��������I����ͭ��!ڽǓǰ�8�����ޝ�p�ם����Ʋ�酒����o�����ͷ߉�������ш�ؙ�ÁU��о�ٍ��������ٻ�ݕ����������ޘ�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�΢���XBattlement Trim")
 ����E @�D����  �?  �?  �?(������2V㖛������܁���͊�����������������Z��ۧ�����������������ʖ��o��ґ����nψ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�㖛�����#Fantasy Castle Trim - Battlement 01"
  �����B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *��܁���͊�#Fantasy Castle Trim - Battlement 01"
  H����B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *����������#Fantasy Castle Trim - Battlement 01"
  HD���B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *��������Z#Fantasy Castle Trim - Battlement 01"
  �D���B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���ۧ����� Fantasy Castle Trim - Parapet 01"
  �����B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *��������� Fantasy Castle Trim - Parapet 01"
  H����B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�����ʖ��o Fantasy Castle Trim - Parapet 01"$

w��7| �A���B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *���ґ����n Fantasy Castle Trim - Parapet 01"
  HD���B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�ψ������ Fantasy Castle Trim - Parapet 01"
  �D���B  �?  �?  �?(΢���Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�Ḱ���>Fantasy Castle Wall 01 - Cellar")
����  E  HB  ��  �?  �?  �?(������2
�ʋ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *��ʋ������Castle Part - Grate 01"

���C���9   �?  �?  �?(Ḱ���>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *�뷘��Fantasy Castle Wall 01 - Cellar")
����  E  HB  ��  �?  �?  �?(������2	��������oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *���������oCastle Part - Grate 01"

���C���9   �?  �?  �?(뷘��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *���������=Fantasy Castle Pillar 01 Base")
 �����E� HB   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��å��Ұ�Fantasy Castle Wall 01 - Cellar")
���C��E  HB  ��  �?  �?  �?(������2
�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *��������Castle Part - Grate 01"

���C���9   �?  �?  �?(�å��Ұ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *����������Fantasy Castle Wall 01 - Cellar")
���D��E  HB  ��  �?  �?  �?(������2
�Ԩ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *��Ԩ������Castle Part - Grate 01"

���C���9   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *�謅������Fantasy Castle Wall 02")
 �����E �"D  ��  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *��ô�kFantasy Castle Pillar 01 Mid")
 �����E �"D   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *����Ӧ訝8Fantasy Castle Pillar 01 Cap")
 �����E  D   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��못�ӭ��Fantasy Castle Pillar 01 Cap")
�����E  �D   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���ֈ���_Fantasy Castle Pillar 01 Cap")
���� E @�D  ��  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�ڳ��ܺҰ�"Fantasy Castle Pillar Wall 01 Arch")
 �C��E �"D���B  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *��������IFantasy Castle Pillar 01 Cap")
 �C��E  �D   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�����ͭ��!Fantasy Castle Pillar 01 Cap")
  �C��E  D   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�ڽǓǰ�8Fantasy Castle Pillar 01 Mid")
  �C��E �"D   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *������ޝ�pFantasy Castle Pillar 01 Base")
  �C��E� HB   �  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��ם����Ʋ'Fantasy Castle Wall 02 Half - Window 01")
 @�D��E �"D  ��  �?  �?  �?(������2������˦����؈�
z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���邖��h088�
 *�������˦Castle Part - Window 01"

��GC  �9   �?  �?  �?(�ם����Ʋz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *�����؈�
/Fantasy Castle Wall 02 Half - Window 01 - Glass")
' HC  1; ��C �����=  @ `@(�ם����ƲZ+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��酒����o"Fantasy Castle Pillar Wall 01 Arch")
 �����E �"D���B  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *������ͷ߉Fantasy Castle Wall 02 Half")
  �C{�E �"D  ��  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *��������ш'Fantasy Castle Wall 02 Half - Window 01")
�TD��E �"D  ��  �?  �?  �?(������2������Ǎ����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���邖��h088�
 *�������Ǎ�Castle Part - Window 01"

��GC  �9   �?  �?  �?(�������шz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *����������/Fantasy Castle Wall 02 Half - Window 01 - Glass")
� HC �"< ��C �����=  @ `@(�������шZ+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��ؙ�ÁUFantasy Castle Wall 02 Half")
�?�DE�E �"D  ��  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *���о�ٍ��Fantasy Castle Wall 02 Half")
����*�E �"D  ��  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *�������ٻ�'Fantasy Castle Wall 02 Half - Window 01")
������E �"D  ��  �?  �?  �?(������2��������r����⇚��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���邖��h088�
 *���������rCastle Part - Window 01"

��GC  �9   �?  �?  �?(������ٻ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *�����⇚��/Fantasy Castle Wall 02 Half - Window 01 - Glass")
��GC `�< ��C �����=  @ `@(������ٻ�Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�ݕ������Fantasy Castle Wall 02 Half")
\ H���E �"D  ��  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *�����ޘ���'Fantasy Castle Wall 02 Half - Window 01")
 ����E �"D  ��  �?  �?  �?(������2Ͼˋ����������۴z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���邖��h088�
 *�Ͼˋ����Castle Part - Window 01"

��GC  �9   �?  �?  �?(����ޘ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *�������۴/Fantasy Castle Wall 02 Half - Window 01 - Glass")
@ HC `�< ��C �����=  @ `@(����ޘ���Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *���������Fantasy Castle Wall 01 - Cellar")
  ����E  HB  ��  �?  �?  �?(������2	゘۱���'z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *�゘۱���'Castle Part - Grate 01"

���C���9   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *�Ӵ̷�����Side Wall 01"
  HD   �?  �?  �?(������ԍ�2���΢�٪�p��م��ݜ���ħҷ��݂�����L��ϊ��������Ŕ���l£���Շ���ڣ�������������Ȇ�䚱Ѻ�諞Ú������Ȟ��������ſ�𺬤�͏����ˎ�В���ȵ�������ԗȾ��ṅ޳�������������Ŕ�œ���d����ʌƻcׇ�����!�Ѐ�ܕ◲z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���΢�٪�pBattlement Trim")
  ��  E @�D����  �?  �?  �?(Ӵ̷�����2U������������뒄�����쬑��c���㶷��*����௲���ɘ���G�����ߐ�>�ø�N�ڲ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������#Fantasy Castle Trim - Battlement 01"
  �����B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *����뒄��#Fantasy Castle Trim - Battlement 01"
  H����B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *����쬑��c#Fantasy Castle Trim - Battlement 01"
  HD���B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *����㶷��*#Fantasy Castle Trim - Battlement 01"
  �D���B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�����௲ Fantasy Castle Trim - Parapet 01"
  �����B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *����ɘ���G Fantasy Castle Trim - Parapet 01"
  H����B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *������ߐ�> Fantasy Castle Trim - Parapet 01"
 ���B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *��ø�N Fantasy Castle Trim - Parapet 01"
  HD���B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *��ڲ������ Fantasy Castle Trim - Parapet 01"
  �D���B  �?  �?  �?(��΢�٪�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *���م��ݜFantasy Castle Wall 01 - Cellar")
 �� E  HB  ��  �?  �?  �?(Ӵ̷�����2�����Az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *������ACastle Part - Grate 01"

���C���9   �?  �?  �?(��م��ݜz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *����ħҷ�Fantasy Castle Wall 01 - Cellar")
  �� E  HB  ��  �?  �?  �?(Ӵ̷�����2	����ǰ��-z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *�����ǰ��-Castle Part - Grate 01"

���C���9   �?  �?  �?(���ħҷ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *��݂�����LFantasy Castle Pillar 01 Base")
  �� E� HB   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *���ϊ�����Fantasy Castle Wall 01")
����  E  HB  ��  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *����Ŕ���lFantasy Castle Wall 01 - Cellar")
  �C E  HB  ��  �?  �?  �?(Ӵ̷�����2
�ǂ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *��ǂ�����Castle Part - Grate 01"

���C���9   �?  �?  �?(���Ŕ���lz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *�£���Շ��Fantasy Castle Wall 01 - Cellar")
  �D  E  HB  ��  �?  �?  �?(Ӵ̷�����2
�œ�Ħ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *��œ�Ħ��Castle Part - Grate 01"

���C���9   �?  �?  �?(£���Շ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *��ڣ������Fantasy Castle Wall 02")
8 ��  E �"D  ��  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������q088�
 *������"Fantasy Castle Wall 02 - Window 01")
 ��  E �"D  ��  �?  �?  �?(Ӵ̷�����2�π�ұ������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *��π�ұ���Castle Part - Window 01"

  �C6�':   �?  �?  �?(�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *����������*Fantasy Castle Wall 02 - Window 01 - Glass")
8 �Ce�': ��C �B���=  @ `@(�����Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *���Ȇ�䚱Fantasy Castle Pillar 01 Mid")
  �� E �"D   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *�Ѻ�諞Ú�Fantasy Castle Pillar 01 Cap")
  �� E  D   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *������Ȟ��Fantasy Castle Pillar 01 Cap")
  �� E ��D   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�������ſFantasy Castle Pillar 01 Cap")
  �� E @�D  ��  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��𺬤�͏�"Fantasy Castle Pillar Wall 01 Arch")
  �C �E �"D���B  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *����ˎ�ВFantasy Castle Pillar 01 Cap")
  �C E ��D   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����ȵ����Fantasy Castle Pillar 01 Cap")
  �C E  D   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����ԗȾ��Fantasy Castle Pillar 01 Mid")
  �C E �"D   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *�ṅ޳����Fantasy Castle Pillar 01 Base")
  �C E� HB   �  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����������Fantasy Castle Pillar 01 Cap")
  �C E @�D  ��  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�Ŕ�œ���d"Fantasy Castle Wall 02 - Window 01")
  ��  E �"D  ��  �?  �?  �?(Ӵ̷�����2Â�������ͭ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *�Â������Castle Part - Window 01"

  �C6�':   �?  �?  �?(Ŕ�œ���dz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *��ͭ������*Fantasy Castle Wall 02 - Window 01 - Glass")
  �C6�': ��C �B���=  @ `@(Ŕ�œ���dZ+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�����ʌƻc"Fantasy Castle Wall 02 - Window 01")
 �D  E �"D  ��  �?  �?  �?(Ӵ̷�����2ײ��̎��.�ն���Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *�ײ��̎��.Castle Part - Window 01"

  �C6�':   �?  �?  �?(����ʌƻcz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *��ն���O*Fantasy Castle Wall 02 - Window 01 - Glass")
���C�': ��C �B���=  @ `@(����ʌƻcZ+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�ׇ�����!"Fantasy Castle Wall 02 - Window 01")
  �C  E �"D  ��  �?  �?  �?(Ӵ̷�����2���������������<z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *���������Castle Part - Window 01"

  �C6�':   �?  �?  �?(ׇ�����!z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *��������<*Fantasy Castle Wall 02 - Window 01 - Glass")
  �C6�': ��C �B���=  @ `@(ׇ�����!Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��Ѐ�ܕ◲"Fantasy Castle Pillar Wall 01 Arch")
  �� �E �"D���B  �?  �?  �?(Ӵ̷�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *�ڟ����官Side Wall 02"$

  HB  HD��3�  �?  �?  �?(������ԍ�2�������֫�������۫#�Ғ��մ�U���䛉��	�΍����K���ϙ���?��А����6ܪꌘ�Ό;������������⺹���������9���õ������������������r������̞H�����Ʃ��䷲�Ǟ��'�����������������܎��إ�+�����Ď���ܾ������������&z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������֫�Battlement Trim")
����  E @�D����  �?  �?  �?(ڟ����官2T���ׄ������ϖ���O��Ǟ؈��&��������u��������t��������}�ͅ�ݩ��b�������Ճ�󍣎ަ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ׄ����#Fantasy Castle Trim - Battlement 01"
  �����B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���ϖ���O#Fantasy Castle Trim - Battlement 01"
  H����B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���Ǟ؈��&#Fantasy Castle Trim - Battlement 01"
  HD���B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���������u#Fantasy Castle Trim - Battlement 01"
  �D���B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���������t Fantasy Castle Trim - Parapet 01"
  �����B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *���������} Fantasy Castle Trim - Parapet 01"
  H����B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *��ͅ�ݩ��b Fantasy Castle Trim - Parapet 01"
 ���B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *��������Ճ Fantasy Castle Trim - Parapet 01"
  HD���B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *��󍣎ަ�� Fantasy Castle Trim - Parapet 01"
  �D���B  �?  �?  �?(������֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������k088�
 *�������۫#Fantasy Castle Wall 01 - Cellar")
 �� E  HB  ��  �?  �?  �?(ڟ����官2
��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *���������Castle Part - Grate 01"

���C���9   �?  �?  �?(������۫#z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *��Ғ��մ�UFantasy Castle Wall 01 - Cellar")
 �� E  HB  ��  �?  �?  �?(ڟ����官2	¸̓����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *�¸̓����Castle Part - Grate 01"

���C���9   �?  �?  �?(�Ғ��մ�Uz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *����䛉��	Fantasy Castle Pillar 01 Base")
���� E� HB   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��΍����KFantasy Castle Wall 01")
����  E  HB  ��  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *����ϙ���?Fantasy Castle Wall 01 - Cellar")
 �C E  HB  ��  �?  �?  �?(ڟ����官2
����ʨ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *�����ʨ���Castle Part - Grate 01"

���C���9   �?  �?  �?(���ϙ���?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *���А����6Fantasy Castle Wall 01 - Cellar")
  �D  E  HB  ��  �?  �?  �?(ڟ����官2	��֊��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ߡ�088�
 *���֊��Castle Part - Grate 01"

���C���9   �?  �?  �?(��А����6z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ĕѫ�ۜ088�
 *�ܪꌘ�Ό;Fantasy Castle Wall 02")
7 ��  E �"D  ��  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������q088�
 *���������"Fantasy Castle Wall 02 - Window 01")
 ��  E �"D  ��  �?  �?  �?(ڟ����官2æڏǻ��"꛿�ך���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *�æڏǻ��"Castle Part - Window 01"

  �C6�':   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *�꛿�ך���*Fantasy Castle Wall 02 - Window 01 - Glass")
p �C�F�: ��C�������=  @ `@(��������Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�����⺹�Fantasy Castle Pillar 01 Mid")
���� E �"D   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *���������9Fantasy Castle Pillar 01 Cap")
���� E  D   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����õ��Fantasy Castle Pillar 01 Cap")
���� E ��D   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���������Fantasy Castle Pillar 01 Cap")
 ��@E @�D  ��  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���������r"Fantasy Castle Pillar Wall 01 Arch")
 �C  E �"D���B  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *�������̞HFantasy Castle Pillar 01 Cap")
 �C E ��D   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *������Ʃ��Fantasy Castle Pillar 01 Cap")
 �C E  D   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�䷲�Ǟ��'Fantasy Castle Pillar 01 Mid")
 �C E �"D   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *����������Fantasy Castle Pillar 01 Base")
 �C E� HB   �  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��������Fantasy Castle Pillar 01 Cap")
 �C@E @�D  ��  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��܎��إ�+"Fantasy Castle Wall 02 - Window 01")
 ��  E �"D  ��  �?  �?  �?(ڟ����官2�����������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *���������Castle Part - Window 01"

  �C6�':   �?  �?  �?(�܎��إ�+z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *����������*Fantasy Castle Wall 02 - Window 01 - Glass")
@ �C�F�: ��C�������=  @ `@(�܎��إ�+Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *������Ď��"Fantasy Castle Wall 02 - Window 01")
 �D  E �"D  ��  �?  �?  �?(ڟ����官2�����������ҫ��υ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *����������Castle Part - Window 01"

  �C6�':   �?  �?  �?(�����Ď��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *���ҫ��υ�*Fantasy Castle Wall 02 - Window 01 - Glass")
���C�r#� ��C�������=  @ `@(�����Ď��Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��ܾ����"Fantasy Castle Wall 02 - Window 01")
 �C  E �"D  ��  �?  �?  �?(ڟ����官2��񫳲�<���ҭ��uz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

Ị�����_088�
 *���񫳲�<Castle Part - Window 01"

  �C6�':   �?  �?  �?(�ܾ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Π���쿤�088�
 *����ҭ��u*Fantasy Castle Wall 02 - Window 01 - Glass")
8 �C�j�8 ��C�������=  @ `@(�ܾ����Z+
)
ma:Shared_BaseMaterial:id�޳���̞��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *���������&"Fantasy Castle Pillar Wall 01 Arch")
����  E �"D���B  �?  �?  �?(ڟ����官z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *���������NTall Tower Pillar")
��E   E �TD����  �?  �?  �?(������ԍ�2/�����Ґ��ĝ�����������Ĳ�_������҃���֦���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Ґ��Fantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(��������Nz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�ĝ�������Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(��������Nz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�����Ĳ�_Fantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(��������Nz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *�������҃�Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(��������Nz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���֦���Fantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(��������Nz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���̧����KInterior Pillars"
 �TD   �?  �?  �?(������ԍ�2����ɯ�ǡ������ޭ����ⴆ��K����������ܼ���ϫ�御���ю�������˳��������y��������������کO͡����ݙK�����ծ��ʵѭ����x�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ɯ�ǡ�Interior Pillar"

  ��  �D   �?  �?  �?(��̧����K2�أ��֕���˨�ˍV��ɟю�ĝz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��أ��֕Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(���ɯ�ǡ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *����˨�ˍVFantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(���ɯ�ǡ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *���ɟю�ĝFantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(���ɯ�ǡ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *������ޭ�Interior Pillar"$

  �C  �D����  �?  �?  �?(��̧����K2����̷Дf��Ӏ�������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����̷ДfFantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(�����ޭ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *���Ӏ�����Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(�����ޭ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *���������Fantasy Castle Pillar 02 - Top"$
 ����o� @D   �?  �?  �?(�����ޭ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *����ⴆ��KInterior Pillar"$

  �C �������  �?  �?  �?(��̧����K2����Ґӌ������������ԩ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����Ґӌ�Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(���ⴆ��Kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *����������Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(���ⴆ��Kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *���ԩ�����Fantasy Castle Pillar 02 - Top"$
" ����o� @D   �?  �?  �?(���ⴆ��Kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *����������Interior Pillar"

  �� ���   �?  �?  �?(��̧����K2���ũ˚�-���݁ƞ����Ӑ�ª��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ũ˚�-Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *����݁ƞ��Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *���Ӑ�ª��Fantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *��ܼ���ϫInterior Pillar"$
  ��  ��  D   �?  �?  �?(��̧����K2��Ⱄ���ސ���НK������9z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���Ⱄ���Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(�ܼ���ϫz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *�ސ���НKFantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(�ܼ���ϫz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *�������9Fantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(�ܼ���ϫz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *��御���юInterior Pillar")
  ��  ��  D���B  �?  �?  �?(��̧����K2��������(��ĵ�ʛ�Yк������ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������(Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(�御���юz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *���ĵ�ʛ�YFantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(�御���юz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *�к������ Fantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(�御���юz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *��������˳Interior Pillar"$
  ��  �D  D   �?  �?  �?(��̧����K2���ݗ����������z�˾�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ݗ��Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(�������˳z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *���������zFantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(�������˳z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *��˾�����Fantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(�������˳z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *���������yInterior Pillar")
  ��  �D  D���B  �?  �?  �?(��̧����K2�����Ư���Ȥ�������ח���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Ư�Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(��������yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *���Ȥ���Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(��������yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *�����ח���Fantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(��������yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *���������Interior Pillar"$
  �D  �D  D   �?  �?  �?(��̧����K2��ܭ������ŝ���������ˍ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ܭ�����Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *��ŝ�����Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *�����ˍ�Fantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *�������کOInterior Pillar"$
  �D  ��  D   �?  �?  �?(��̧����K2׏������KȽְܾ�݃��������ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�׏������KFantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(������کOz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *�Ƚְܾ�݃Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(������کOz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *���������eFantasy Castle Pillar 02 - Top"$
  ��  p� @D   �?  �?  �?(������کOz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *�͡����ݙKInterior Pillar"$

 @�D @������  �?  �?  �?(��̧����K2����ȟ�|���ۭ�����϶Զ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ȟ�|Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(͡����ݙKz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *����ۭ��Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(͡����ݙKz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *����϶Զ��Fantasy Castle Pillar 02 - Top"$
" ����o� @D   �?  �?�̌?(͡����ݙKz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *������ծ��Interior Pillar"$

  �D �������  �?  �?  �?(��̧����K2ь�ھݦ�J���̰���������紀�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ь�ھݦ�JFantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(�����ծ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *����̰����Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(�����ծ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *������紀�Fantasy Castle Pillar 02 - Top"$
" ����o� @D   �?  �?  �?(�����ծ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *�ʵѭ����xInterior Pillar"$

 @�D  �D����  �?  �?  �?(��̧����K2��Պ�����ϕŴ��ʬ���񂁺���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���Պ�����Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(ʵѭ����xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *�ϕŴ��ʬ�Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(ʵѭ����xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *���񂁺���Fantasy Castle Pillar 02 - Top"$
" ����o� @D   �?  �?�̌?(ʵѭ����xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *������Interior Pillar"$

  �D ��D����  �?  �?  �?(��̧����K2�������#������������ǎ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������#Fantasy Castle Pillar 02 - Base"

  ��  p�   �?  �?  �?(�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��Ɨ�����088�
 *��������Fantasy Castle Pillar 02 - Mid"$
  ��  p�  �C   �?  �?  �?(�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ޏ����仗088�
 *������ǎ�Fantasy Castle Pillar 02 - Top"$
" ����o� @D   �?  �?  �?(�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *�������ߒ�Top Floor Walkway"$
  aC  HB   E   �?  �?  �?(������ԍ�2����%��̐��������顒������گ��'����Ԧ����Ԛ� ��Q���Ҕ�剎��������H��������3��֧�����������������Ɉ�+����垠�����Ӭי���������������բ���ز���r�Ӻ�؉������ҵ���~�ý�ȃ�������ւ�xʍ���ߔɄ������肕��غ��������+��������R��������#��������������������Ϯ�����������k����̛������������Ϭ��㣂��ޭ�����@��������S���������Ҍ��â�Y��������Ɯ����0������������֏���ɂ�����������濺�������ڞ�������������������ۣ����Ȱ����϶��^��袭�ȸ�স���� ��������ۼ�Ō�ݠ�������������ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����%Fantasy Castle Floor 01 - 8m")
 �sD  �  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���̐�����Fantasy Castle Floor 01 - 8m")
 �D  ��  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *����顒���Fantasy Castle Floor 01 - 8m")
 �D  �  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *����گ��',Fantasy Castle Floor 01 - Curved 4m Inverted"$
 �D  ��  ��   �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����Ԧ���,Fantasy Castle Floor 01 - Curved 4m Inverted")
 �D  �  �����B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��Ԛ� ��QFantasy Castle Floor 01 - 8m")
  /C  �  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����Ҕ�剎#Fantasy Castle Floor 02 - Corner 01")
  /C��.�  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *���������HFantasy Castle Floor 01 - 8m")
@�  �  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������3Fantasy Castle Floor 01 - 8m"$

  ��  ���.e6  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���֧����Fantasy Castle Floor 01 - 8m")
 $�  ��  �9 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *����������Fantasy Castle Floor 01 - 8m"$

 ��D  ������  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�����Ɉ�+,Fantasy Castle Floor 01 - Curved 4m Inverted"$

 `E  �� ��  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����垠��,Fantasy Castle Floor 01 - Curved 4m Inverted"$

 ��  ���3C  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *����Ӭי�Fantasy Castle Floor 01 - 8m")
  ��  ��  �9�.e6  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���������,Fantasy Castle Floor 01 - Curved 4m Inverted"$

  ��  ������  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�������բ,Fantasy Castle Floor 01 - Curved 4m Inverted"

 $�����   �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *����ز���rFantasy Castle Floor 01 - 8m")
 $�  ��  �9 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��Ӻ�؉���Fantasy Castle Floor 01 - 8m"$

 $�  �� �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *����ҵ���~Fantasy Castle Floor 01 - 8m")
�$�  �C  �9 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *��ý�ȃ���Fantasy Castle Floor 01 - 8m")
 $�  �D  �9 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�����ւ�xFantasy Castle Floor 01 - 8m")
 �  �D  �9 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�ʍ���ߔɄFantasy Castle Floor 01 - 8m"$

 �E  �D����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�������肕Fantasy Castle Floor 01 - 8m"$

 ��D  �D����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���غ����Fantasy Castle Floor 01 - 8m"$

 �E  �D����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����+Fantasy Castle Floor 01 - 8m"$

 �E���C����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������RFantasy Castle Floor 01 - 8m"$

 �E ������  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������#Fantasy Castle Floor 01 - 8m"$

 �E  ������  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *����������$Fantasy Castle Floor 01 - Curved 4m "$

 �D  ������  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����������Fantasy Castle Floor 01 - 8m"$

 �D  ����3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���Ϯ����Fantasy Castle Floor 01 - 8m"
 �D��3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *��������k$Fantasy Castle Floor 01 - Curved 4m "$

 �D  �C��3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *�����̛���#Fantasy Castle Floor 02 - Corner 01"$

 @�  /�
 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *���������#Fantasy Castle Floor 02 - Corner 01"$

�� E �C����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *��Ϭ��㣂�#Fantasy Castle Floor 02 - Corner 01"$

�� E������3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *��ޭ�����@,Fantasy Castle Floor 01 - Curved 4m Inverted"$

��E���D��3C  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *���������S,Fantasy Castle Floor 01 - Curved 4m Inverted"$

 �D  �D���B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *���������,Fantasy Castle Floor 01 - Curved 4m Inverted"$

 �D  E���  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��Ҍ��â�YFantasy Castle Floor 01 - 8m"$

 �D  �D����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���������Fantasy Castle Floor 01 - 8m"$

 �D  �D��3�  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�Ɯ����0Fantasy Castle Floor 01 - 8m"

  /C  E   �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������Fantasy Castle Floor 01 - 8m"

 @�  E   �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�����֏���#Fantasy Castle Floor 02 - Corner 01"$

  /C  /E����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *�ɂ������#Fantasy Castle Floor 02 - Corner 01"

 @�  /E   �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *������濺�Fantasy Castle Floor 01 - 8m"

  ��  E   �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������ڞ�Fantasy Castle Floor 01 - 8m")
  ��  �D  �9%�+7  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���������Fantasy Castle Floor 01 - 8m")
  ��  E  �9%�+7  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *����������,Fantasy Castle Floor 01 - Curved 4m Inverted"$

  ��  �D��3C  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��ۣ����Ȱ,Fantasy Castle Floor 01 - Curved 4m Inverted"$

  ��  E����  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����϶��^,Fantasy Castle Floor 01 - Curved 4m Inverted"$

 $�  �D���B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *���袭�ȸFantasy Castle Floor 01 - 8m")
 �  ��  �9 �B  �?  �?  �?(������ߒ�Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *��স���� Fantasy Castle Floor 01 - 8m".

 �D  ��(�+8��3C����   ?  �?333?(������ߒ�Z{
$
ma:Building_Floor:id�����Վ���
)
ma:Building_WallInner2:id�����Վ���
(
ma:Building_WallInner:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������ëp088�
 *���������Fantasy Castle Floor 01 - 8m".

  ��  ��L=8���B����   ?  �?333?(������ߒ�Z{
$
ma:Building_Floor:id�����Վ���
)
ma:Building_WallInner2:id�����Վ���
(
ma:Building_WallInner:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������ëp088�
 *�ۼ�Ō�ݠ�Fantasy Castle Floor 01 - 8m".

  ��  �D(�+8  ������   ?  �?333?(������ߒ�Z{
$
ma:Building_Floor:id�����Վ���
)
ma:Building_WallInner2:id�����Վ���
(
ma:Building_WallInner:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������ëp088�
 *���������Fantasy Castle Floor 01 - 8m".

 �D  �D(�+8 ������   ?  �?333?(������ߒ�Z{
$
ma:Building_Floor:id�����Վ���
)
ma:Building_WallInner2:id�����Վ���
(
ma:Building_WallInner:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������ëp088�
 *�����ᒆ�=&Top Walkway Bannisters and Battlements"

 `�D  ��   �?  �?  �?(������ߒ�2��Ŷ�����+����א����ǲ�Ύ��������������Ɖ�����ȳ�@����Ǐҽ�ʮߏ��ʶJ���֦�������Α���������%�����ԅ��������e����������Ϛ����������ƿ���Ѿ����ы����ь����ֆ�����������ߔታ�V����Ԡ���ɋ������ӷ���Ƥ��ȧ���w��ӭӈΏ��������mǺ�����������Ā�������ݫ��۩��������֣����&����S���җ����ｯ߫É��􈤂��\�����߼����������æ���ʊ���������������Y���ɂ���1��������ա�����������������ﴬ��������������悕�)z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Ŷ�����+&Fantasy Castle Trim - Battlement 01 4m"$

  HB ������B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����҂��088�
 *�����א��&Fantasy Castle Trim - Battlement 01 4m"$

  HB  aD���B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����҂��088�
 *���ǲ�Ύ��)Fantasy Castle Bannister 01 - Curve Small"$
  �B  ��  �B   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ۯ֤���088�
 *���������,Fantasy Castle Stairs Spiral Trim 01 - Small"

  �B  ��   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ڎ�`088�
 *�����Ɖ��)Fantasy Castle Bannister 01 - Curve Small")
  �B  �C  �B  ��  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ۯ֤���088�
 *����ȳ�@,Fantasy Castle Stairs Spiral Trim 01 - Small"$

  �B  �C  ��  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ڎ�`088�
 *�����Ǐҽ�&Fantasy Castle Bannister 01 - Straight"$

  ��  �����B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�ʮߏ��ʶJ&Fantasy Castle Bannister 01 - Straight"$

  ��  �B���B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *����֦��#Fantasy Castle Trim - Battlement 01")
�A� ��  �9����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *������Α�#Fantasy Castle Trim - Battlement 01")
�A����C  �9����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���������%#Fantasy Castle Trim - Battlement 01")
 �A���D  �9����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *������ԅ��#Fantasy Castle Trim - Battlement 01"

 �+� ���   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�������e#Fantasy Castle Trim - Battlement 01"

 ��� ���   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���������#Fantasy Castle Trim - Battlement 01"

 ��� ���   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���Ϛ�����#Fantasy Castle Trim - Battlement 01"

 ��� `�D   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *������ƿ��#Fantasy Castle Trim - Battlement 01"

 ��� `�D   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *��Ѿ����#Fantasy Castle Trim - Battlement 01"

 �(� `�D   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�ы����ь�#Fantasy Castle Trim - Battlement 01"$

  ��  ����3Bgff?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *����ֆ���#Fantasy Castle Trim - Battlement 01"$

 �%�  ����Cgff?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�������#Fantasy Castle Trim - Battlement 01"$

 �%����D���gff?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *���ߔታ�V#Fantasy Castle Trim - Battlement 01"$

  �� ��D 4�gff?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���җ��Բ088�
 *�����Ԡ��&Fantasy Castle Bannister 01 - Straight")
�����(�  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ɋ������"Fantasy Castle Bannister 01 - Post")
������  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�ӷ���Ƥ"Fantasy Castle Bannister 01 - Post")
�����(�  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���ȧ���w&Fantasy Castle Bannister 01 - Straight")
�����(�  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���ӭӈΏ�"Fantasy Castle Bannister 01 - Post")
�����(�  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��������m&Fantasy Castle Bannister 01 - Straight")
�����(�  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�Ǻ�������&Fantasy Castle Bannister 01 - Straight")
��� �(�  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����Ā��"Fantasy Castle Bannister 01 - Post")
��� �(�  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *������ݫ��"Fantasy Castle Bannister 01 - Post")
��� ��  �A	 �B  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�۩������"Fantasy Castle Bannister 01 - Post")
 ���  E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���֣����&&Fantasy Castle Bannister 01 - Straight")
 ���  2E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����S&Fantasy Castle Bannister 01 - Straight"$
 ���  2E  �A   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *����җ���&Fantasy Castle Bannister 01 - Straight"$
 ���  2E  �A   �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ｯ߫É&Fantasy Castle Bannister 01 - Straight")
 ���  2E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���􈤂��\"Fantasy Castle Bannister 01 - Post")
 ���  E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *������߼�"Fantasy Castle Bannister 01 - Post")
 ���  2E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���������"Fantasy Castle Bannister 01 - Post")
 ���  2E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��æ���ʊ�"Fantasy Castle Bannister 01 - Post")
 ���  2E  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��������"Fantasy Castle Bannister 01 - Post")
��`D0 �C  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��������Y&Fantasy Castle Bannister 01 - Straight")
��D( �C  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *����ɂ���1&Fantasy Castle Bannister 01 - Straight")
��D( �C  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��������"Fantasy Castle Bannister 01 - Post")
��D� �B  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��ա�����&Fantasy Castle Bannister 01 - Straight")
��D� �B  �A����  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *����������"Fantasy Castle Bannister 01 - Post")
��D����  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *����ﴬ��"Fantasy Castle Bannister 01 - Post")
��`D����  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���������&Fantasy Castle Bannister 01 - Straight")
��D����  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����悕�)"Fantasy Castle Bannister 01 - Post")
��D( �C  �A��3�  �?  �?  �?(����ᒆ�=z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���߯����@Inside Support Pillar")
  ��  �D �TD��3�  �?  �?  �?(������ԍ�2��������>��쓨ә����ѭ����Lz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������>Fantasy Castle Pillar 01 Base"
    �?  �?  �?(��߯����@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *���쓨ә��Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(��߯����@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���ѭ����LFantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(��߯����@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�˚��ۚ��@Inside Support Pillar")
  �C  �D �TD��3�  �?  �?  �?(������ԍ�2�Ήޝ���k����鶲�)��䞻���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Ήޝ���kFantasy Castle Pillar 01 Base"
    �?  �?  �?(˚��ۚ��@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�����鶲�)Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(˚��ۚ��@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���䞻���Fantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(˚��ۚ��@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *������꟏*Inside Support Pillar"$
  ��  �� �TD   �?  �?  �?(������ԍ�2����ܐ����̌��������ԉե��dz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ܐ���Fantasy Castle Pillar 01 Base"
    �?  �?  �?(�����꟏*z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��̌������Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(�����꟏*z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���ԉե��dFantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(�����꟏*z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��ş�Ϧ�Inside Support Pillar")
  �C  �� �TD����  �?  �?  �?(������ԍ�2�ܵ������ʇ���������Τ�˜Nz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ܵ������Fantasy Castle Pillar 01 Base"
    �?  �?  �?(�ş�Ϧ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�ʇ������Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(�ş�Ϧ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *����Τ�˜NFantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(�ş�Ϧ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�꩚��οƱInterior Stairs Main"

  �D �TD   �?  �?  �?(������ԍ�2����������������Hz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Fantasy Castle Stairs 01 - L"
  �����B  �?  �?  �?(꩚��οƱz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

䪫�����088�
 *��������HFantasy Castle Stairs 01 - L"
  �C���B  ��  �?  �?(꩚��οƱz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

䪫�����088�
 *��㿉�Ў��Inside Support Pillar")
 `�D ��C �TD��3�  �?  �?  �?(������ԍ�2$��Š��Ѝb��⨨���󍭚�ʒ�t���լϤz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���Š��ЍbFantasy Castle Pillar 01 Base"
    �?  �?  �?(�㿉�Ў��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *���⨨���Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(�㿉�Ў��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *�󍭚�ʒ�tFantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(�㿉�Ў��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����լϤ"Fantasy Castle Pillar Wall 01 Arch")
������7  D��3C  �?  �?  �?(�㿉�Ў��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *���ڧ���First Floor Interior Walls"

  z�  HD   �?  �?  �?(������ԍ�2������������������؆Г�����������􌱂̬�������k�������������Ӑ%�����������ҷ����Ӟ�ۥz����ۊՃ����������ܷ�풌�M�����������������h�����Ѱ�K���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������Fantasy Castle Wall 01")
 �E  �� �TD��3Cgff?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *���������Fantasy Castle Wall 01")
 ��E `�� �TD   �gff?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *���؆Г�Fantasy Castle Wall 01")
 H�E   � �TD���B  �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *���������+Fantasy Castle Wall Interior 01- Doorway 01"$
 ��E  �� �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�������ߠ088�
 *���􌱂̬%Fantasy Castle Wall Interior 01- Half")
 ��E  � �TD���B  �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��М����088�
 *��������kFantasy Castle Wall Interior 01"$
  aE  � �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *��������%Fantasy Castle Wall Interior 01- Half")
  aE  � �TD���B  �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��М����088�
 *�������Ӑ%+Fantasy Castle Wall Interior 01- Doorway 01"$
  /E  �� �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�������ߠ088�
 *�������Fantasy Castle Wall Interior 01"$
  �D  ���TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *������ҷ�%Fantasy Castle Wall Interior 01- Half"$
  �D  �� �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��М����088�
 *����Ӟ�ۥz%Fantasy Castle Wall Interior 01- Half"$
  �D  �C �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��М����088�
 *�����ۊՃFantasy Castle Wall Interior 01"$
  �D  �C�TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *����������+Fantasy Castle Wall Interior 01- Doorway 01"$
  /E  �C �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�������ߠ088�
 *��ܷ�풌�M%Fantasy Castle Wall Interior 01- Half")
  aE  �C �TD���B  �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��М����088�
 *����������Fantasy Castle Wall Interior 01"$
  aE  HD �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������088�
 *���������h%Fantasy Castle Wall Interior 01- Half")
 ��E  �C �TD���B  �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��М����088�
 *������Ѱ�K+Fantasy Castle Wall Interior 01- Doorway 01"$
 ��E  �C �TD   �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�������ߠ088�
 *����������Fantasy Castle Wall 01")
 H�E  �� �TD���B  �?  �?  �?(��ڧ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������D088�
 *��ݤ镇���Inside Support Pillar")
 `�D  �� �TD%�+7  �?  �?  �?(������ԍ�2'��蚅���������ĳ���ۦ��������������mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���蚅����Fantasy Castle Pillar 01 Base"
    �?  �?  �?(�ݤ镇���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *������ĳ��Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(�ݤ镇���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *��ۦ������Fantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(�ݤ镇���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���������m"Fantasy Castle Pillar Wall 01 Arch")
  �A����  D'�+�  �?  �?  �?(�ݤ镇���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��Ѕ���E088�
 *���������Floor 02 Interior Walls"

  �� @�D   �?  �?  �?(������ԍ�2����Ɂ̒�c����ޭ��D���򯭧�����秤����ǔ�����ÿ�����ͩ����쿤�������쵌d������ԝ��Ϲ��ȅ	���ط���)���ئ���qے�Ӥ�������®˖Rz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����Ɂ̒�c Fantasy Castle Wall 03 - Arch 01"

  ��  ��   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *�����ޭ��D Fantasy Castle Wall 03 - Arch 01"

  ��  �D   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *����򯭧�� Fantasy Castle Wall 03 - Arch 01"

  a�  �D   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *����秤��� Fantasy Castle Wall 03 - Arch 01"

  a�  ��   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *��ǔ����� Fantasy Castle Wall 03 - Arch 01"

  /D  �D   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *�ÿ�����ͩ Fantasy Castle Wall 03 - Arch 01"

  /D  ��   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *�����쿤�� Fantasy Castle Wall 03 - Arch 01"

 ���  ��   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *������쵌dFantasy Castle Wall 02 Half"

 @�  ��   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *�������ԝFantasy Castle Wall 02 Half"$

 ���  �D��3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *���Ϲ��ȅ	 Fantasy Castle Wall 03 - Arch 01"

 ���  �D   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *����ط���) Fantasy Castle Wall 03 - Arch 01"

 ��D  �D   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *����ئ���qFantasy Castle Wall 02 Half"$

 �(E  �D��3C  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *�ے�Ӥ��� Fantasy Castle Wall 03 - Arch 01"

 ��D  ��   �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��כ����i088�
 *�����®˖RFantasy Castle Wall 02 Half"$

 �E  �����  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����Ǵ��{088�
 *�����ߘ��OFloor 02 Bannisters"

  z�  HD   �?  �?  �?(������ԍ�2���۠��˨*�������������ჾ��û���������j�������c��������5�煼�Ņ�]��웇���?������ؗ��ู��л���籂����˒�����ʌ��U�ہ����r���̉Ї�������Հ��޸��ߜ�o��������$��������Ƌ�������ߐ���p��ݒ�ߺ���ퟃ����S����ǯՙ�����Ҳ���ȧר̰���������۶��ы�歸����ڟ��˨񟊠髯���¤����>�ݿ���݈m����򫉐����ƪ�����ʨ�����򟦷����Q�������T�Γ��Ϯ���뱻����T����񷍅�ذ����ߛ�칁��ЧHʖ���������؆�������畘��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���۠��˨*"Fantasy Castle Bannister 01 - Post")
  �D  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *����������&Fantasy Castle Bannister 01 - Straight"$
  aE @�  �D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����ჾ�&Fantasy Castle Bannister 01 - Straight"$
  zE @�  �D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��û��&Fantasy Castle Bannister 01 - Straight"$
  zE @ND  �D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��������j&Fantasy Castle Bannister 01 - Straight"$
  aE @ND  �D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��������c&Fantasy Castle Bannister 01 - Straight"$
 pFE  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���������5&Fantasy Castle Bannister 01 - Straight")
  aE  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��煼�Ņ�]&Fantasy Castle Bannister 01 - Straight"$
 p-E  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���웇���?&Fantasy Castle Bannister 01 - Straight"$
 ��D  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�������ؗ�&Fantasy Castle Bannister 01 - Straight"$
 pE  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ู��л�&Fantasy Castle Bannister 01 - Straight"$
 ��D  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���籂��&Fantasy Castle Bannister 01 - Straight"$
 ȖE  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���˒�&Fantasy Castle Bannister 01 - Straight"$
 H�E  �� @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����ʌ��U&Fantasy Castle Bannister 01 - Straight")
 ��E  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ہ����r"Fantasy Castle Bannister 01 - Post")
  aE  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *����̉Ї��"Fantasy Castle Bannister 01 - Post")
 ��E  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *������Հ�"Fantasy Castle Bannister 01 - Post")
 H�E  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��޸��ߜ�o&Fantasy Castle Bannister 01 - Straight")
 H�E  �� @�D���B��L?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���������$&Fantasy Castle Bannister 01 - Straight")
 H�E  �� @�D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��������&Fantasy Castle Bannister 01 - Straight")
 H�E  �� @�D���Bgff?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��Ƌ�����&Fantasy Castle Bannister 01 - Straight")
 H�E  HB @�D���Bgff?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���ߐ���p"Fantasy Castle Bannister 01 - Post")
 H�E  �C @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���ݒ�ߺ��&Fantasy Castle Bannister 01 - Straight"$
 ȖE  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ퟃ����S&Fantasy Castle Bannister 01 - Straight"$
 H�E  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����ǯՙ�"Fantasy Castle Bannister 01 - Post")
 ��E  �C @�D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�����Ҳ��&Fantasy Castle Bannister 01 - Straight")
 ��E  HD @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ȧר̰��&Fantasy Castle Bannister 01 - Straight")
  aE  HD @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��������۶"Fantasy Castle Bannister 01 - Post")
  aE  �C @�D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���ы�歸�&Fantasy Castle Bannister 01 - Straight"$
 pFE  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *����ڟ��˨&Fantasy Castle Bannister 01 - Straight"$
 p-E  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�񟊠髯��&Fantasy Castle Bannister 01 - Straight"$
 pE  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��¤����>&Fantasy Castle Bannister 01 - Straight"$
 ��D  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��ݿ���݈m&Fantasy Castle Bannister 01 - Straight"$
 ��D  �C @�D   �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����򫉐"Fantasy Castle Bannister 01 - Post")
  /E  �C @�D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�����ƪ���"Fantasy Castle Bannister 01 - Post")
  /E  �� @�D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *���ʨ�����"Fantasy Castle Bannister 01 - Post")
  �D  �C @�D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *�򟦷����Q"Fantasy Castle Bannister 01 - Post")
 H�E @�� @�D��V8  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��������T"Fantasy Castle Bannister 01 - Post")
 H�E ��� @�D��V8  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��Γ��Ϯ��&Fantasy Castle Bannister 01 - Straight")
  �E  ��  �D��3C*\O?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *��뱻����T&Fantasy Castle Bannister 01 - Straight")
 @�E  ��  �D��3Cgff?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����񷍅"Fantasy Castle Bannister 01 - Post")
 ��E  ��  �D
 �B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��ذ����ߛ"Fantasy Castle Bannister 01 - Post")
 ��E ���  �D����  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����Ϭ�;088�
 *��칁��ЧH&Fantasy Castle Bannister 01 - Straight")
  �E ���  �D��3C*\O?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�ʖ�������&Fantasy Castle Bannister 01 - Straight")
 @�E ���  �D��3Cgff?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *���؆���&Fantasy Castle Bannister 01 - Straight")
 ��E �A� �D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *�����畘��&Fantasy Castle Bannister 01 - Straight")
 ��E ��� �D���B  �?  �?  �?(����ߘ��Oz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ܮӚ��088�
 *������ՋFloor 02 Ground"

  z�  HD   �?  �?  �?(������ԍ�2������̺�`ѧ������������Ɠ����Ģ�����������ħ���������������T��̃��ŵ������������ؽ�քe������ȁn��Ǡ����E鐭��������ǎܓ��vӔ��ӟ����Ҩ�����ө������S����҆��e��������m��������{������ޢܘ������տ��y��������j��ރ��������ߘ��'Ȧ����ҙ������ܨ�I��ۥ�������˩�����������K�����М�\����������Όܫ�������������я��Ğ�����ٚ��8�����Ӡ��������:�������J�˷а���������ټ�����Í�|��������9����‖؄Ɖ����������������¨���]������K���楎��ܬ������4Ե�����n���鷪��M�������כʔ��έ������О���ɑ�堫���䍋�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������̺�`,Fantasy Castle Floor 01 - Curved 4m Inverted")
  E  �D @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�ѧ�������,Fantasy Castle Floor 01 - Curved 4m Inverted")
  E  � @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *������Ɠ��Fantasy Castle Floor 02")
  �E  �� @�D���  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���Ģ�����#Fantasy Castle Floor 02 - Corner 01")
 ��E  �� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *�������ħ�Fantasy Castle Floor 01 - 8m")
 ��E  H� @�D��3�  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���������Fantasy Castle Floor 01 4m")
  zE  H� @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�������TFantasy Castle Floor 02")
  �D  �� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���̃��ŵ�Fantasy Castle Floor 02")
  �D  �� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���������Fantasy Castle Floor 02")
  E  �� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *����ؽ�քeFantasy Castle Floor 01 4m")
  /E  � @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�������ȁnFantasy Castle Floor 01 4m")
  /E  /� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���Ǡ����E,Fantasy Castle Floor 01 - Curved 4m Inverted")
  E  H� @�D��3�  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�鐭������Fantasy Castle Floor 01 - 8m")
  aE  H� @�D��3�  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *���ǎܓ��vFantasy Castle Floor 02")
  /E  �� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *�Ӕ��ӟ��#Fantasy Castle Floor 02 - Corner 01")
  aE  �� @�D ��  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *���Ҩ�����Fantasy Castle Floor 02")
  aE  � @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *�ө������SFantasy Castle Floor 01 4m")
  zE  H� @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�����҆��eFantasy Castle Floor 02")
  zE  � @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���������mFantasy Castle Floor 01 4m")
  �E  /� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���������{,Fantasy Castle Floor 01 - Curved 4m Inverted")
  �E �D� @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����Fantasy Castle Floor 01 4m"$
 ��E  � @�D   �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���ޢܘ��,Fantasy Castle Floor 01 - Curved 4m Inverted"$
  �E  � @�D   �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *�����տ��yFantasy Castle Floor 01 4m")
  �E  � @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���������j#Fantasy Castle Floor 02 - Corner 02")
 ��E  �� @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��鋖��.088�
 *���ރ����Fantasy Castle Floor 01 4m")
 ��E  � @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�����ߘ��'Fantasy Castle Floor 01 4m")
  �E  �� @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�Ȧ����ҙ�#Fantasy Castle Floor 02 - Corner 02")
 ��E  �� @�D ��  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��鋖��.088�
 *������ܨ�IFantasy Castle Floor 02")
 ��E  �� @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���ۥ�����#Fantasy Castle Floor 02 - Corner 01")
 ��E  �� @�D���  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *���˩����#Fantasy Castle Floor 02 - Corner 01")
 ��E  �� @�D ��  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *��������K#Fantasy Castle Floor 02 - Corner 01")
 ��E  �� @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *������М�\#Fantasy Castle Floor 02 - Corner 01")
 ��E  �� @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *����������#Fantasy Castle Floor 02 - Corner 02"$

 ��E @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��鋖��.088�
 *��Όܫ���Fantasy Castle Floor 02"$

 ��E @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *���������#Fantasy Castle Floor 02 - Corner 02")
 ��E  �C @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��鋖��.088�
 *���я��Ğ�Fantasy Castle Floor 02")
 ��E  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *�����ٚ��8#Fantasy Castle Floor 02 - Corner 01")
 ��E  �C @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *������Ӡ��Fantasy Castle Floor 01 - 8m"$
 ��E  �D @�D   �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������:Fantasy Castle Floor 02")
 ��E  HD @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *��������JFantasy Castle Floor 02")
  zE  HD @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *��˷а���Fantasy Castle Floor 01 - 8m")
  aE  HD @�D��3�  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������q088�
 *�������ټFantasy Castle Floor 01 4m")
  /E  �D @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *������Í�|Fantasy Castle Floor 01 4m")
  /E  �D @�D����  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *���������9#Fantasy Castle Floor 02 - Corner 01")
  aE  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
����ൌ��088�
 *�����‖؄Fantasy Castle Floor 02")
  HE  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *�Ɖ������Fantasy Castle Floor 02")
  /E  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *��������,Fantasy Castle Floor 01 - Curved 4m Inverted")
  E  HD @�D��3�  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *����¨���]Fantasy Castle Floor 02")
  E  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *�������KFantasy Castle Floor 02")
  �D  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������"088�
 *����楎��Fantasy Castle Floor 01 4m"$

 ��E @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�ܬ������4Fantasy Castle Floor 01 4m")
 ��E  �C @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�Ե�����nFantasy Castle Floor 01 4m")
 ��E  �C @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *����鷪��MFantasy Castle Floor 01 4m")
  �E  HD @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *��������כFantasy Castle Floor 01 4m")
 ��E  �D @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�ʔ��έ�,Fantasy Castle Floor 01 - Curved 4m Inverted")
  �E  HD @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *������О��,Fantasy Castle Floor 01 - Curved 4m Inverted")
  �E  �D @�D   �  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��ɑ�堫��Fantasy Castle Floor 01 4m")
  zE  �D @�D���B  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *��䍋�����Fantasy Castle Floor 01 4m")
  zE  �D @�D��3C  �?  �?  �?(�����Ջz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��ӡ����088�
 *�����⦍�aCastle Tower - 4xTiles High")
  ��  �D �TD����  �?  �?  �?(������ԍ�2�����̿»�ݩ����h�����ª�-���ӯ��������Ȟ���������!�¶�������ܪ��ܩ�4�������(�ҳ�闣����С�4ɧ���������������Վ�����?ޙ������˄����ǻ�����������陚�����Ъ������T������٬ ��ž����ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����̿»�Fantasy Castle Wall 02 - Curved"
  ����3C  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�ݩ����hFantasy Castle Wall 02 - Curved"$

  ��  D��3�  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *������ª�-)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D��3�  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *����ӯ���)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D �B  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *������Ȟ�"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D �B  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *���������!"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D��3�  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *��¶������"Fantasy Castle Wall 03 - Curve Top"$

  �C  �D�.e6  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *��ܪ��ܩ�4"Fantasy Castle Wall 03 - Curve Top")
  �C  ��  �D ��  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *��������()Fantasy Castle Wall 02 - Curved Window 01"$

  �C  �D  ��  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *��ҳ�闣'Fantasy Castle Wall 02 - Curved Doorway"$

  �C  �D�.�6  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ܢ��088�
 *�����С�4Fantasy Castle Wall 02 - Curved"$

  �C  D  ��  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *�ɧ�������Fantasy Castle Wall 02 - Curved"$

  �C  D�.�6  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *��������Fantasy Castle Wall 02 - Curved"$

  ��  D �B  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *��Վ�����?Fantasy Castle Wall 02 - Curved"
  �C  ��  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�ޙ������'Fantasy Castle Wall 01 - Curved Doorway"
  �C�.�6  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��⅏����088�
 *�˄����ǻ�Fantasy Castle Wall 02 - Curved"
  �� �B  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *����������Spiral Stairs Tower"
 ����  �?  �?  �?(����⦍�a29������������ꨭ��m�����������݊����a����ވ�ʥ����Ϟ��yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Spiral Stairs 6m"
    �?  �?  �?(���������2(ɼ������㑋���������ڍ�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ɼ������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�㑋������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����ڍ���-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����ꨭ��mSpiral Stairs 6m"
  D   �?  �?  �?(���������2&����ӧ��:���۟�������ޭ�ݯn�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ӧ��:-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(���ꨭ��mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����۟����-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(���ꨭ��mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����ޭ�ݯn-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(���ꨭ��mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(���ꨭ��mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����������Spiral Stairs 6m"
  �D   �?  �?  �?(���������2'�테��˽���ɺ�ȼ��������������ѕεz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��테��˽-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����ɺ�ȼ�-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����ѕε-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���݊����aSpiral Stairs 6m"
  �D   �?  �?  �?(���������2�ѕ�������ā�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ѕ������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(��݊����az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��ā�����-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(��݊����az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����ވ�ʥ$Fantasy Castle Floor 01 - Curved 4m "
 �E �B  �?  �?  �?(���������Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *�����Ϟ��y,Fantasy Castle Floor 01 - Curved 4m Inverted")
   9���C �E  ��  �?   ?  �?(���������Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��陚�����$Fantasy Castle Floor 01 - Curved 4m "
    �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *�Ъ������T$Fantasy Castle Floor 01 - Curved 4m "
 ����  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *�������٬ $Fantasy Castle Floor 01 - Curved 4m "
  �B  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *���ž����e$Fantasy Castle Floor 01 - Curved 4m "
 ��3�  �?  �?  �?(����⦍�az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����������Castle Tower - 4xTiles High"$
  ��  �� �TD   �?  �?  �?(������ԍ�2�̺�������ӳ��������Щ�W�����������������ԊǕ�ނ��Ɏ�ݡ���K����γ��^�����̴�O�މ���������ߟ��Ì��ś������䥜���������K����ڂ�������؉�%ǻ�и������������wβ����������܃д���Ӑ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�̺����Fantasy Castle Wall 02 - Curved"
  ����3C  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *����ӳ���Fantasy Castle Wall 02 - Curved"$

  ��  D��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *������Щ�W)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *���������)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *����������"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *�ԊǕ�ނ��"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *�Ɏ�ݡ���K"Fantasy Castle Wall 03 - Curve Top"$

  �C  �D�.e6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *�����γ��^"Fantasy Castle Wall 03 - Curve Top")
  �C  ��  �D ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *������̴�O)Fantasy Castle Wall 02 - Curved Window 01"$

  �C  �D  ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *��މ�����'Fantasy Castle Wall 02 - Curved Doorway"$

  �C  �D�.�6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ܢ��088�
 *�����ߟ�Fantasy Castle Wall 02 - Curved"$

  �C  D  ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *��Ì��ś�Fantasy Castle Wall 02 - Curved"$

  �C  D�.�6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *������䥜�Fantasy Castle Wall 02 - Curved"$

  ��  D �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *���������KFantasy Castle Wall 02 - Curved"
  �C  ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�����ڂ��'Fantasy Castle Wall 01 - Curved Doorway"
  �C�.�6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��⅏����088�
 *������؉�%Fantasy Castle Wall 02 - Curved"
  �� �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�ǻ�и����Spiral Stairs Tower"
 ����  �?  �?  �?(���������29��ķ���y����ŕς��򖃸�ǫ�������&�����̤�)�������ҕz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ķ���ySpiral Stairs 6m"
    �?  �?  �?(ǻ�и����2%�݈����g�������q�ɋ�������������Az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��݈����g-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(��ķ���yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��������q-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(��ķ���yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��ɋ������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(��ķ���yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��������A-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(��ķ���yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����ŕς�Spiral Stairs 6m"
  D   �?  �?  �?(ǻ�и����2'�޸���V�����������������������Ǉz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��޸���V-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(����ŕς�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(����ŕς�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(����ŕς�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�������Ǉ-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(����ŕς�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��򖃸�ǫ�Spiral Stairs 6m"
  �D   �?  �?  �?(ǻ�и����2$��ۦ��ƻQ����ֺ���⼋����)�������!z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ۦ��ƻQ-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(�򖃸�ǫ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����ֺ��-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(�򖃸�ǫ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��⼋����)-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(�򖃸�ǫ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��������!-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(�򖃸�ǫ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�������&Spiral Stairs 6m"
  �D   �?  �?  �?(ǻ�и����2�Ƀ����������ιҎz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Ƀ�����-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(������&z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *������ιҎ-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(������&z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *������̤�)$Fantasy Castle Floor 01 - Curved 4m "
 �E �B  �?  �?  �?(ǻ�и����Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *��������ҕ,Fantasy Castle Floor 01 - Curved 4m Inverted")
   9���C �E  ��  �?   ?  �?(ǻ�и����Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *���������w$Fantasy Castle Floor 01 - Curved 4m "
    �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *�β������$Fantasy Castle Floor 01 - Curved 4m "
 ����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *�����܃д�$Fantasy Castle Floor 01 - Curved 4m "
  �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *���Ӑ����$Fantasy Castle Floor 01 - Curved 4m "
 ��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *��ݨ����TCastle Tower - 4xTiles High")
  �D  �D �TD��3�  �?  �?  �?(������ԍ�2���������|ϼ���ū�`��������坾�������������	�¤��ô�����˭���e�����χ���ǫϵ�إ����ϳ����ڻ����滖����������۶h�����������հT����������������΀���H���ٟ鱣A���틙�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������|Fantasy Castle Wall 02 - Curved"
  ����3C  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�ϼ���ū�`Fantasy Castle Wall 02 - Curved"$

  ��  D��3�  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *��������)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D��3�  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *��坾�����)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D �B  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *���������	"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D �B  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *��¤��ô��"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D��3�  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *����˭���e"Fantasy Castle Wall 03 - Curve Top"$

  �C  �D�.e6  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *������χ��"Fantasy Castle Wall 03 - Curve Top")
  �C  ��  �D ��  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *��ǫϵ�إ�)Fantasy Castle Wall 02 - Curved Window 01"$

  �C  �D  ��  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *����ϳ���'Fantasy Castle Wall 02 - Curved Doorway"$

  �C  �D�.�6  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ܢ��088�
 *��ڻ��Fantasy Castle Wall 02 - Curved"$

  �C  D  ��  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *���滖����Fantasy Castle Wall 02 - Curved"$

  �C  D�.�6  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *�������۶hFantasy Castle Wall 02 - Curved"$

  ��  D �B  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *��������Fantasy Castle Wall 02 - Curved"
  �C  ��  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�����հT'Fantasy Castle Wall 01 - Curved Doorway"
  �C�.�6  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��⅏����088�
 *��������Fantasy Castle Wall 02 - Curved"
  �� �B  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�������Spiral Stairs Tower"
 ����  �?  �?  �?(�ݨ����T2:ֶ��٘���䂧��<��������S��ڧ�٦��إ���������詆���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ֶ��٘���Spiral Stairs 6m"
    �?  �?  �?(������2'����������έ���󟽰�ĸX��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(ֶ��٘���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����έ��-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(ֶ��٘���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *��󟽰�ĸX-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(ֶ��٘���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(ֶ��٘���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�䂧��<Spiral Stairs 6m"
  D   �?  �?  �?(������2%��ݯ�ߓ�Z��������/��������z�����㲉�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ݯ�ߓ�Z-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(䂧��<z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������/-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(䂧��<z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������z-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(䂧��<z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *������㲉�-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(䂧��<z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������SSpiral Stairs 6m"
  �D   �?  �?  �?(������2&���͕���ډ�����7�����������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����͕���-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(��������Sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�ډ�����7-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(��������Sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(��������Sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(��������Sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���ڧ�٦��Spiral Stairs 6m"
  �D   �?  �?  �?(������2����ę�\������٢z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ę�\-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(��ڧ�٦��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�������٢-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(��ڧ�٦��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�إ������$Fantasy Castle Floor 01 - Curved 4m "
 �E �B  �?  �?  �?(������Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����詆���,Fantasy Castle Floor 01 - Curved 4m Inverted")
   9���C �E  ��  �?   ?  �?(������Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *����΀���H$Fantasy Castle Floor 01 - Curved 4m "
    �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����ٟ鱣A$Fantasy Castle Floor 01 - Curved 4m "
 ����  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����틙��$Fantasy Castle Floor 01 - Curved 4m "
  �B  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����������$Fantasy Castle Floor 01 - Curved 4m "
 ��3�  �?  �?  �?(�ݨ����Tz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *����������Castle Tower - 4xTiles High")
  �D  �� �TD���B  �?  �?  �?(������ԍ�2������ه�����،�������ٷ׉��Б����������ה���Ŗ��՞D��ɨ����W����ؚԺ9�Ν������Γ�����T���ޭ��D�������������*ϗ�۬�ĥ:וܞ������������Ӌ���𽽕���ʭ��ؼ����������[��ܘ������������1z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ه��Fantasy Castle Wall 02 - Curved"
  ����3C  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *����،����Fantasy Castle Wall 02 - Curved"$

  ��  D��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *����ٷ׉��)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *�Б������)Fantasy Castle Wall 02 - Curved Window 01"$

  ��  �D �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *�����ה���"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *�Ŗ��՞D"Fantasy Castle Wall 03 - Curve Top"$

  ��  �D��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *���ɨ����W"Fantasy Castle Wall 03 - Curve Top"$

  �C  �D�.e6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *�����ؚԺ9"Fantasy Castle Wall 03 - Curve Top")
  �C  ��  �D ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����в��088�
 *��Ν�����)Fantasy Castle Wall 02 - Curved Window 01"$

  �C  �D  ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ů������a088�
 *��Γ�����T'Fantasy Castle Wall 02 - Curved Doorway"$

  �C  �D�.�6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ܢ��088�
 *����ޭ��DFantasy Castle Wall 02 - Curved"$

  �C  D  ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *���������Fantasy Castle Wall 02 - Curved"$

  �C  D�.�6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *������*Fantasy Castle Wall 02 - Curved"$

  ��  D �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������1088�
 *�ϗ�۬�ĥ:Fantasy Castle Wall 02 - Curved"
  �C  ��  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *�וܞ�����'Fantasy Castle Wall 01 - Curved Doorway"
  �C�.�6  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��⅏����088�
 *��������ӋFantasy Castle Wall 02 - Curved"
  �� �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������1088�
 *����𽽕��Spiral Stairs Tower"
 ����  �?  �?  �?(���������28���������ɂ�����̪ě�֫����ݡۑ�������ŉ�}�Б��ݢ5z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������Spiral Stairs 6m"
    �?  �?  �?(���𽽕��2&���ǖ���b����钬�������I����ߝ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ǖ���b-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����钬��-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *������I-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����ߝ���-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���ɂ�����Spiral Stairs 6m"
  D   �?  �?  �?(���𽽕��2'����������戞�����Ԣچ�����ě�Ϩ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(��ɂ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *���戞��-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(��ɂ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����Ԣچ��-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(��ɂ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����ě�Ϩ�-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(��ɂ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�̪ě�֫�Spiral Stairs 6m"
  �D   �?  �?  �?(���𽽕��2&���ۮ�ڡߛ�ѷ���������Ɔh����ܵ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ۮ�ڡ-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(̪ě�֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�ߛ�ѷ���-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(̪ě�֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�������Ɔh-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C����  �?  �?  �?(̪ě�֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *�����ܵ���-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  �C��3�  �?  �?  �?(̪ě�֫�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����ݡۑ��Spiral Stairs 6m"
  �D   �?  �?  �?(���𽽕��2���ΐ���e���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ΐ���e-Fantasy Castle Stairs Spiral 01 - Small 150cm"
    �?  �?  �?(���ݡۑ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *����������-Fantasy Castle Stairs Spiral 01 - Small 150cm"
  C���B  �?  �?  �?(���ݡۑ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��储���088�
 *������ŉ�}$Fantasy Castle Floor 01 - Curved 4m "
 �E �B  �?  �?  �?(���𽽕��Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *��Б��ݢ5,Fantasy Castle Floor 01 - Curved 4m Inverted")
   9���C �E  ��  �?   ?  �?(���𽽕��Z&
$
ma:Building_Floor:id�����Վ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������088�
 *��ʭ��ؼ��$Fantasy Castle Floor 01 - Curved 4m "
    �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *���������[$Fantasy Castle Floor 01 - Curved 4m "
 ����  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *���ܘ����$Fantasy Castle Floor 01 - Curved 4m "
  �B  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *���������1$Fantasy Castle Floor 01 - Curved 4m "
 ��3�  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ˢ��088�
 *��������Tall Tower Pillar")
��E ��� �TD����  �?  �?  �?(������ԍ�21��р����\���ֿ���Ί�����џ퉚���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���р����\Fantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����ֿ��Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��Ί�����Fantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *�џ퉚����Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *������Fantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����疷��Tall Tower Pillar")
 ��D  � �TD��3�  �?  �?  �?(������ԍ�2.�ւ�����y�����������Ϻ۞ĞU��������Iӄ����дz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ւ�����yFantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(���疷��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����������Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(���疷��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���Ϻ۞ĞUFantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(���疷��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *���������IFantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(���疷��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *�ӄ����дFantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(���疷��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���ƽ����4Tall Tower Pillar")
 ���  � �TD��3�  �?  �?  �?(������ԍ�22騭�����������������𫺀�῔�菄���䪇��ܱz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�騭�����Fantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(��ƽ����4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����������Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(��ƽ����4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����𫺀�Fantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(��ƽ����4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *�῔�菄�Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(��ƽ����4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���䪇��ܱFantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(��ƽ����4z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *���������QTall Tower Pillar")
  � ��� �TD �B  �?  �?  �?(������ԍ�21�ֽ�������������������ȓ�������������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ֽ�����Fantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(��������Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����������Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(��������Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *������ȓ��Fantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(��������Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *���������Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(��������Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *����������Fantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(��������Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��ߥ�����Tall Tower Pillar")
  � ��D �TD �B  �?  �?  �?(������ԍ�20��ʷ����.�������B�ݤ���É���������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ʷ����.Fantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(�ߥ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��������BFantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(�ߥ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��ݤ���ÉFantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(�ߥ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *��������Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(�ߥ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���������Fantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(�ߥ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��󛽮��Tall Tower Pillar")
 ���  E �TD�.�6  �?  �?  �?(������ԍ�20��������f�­��Ŧ��ς�����������2��޾����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������fFantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(�󛽮��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *��­��Ŧ��Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(�󛽮��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�ς����Fantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(�󛽮��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *��������2Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(�󛽮��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *���޾����Fantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(�󛽮��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *����������Tall Tower Pillar")
 ��D  E �TD�.�6  �?  �?  �?(������ԍ�2.���֘��G�������������ȩ����Ֆ믮�6딧�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����֘��GFantasy Castle Pillar 01 Base")
��:��g�   :]� �  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����������Fantasy Castle Pillar 01 Cap")
��:��g� �	D]� �  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *�����ȩ��Fantasy Castle Pillar 01 Mid")
��:��g�  D]� �  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����ό�088�
 *���Ֆ믮�6Fantasy Castle Pillar 01 Top")
  ��  м  �D]� �  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *�딧�����Fantasy Castle Pillar 01 Cap")
��< ��  �D]� �  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��Ⱦ�����)Inside Support Pillar")
  ��  �� �TD����  �?  �?  �?(������ԍ�2����薎��֢������9�������Ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����薎��Fantasy Castle Pillar 01 Base"
    �?  �?  �?(�Ⱦ�����)z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *�֢������9Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(�Ⱦ�����)z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *��������EFantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(�Ⱦ�����)z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 *��ݩ����zInside Support Pillar")
  ��  �C �TD����  �?  �?  �?(������ԍ�2߲����ج���֊���������Όz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�߲����جFantasy Castle Pillar 01 Base"
    �?  �?  �?(�ݩ����zz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ƙ�����*088�
 *����֊����Fantasy Castle Pillar 01 Top"
  D   �?  �?  �?(�ݩ����zz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ߞ������088�
 *������ΌFantasy Castle Pillar 01 Cap"
 �"D   �?  �?  �?(�ݩ����zz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ݥ����088�
 %
TemplateAssetRefFantasy_Castle_01
|��储���-Fantasy Castle Stairs Spiral 01 - Small 150cmR>
StaticMeshAssetRef(sm_ts_fan_cas_stairs_spiral_001_sm_150cm
r��⅏����'Fantasy Castle Wall 01 - Curved DoorwayR:
StaticMeshAssetRef$sm_ts_fan_cas_wall_curve_001_door_01
r�����ܢ��'Fantasy Castle Wall 02 - Curved DoorwayR:
StaticMeshAssetRef$sm_ts_fan_cas_wall_curve_002_door_01
k����в��"Fantasy Castle Wall 03 - Curve TopR9
StaticMeshAssetRef#sm_ts_fan_cas_wall_curve_003_top_01
rů������a)Fantasy Castle Wall 02 - Curved Window 01R9
StaticMeshAssetRef#sm_ts_fan_cas_wall_curve_002_win_01
a�������1Fantasy Castle Wall 02 - CurvedR2
StaticMeshAssetRefsm_ts_fan_cas_wall_curve_002
a��������1Fantasy Castle Wall 01 - CurvedR2
StaticMeshAssetRefsm_ts_fan_cas_wall_curve_001
n��鋖��.#Fantasy Castle Floor 02 - Corner 02R;
StaticMeshAssetRef%sm_ts_fan_cas_floor_002_4m_corner_002
`���������Fantasy Castle Wall Interior 01R0
StaticMeshAssetRefsm_ts_fan_cas_wall_int_001
j��М����%Fantasy Castle Wall Interior 01- HalfR5
StaticMeshAssetRefsm_ts_fan_cas_wall_int_half_001
t�������ߠ+Fantasy Castle Wall Interior 01- Doorway 01R8
StaticMeshAssetRef"sm_ts_fan_cas_wall_int_001_door_01
`䪫�����Fantasy Castle Stairs 01 - LR4
StaticMeshAssetRefsm_ts_fan_cas_stairs_001_L_ref
y���ڎ�`,Fantasy Castle Stairs Spiral Trim 01 - SmallR=
StaticMeshAssetRef'sm_ts_fan_cas_stairs_spiral_trim_001_sm
t��ۯ֤���)Fantasy Castle Bannister 01 - Curve SmallR:
StaticMeshAssetRef$sm_ts_fan_cas_bannister_001_curve_sm
l�����҂��&Fantasy Castle Trim - Battlement 01 4mR5
StaticMeshAssetRefsm_ts_fan_cas_battlement_001_4m
h�����ˢ��$Fantasy Castle Floor 01 - Curved 4m R3
StaticMeshAssetRefsm_ts_fan_cas_floor_curve_001
o����ൌ��#Fantasy Castle Floor 02 - Corner 01R;
StaticMeshAssetRef%sm_ts_fan_cas_floor_002_4m_corner_001
eỊ�����_"Fantasy Castle Wall 02 - Window 01R3
StaticMeshAssetRefsm_ts_fan_cas_wall_002_win_01
\����Ǵ��{Fantasy Castle Wall 02 HalfR1
StaticMeshAssetRefsm_ts_fan_cas_wall_half_002
o���邖��h'Fantasy Castle Wall 02 Half - Window 01R8
StaticMeshAssetRef"sm_ts_fan_cas_wall_half_002_win_01
m��Ѕ���E"Fantasy Castle Pillar Wall 01 ArchR;
StaticMeshAssetRef%sm_ts_fan_cas_pillar_wall_001_arch_01
_�����ό�Fantasy Castle Pillar 01 MidR2
StaticMeshAssetRefsm_ts_fan_cas_pillar_001_mid
d��כ����i Fantasy Castle Wall 03 - Arch 01R4
StaticMeshAssetRefsm_ts_fan_cas_wall_003_arch_01
]��Ĕѫ�ۜCastle Part - Grate 01R6
StaticMeshAssetRef sm_ts_fan_cas_part_grate_001_ref
e���ߡ�Fantasy Castle Wall 01 - CellarR5
StaticMeshAssetRefsm_ts_fan_cas_wall_001_grate_01
_��������k Fantasy Castle Trim - Parapet 01R/
StaticMeshAssetRefsm_ts_fan_cas_parapet_001
f���җ��Բ#Fantasy Castle Trim - Battlement 01R2
StaticMeshAssetRefsm_ts_fan_cas_battlement_001
a���������Fantasy Castle Pillar 02 - TopR2
StaticMeshAssetRefsm_ts_fan_cas_pillar_002_top
aޏ����仗Fantasy Castle Pillar 02 - MidR2
StaticMeshAssetRefsm_ts_fan_cas_pillar_002_mid
c��Ɨ�����Fantasy Castle Pillar 02 - BaseR3
StaticMeshAssetRefsm_ts_fan_cas_pillar_002_base
^������ëpWhitebox Wall 01 TriangleR5
StaticMeshAssetRefsm_ts_gen_whitebox_wall_001_tri
i����Ϭ�;"Fantasy Castle Bannister 01 - PostR6
StaticMeshAssetRef sm_ts_fan_cas_bannister_001_post
W�������"Fantasy Castle Floor 02R0
StaticMeshAssetRefsm_ts_fan_cas_floor_002_4m
q���ܮӚ��&Fantasy Castle Bannister 01 - StraightR:
StaticMeshAssetRef$sm_ts_fan_cas_bannister_001_straight
~��á��Г{/Fantasy Castle Stairs Spiral Wall 01 - StraightR?
StaticMeshAssetRef)sm_ts_fan_cas_stairs_spiral_wall_001_strt
l�Ŵ���\$Fantasy Castle Bannister 01 - SpiralR8
StaticMeshAssetRef"sm_ts_fan_cas_bannister_001_spiral
v��싍���*Fantasy Castle Stairs Spiral 03 - Large 3mR;
StaticMeshAssetRef%sm_ts_fan_cas_stairs_spiral_003_lg_3m
j��ܕ���#Fantasy Castle Stairs 01 - StraightR7
StaticMeshAssetRef!sm_ts_fan_cas_stairs_001_straight
_�ߞ������Fantasy Castle Pillar 01 TopR2
StaticMeshAssetRefsm_ts_fan_cas_pillar_001_top
_���ݥ����Fantasy Castle Pillar 01 CapR2
StaticMeshAssetRefsm_ts_fan_cas_pillar_001_cap
`�ƙ�����*Fantasy Castle Pillar 01 BaseR3
StaticMeshAssetRefsm_ts_fan_cas_pillar_001_base
_Π���쿤�Castle Part - Window 01R7
StaticMeshAssetRef!sm_ts_fan_cas_part_window_001_ref
e�݌�����"Fantasy Castle Wall 03 - Window 01R3
StaticMeshAssetRefsm_ts_fan_cas_wall_003_win_01
n��ʨ�����&Fantasy Castle Wall 04 - Window 01 TopR7
StaticMeshAssetRef!sm_ts_fan_cas_wall_004_win_01_top
R�������qFantasy Castle Wall 02R,
StaticMeshAssetRefsm_ts_fan_cas_wall_002
g�������s#Fantasy Castle Wall 01 - Doorway 02R4
StaticMeshAssetRefsm_ts_fan_cas_wall_001_door_02
p���������'Fantasy Castle Wall 04 - Window 01 BaseR8
StaticMeshAssetRef"sm_ts_fan_cas_wall_004_win_01_base
R��������DFantasy Castle Wall 01R,
StaticMeshAssetRefsm_ts_fan_cas_wall_001
w��������,Fantasy Castle Floor 01 - Curved 4m InvertedR:
StaticMeshAssetRef$sm_ts_fan_cas_floor_curve_001_invert
z���ߟ����-Fantasy Castle Wall Foundation 01 - Pillar 01R<
StaticMeshAssetRef&sm_ts_fan_cas_wall_found_001_pillar_01
w��˚����*Fantasy Castle Wall Foundation 01 - CurvedR<
StaticMeshAssetRef&sm_ts_fan_cas_wall_found_001_curve_001
c�����Ҕ!Fantasy Castle Wall Foundation 01R2
StaticMeshAssetRefsm_ts_fan_cas_wall_found_001
S盁֞����Fantasy Castle Door 02R,
StaticMeshAssetRefsm_ts_fan_cas_door_002
��ς����DoubleDoorControllerClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local ROTATION_ROOT = script:GetCustomProperty("RotationRoot"):WaitForObject()
local OPEN_SOUND1 = script:GetCustomProperty("OpenSound1"):WaitForObject()
local CLOSE_SOUND1 = script:GetCustomProperty("CloseSound1"):WaitForObject()
local OPEN_SOUND2 = script:GetCustomProperty("OpenSound2"):WaitForObject()
local CLOSE_SOUND2 = script:GetCustomProperty("CloseSound2"):WaitForObject()

-- Variable
local previousRotation = 0.0

-- float GetDoorRotation()
-- Gives you the current rotation of the door
function GetDoorRotation()
	return ROTATION_ROOT:GetRotation().z / 90.0
end

function Tick(deltaTime)
	local doorRotation = GetDoorRotation()

	if doorRotation ~= 0.0 and previousRotation == 0.0 then
		if OPEN_SOUND1 then
			OPEN_SOUND1:Play()
		end

		if OPEN_SOUND2 then
			OPEN_SOUND2:Play()
		end
	end

	if doorRotation == 0.0 and previousRotation ~= 0.0 then
		if CLOSE_SOUND1 then
			CLOSE_SOUND1:Play()
		end

		if CLOSE_SOUND2 then
			CLOSE_SOUND2:Play()
		end
	end

	previousRotation = doorRotation
end

\��������qFantasy Castle Floor 01 - 8mR0
StaticMeshAssetRefsm_ts_fan_cas_floor_001_8m
Zʘ����ŤGBone Human Scattered 02R3
StaticMeshAssetRefsm_bones_human_scatter_02_ref
:ȯ�ܐ���ECustom Bricks Chunky Stone 01������� 
S������Bricks Chunky Stone 01R-
MaterialAssetRefmi_brick_stone_chunky_001
���������<&Custom Base Material from Skeleton Mob��������ᢨ�

emissive_booste�=�A


glow color�
  �?%  �?
&
primary color���> �>���=%  �?
&
fresnel_color�T8F?C�Y?)\o?%  �?

fresnel_powere    

fresnel_emissive_booste    

speculare4Mh>
B������ᢨSkeleton MaterialR 
MaterialAssetRefskeletonBody
�����Θ��8Team Score Displayb�
� ����힞*�����힞Team Score Display"  �?  �?  �?(�������X2	מ��殶�Z�

cs:TeamX

cs:LabeljScore:

cs:ShowMaxScoreP

cs:MaxScoreXd
-
cs:Team:tooltipjWhich team's score to show
.
cs:Label:tooltipjDescription for this score
E
cs:ShowMaxScore:tooltipj*Whether to show the value out of a maximum
0
cs:MaxScore:tooltipjThe maximum value to showz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�מ��殶�ClientContext"
    �?  �?  �?(����힞2����������ͮğ�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������TeamScoreDisplayClient"
    �?  �?  �?(מ��殶�Z=
 
cs:ComponentRoot�����힞


cs:TextBox�
���Բ���Qz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������^*��ͮğ�TeamScoreCanvas"
    �?  �?  �?(מ��殶�2
������˧�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�Y:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*�������˧�Panel"
    �?  �?  �?(�ͮğ�2������������Բ���QZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�h�,%  �A-  �A:

mc:euianchor:middlecenter� �4


mc:euianchor:topleft

mc:euianchor:topleft*����������BackgroundImage"
    �?  �?  �?(������˧�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���,:

mc:euianchor:middlecenter�$

ؿ���ώH+ R>+ R>+ R>%   ? �4


mc:euianchor:topleft

mc:euianchor:topleft*����Բ���QText Box"
    �?  �?  �?(������˧�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent���,:

mc:euianchor:middlecenter�/

Team Score%  �?"
mc:etextjustify:left(�8


mc:euianchor:topcenter

mc:euianchor:topcenter&
TemplateAssetRefTeam_Score_Display
�ۣ������8NPCAttackClientZ��--[[
	NPCAttack - Client
	by: standardcombo
	v0.9.0
	
	The client counterpart for NPCAttackServer. Listens for damage and destroy networked events
	and spawns the appropriate effects for each.
--]]

local ROOT = script:GetCustomProperty("Root"):WaitForObject()

local DAMAGE_FX = script:GetCustomProperty("DamageFX")
local DESTROY_FX = script:GetCustomProperty("DestroyFX")

local STATE_SLEEPING = 0
local STATE_ENGAGING = 1
local STATE_ATTACK_CAST = 2
local STATE_ATTACK_RECOVERY = 3
local STATE_PATROLLING = 4
local STATE_LOOKING_AROUND = 5
local STATE_DEAD_1 = 6
local STATE_DEAD_2 = 7
local STATE_DISABLED = 8


function OnPropertyChanged(object, propertyName)
	
	if (propertyName == "CurrentState") then
		local state = ROOT:GetCustomProperty("CurrentState")
		
		if (state == STATE_DEAD_1) then
			SpawnAsset(DESTROY_FX, script:GetWorldPosition(), script:GetWorldRotation())
		end
	end
end
ROOT.networkedPropertyChangedEvent:Connect(OnPropertyChanged)


function GetID()
	if Object.IsValid(ROOT) then
		return ROOT:GetCustomProperty("ObjectId")
	end
	return nil
end

function OnObjectDamaged(id, prevHealth, dmgAmount, impactPosition, impactRotation, sourceObject)
	-- Ignore other NPCs, make sure this event is for us
	if id == GetID() then
		SpawnAsset(DAMAGE_FX, impactPosition, impactRotation)
	end
end

function OnObjectDestroyed(id)
	-- Ignore other NPCs, make sure this event is for us
	--if id == GetID() then
		--SpawnAsset(DESTROY_FX, script:GetWorldPosition(), script:GetWorldRotation())
	--end
end

local damagedListener = Events.Connect("ObjectDamaged", OnObjectDamaged)
local destroyedListener = Events.Connect("ObjectDestroyed", OnObjectDestroyed)


function OnDestroyed(obj)
	if Object.IsValid(damagedListener) then
		damagedListener:Disconnect()
	end
	
	if Object.IsValid(destroyedListener) then
		destroyedListener:Disconnect()
	end
end
ROOT.destroyEvent:Connect(OnDestroyed)


function SpawnAsset(template, pos, rot)
	local spawnedVfx = World.SpawnAsset(template, {position = pos, rotation = rot})
	if spawnedVfx and spawnedVfx.lifeSpan <= 0 then
		spawnedVfx.lifeSpan = 1.5
	end
end�

cs:Root� 

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�
n
cs:Root:tooltipj[A reference to the root of the template, where most of the NPC's custom properties are set.
R
cs:DamageFX:tooltipj;Visual effect template to spawn when this NPC takes damage.
K
cs:DestroyFX:tooltipj3Visual effect template to spawn when this NPC dies.
���Ӵ���4
Teleporterb�
� ����d*�����d
Teleporter"  �?  �?  �?(�������2%���ñϳ�Z��������E��������~�ἔ����Z�

	cs:Target� 

cs:DestinationOffsetr 
#
cs:StartPointEffects�
��˽����
!
cs:EndPointEffects�
��˽����

cs:TeleporterCooldowne    

cs:PerPlayerCooldowne    
q
cs:Target:tooltipj\Target object to teleport to. Leave blank to just use DestinationOffset as a world position.
v
cs:DestinationOffset:tooltipjVOffset from the target to teleport to. If no target, instead this is a world position.
h
cs:TeleporterCooldown:tooltipjGCooldown period before another player can teleport from this teleporter
n
cs:PerPlayerCooldown:tooltipjNCooldown period on the player before they can teleport again at any teleporterz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ñϳ�ZTeleporterServer"
    �?  �?  �?(����dZ=

cs:ComponentRoot�
����d


cs:Trigger��ἔ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ړ������j*���������EClientContext"
    �?  �?  �?(����d2
���������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������TeleporterClient"
    �?  �?  �?(��������EZ!

cs:ComponentRoot�
����dz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
	��ʸ҃�9*���������~Geo"
    �?  �?  �?(����d2������������ۊ䉛�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������!Cylinder - Rounded Bottom-Aligned"
     @   @��L=(��������~Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�+ R>+ R>+ R>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ۊ䉛�Pipe (thin)"
  ff�?ff�?���=(��������~Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t?z�>k>)<%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Ѓ̭���P088�
 *��ἔ����Trigger"
  �B   �?  �?   @(����dZ z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�""08*
mc:etriggershape:capsule
TemplateAssetRef
Teleporter
<�Ѓ̭���PPipe (thin)R!
StaticMeshAssetRefsm_pipe_003
L���������Basic MaterialR-
MaterialAssetRefmi_basic_pbr_material_001
_������Փ�!Cylinder - Rounded Bottom-AlignedR-
StaticMeshAssetRefsm_cylinder_rounded_001
���ʸ҃�9TeleporterClientZ��--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

-- User exposed properties
local START_POINT_EFFECTS = COMPONENT_ROOT:GetCustomProperty("StartPointEffects")
local END_POINT_EFFECTS = COMPONENT_ROOT:GetCustomProperty("EndPointEffects")

-- nil OnPlayerTeleport(Vector3, Vector3)
-- Create effects for a teleport
function OnPlayerTeleport(startPosition, endPosition)
	if START_POINT_EFFECTS then
		World.SpawnAsset(START_POINT_EFFECTS, {position = startPosition})
	end

	if END_POINT_EFFECTS then
		World.SpawnAsset(END_POINT_EFFECTS, {position = endPosition})
	end
end

-- Initialize
Events.Connect("PlayerTeleport_Internal", OnPlayerTeleport)

���˽����Helper_TeleportEffectsb�
� ȹ�ɞ��*�ȹ�ɞ��Helper_TeleportEffects"  �?  �?  �?(�����۬ǯ2����Ǡ��������Ԋ̺Z e   @z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����Ǡ���Health Spiral VFX"
    �?  �?  �?(ȹ�ɞ��Z�
!
bp:color��t>:M?   @%  �?

bp:Lifee33�?

bp:Ring Lifee  �?
#
bp:Particle Scale Multipliere   @

	bp:Radiuse  @@

bp:Spiral Speede   Az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
ӝ������ �*������Ԋ̺Meta Fantasy Revive Life 02 SFX"
    �?  �?  �?(ȹ�ɞ��Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�)

������|-�l��5  �?=  aEE  �CXx�
NoneNone
g������|Meta Fantasy Revive Life 02 SFXR8
AudioAssetRef'sfx_meta_fantasy_revive_life_02_Cue_ref
Lӝ������Health Spiral VFXR*
VfxBlueprintAssetReffxbp_health_spiral
��إ����)Spinning Axe Trapbe
U ���������*H���������TemplateBundleDummy"
    �?  �?  �?�Z

���ǁ���
NoneNone��
 e3582eb6a42b47e4809d4981c50fb87c a2f7c421ba7048539b88b86e0dc3f408itscodi"1.0.0*GA basic spinning axe trap.
I used NPC Kit would recommend having it!!!
�����ǁ���	Axe Trapsb��
�� ����Ի��**�����Ի��*	Axe Traps"  �?  �?  �?(�����B2�������ơқ����݇.�Ԋ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������ơSpinning Axe Trap(DMG50)"$
 ɽ� XA����   �?  �?  �?(����Ի��*29�������ԡ���ƣ��Χ��ʘ�����Һ����������;������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������RotatingAxes(NoDMG)")
 ��  �AފZByq�B  �?  �?  �?(�������ơ2	��������bz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���������bCenter Point"3
{���|�= ��B:��8q��B ����Q4?�Q4?�Q4?(�������2�ȡֵ���/������/��᱕�Ƃ�Z]
)
ma:Shared_BaseMaterial:id���棿����
0
ma:Shared_BaseMaterial:color�.z<�Ev?%  �?pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
�����088�
 *��ȡֵ���/Axes"3
Ms@d�>?��?�.�7��+7 �ӿ �? �? �?(��������b2�כ��������䘈���pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*��כ������Fantasy Weapon - Axe 01 (Prop)"3
�ד9�����g�@�_A����9���ˍh@ˍh@ˍh@(�ȡֵ���/29�����㪍����������ٽ���ꬥ�����ժ�����l��������pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*������㪍�Fantasy Axe Grip 01"
}��   �?  �?  �?(�כ������Z"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��˷����08�
 *���������Fantasy Pommel 02"
�?�� tw�?tw�?tw�?(�כ������pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
Ƚ�������08�
 *��ٽ���ꬥFantasy Axe Base 01"
��B   �?  �?  �?(�כ������ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Я�����08�
 *������ժFantasy Hammer Guard 01"
��A   �?  �?  �?(�כ������Z"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

���݂���08�
 *������lFantasy Axe Blade 01"

  �  \B   �?  �?  �?(�כ������ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *���������Fantasy Axe Blade 01"$

  A  \B��3�  �?  �?  �?(�כ������ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *���䘈���Fantasy Weapon - Axe 01 (Prop)"3
ȏ�A��BG�5:��8��3��q��ˍh@ˍh@ˍh@(�ȡֵ���/28Ǣ������&��㫔���M���������ǟ��ֹ�?�����������䪚�Cpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�Ǣ������&Fantasy Axe Grip 01"
}��   �?  �?  �?(��䘈���Z"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��˷����08�
 *���㫔���MFantasy Pommel 02"
�?�� tw�?tw�?tw�?(��䘈���pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
Ƚ�������08�
 *���������Fantasy Axe Base 01"
��B   �?  �?  �?(��䘈���ZO
#
ma:Shared_Detail1:id�
ԁ������;
(
ma:Shared_BaseMaterial:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Я�����08�
 *��ǟ��ֹ�?Fantasy Hammer Guard 01"
��A   �?  �?  �?(��䘈���Z"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

���݂���08�
 *��������Fantasy Axe Blade 01"

  �  \B   �?  �?  �?(��䘈���ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *�����䪚�CFantasy Axe Blade 01"$

  A  \B��3�  �?  �?  �?(��䘈���ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *�������/Center Rotation".
�"��f5�>�m�@
Ie��.�yJ�?�J�?'F�>(��������bZa
(
ma:Shared_BaseMaterial:id�
ԁ������;
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���᱕�Ƃ�Axe Spin"3
�5���!�E�UE:��8��3��dܿ���?���?���?(��������bpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ա����ȫP*�ԡ���ƣ��Axes Pillar"

 й� �A   �?  �?  �?(�������ơ2^��ͻ�ݯ˸��ӷ����Q�ڔ�������Ƕ������˖��Ҕ����������ѭ��9ў�������ഗ�о�j��������,pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ͻ�ݯ˸Cylinder"$
  ��  �:
g.B   �?  �?�s�?(ԡ���ƣ��Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���ӷ����QCylinder"$
  ��  �:8�C   �?  �?��>(ԡ���ƣ��Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��ڔ������Cylinder"$
  ��  �:�C w@�?w@�?2��=(ԡ���ƣ��Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��Ƕ�����Cylinder"$
  ��  �:��*C w@�?w@�?2��=(ԡ���ƣ��Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��˖��Ҕ��Cylinder"

  ��  �: �@�?�@�?F�>(ԡ���ƣ��Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�������Cylinder"$
  ��  �:�I@ X��?X��?��>(ԡ���ƣ��Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���ѭ��9Cylinder"$
  ��  �:�Q�B w@�?w@�?2��=(ԡ���ƣ��Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�ў������Cylinder"$
  ��  �:��A w@�?w@�?2��=(ԡ���ƣ��Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��ഗ�о�jCylinder"

  ��  �: b��@b��@�Ê=(ԡ���ƣ��Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���������,Cylinder"$
  ��  �: �2? ���@���@��~=(ԡ���ƣ��Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�(Χ��ʘ���NPC - Axe Trap")
�%*C �A추����B  �?  �?  �?(�������ơ20���ʀ�Ī厵��������Ț������������q��������VZ�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ʀ�ĪNPCAIServer"
  �B   �?  �?  �?(Χ��ʘ���Z�

cs:Root�Χ��ʘ���

cs:RotationRoot�Χ��ʘ���

cs:Collider���Ț����


cs:Trigger�
��������q
"
cs:AttackComponent�厵������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*�厵������NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(Χ��ʘ���Z�

cs:Root�Χ��ʘ���

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*���Ț����Collider"
  �B fff?fff?�̌?(Χ��ʘ���Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *���������qTrigger"
  �B ��?��?��?(Χ��ʘ���pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*���������VClientContext"
    �?  �?  �?(Χ��ʘ���2&񾿵����6�ǥ�壝ƅ��ԡʚ��A����ƭ�Ɠpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *�񾿵����6NPCAIClient"
  ���?���?���?(��������VZ�

cs:Root�Χ��ʘ���


cs:GeoRoot�����ƭ�Ɠ

cs:Sleeping�������쯰

cs:Engaging�������쯰

cs:Attacking�������쯰

cs:Patrolling�������쯰

cs:Dead�������쯰

cs:ForwardNode�
��ԡʚ��Az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*��ǥ�壝ƅNPCAttackClient"
  ���?���?���?(��������VZT

cs:Root�Χ��ʘ���

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*���ԡʚ��AForwardNode"

  �B  �B   �?  �?  �?(��������Vz
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*�����ƭ�ƓGeoRoot"
    �?  �?  �?(��������V2C����Ջ�����Ƃ��L���Ծ����������쯰ϕ������<Ӷ���޽����≃���qz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*�����Ջ���NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(����ƭ�ƓZ

cs:Root�Χ��ʘ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*���Ƃ��LAnimControllerHumanoidSwordsman"
    �?  �?  �?(����ƭ�ƓZ:

cs:AnimatedMesh�������쯰

cs:Root�Χ��ʘ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*����Ծ����AnimatedMeshCostume"
    �?  �?  �?(����ƭ�Ɠz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*�������쯰Skeleton Mob"
p��B�.�  �?  �?  �?(����ƭ�ƓZa
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*�ϕ������<
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(����ƭ�Ɠ2|��ۑ���a���������������������ܮ������Ō������򙂛�t������C��͚����q�魧�Й�6��́����~��틿�Ӵ����ۢ������ʖ�ꎠ�Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���ۑ���aCone - Bullet"

 ��8SA �F�=�F�<G��>(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *���������Cube"$

 ���B���B�F�<�8�;�$e?(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *����������Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�����ܮ���Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����Ō���Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����򙂛�tWedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�������CCube"

 ��`&A �F�=R�Z=�Ff=(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*���͚����qSphere"$
@�A |տ��'A �88=�88=�88=(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��魧�Й�6Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���́����~Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���틿�Ӵ�Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(ϕ������<Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *����ۢ����Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(ϕ������<Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *���ʖ�ꎠ�Handle"

 ��G�@   �?  �?  �?(ϕ������<2����ޝ������������=���ʏ����͔�ߥ�Ȕ�ﲄ����������+���⚬ʗ��Æ������婫����ς�����Ü��ᮖ���q������ä��������l���������َ�̱���~������͘i���֒��ƣ�ʉ������鐩��ŏ������܆��Ȳ��ω��ͻ��ى��G�����Ё�)�ˈĴ���O�󔿷��Ұ���ϙx����������٨�������٧Ø�������ړ�����Ԕ������������j������@���׷���������Ä�Dz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ޝ����Sphere"
�3� &��=&��=&��=(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������=!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ʏ���!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��͔�ߥ�Ȕ!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ﲄ�����!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������+!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����⚬ʗ�!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Æ�����!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��婫����!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ς�����Ü!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ᮖ���q!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ä�!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������l!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�َ�̱���~!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������͘i!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����֒��ƣ!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ʉ������!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�鐩��ŏ!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������܆�!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ȳ��ω��!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ͻ��ى��G!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������Ё�)!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ˈĴ���O!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��󔿷�!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ұ���ϙx!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���٨�����!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���٧Ø���!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ړ���!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ԕ�����!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������j!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������@!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����׷����!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������Ä�D!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(��ʖ�ꎠ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�Ӷ���޽��upper_spine"$
  ��  8���C   �?  �?  �?(����ƭ�Ɠ2/�˭����y������������ѝ����շ������e�������	z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��˭����yLung"$
  � ��@���A   �?  �?  �?(Ӷ���޽��2���܌��Aܯ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����܌��AChanceToDestroyParent"
 �$!8  �?  �?  �?(�˭����yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ܯ������Thorn"$
 �.�6��3�X�(���>�K>�܊>(�˭����yZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *����������Guts"
    �?  �?  �?(Ӷ���޽��21���������������J�ʞ������ζ�Η��ƕ�Ȳ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������ChanceToDestroyParent"
 �$!8  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������JRing - Thick"
  �=վ~>վ~>(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��ʞ������Ring - Thick"
 ʄ� i��=]�m>]�m>(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�ζ�Η��ƕRing - Thick"
 ��� r0�=��U>��U>(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��Ȳ������Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *����ѝ����Heart")
 �� x�� (`A�5D�  �?  �?  �?(Ӷ���޽��2&�ٟ�����Ȱ՗�晛������������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ٟ�����ChanceToDestroyParent"
 �5DA  �?  �?  �?(���ѝ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�Ȱ՗�晛�Sphere")
   ��ү=���:��d��=d��=��">(���ѝ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������Sphere")
   ���?�:�?����=��=��=(���ѝ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������Sphere")
   ��=����T@��YB��=��=}��=(���ѝ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�շ������e	Grass Rib"$
 @@ fA ��   �?  �?  �?(Ӷ���޽��2�������U�ͼڶ铴5z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������UChanceToDestroyParent"
 �ȶ  �?  �?  �?(շ������ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��ͼڶ铴5
Grass Tall"
 
�(RB��3Cj7�;w19=���>(շ������eZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *��������	
Moss Chest"$
 �'A �����A   �?  �?  �?(Ӷ���޽��2����Ӟ����µب���kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����Ӟ���ChanceToDestroyParent"
 �H7  �?  �?  �?(�������	z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��µب���kDecal Moss Patch"
 
 �����B
P�=OI�=�=0=(�������	Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *���≃���qhead"$
  ��  8���C   �?  �?  �?(����ƭ�Ɠ2	�������Sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������S	Eye Patch"$
 ��? ���+JB   �?  �?  �?(��≃���q2&��ꉋ�ΰ.����������������������sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ꉋ�ΰ.ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(�������SZ

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�������Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(�������SZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *����������Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(�������SZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *��������sRing - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(�������SZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(��Һ���NPC - Axe Trap")
�84� �A추����B  �?  �?  �?(�������ơ2.׏�����A�������$��������ȇ�𚰦�,��̔����"Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�׏�����ANPCAIServer"
  �B   �?  �?  �?(��Һ���Z�

cs:Root�
��Һ���

cs:RotationRoot�
��Һ���

cs:Collider���������


cs:Trigger�
ȇ�𚰦�,
!
cs:AttackComponent�
�������$pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*��������$NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(��Һ���Z�

cs:Root�
��Һ���

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*���������Collider"
  �B fff?fff?�̌?(��Һ���Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *�ȇ�𚰦�,Trigger"
  �B ��?��?��?(��Һ���pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*���̔����"ClientContext"
    �?  �?  �?(��Һ���2'�����؎������뵓�������ꮟ�í����Ypz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *������؎�NPCAIClient"
  ���?���?���?(��̔����"Z�

cs:Root�
��Һ���


cs:GeoRoot�
�í����Y

cs:Sleeping�
�Զ��ˎ�

cs:Engaging�
�Զ��ˎ�

cs:Attacking�
�Զ��ˎ�

cs:Patrolling�
�Զ��ˎ�

cs:Dead�
�Զ��ˎ�

cs:ForwardNode�������ꮟz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*������뵓�NPCAttackClient"
  ���?���?���?(��̔����"ZS

cs:Root�
��Һ���

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*�������ꮟForwardNode"

  �B  �B   �?  �?  �?(��̔����"z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*��í����YGeoRoot"
    �?  �?  �?(��̔����"2D�����������������ާ�������Զ��ˎ���������٤׸���u���������z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*��������NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(�í����YZ

cs:Root�
��Һ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*����������AnimControllerHumanoidSwordsman"
    �?  �?  �?(�í����YZ8

cs:AnimatedMesh�
�Զ��ˎ�

cs:Root�
��Һ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*��ާ������AnimatedMeshCostume"
    �?  �?  �?(�í����Yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*��Զ��ˎ�Skeleton Mob"
p��B�.�  �?  �?  �?(�í����YZa
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*��������
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(�í����Y2}��Χ���\����ؙ��������ح����ۭ����������د�������������������������)���������ɮ�Ɋ����ʘ����Ȯ�����ؔ����͐��JZ z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���Χ���\Cone - Bullet"

 ��8SA �F�=�F�<G��>(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�����ؙ���Cube"$

 ���B���B�F�<�8�;�$e?(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *������ح��Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *���ۭ�����Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *������د��Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��������Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *���������Cube"

 ��`&A �F�=R�Z=�Ff=(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*���������)Sphere"$
@�A |տ��'A �88=�88=�88=(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�ɮ�Ɋ���Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��ʘ����ȮHorn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(�������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *������ؔ�Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(�������Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *����͐��JHandle"

 ��G�@   �?  �?  �?(�������2������������ɧߩ޻������̨����ӯ��ŤП�������ܣ���������=��������;�����������ס����������a������ʫ�������먌�����Ֆ����Ɨ�����Ձ�������Λ���ЪSÏۗ��ֽ�������������к������쵫�\���鲘����������ٱҶр������Ҳ������������ʉ������޺���.ȹ�Ť����Ԫ���4ߔ�ߓ������������ύ���������������������ׯz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Sphere"
�3� &��=&��=&��=(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���ɧߩ޻�!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������̨��!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ӯ��Ť!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�П��!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ܣ��!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������=!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������;!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ס��!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������a!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ʫ�!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������먌!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������Ֆ��!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ɨ����!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ձ������!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Λ���ЪS!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�Ïۗ��ֽ�!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����к��!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����쵫�\!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����鲘��!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ٱҶр��!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Ҳ�!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ʉ����!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���޺���.!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ȹ�Ť���!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ԫ���4!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ߔ�ߓ���!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ύ�������!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ׯ!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(���͐��JZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��٤׸���uupper_spine"$
  ��  8���C   �?  �?  �?(�í����Y2/��ͳ��LǮӂ����󽚬����������纜������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ͳ��LLung"$
  � ��@���A   �?  �?  �?(�٤׸���u2����������̝����,z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������ChanceToDestroyParent"
 �$!8  �?  �?  �?(��ͳ��Lz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��̝����,Thorn"$
 �.�6��3�X�(���>�K>�܊>(��ͳ��LZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *�Ǯӂ����Guts"
    �?  �?  �?(�٤׸���u2/Ű��޲��<����ԫ��t��������O��鿟������ȭ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ű��޲��<ChanceToDestroyParent"
 �$!8  �?  �?  �?(Ǯӂ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����ԫ��tRing - Thick"
  �=վ~>վ~>(Ǯӂ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���������ORing - Thick"
 ʄ� i��=]�m>]�m>(Ǯӂ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���鿟����Ring - Thick"
 ��� r0�=��U>��U>(Ǯӂ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���ȭ����Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(Ǯӂ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�󽚬����Heart")
 �� x�� (`A�5D�  �?  �?  �?(�٤׸���u2'蔵��������װ����������ϧN������︆z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�蔵�����ChanceToDestroyParent"
 �5DA  �?  �?  �?(󽚬����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����װ����Sphere")
   ��ү=���:��d��=d��=��">(󽚬����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�������ϧNSphere")
   ���?�:�?����=��=��=(󽚬����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�������︆Sphere")
   ��=����T@��YB��=��=}��=(󽚬����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�������纜	Grass Rib"$
 @@ fA ��   �?  �?  �?(�٤׸���u2��ͳ�����������7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ͳ���ChanceToDestroyParent"
 �ȶ  �?  �?  �?(������纜z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������7
Grass Tall"
 
�(RB��3Cj7�;w19=���>(������纜ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *�������
Moss Chest"$
 �'A �����A   �?  �?  �?(�٤׸���u2���������ˌ�Әz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �H7  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��ˌ�ӘDecal Moss Patch"
 
 �����B
P�=OI�=�=0=(������Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *����������head"$
  ��  8���C   �?  �?  �?(�í����Y2	�����kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������k	Eye Patch"$
 ��? ���+JB   �?  �?  �?(���������2'��������1�φ����Ҵ����������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������1ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(�����kZ

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��φ����ҴHill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(�����kZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *����������Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(�����kZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *��������Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(�����kZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(�������;NPC - Axe Trap"$
 �z� �EC���   �?  �?  �?(�������ơ20�Є������������׺c�������ń����������������[Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Є������NPCAIServer"
  �B   �?  �?  �?(�������;Z�

cs:Root�
�������;

cs:RotationRoot�
�������;

cs:Collider��������ń


cs:Trigger����������
!
cs:AttackComponent�
������׺cpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*�������׺cNPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(�������;Z�

cs:Root�
�������;

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*��������ńCollider"
  �B fff?fff?�̌?(�������;Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *����������Trigger"
  �B ��?��?��?(�������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*��������[ClientContext"
    �?  �?  �?(�������;2&��۪����)�¡���ب��ߊ��ɮ���ӵ����rpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *���۪����)NPCAIClient"
  ���?���?���?(�������[Z�

cs:Root�
�������;


cs:GeoRoot�
��ӵ����r

cs:Sleeping�
漪֥���Q

cs:Engaging�
漪֥���Q

cs:Attacking�
漪֥���Q

cs:Patrolling�
漪֥���Q

cs:Dead�
漪֥���Q

cs:ForwardNode��ߊ��ɮ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*��¡���ب�NPCAttackClient"
  ���?���?���?(�������[ZS

cs:Root�
�������;

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*��ߊ��ɮ�ForwardNode"

  �B  �B   �?  �?  �?(�������[z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*���ӵ����rGeoRoot"
    �?  �?  �?(�������[2B�ف�ԟ����Ǣ�ĳ�z������Ɗ>漪֥���Q��騁���*ʚ����ҹ���������z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*��ف�ԟ��NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(��ӵ����rZ

cs:Root�
�������;z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*���Ǣ�ĳ�zAnimControllerHumanoidSwordsman"
    �?  �?  �?(��ӵ����rZ8

cs:AnimatedMesh�
漪֥���Q

cs:Root�
�������;z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*�������Ɗ>AnimatedMeshCostume"
    �?  �?  �?(��ӵ����rz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*�漪֥���QSkeleton Mob"
p��B�.�  �?  �?  �?(��ӵ����rZa
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*���騁���*
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(��ӵ����r2{���黙��<���􍋥�=���씆�O���һ�Տ��р��؅���ڛ�����܄������������o���������ۧ������ʬ�����������ΐ�̸�����NZ z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*����黙��<Cone - Bullet"

 ��8SA �F�=�F�<G��>(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *����􍋥�=Cube"$

 ���B���B�F�<�8�;�$e?(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *����씆�OWedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����һ�Տ�Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��р��؅��Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��ڛ�����Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�܄������Cube"

 ��`&A �F�=R�Z=�Ff=(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*�������oSphere"$
@�A |տ��'A �88=�88=�88=(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�������Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *����ۧ����Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���ʬ�����Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(��騁���*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�������ΐDecal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(��騁���*Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *��̸�����NHandle"

 ��G�@   �?  �?  �?(��騁���*2��ۤ���������ذ�����ػ���*�ߛ�Ђ�,��ԁ��ׅA��������U�ߛ��϶�䈶�ᅑ�-�������ą�������������������ޜ݆۹��������6̾ڏ��ԅs���������������E������Տ������ձ�����ߊڶ�̭�����b���������أ������S��Ő������آ���9�����t�����������ڸӚ���ۯ��՜\�ޞ���̩���������'��������������Ԕ(��Ԡ�������ï��ؠv�讃�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ۤ������Sphere"
�3� &��=&��=&��=(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����ذ��!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ػ���*!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ߛ�Ђ�,!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ԁ��ׅA!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������U!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ߛ��϶�!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�䈶�ᅑ�-!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������ą!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ޜ݆۹!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������6!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�̾ڏ��ԅs!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������E!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������Տ�!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ձ��!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ߊڶ!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��̭�����b!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�أ������S!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ő���!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����آ���9!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������t!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ڸӚ�!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ۯ��՜\!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ޞ���̩�!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������'!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������Ԕ(!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ԡ�����!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ï��ؠv!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��讃�����!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(�̸�����NZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ʚ����ҹ�upper_spine"$
  ��  8���C   �?  �?  �?(��ӵ����r21��ں�����޲���Ʉ�ũ�������ݺ���������Ǟ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ں����Lung"$
  � ��@���A   �?  �?  �?(ʚ����ҹ�2�Փ��ɪ�z������׋:z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Փ��ɪ�zChanceToDestroyParent"
 �$!8  �?  �?  �?(��ں����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�������׋:Thorn"$
 �.�6��3�X�(���>�K>�܊>(��ں����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *��޲���Ʉ�Guts"
    �?  �?  �?(ʚ����ҹ�20�䊞������������\߈ވ����j��������������Øz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��䊞����ChanceToDestroyParent"
 �$!8  �?  �?  �?(�޲���Ʉ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������\Ring - Thick"
  �=վ~>վ~>(�޲���Ʉ�Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�߈ވ����jRing - Thick"
 ʄ� i��=]�m>]�m>(�޲���Ʉ�Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���������Ring - Thick"
 ��� r0�=��U>��U>(�޲���Ʉ�Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�������ØCone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(�޲���Ʉ�Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�ũ�������Heart")
 �� x�� (`A�5D�  �?  �?  �?(ʚ����ҹ�2&�އ맀��*ЊߤФ�݀��ݓ�ĥ�����'z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��އ맀��*ChanceToDestroyParent"
 �5DA  �?  �?  �?(ũ�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ЊߤФSphere")
   ��ү=���:��d��=d��=��">(ũ�������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��݀��ݓ�Sphere")
   ���?�:�?����=��=��=(ũ�������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ĥ�����'Sphere")
   ��=����T@��YB��=��=}��=(ũ�������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ݺ������	Grass Rib"$
 @@ fA ��   �?  �?  �?(ʚ����ҹ�2����������ն�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �ȶ  �?  �?  �?(ݺ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���ն�����
Grass Tall"
 
�(RB��3Cj7�;w19=���>(ݺ������ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *����Ǟ���
Moss Chest"$
 �'A �����A   �?  �?  �?(ʚ����ҹ�2�����Ɠ�Fǎ�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Ɠ�FChanceToDestroyParent"
 �H7  �?  �?  �?(���Ǟ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ǎ�������Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(���Ǟ���Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *���������head"$
  ��  8���C   �?  �?  �?(��ӵ����r2
��ꂒ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ꂒ���	Eye Patch"$
 ��? ���+JB   �?  �?  �?(��������2&݀��͑��0�����ﶡ��������������ІßLz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�݀��͑��0ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(��ꂒ���Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������ﶡ�Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(��ꂒ���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *����������Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(��ꂒ���Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�����ІßLRing - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(��ꂒ���Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(������NPC - Axe Trap"$
 �z� �����   �?  �?  �?(�������ơ20��̹����%��Ҫ��̀���׸�����᧕ѳ��l㹅�����Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���̹����%NPCAIServer"
  �B   �?  �?  �?(������Z�

cs:Root�������

cs:RotationRoot�������

cs:Collider���׸����


cs:Trigger�
�᧕ѳ��l
"
cs:AttackComponent���Ҫ��̀�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*���Ҫ��̀�NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(������Z�

cs:Root�������

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*���׸����Collider"
  �B fff?fff?�̌?(������Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *��᧕ѳ��lTrigger"
  �B ��?��?��?(������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*�㹅�����ClientContext"
    �?  �?  �?(������2(�и�֙��������榃��ҳ��ּ������ޝ���pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *��и�֙���NPCAIClient"
  ���?���?���?(㹅�����Z�

cs:Root�������


cs:GeoRoot�����ޝ���

cs:Sleeping�
خ������

cs:Engaging�
خ������

cs:Attacking�
خ������

cs:Patrolling�
خ������

cs:Dead�
خ������

cs:ForwardNode��ҳ��ּ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*������榃�NPCAttackClient"
  ���?���?���?(㹅�����ZT

cs:Root�������

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*��ҳ��ּ��ForwardNode"

  �B  �B   �?  �?  �?(㹅�����z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*�����ޝ���GeoRoot"
    �?  �?  �?(㹅�����2@ˉځ�������ũ��H��Ӌ����%خ���������У������񂐋��N֒��Ա��z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*�ˉځ����NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(����ޝ���Z

cs:Root�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*����ũ��HAnimControllerHumanoidSwordsman"
    �?  �?  �?(����ޝ���Z9

cs:AnimatedMesh�
خ������

cs:Root�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*���Ӌ����%AnimatedMeshCostume"
    �?  �?  �?(����ޝ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*�خ������Skeleton Mob"
p��B�.�  �?  �?  �?(����ޝ���Za
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*����У����
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(����ޝ���2���ʇ曊���ʏ�������������������׎���绝���������򀿌ՙ����犾����ȖȽ�����ֵ����ƙ�����ۀ������a��������m���������Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���ʇ曊��Cone - Bullet"

 ��8SA �F�=�F�<G��>(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *��ʏ������Cube"$

 ���B���B�F�<�8�;�$e?(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��������Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�������׎�Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *���绝����Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *������򀿌Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�ՙ����犾Cube"

 ��`&A �F�=R�Z=�Ff=(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*�����ȖȽ�Sphere"$
@�A |տ��'A �88=�88=�88=(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�����ֵ���Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *��ƙ�����Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ۀ������aHorn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(���У����Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���������mDecal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(���У����Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *����������Handle"

 ��G�@   �?  �?  �?(���У����2�Τ򻁧���������꼸�Ǚ��S�ۘ��蘿���ݠ��Xծ����ن���Ӎϗ�	�������ﯹэű����Ǥ�ܓ���������r������������塯�d�徶��؉�ۇ����������߹��\�����ҕ���Ɇ����z��Ŝ����������͋������ُ�˓��ј��ኜ�ʶ�i⇲�ֆ�������������������P���̽��������Ӧ���蓱�����e����벾�W�������۹�ӛ1�ª��ی�s��������������·�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Τ򻁧��Sphere"
�3� &��=&��=&��=(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��������!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�꼸�Ǚ��S!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ۘ��蘿!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ݠ��X!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ծ����ن!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ӎϗ�	!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ﯹэű��!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ǥ�ܓ��!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������r!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����塯�d!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��徶��؉�!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ۇ������!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����߹��\!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ҕ�!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ɇ����z!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ŝ����!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������͋!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ُ!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��˓��ј�!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ኜ�ʶ�i!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�⇲�ֆ���!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������P!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����̽����!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Ӧ���!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�蓱�����e!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����벾�W!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��۹�ӛ1!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ª��ی�s!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������·�!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���񂐋��Nupper_spine"$
  ��  8���C   �?  �?  �?(����ޝ���20��������ū��윪��Ɩ��өУ��Ŝ����a������қgz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������Lung"$
  � ��@���A   �?  �?  �?(��񂐋��N2�ӭ޽���������ۄwz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ӭ޽����ChanceToDestroyParent"
 �$!8  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������ۄwThorn"$
 �.�6��3�X�(���>�K>�܊>(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *�ū��윪��Guts"
    �?  �?  �?(��񂐋��N2/�쮱�����́뻡�C�Ǥ��̊����������J�������6z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��쮱���ChanceToDestroyParent"
 �$!8  �?  �?  �?(ū��윪��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���́뻡�CRing - Thick"
  �=վ~>վ~>(ū��윪��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��Ǥ��̊��Ring - Thick"
 ʄ� i��=]�m>]�m>(ū��윪��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���������JRing - Thick"
 ��� r0�=��U>��U>(ū��윪��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��������6Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(ū��윪��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�Ɩ��өУHeart")
 �� x�� (`A�5D�  �?  �?  �?(��񂐋��N2%������ڞ���̶�������Ȭ���O����º�Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������ڞ�ChanceToDestroyParent"
 �5DA  �?  �?  �?(Ɩ��өУz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���̶����Sphere")
   ��ү=���:��d��=d��=��">(Ɩ��өУZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����Ȭ���OSphere")
   ���?�:�?����=��=��=(Ɩ��өУZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�����º�XSphere")
   ��=����T@��YB��=��=}��=(Ɩ��өУZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���Ŝ����a	Grass Rib"$
 @@ fA ��   �?  �?  �?(��񂐋��N2���ؿ�ŋ��������7z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ؿ�ŋChanceToDestroyParent"
 �ȶ  �?  �?  �?(��Ŝ����az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������7
Grass Tall"
 
�(RB��3Cj7�;w19=���>(��Ŝ����aZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *�������қg
Moss Chest"$
 �'A �����A   �?  �?  �?(��񂐋��N2�������������ܭ�>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �H7  �?  �?  �?(������қgz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������ܭ�>Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(������қgZ#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *�֒��Ա��head"$
  ��  8���C   �?  �?  �?(����ޝ���2
ƒь���ڌz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ƒь���ڌ	Eye Patch"$
 ��? ���+JB   �?  �?  �?(֒��Ա��2&������ɜg����ͼ�������پ��$��ś��˴�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������ɜgChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(ƒь���ڌZ

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����ͼ���Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(ƒь���ڌZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *�����پ��$Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(ƒь���ڌZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *���ś��˴�Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(ƒь���ڌZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�қ����݇."Spinning Axe Trap Verticle (DMG50)"3
 �	� XA  zC  �����<  ��  �?  �?  �?(����Ի��*28������ך�������������ه�����Ľٻ�5���ŕ������Ǳϕ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������ך�RotatingAxes(NoDMG)")
 ��  �AފZByq�B  �?  �?  �?(қ����݇.2	�׹���=z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*��׹���=Center Point"3
{���|�= ��B:��8q��B ����Q4?�Q4?�Q4?(������ך�2����׎�b쿒����i���䎤���Z]
)
ma:Shared_BaseMaterial:id���棿����
0
ma:Shared_BaseMaterial:color�.z<�Ev?%  �?pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
�����088�
 *�����׎�bAxes"3
Ms@d�>?��?�.�7��+7 �ӿ �? �? �?(�׹���=2��������u�Ě�����dpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���������uFantasy Weapon - Axe 01 (Prop)"3
�ד9�����g�@�_A����9���ˍh@ˍh@ˍh@(����׎�b27������tޗ����ҽ
�������n㱌ˊ�_㫞����ʀ���Ġ	pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�������tFantasy Axe Grip 01"
}��   �?  �?  �?(��������uZ"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��˷����08�
 *�ޗ����ҽ
Fantasy Pommel 02"
�?�� tw�?tw�?tw�?(��������upz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
Ƚ�������08�
 *��������nFantasy Axe Base 01"
��B   �?  �?  �?(��������uZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Я�����08�
 *�㱌ˊ�_Fantasy Hammer Guard 01"
��A   �?  �?  �?(��������uZ"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

���݂���08�
 *�㫞����Fantasy Axe Blade 01"

  �  \B   �?  �?  �?(��������uZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *�ʀ���Ġ	Fantasy Axe Blade 01"$

  A  \B��3�  �?  �?  �?(��������uZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *��Ě�����dFantasy Weapon - Axe 01 (Prop)"3
ȏ�A��BG�5:��8��3��q��ˍh@ˍh@ˍh@(����׎�b29���ק��Q��񉀪���Ȋܞ�ϫ��Ȉ�⧯�"���աԉ���ׅ�����(pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*����ק��QFantasy Axe Grip 01"
}��   �?  �?  �?(�Ě�����dZ"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��˷����08�
 *���񉀪���Fantasy Pommel 02"
�?�� tw�?tw�?tw�?(�Ě�����dpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
Ƚ�������08�
 *�Ȋܞ�ϫ�Fantasy Axe Base 01"
��B   �?  �?  �?(�Ě�����dZO
#
ma:Shared_Detail1:id�
ԁ������;
(
ma:Shared_BaseMaterial:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Я�����08�
 *��Ȉ�⧯�"Fantasy Hammer Guard 01"
��A   �?  �?  �?(�Ě�����dZ"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

���݂���08�
 *����աԉ��Fantasy Axe Blade 01"

  �  \B   �?  �?  �?(�Ě�����dZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *��ׅ�����(Fantasy Axe Blade 01"$

  A  \B��3�  �?  �?  �?(�Ě�����dZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *�쿒����iCenter Rotation".
�"��f5�>�m�@
Ie��.�yJ�?�J�?'F�>(�׹���=Za
(
ma:Shared_BaseMaterial:id�
ԁ������;
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *����䎤���Axe Spin Verticle"3
�]�B�F���"G�ѳB��B}�����?���?���?(�׹���=pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�����˞��*���������Axes Pillar"

 й� �A   �?  �?  �?(қ����݇.2a�������ģՇ������ғ��Á�q��»˄�^҄���ᑁ����ў���כ����ި�����������򈯺᷒ɡ���ٴ��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������ģCylinder"$
  ��  �:
g.B   �?  �?�s�?(��������Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�Շ�����Cylinder"$
  ��  �:8�C   �?  �?��>(��������Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��ғ��Á�qCylinder"$
  ��  �:�C w@�?w@�?2��=(��������Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���»˄�^Cylinder"$
  ��  �:��*C w@�?w@�?2��=(��������Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�҄���ᑁ�Cylinder"

  ��  �: �@�?�@�?F�>(��������Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *����ў���Cylinder"$
  ��  �:�I@ X��?X��?��>(��������Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�כ����ި�Cylinder"$
  ��  �:�Q�B w@�?w@�?2��=(��������Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���������Cylinder"$
  ��  �:��A w@�?w@�?2��=(��������Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���򈯺᷒Cylinder"

  ��  �: b��@b��@�Ê=(��������Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�ɡ���ٴ��Cylinder"$
  ��  �: �2? ���@���@��~=(��������Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�(����ه��NPC - Axe Trap")
�%*C �A추����B  �?  �?  �?(қ����݇.21���ո���r���Յ����倡����������÷������ڳ�ʠ�Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ո���rNPCAIServer"
  �B   �?  �?  �?(����ه��Z�

cs:Root�����ه��

cs:RotationRoot�����ه��

cs:Collider�倡������


cs:Trigger�����÷���
"
cs:AttackComponent����Յ����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*����Յ����NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(����ه��Z�

cs:Root�����ه��

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*�倡������Collider"
  �B fff?fff?�̌?(����ه��Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *�����÷���Trigger"
  �B ��?��?��?(����ه��pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*����ڳ�ʠ�ClientContext"
    �?  �?  �?(����ه��2'����⢆�.�Տ�����������������������pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *�����⢆�.NPCAIClient"
  ���?���?���?(���ڳ�ʠ�Z�

cs:Root�����ه��


cs:GeoRoot����������

cs:Sleeping��Է㰶Ī�

cs:Engaging��Է㰶Ī�

cs:Attacking��Է㰶Ī�

cs:Patrolling��Է㰶Ī�

cs:Dead��Է㰶Ī�

cs:ForwardNode����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*��Տ�����NPCAttackClient"
  ���?���?���?(���ڳ�ʠ�ZT

cs:Root�����ه��

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*����������ForwardNode"

  �B  �B   �?  �?  �?(���ڳ�ʠ�z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*����������GeoRoot"
    �?  �?  �?(���ڳ�ʠ�2C�������B���������Ĺ������Է㰶Ī���������:��������'�����՟��z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*��������BNPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(���������Z

cs:Root�����ه��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*���������AnimControllerHumanoidSwordsman"
    �?  �?  �?(���������Z:

cs:AnimatedMesh��Է㰶Ī�

cs:Root�����ه��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*��Ĺ�����AnimatedMeshCostume"
    �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*��Է㰶Ī�Skeleton Mob"
p��B�.�  �?  �?  �?(���������Za
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*���������:
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(���������2y؋�ᴀ��^��������kГ�٥������ќ��:�������)���ݒ���2���������ړ������Z��˰ѳ����������������Ć����৮�カ����ϧ�KZ z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�؋�ᴀ��^Cone - Bullet"

 ��8SA �F�=�F�<G��>(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *���������kCube"$

 ���B���B�F�<�8�;�$e?(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�Г�٥����Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *���ќ��:Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��������)Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����ݒ���2Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����������Cube"

 ��`&A �F�=R�Z=�Ff=(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*�ړ������ZSphere"$
@�A |տ��'A �88=�88=�88=(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���˰ѳ���Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *����������Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�����Ć���Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(��������:Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *��৮�カ�Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(��������:Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *����ϧ�KHandle"

 ��G�@   �?  �?  �?(��������:2���������ٻ2�������,��������������ܖ�ㆷ����֮�����ʱ�䒬��ݧ����ؔ��L���������Β���,���螨����Ŭ�������ԭȓH�������6������ׁ:�ʄ�������ʞ�8�犒������Э��詞:��ũ���������Βݽ�����������ع��ޠ��ـ�����ڷ�����Ŭฎ���ķ���Ѐ�-�������������˖�������Ԋ������ۏ������Ӎ�ڍ�������޲+��������Az(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Sphere"
�3� &��=&��=&��=(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����ٻ2!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������,!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ܖ!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ㆷ����!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�֮�����ʱ!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��䒬��ݧ�!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ؔ��L!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Β���,!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����螨�!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ŭ���!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ԭȓH!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������6!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ׁ:!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ʄ��!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ʞ�8!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��犒�����!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Э��詞:!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ũ�����!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Βݽ!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ع��ޠ�!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ـ�����!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ڷ�����Ŭ!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ฎ���ķ!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ѐ�-!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����˖���!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Ԋ���!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ۏ����!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ӎ�ڍ��!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������޲+!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������A!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(���ϧ�KZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������'upper_spine"$
  ��  8���C   �?  �?  �?(���������2/��������]����曉�p��ί�������������������ѽ�Gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������]Lung"$
  � ��@���A   �?  �?  �?(��������'2������s�����Ƚ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������sChanceToDestroyParent"
 �$!8  �?  �?  �?(��������]z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������Ƚ�Thorn"$
 �.�6��3�X�(���>�K>�܊>(��������]Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *�����曉�pGuts"
    �?  �?  �?(��������'2/�𖭗����ɀ𢲉δS�񴘺ٙ�I�����ރi�Ȫ�ӌ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��𖭗����ChanceToDestroyParent"
 �$!8  �?  �?  �?(����曉�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ɀ𢲉δSRing - Thick"
  �=վ~>վ~>(����曉�pZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��񴘺ٙ�IRing - Thick"
 ʄ� i��=]�m>]�m>(����曉�pZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *������ރiRing - Thick"
 ��� r0�=��U>��U>(����曉�pZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��Ȫ�ӌ���Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(����曉�pZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *���ί�����Heart")
 �� x�� (`A�5D�  �?  �?  �?(��������'2'����ل���������
ӏ��⾭�����ۥ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ل��ChanceToDestroyParent"
 �5DA  �?  �?  �?(��ί�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��������
Sphere")
   ��ү=���:��d��=d��=��">(��ί�����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ӏ��⾭��Sphere")
   ���?�:�?����=��=��=(��ί�����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����ۥ��Sphere")
   ��=����T@��YB��=��=}��=(��ί�����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������	Grass Rib"$
 @@ fA ��   �?  �?  �?(��������'2�������Kڗ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������KChanceToDestroyParent"
 �ȶ  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ڗ�����
Grass Tall"
 
�(RB��3Cj7�;w19=���>(���������ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *������ѽ�G
Moss Chest"$
 �'A �����A   �?  �?  �?(��������'2����ˬڼ��ʜ���Źz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ˬڼ�ChanceToDestroyParent"
 �H7  �?  �?  �?(�����ѽ�Gz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��ʜ���ŹDecal Moss Patch"
 
 �����B
P�=OI�=�=0=(�����ѽ�GZ#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *������՟��head"$
  ��  8���C   �?  �?  �?(���������2	�����ǁ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ǁ�	Eye Patch"$
 ��? ���+JB   �?  �?  �?(�����՟��2&ɗ�ᵕ��������䚨@�����l��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ɗ�ᵕ���ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(�����ǁ�Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������䚨@Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(�����ǁ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *������lRing - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(�����ǁ�Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *���������Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(�����ǁ�Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(���Ľٻ�5NPC - Axe Trap")
�84� �A추����B  �?  �?  �?(қ����݇.2/��������g������΋G���ڏ��<���ۊ����������Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������gNPCAIServer"
  �B   �?  �?  �?(���Ľٻ�5Z�

cs:Root�
���Ľٻ�5

cs:RotationRoot�
���Ľٻ�5

cs:Collider�
���ڏ��<


cs:Trigger����ۊ����
!
cs:AttackComponent�
������΋Gpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*�������΋GNPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(���Ľٻ�5Z�

cs:Root�
���Ľٻ�5

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*����ڏ��<Collider"
  �B fff?fff?�̌?(���Ľٻ�5Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *����ۊ����Trigger"
  �B ��?��?��?(���Ľٻ�5pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*�������ClientContext"
    �?  �?  �?(���Ľٻ�52&���Ӵ�����������e������������ꯓ��0pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *����Ӵ����NPCAIClient"
  ���?���?���?(������Z�

cs:Root�
���Ľٻ�5


cs:GeoRoot�
���ꯓ��0

cs:Sleeping�
���Ģې�

cs:Engaging�
���Ģې�

cs:Attacking�
���Ģې�

cs:Patrolling�
���Ģې�

cs:Dead�
���Ģې�

cs:ForwardNode����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*��������eNPCAttackClient"
  ���?���?���?(������ZS

cs:Root�
���Ľٻ�5

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*����������ForwardNode"

  �B  �B   �?  �?  �?(������z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*����ꯓ��0GeoRoot"
    �?  �?  �?(������2A��������)���Ѿ����������ʱ����Ģې�������B����ӹ��l����ߢ�+z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*���������)NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(���ꯓ��0Z

cs:Root�
���Ľٻ�5z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*����Ѿ����AnimControllerHumanoidSwordsman"
    �?  �?  �?(���ꯓ��0Z8

cs:AnimatedMesh�
���Ģې�

cs:Root�
���Ľٻ�5z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*�������ʱ�AnimatedMeshCostume"
    �?  �?  �?(���ꯓ��0z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*����Ģې�Skeleton Mob"
p��B�.�  �?  �?  �?(���ꯓ��0Za
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*�������B
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(���ꯓ��02~����Ԭ�nܿ�ߝ̥�����ѵƩ�=����������랫����������������ׅ�����������᷻��ل�׍�����Դ����ۺ����m������ǟ�Њ֏á�lZ z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�����Ԭ�nCone - Bullet"

 ��8SA �F�=�F�<G��>(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�ܿ�ߝ̥��Cube"$

 ���B���B�F�<�8�;�$e?(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *����ѵƩ�=Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����������Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��랫�����Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����������Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *���ׅ�����Cube"

 ��`&A �F�=R�Z=�Ff=(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*�������᷻Sphere"$
@�A |տ��'A �88=�88=�88=(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���ل�׍�Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�����Դ���Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��ۺ����mHorn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(������BZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�������ǟDecal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(������BZ

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *��Њ֏á�lHandle"

 ��G�@   �?  �?  �?(������B2����������ֻ�ō������ͤ����橣�ܭ�����ո��M�ǁ����������쯁�¯ڑ���"ŕ�����ͭٜ�·�Җx��������e����س��n��妊���=�ھȥ��)����ߵ���̪��������Ѯ����kӈ�ס���z���҆���9��Ռǐ��Zŭ������������æ��������T��������������ȳ�`�����������������̻򹖧�Ӑ�ߨȫե��׶ț����J�҅��ǉ���ߊК�����͟����Bޝ�ޞ֜^�����-z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������Sphere"
�3� &��=&��=&��=(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���ֻ�ō��!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ͤ���!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��橣�ܭ�!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ո��M!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ǁ������!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����쯁!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��¯ڑ���"!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ŕ�����ͭ!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ٜ�·�Җx!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������e!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����س��n!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���妊���=!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ھȥ��)!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ߵ��!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��̪������!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ѯ����k!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ӈ�ס���z!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����҆���9!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ռǐ��Z!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ŭ������!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������æ�!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������T!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ȳ�`!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�̻򹖧�Ӑ!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ߨȫե��!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�׶ț����J!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��҅��ǉ��!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ߊК���!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���͟����B!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ޝ�ޞ֜^!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������-!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(�Њ֏á�lZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ӹ��lupper_spine"$
  ��  8���C   �?  �?  �?(���ꯓ��020���Ĵ��������������ߜ������ݎ񪢠ؓ�����?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����Ĵ��Lung"$
  � ��@���A   �?  �?  �?(����ӹ��l2��ҔԊ�������Đ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ҔԊ���ChanceToDestroyParent"
 �$!8  �?  �?  �?(���Ĵ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����Đ��Thorn"$
 �.�6��3�X�(���>�K>�܊>(���Ĵ��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *����������Guts"
    �?  �?  �?(����ӹ��l20�������������������֗�뜪�a��������n������ٗ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������ChanceToDestroyParent"
 �$!8  �?  �?  �?(���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����������Ring - Thick"
  �=վ~>վ~>(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��֗�뜪�aRing - Thick"
 ʄ� i��=]�m>]�m>(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���������nRing - Thick"
 ��� r0�=��U>��U>(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�������ٗ�Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(���������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *����ߜ����Heart")
 �� x�� (`A�5D�  �?  �?  �?(����ӹ��l2&�����������ܠ�������������������mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �5DA  �?  �?  �?(���ߜ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����ܠ���Sphere")
   ��ү=���:��d��=d��=��">(���ߜ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������Sphere")
   ���?�:�?����=��=��=(���ߜ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������mSphere")
   ��=����T@��YB��=��=}��=(���ߜ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���ݎ񪢠	Grass Rib"$
 @@ fA ��   �?  �?  �?(����ӹ��l2������ʟ��������^z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������ʟChanceToDestroyParent"
 �ȶ  �?  �?  �?(��ݎ񪢠z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������^
Grass Tall"
 
�(RB��3Cj7�;w19=���>(��ݎ񪢠ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *�ؓ�����?
Moss Chest"$
 �'A �����A   �?  �?  �?(����ӹ��l2�ν�����=���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ν�����=ChanceToDestroyParent"
 �H7  �?  �?  �?(ؓ�����?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����������Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(ؓ�����?Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *�����ߢ�+head"$
  ��  8���C   �?  �?  �?(���ꯓ��02
灚��Ѳ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�灚��Ѳ�	Eye Patch"$
 ��? ���+JB   �?  �?  �?(����ߢ�+2%����Ҧɵ��ɓ��,����Ղ'�֕�����:z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ҦɵChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(灚��Ѳ�Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���ɓ��,Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(灚��Ѳ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *�����Ղ'Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(灚��Ѳ�Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *��֕�����:Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(灚��Ѳ�Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(���ŕ���NPC - Axe Trap"$
 �z� �EC���   �?  �?  �?(қ����݇.21�����̫��������������������һ��4ϲ��䘦��Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������̫�NPCAIServer"
  �B   �?  �?  �?(���ŕ���Z�

cs:Root�
���ŕ���

cs:RotationRoot�
���ŕ���

cs:Collider���������


cs:Trigger�
���һ��4
"
cs:AttackComponent���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*���������NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(���ŕ���Z�

cs:Root�
���ŕ���

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*���������Collider"
  �B fff?fff?�̌?(���ŕ���Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *����һ��4Trigger"
  �B ��?��?��?(���ŕ���pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*�ϲ��䘦��ClientContext"
    �?  �?  �?(���ŕ���2'�������B���������������������΍���pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *��������BNPCAIClient"
  ���?���?���?(ϲ��䘦��Z�

cs:Root�
���ŕ���


cs:GeoRoot�����΍���

cs:Sleeping�
�������;

cs:Engaging�
�������;

cs:Attacking�
�������;

cs:Patrolling�
�������;

cs:Dead�
�������;

cs:ForwardNode����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*���������NPCAttackClient"
  ���?���?���?(ϲ��䘦��ZS

cs:Root�
���ŕ���

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*����������ForwardNode"

  �B  �B   �?  �?  �?(ϲ��䘦��z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*�����΍���GeoRoot"
    �?  �?  �?(ϲ��䘦��2BǑ���č�\����¦�߲ܣ���ϯ�������;�͆����K�����������������dz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*�Ǒ���č�\NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(����΍���Z

cs:Root�
���ŕ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*�����¦�߲AnimControllerHumanoidSwordsman"
    �?  �?  �?(����΍���Z8

cs:AnimatedMesh�
�������;

cs:Root�
���ŕ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*�ܣ���ϯAnimatedMeshCostume"
    �?  �?  �?(����΍���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*��������;Skeleton Mob"
p��B�.�  �?  �?  �?(����΍���Za
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*��͆����K
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(����΍���2|�Ѻ�����?���Ӥ���rʜ���וּ���ㆹ���������̀���߿9����ئ�����������刏���*����ߊ�	�������������������տ�˦���Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*��Ѻ�����?Cone - Bullet"

 ��8SA �F�=�F�<G��>(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *����Ӥ���rCube"$

 ���B���B�F�<�8�;�$e?(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�ʜ���וּWedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����ㆹ��Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�������Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��̀���߿9Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�����ئ���Cube"

 ��`&A �F�=R�Z=�Ff=(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*��������Sphere"$
@�A |տ��'A �88=�88=�88=(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��刏���*Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�����ߊ�	Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(�͆����KZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *����������Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(�͆����KZ

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *��տ�˦���Handle"

 ��G�@   �?  �?  �?(�͆����K2����Ϣ���9�����Ӡ�>���Ʌ���7���������颮����G����ŗ��������Ĺ������ƒ����;���[���뺆ζ���؛����Ҡ񙴴����Ь��ѽ���������������飱ѱⶨ���q����ɢ���ǚ�����䆱��������Е��(��ʙ����~հ�血��0ƌڏ��ѣ�����������ӡ���ߌ�����̺������=�Җ����U���Љ��������������銫��ۑ������Ӄ���������������~���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����Ϣ���9Sphere"
�3� &��=&��=&��=(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *������Ӡ�>!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ʌ���7!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��颮����G!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ŗ���!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������Ĺ�!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ƒ�!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����;���[!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����뺆ζ�!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���؛����!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�Ҡ񙴴���!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ь��ѽ�!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������飱!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ѱⶨ���q!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ɢ��!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ǚ�����!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�䆱����!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Е��(!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ʙ����~!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�հ�血��0!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ƌڏ��!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ѣ������!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ӡ�!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ߌ�����!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�̺������=!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Җ����U!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Љ���!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���銫��ۑ!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������Ӄ�!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������~!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(�տ�˦���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������upper_spine"$
  ��  8���C   �?  �?  �?(����΍���20ْ����9�Œ�����������������������Л�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ْ����9Lung"$
  � ��@���A   �?  �?  �?(���������2����ԑ�mν�Ƿ谑|z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ԑ�mChanceToDestroyParent"
 �$!8  �?  �?  �?(ْ����9z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ν�Ƿ谑|Thorn"$
 �.�6��3�X�(���>�K>�܊>(ْ����9Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *��Œ������Guts"
    �?  �?  �?(���������2/�������������W��������۴ӽ�ڝ�5���ϻ���Jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������ChanceToDestroyParent"
 �$!8  �?  �?  �?(�Œ������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��������WRing - Thick"
  �=վ~>վ~>(�Œ������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���������Ring - Thick"
 ʄ� i��=]�m>]�m>(�Œ������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�۴ӽ�ڝ�5Ring - Thick"
 ��� r0�=��U>��U>(�Œ������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *����ϻ���JCone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(�Œ������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *��������Heart")
 �� x�� (`A�5D�  �?  �?  �?(���������2%��������y����㓄�� ����5�����׶�Xz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������yChanceToDestroyParent"
 �5DA  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����㓄�Sphere")
   ��ү=���:��d��=d��=��">(�������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�� ����5Sphere")
   ���?�:�?����=��=��=(�������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *������׶�XSphere")
   ��=����T@��YB��=��=}��=(�������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������	Grass Rib"$
 @@ fA ��   �?  �?  �?(���������2�݁��ϴ�i��������mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��݁��ϴ�iChanceToDestroyParent"
 �ȶ  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������m
Grass Tall"
 
�(RB��3Cj7�;w19=���>(��������ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *���Л�����
Moss Chest"$
 �'A �����A   �?  �?  �?(���������2�ɀ���ԶI�ͱ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ɀ���ԶIChanceToDestroyParent"
 �H7  �?  �?  �?(��Л�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��ͱ�����Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(��Л�����Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *���������dhead"$
  ��  8���C   �?  �?  �?(����΍���2
�����ϜՈz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ϜՈ	Eye Patch"$
 ��? ���+JB   �?  �?  �?(��������d2&λ���䜣����Ȩ��;�����������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�λ���䜣ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(�����ϜՈZ

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����Ȩ��;Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(�����ϜՈZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *���������Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(�����ϜՈZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *����������Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(�����ϜՈZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(���Ǳϕ�NPC - Axe Trap"$
 �z� �����   �?  �?  �?(қ����݇.2/��ڿ�ް���Ҿ��ϴ_����ˎڙ������҃v��������9Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ڿ�ް�NPCAIServer"
  �B   �?  �?  �?(���Ǳϕ�Z�

cs:Root�
���Ǳϕ�

cs:RotationRoot�
���Ǳϕ�

cs:Collider�����ˎڙ�


cs:Trigger�
�����҃v
!
cs:AttackComponent�
��Ҿ��ϴ_pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*���Ҿ��ϴ_NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(���Ǳϕ�Z�

cs:Root�
���Ǳϕ�

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*�����ˎڙ�Collider"
  �B fff?fff?�̌?(���Ǳϕ�Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *������҃vTrigger"
  �B ��?��?��?(���Ǳϕ�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*���������9ClientContext"
    �?  �?  �?(���Ǳϕ�2%ȕ����̜����ڂ���������������ܜ�pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *�ȕ����̜NPCAIClient"
  ���?���?���?(��������9Z�

cs:Root�
���Ǳϕ�


cs:GeoRoot�
�����ܜ�

cs:Sleeping�
���ъ���w

cs:Engaging�
���ъ���w

cs:Attacking�
���ъ���w

cs:Patrolling�
���ъ���w

cs:Dead�
���ъ���w

cs:ForwardNode�
��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*�����ڂ��NPCAttackClient"
  ���?���?���?(��������9ZS

cs:Root�
���Ǳϕ�

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*���������ForwardNode"

  �B  �B   �?  �?  �?(��������9z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*������ܜ�GeoRoot"
    �?  �?  �?(��������92B���¡о��ڻ�ސ������������ъ���w�����ڭ$���˞�܊���ΣƟ��zz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*����¡о�NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(�����ܜ�Z

cs:Root�
���Ǳϕ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*��ڻ�ސ��AnimControllerHumanoidSwordsman"
    �?  �?  �?(�����ܜ�Z8

cs:AnimatedMesh�
���ъ���w

cs:Root�
���Ǳϕ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*��������AnimatedMeshCostume"
    �?  �?  �?(�����ܜ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*����ъ���wSkeleton Mob"
p��B�.�  �?  �?  �?(�����ܜ�Za
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*������ڭ$
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(�����ܜ�2|��ғ���Ɍ��������,��ꥍޡ��؃�����������������������ᤚ����y��������4���т���n��������Y��������������������������Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���ғ���ɌCone - Bullet"

 ��8SA �F�=�F�<G��>(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *���������,Cube"$

 ���B���B�F�<�8�;�$e?(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *���ꥍޡ��Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�؃�������Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��������Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����������Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�ᤚ����yCube"

 ��`&A �F�=R�Z=�Ff=(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*���������4Sphere"$
@�A |տ��'A �88=�88=�88=(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����т���nHorn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���������YSphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(�����ڭ$Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���������Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(�����ڭ$Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *����������Handle"

 ��G�@   �?  �?  �?(�����ڭ$2��������ˁ�����؋⎮��̒â��۩�ɠ�H�����ɢ�����ɯά�f���񀦜��呅̲퐵������ȳ�����������ԑɞ�����������B�ۭ��صc��͙��ԡᖖӂ�����ح����K�Í�ҏ��i���ϱң�������������Ԉ��������«�[�޺�����\��ǔ����j�ٟ����������Ἑ��怬����d�����������������ȋʭ��]�������������͏�O┦�婏�+��������������ʭq�띅���܏z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������Sphere"
�3� &��=&��=&��=(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ˁ�����؋!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�⎮��̒â!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���۩�ɠ�H!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ɢ��!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ɯά�f!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����񀦜��!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�呅̲퐵�!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ȳ��!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ԑɞ���!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������B!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ۭ��صc!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���͙��ԡ!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ᖖӂ���!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ح����K!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Í�ҏ��i!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ϱң�!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Ԉ���!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������«�[!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��޺�����\!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ǔ����j!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ٟ������!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Ἑ�!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��怬����d!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ȋʭ��]!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����͏�O!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�┦�婏�+!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������ʭq!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��띅���܏!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����˞�܊�upper_spine"$
  ��  8���C   �?  �?  �?(�����ܜ�20�Ш�ݟ����������צ��雜�ȧ�����\��͢����!z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Ш�ݟ���Lung"$
  � ��@���A   �?  �?  �?(���˞�܊�2���������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �$!8  �?  �?  �?(�Ш�ݟ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��������Thorn"$
 �.�6��3�X�(���>�K>�܊>(�Ш�ݟ���Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *�������Guts"
    �?  �?  �?(���˞�܊�2.����Лбȫ��������ʯ����������ۼԸ��ٛfz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ЛбChanceToDestroyParent"
 �$!8  �?  �?  �?(������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ȫ�����Ring - Thick"
  �=վ~>վ~>(������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *����ʯ���Ring - Thick"
 ʄ� i��=]�m>]�m>(������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��������Ring - Thick"
 ��� r0�=��U>��U>(������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�ۼԸ��ٛfCone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *��צ��雜Heart")
 �� x�� (`A�5D�  �?  �?  �?(���˞�܊�2&������ތ7�������ݛ����ĕ����������Kz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������ތ7ChanceToDestroyParent"
 �5DA  �?  �?  �?(�צ��雜z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��������ݛSphere")
   ��ү=���:��d��=d��=��">(�צ��雜Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�����ĕ��Sphere")
   ���?�:�?����=��=��=(�צ��雜Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������KSphere")
   ��=����T@��YB��=��=}��=(�צ��雜Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��ȧ�����\	Grass Rib"$
 @@ fA ��   �?  �?  �?(���˞�܊�2��巜��Ƕ��ڡ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���巜��ǶChanceToDestroyParent"
 �ȶ  �?  �?  �?(�ȧ�����\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���ڡ��
Grass Tall"
 
�(RB��3Cj7�;w19=���>(�ȧ�����\ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *���͢����!
Moss Chest"$
 �'A �����A   �?  �?  �?(���˞�܊�2�������ı�����ތ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������ıChanceToDestroyParent"
 �H7  �?  �?  �?(��͢����!z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������ތ�Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(��͢����!Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *���ΣƟ��zhead"$
  ��  8���C   �?  �?  �?(�����ܜ�2	ǲ���՚�.z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ǲ���՚�.	Eye Patch"$
 ��? ���+JB   �?  �?  �?(��ΣƟ��z2'�����՛�ԃ�Λ�膽�폕�Ȥ�i�����Ѧ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������՛�ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(ǲ���՚�.Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ԃ�Λ�膽Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(ǲ���՚�.Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *��폕�Ȥ�iRing - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(ǲ���՚�.Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *������Ѧ�Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(ǲ���՚�.Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *��Ԋ�����Spinning Axe Trap(DMG50)"3
  D XA  �C�f:��3���3�  �?  �?  �?(����Ի��*28������������̡�"��ʵ��ǆ���د����ۥ���⍹\�ХÆ���jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������RotatingAxes(NoDMG)")
 ��  �AފZByq�B  �?  �?  �?(�Ԋ�����2	��痂���Sz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���痂���SCenter Point"3
{���|�= ��B:��8q��B ����Q4?�Q4?�Q4?(�������2����иٵٽ��������⁸�ݿϨZ]
)
ma:Shared_BaseMaterial:id���棿����
0
ma:Shared_BaseMaterial:color�.z<�Ev?%  �?pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
�����088�
 *�����иٵAxes"3
Ms@d�>?��?�.�7��+7 �ӿ �? �? �?(��痂���S2��������xǊ�ť�pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*���������xFantasy Weapon - Axe 01 (Prop)"3
�ד9�����g�@�_A����9���ˍh@ˍh@ˍh@(����иٵ29����ߩ��K������������Ֆ�/��������0����ӻ¿���Ӄ���pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�����ߩ��KFantasy Axe Grip 01"
}��   �?  �?  �?(��������xZ"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��˷����08�
 *���������Fantasy Pommel 02"
�?�� tw�?tw�?tw�?(��������xpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
Ƚ�������08�
 *�����Ֆ�/Fantasy Axe Base 01"
��B   �?  �?  �?(��������xZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Я�����08�
 *���������0Fantasy Hammer Guard 01"
��A   �?  �?  �?(��������xZ"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

���݂���08�
 *�����ӻ¿�Fantasy Axe Blade 01"

  �  \B   �?  �?  �?(��������xZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *���Ӄ���Fantasy Axe Blade 01"$

  A  \B��3�  �?  �?  �?(��������xZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *�Ǌ�ť�Fantasy Weapon - Axe 01 (Prop)"3
ȏ�A��BG�5:��8��3��q��ˍh@ˍh@ˍh@(����иٵ2:����༭Ö͚������Xۼ���϶�8�޹��֊�źаފ�����ȟ�pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�����༭ÖFantasy Axe Grip 01"
}��   �?  �?  �?(Ǌ�ť�Z"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��˷����08�
 *�͚������XFantasy Pommel 02"
�?�� tw�?tw�?tw�?(Ǌ�ť�pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
Ƚ�������08�
 *�ۼ���϶�8Fantasy Axe Base 01"
��B   �?  �?  �?(Ǌ�ť�ZO
#
ma:Shared_Detail1:id�
ԁ������;
(
ma:Shared_BaseMaterial:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

�Я�����08�
 *��޹��֊Fantasy Hammer Guard 01"
��A   �?  �?  �?(Ǌ�ť�Z"
 
ma:Shared_Trim:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

���݂���08�
 *��źаފ��Fantasy Axe Blade 01"

  �  \B   �?  �?  �?(Ǌ�ť�ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *����ȟ�Fantasy Axe Blade 01"$

  A  \B��3�  �?  �?  �?(Ǌ�ť�ZO
(
ma:Shared_BaseMaterial:id�
ԁ������;
#
ma:Shared_Detail1:id�
ԁ������;pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�
ˡ�������08�
 *�ٽ�������Center Rotation".
�"��f5�>�m�@
Ie��.�yJ�?�J�?'F�>(��痂���SZa
(
ma:Shared_BaseMaterial:id�
ԁ������;
5
ma:Shared_BaseMaterial:color�  �?  �?  �?%  �?pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��⁸�ݿϨAxe Spin"3
�5���!�E�UE:��8��3��dܿ���?���?���?(��痂���Spz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ա����ȫP*������̡�"Axes Pillar"

 й� �A   �?  �?  �?(�Ԋ�����2_�����������ى��߆Q�����ķ>�ۡ�ʄ�������������͜H��ϥ����׹���Ά����·���ܿ�����>pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������Cylinder"$
  ��  �:
g.B   �?  �?�s�?(�����̡�"Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���ى��߆QCylinder"$
  ��  �:8�C   �?  �?��>(�����̡�"Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *������ķ>Cylinder"$
  ��  �:�C w@�?w@�?2��=(�����̡�"Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *��ۡ�ʄCylinder"$
  ��  �:��*C w@�?w@�?2��=(�����̡�"Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���������Cylinder"

  ��  �: �@�?�@�?F�>(�����̡�"Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *������͜HCylinder"$
  ��  �:�I@ X��?X��?��>(�����̡�"Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���ϥ����Cylinder"$
  ��  �:�Q�B w@�?w@�?2��=(�����̡�"Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�׹���Ά��Cylinder"$
  ��  �:��A w@�?w@�?2��=(�����̡�"Z*
(
ma:Shared_BaseMaterial:id�
ԁ������;pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *���·���Cylinder"

  ��  �: b��@b��@�Ê=(�����̡�"Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�ܿ�����>Cylinder"$
  ��  �: �2? ���@���@��~=(�����̡�"Z+
)
ma:Shared_BaseMaterial:id���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��������088�
 *�(��ʵ��ǆ�NPC - Axe Trap")
�%*C �A추����B  �?  �?  �?(�Ԋ�����2/Ԃ�����s�������|���������࿑�֯��s���������Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ԃ�����sNPCAIServer"
  �B   �?  �?  �?(��ʵ��ǆ�Z�

cs:Root���ʵ��ǆ�

cs:RotationRoot���ʵ��ǆ�

cs:Collider����������


cs:Trigger�
࿑�֯��s
!
cs:AttackComponent�
�������|pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*��������|NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(��ʵ��ǆ�Z�

cs:Root���ʵ��ǆ�

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*����������Collider"
  �B fff?fff?�̌?(��ʵ��ǆ�Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *�࿑�֯��sTrigger"
  �B ��?��?��?(��ʵ��ǆ�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*����������ClientContext"
    �?  �?  �?(��ʵ��ǆ�2&Й���������σ����ѭ���ǚ�Ε������Mpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *�Й�������NPCAIClient"
  ���?���?���?(���������Z�

cs:Root���ʵ��ǆ�


cs:GeoRoot�
Ε������M

cs:Sleeping��Ǣ�����

cs:Engaging��Ǣ�����

cs:Attacking��Ǣ�����

cs:Patrolling��Ǣ�����

cs:Dead��Ǣ�����

cs:ForwardNode�ѭ���ǚ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*���σ����NPCAttackClient"
  ���?���?���?(���������ZT

cs:Root���ʵ��ǆ�

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*�ѭ���ǚ�ForwardNode"

  �B  �B   �?  �?  �?(���������z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*�Ε������MGeoRoot"
    �?  �?  �?(���������2E��ۂ�����ݑ���ў�מ������Ǣ������ӽ�ϰ�����Ш������ŵ��ˍz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*���ۂ�����NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(Ε������MZ

cs:Root���ʵ��ǆ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*�ݑ���ў�AnimControllerHumanoidSwordsman"
    �?  �?  �?(Ε������MZ:

cs:AnimatedMesh��Ǣ�����

cs:Root���ʵ��ǆ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*�מ�����AnimatedMeshCostume"
    �?  �?  �?(Ε������Mz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*��Ǣ�����Skeleton Mob"
p��B�.�  �?  �?  �?(Ε������MZa
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*��ӽ�ϰ��
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(Ε������M2z�ǭ�����)����և���Ƽ����_���Á���ư����k������߅�ߜԩ����.ә��ۻ����ɖڕ�F𪟉���������������������v��괤��Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*��ǭ�����)Cone - Bullet"

 ��8SA �F�=�F�<G��>(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�����և��Cube"$

 ���B���B�F�<�8�;�$e?(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��Ƽ����_Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����Á�Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *���ư����kWedge - Concave Polished"$

 �?8SA������:�Ff=J�?(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�������߅�Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�ߜԩ����.Cube"

 ��`&A �F�=R�Z=�Ff=(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*�ә��ۻ�Sphere"$
@�A |տ��'A �88=�88=�88=(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����ɖڕ�FHorn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�𪟉����Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(�ӽ�ϰ��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���������vDecal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(�ӽ�ϰ��Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *���괤��Handle"

 ��G�@   �?  �?  �?(�ӽ�ϰ��2���������2���܏���P���Ӫ�ν���ʳ����������������Ї������ɏ�]���������ߘ���ء�8���̬��o����ܥ��!���������򯈺���t�������%���ņ٫��������k�Ī��7ߖ������������������ޮ��L������Μ��������޼��R��Õ��ۅŏ����-���Ơ������ޠ�㹺����𸓰�X��ȫ������ɛ����������ه��������&˨�����Ѝ����ϓ�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������2Sphere"
�3� &��=&��=&��=(��괤��Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����܏���P!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ӫ�ν!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ʳ���!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������Ї�!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ɏ�]!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ߘ���ء�8!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����̬��o!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ܥ��!!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��򯈺���t!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������%!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ņ٫!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������k!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ī��7!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ߖ������!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ޮ��L!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Μ����!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����޼��R!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Õ��ۅ!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ŏ����-!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ơ����!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ޠ�㹺�!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����𸓰�X!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ȫ�����!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ɛ�����!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ه�!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������&!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�˨�����Ѝ!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ϓ���!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(��괤��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ш����upper_spine"$
  ��  8���C   �?  �?  �?(Ε������M2/���ץ�8ؼ겮������������ɴ��Ǻ���ۼ���Œ�Lz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ץ�8Lung"$
  � ��@���A   �?  �?  �?(���Ш����2Ϳע�������䘐��Ez(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ϳע����ChanceToDestroyParent"
 �$!8  �?  �?  �?(���ץ�8z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����䘐��EThorn"$
 �.�6��3�X�(���>�K>�܊>(���ץ�8Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *�ؼ겮����Guts"
    �?  �?  �?(���Ш����21�ʐ�����Ҩ��ґ�/���궡����������⊗������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ʐ�����ChanceToDestroyParent"
 �$!8  �?  �?  �?(ؼ겮����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�Ҩ��ґ�/Ring - Thick"
  �=վ~>վ~>(ؼ겮����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *����궡�Ring - Thick"
 ʄ� i��=]�m>]�m>(ؼ겮����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *����������Ring - Thick"
 ��� r0�=��U>��U>(ؼ겮����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�⊗������Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(ؼ겮����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *���������Heart")
 �� x�� (`A�5D�  �?  �?  �?(���Ш����2&����������������x����߷�����������Pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �5DA  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���������xSphere")
   ��ү=���:��d��=d��=��">(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�����߷���Sphere")
   ���?�:�?����=��=��=(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������PSphere")
   ��=����T@��YB��=��=}��=(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ɴ��Ǻ���	Grass Rib"$
 @@ fA ��   �?  �?  �?(���Ш����2�Ԟ������Θ������sz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��Ԟ������ChanceToDestroyParent"
 �ȶ  �?  �?  �?(ɴ��Ǻ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�Θ������s
Grass Tall"
 
�(RB��3Cj7�;w19=���>(ɴ��Ǻ���ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *�ۼ���Œ�L
Moss Chest"$
 �'A �����A   �?  �?  �?(���Ш����2��Ő�����˅�����]z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���Ő����ChanceToDestroyParent"
 �H7  �?  �?  �?(ۼ���Œ�Lz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��˅�����]Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(ۼ���Œ�LZ#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *���ŵ��ˍhead"$
  ��  8���C   �?  �?  �?(Ε������M2
�������υz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��������υ	Eye Patch"$
 ��? ���+JB   �?  �?  �?(��ŵ��ˍ2&�џָ���JҪ����� �������ݪ���Η��уz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��џָ���JChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(�������υZ

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�Ҫ����� Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(�������υZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *��������ݪRing - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(�������υZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *����Η��уRing - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(�������υZ�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(��د����NPC - Axe Trap")
�84� �A추����B  �?  �?  �?(�Ԋ�����20�藄־��nϤ���Ԟ�Ӛ�٧�ˆ����ĩ�����������Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��藄־��nNPCAIServer"
  �B   �?  �?  �?(��د����Z�

cs:Root���د����

cs:RotationRoot���د����

cs:Collider�Ӛ�٧�ˆ�


cs:Trigger����ĩ��
!
cs:AttackComponent�
Ϥ���Ԟ�pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*�Ϥ���Ԟ�NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(��د����Z�

cs:Root���د����

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*�Ӛ�٧�ˆ�Collider"
  �B fff?fff?�̌?(��د����Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *����ĩ��Trigger"
  �B ��?��?��?(��د����pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*����������ClientContext"
    �?  �?  �?(��د����2%�˩�����l�����޻�$���о�����������Vpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *��˩�����lNPCAIClient"
  ���?���?���?(���������Z�

cs:Root���د����


cs:GeoRoot�
�������V

cs:Sleeping�
������ϯ

cs:Engaging�
������ϯ

cs:Attacking�
������ϯ

cs:Patrolling�
������ϯ

cs:Dead�
������ϯ

cs:ForwardNode����о����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*������޻�$NPCAttackClient"
  ���?���?���?(���������ZT

cs:Root���د����

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*����о����ForwardNode"

  �B  �B   �?  �?  �?(���������z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*��������VGeoRoot"
    �?  �?  �?(���������2A��������񉶣Ӻ����������������ϯ��Ừ���}��ӿ��ŪT�������|z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*��������NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(�������VZ

cs:Root���د����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*��񉶣Ӻ��AnimControllerHumanoidSwordsman"
    �?  �?  �?(�������VZ9

cs:AnimatedMesh�
������ϯ

cs:Root���د����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*���������AnimatedMeshCostume"
    �?  �?  �?(�������Vz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*�������ϯSkeleton Mob"
p��B�.�  �?  �?  �?(�������VZa
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*���Ừ���}
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(�������V2y����鮵�pȽ���┃�����ƿ�R����ފ�������ƌ�k°�����(�����̜1ñ��ƭ��\酡�؋�����К����1�����Ђם֒������������Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�����鮵�pCone - Bullet"

 ��8SA �F�=�F�<G��>(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�Ƚ���┃�Cube"$

 ���B���B�F�<�8�;�$e?(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *�����ƿ�RWedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�����ފ��Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *������ƌ�kWedge - Concave Polished"$

 �?8SA������:�Ff=J�?(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�°�����(Wedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *������̜1Cube"

 ��`&A �F�=R�Z=�Ff=(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*�ñ��ƭ��\Sphere"$
@�A |տ��'A �88=�88=�88=(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�酡�؋���Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���К����1Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *������ЂHorn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(��Ừ���}Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *�ם֒���Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(��Ừ���}Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *����������Handle"

 ��G�@   �?  �?  �?(��Ừ���}2���������������V������=�����׀���׀բ�������������ظ�ʬ홞�̛�����𣪡������毮�ʠ����������������������Ͷ���ÓԴ�Ư�������Й����{���Ԗ�䰣�������0��������歕��/���慂������ɑ���͉��������ֆ$��א����������i���ٖ��o�����������˞���>������z���뼙�ك�������L�������]ۻ����ޒT��������
z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�������Sphere"
�3� &��=&��=&��=(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������V!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������=!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������׀�!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���׀բ��!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ظ�ʬ!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�홞�̛���!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���𣪡��!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����毮�!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ʠ�����!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�Ͷ���ÓԴ!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ư�����!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Й����{!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����Ԗ�䰣!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������0!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���歕��/!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����慂�!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ɑ��!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��͉���!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ֆ$!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���א�����!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������i!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ٖ��o!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����˞���>!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������z!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����뼙�ك!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������L!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������]!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ۻ����ޒT!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������
!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(���������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ӿ��ŪTupper_spine"$
  ��  8���C   �?  �?  �?(�������V21�ĳ�����Uޗ�����Ӣ�����ݴ����ɴ��������й��׻z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��ĳ�����ULung"$
  � ��@���A   �?  �?  �?(��ӿ��ŪT2�¯ۉ��ɴ����̷�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*��¯ۉ��ChanceToDestroyParent"
 �$!8  �?  �?  �?(�ĳ�����Uz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ɴ����̷�Thorn"$
 �.�6��3�X�(���>�K>�܊>(�ĳ�����UZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *�ޗ�����ӢGuts"
    �?  �?  �?(��ӿ��ŪT20����Ɍ���������������ɝ���누���]��Ҙ��ĸ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����Ɍ�ChanceToDestroyParent"
 �$!8  �?  �?  �?(ޗ�����Ӣz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����������Ring - Thick"
  �=վ~>վ~>(ޗ�����ӢZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *������ɝ�Ring - Thick"
 ʄ� i��=]�m>]�m>(ޗ�����ӢZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���누���]Ring - Thick"
 ��� r0�=��U>��U>(ޗ�����ӢZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���Ҙ��ĸ�Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(ޗ�����ӢZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *������ݴ��Heart")
 �� x�� (`A�5D�  �?  �?  �?(��ӿ��ŪT2'����������ڨ������������:��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �5DA  �?  �?  �?(�����ݴ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���ڨ����Sphere")
   ��ү=���:��d��=d��=��">(�����ݴ��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������:Sphere")
   ���?�:�?����=��=��=(�����ݴ��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������Sphere")
   ��=����T@��YB��=��=}��=(�����ݴ��Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���ɴ�����	Grass Rib"$
 @@ fA ��   �?  �?  �?(��ӿ��ŪT2��������ё����Қz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������ChanceToDestroyParent"
 �ȶ  �?  �?  �?(��ɴ�����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�ё����Қ
Grass Tall"
 
�(RB��3Cj7�;w19=���>(��ɴ�����ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *����й��׻
Moss Chest"$
 �'A �����A   �?  �?  �?(��ӿ��ŪT2����ɨ��S�����Ũ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ɨ��SChanceToDestroyParent"
 �H7  �?  �?  �?(���й��׻z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������Ũ�Decal Moss Patch"
 
 �����B
P�=OI�=�=0=(���й��׻Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *��������|head"$
  ��  8���C   �?  �?  �?(�������V2
��ض���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ض���	Eye Patch"$
 ��? ���+JB   �?  �?  �?(�������|2%����쉐������㙥����Ŋ��l�����ª��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����쉐�ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(��ض���Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������㙥Hill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(��ض���Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *�����Ŋ��lRing - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(��ض���Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *������ª��Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(��ض���Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(ۥ���⍹\NPC - Axe Trap"$
 �z� �EC���   �?  �?  �?(�Ԋ�����21�������������������������下�����t�܊�ﾞ��Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������NPCAIServer"
  �B   �?  �?  �?(ۥ���⍹\Z�

cs:Root�
ۥ���⍹\

cs:RotationRoot�
ۥ���⍹\

cs:Collider����������


cs:Trigger�
下�����t
"
cs:AttackComponent���������pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*���������NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(ۥ���⍹\Z�

cs:Root�
ۥ���⍹\

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*����������Collider"
  �B fff?fff?�̌?(ۥ���⍹\Zd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *�下�����tTrigger"
  �B ��?��?��?(ۥ���⍹\pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*��܊�ﾞ��ClientContext"
    �?  �?  �?(ۥ���⍹\2%�������6΋��㕮������Á�|����Ċ��rpz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *��������6NPCAIClient"
  ���?���?���?(�܊�ﾞ��Z�

cs:Root�
ۥ���⍹\


cs:GeoRoot�
����Ċ��r

cs:Sleeping�
�������


cs:Engaging�
�������


cs:Attacking�
�������


cs:Patrolling�
�������


cs:Dead�
�������


cs:ForwardNode�
����Á�|z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*�΋��㕮��NPCAttackClient"
  ���?���?���?(�܊�ﾞ��ZS

cs:Root�
ۥ���⍹\

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*�����Á�|ForwardNode"

  �B  �B   �?  �?  �?(�܊�ﾞ��z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*�����Ċ��rGeoRoot"
    �?  �?  �?(�܊�ﾞ��2D�������ʄɗ��ʖ�Ɠ��Ђ�빭��������
���������ǀў�ŧ�	�� ��á�z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*��������ʄNPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(����Ċ��rZ

cs:Root�
ۥ���⍹\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*�ɗ��ʖ�ƓAnimControllerHumanoidSwordsman"
    �?  �?  �?(����Ċ��rZ8

cs:AnimatedMesh�
�������


cs:Root�
ۥ���⍹\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*���Ђ�빭�AnimatedMeshCostume"
    �?  �?  �?(����Ċ��rz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*��������
Skeleton Mob"
p��B�.�  �?  �?  �?(����Ċ��rZa
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*����������
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(����Ċ��r2~���춬�����������e�������:�ؿ�����������˥����İΪ�R�������������������������Ժ��ዩ՚��������ش��ة���Ȕ��ݐ�Z z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*����춬���Cone - Bullet"

 ��8SA �F�=�F�<G��>(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *���������eCube"$

 ���B���B�F�<�8�;�$e?(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *��������:Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��ؿ������Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *������˥�Wedge - Concave Polished"$

 �?8SA������:�Ff=J�?(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����İΪ�RWedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *��������Cube"

 ��`&A �F�=R�Z=�Ff=(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*����������Sphere"$
@�A |տ��'A �88=�88=�88=(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��������Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *���Ժ��ዩSphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�՚�������Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(���������Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *��ش��ة�Decal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(���������Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *���Ȕ��ݐ�Handle"

 ��G�@   �?  �?  �?(���������2�Ҵ���ܤ�Vֻ�����������ؾ��R�����ۿ�R���������⪝����и���b�����������������˭������i��������.���؝̅������݄�������������������Ҥ�����2����������ж�����v󮺔ü�ܤ�������׉�̫�������գ���W��׸��������ݿ���ȭ�����w����Њ�:��������������t��������$р���ߋ/��������Q����������������l䣇㺬����漻���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ҵ���ܤ�VSphere"
�3� &��=&��=&��=(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�ֻ�������!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ؾ��R!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ۿ�R!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��⪝���!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��и���b!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�˭������i!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������.!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����؝̅��!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����݄��!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ҥ�����2!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ж�����v!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�󮺔ü�ܤ!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������׉!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��̫������!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��գ���W!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���׸���!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������ݿ��!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ȭ�����w!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Њ�:!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������t!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������$!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�р���ߋ/!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������Q!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������l!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�䣇㺬��!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���漻���!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(��Ȕ��ݐ�Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ǀў�ŧ�	upper_spine"$
  ��  8���C   �?  �?  �?(����Ċ��r2.賊����ܿ���޷��\����̼&����˦��1���ۿ���cz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�賊����ܿLung"$
  � ��@���A   �?  �?  �?(ǀў�ŧ�	2�����ѵ��������/z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������ѵ��ChanceToDestroyParent"
 �$!8  �?  �?  �?(賊����ܿz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�������/Thorn"$
 �.�6��3�X�(���>�K>�܊>(賊����ܿZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *����޷��\Guts"
    �?  �?  �?(ǀў�ŧ�	2/����ᶒ�p������?ŏڛ����%���������ђܕ�ɷ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ᶒ�pChanceToDestroyParent"
 �$!8  �?  �?  �?(���޷��\z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�������?Ring - Thick"
  �=վ~>վ~>(���޷��\Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�ŏڛ����%Ring - Thick"
 ʄ� i��=]�m>]�m>(���޷��\Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���������Ring - Thick"
 ��� r0�=��U>��U>(���޷��\Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *��ђܕ�ɷ�Cone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(���޷��\Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�����̼&Heart")
 �� x�� (`A�5D�  �?  �?  �?(ǀў�ŧ�	2%ݨ�������ê����q��������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ݨ�����ChanceToDestroyParent"
 �5DA  �?  �?  �?(����̼&z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���ê����qSphere")
   ��ү=���:��d��=d��=��">(����̼&Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�������Sphere")
   ���?�:�?����=��=��=(����̼&Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������Sphere")
   ��=����T@��YB��=��=}��=(����̼&Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�����˦��1	Grass Rib"$
 @@ fA ��   �?  �?  �?(ǀў�ŧ�	2��������	�������� z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������	ChanceToDestroyParent"
 �ȶ  �?  �?  �?(����˦��1z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��������� 
Grass Tall"
 
�(RB��3Cj7�;w19=���>(����˦��1ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *����ۿ���c
Moss Chest"$
 �'A �����A   �?  �?  �?(ǀў�ŧ�	2���˗���������¦фz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����˗����ChanceToDestroyParent"
 �H7  �?  �?  �?(���ۿ���cz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������¦фDecal Moss Patch"
 
 �����B
P�=OI�=�=0=(���ۿ���cZ#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *��� ��á�head"$
  ��  8���C   �?  �?  �?(����Ċ��r2
��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������	Eye Patch"$
 ��? ���+JB   �?  �?  �?(�� ��á�2'�����Ȳ�����䂦�Yﱦܾ���������֚��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Ȳ�ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(��������Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����䂦�YHill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(��������Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *�ﱦܾ����Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(��������Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *������֚��Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(��������Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *�(�ХÆ���jNPC - Axe Trap"$
 �z� �����   �?  �?  �?(�Ԋ�����20��������R�Ŵ�ە��������ܫ�q��ҿ�Ւ�����������Z�&

cs:ObjectIdX 

cs:TeamX

cs:CurrentStateX 

cs:CurrentHealthe @F

cs:MoveSpeede    

cs:TurnSpeede   A

cs:LogicalPeriode   ?

cs:ReturnToSpawnP

cs:VisionHalfAnglee  �C

cs:VisionRadiuse @E

cs:HearingRadiuse  zD

cs:SearchBonusVisione @�E

cs:SearchDuratione  �@

cs:PossibilityRadiuse  HD

cs:ChaseRadiuse  zE

cs:AttackRangee  zC

cs:AttackCaste���=

cs:AttackRecoverye   ?

cs:AttackCooldowne    

cs:IsPushableP 

cs:RewardResourceTypejXP

cs:RewardResourceAmountX 

	cs:LootIdjCommon

cs:CurrentState:isrepP

cs:CurrentHealth:isrepP

cs:ObjectId:isrepP

cs:Team:isrepP
�
cs:LootId:tooltipj�The ID of the group of loot from the Loot Factory. E.g. "Common" will drop a common loot when the NPC is killed. To drop nothing remove this property.
�
cs:ObjectId:tooltipj�Set at runtime. The NPC Manager dynamically assigns an ID to each NPC so they can know if a networked event pertains to them or to another NPC.
�
cs:Team:tooltipj�Like players, NPCs can have a team. They will fight players and NPCs from other teams and will not fight characters from the same team as them. When spawned from a spawn camp, the NPC's team is dynamically set to that of the camp.
�
cs:CurrentState:tooltipj�Set dynamically at runtime. This is the internal state of the NPC, such as sleeping, engaging, attacking, etc. This networked property coordinates the server and client parts of the NPC.
�
cs:CurrentHealth:tooltipj~The NPC's health/hitpoints. When editing it represents their max and initial health. During runtime it's their current health.
�
cs:MoveSpeed:tooltipjnThe NPC's top movement speed in cm/s. Set to zero for an NPC that doesn't move (e.g. Tower or other building).
w
cs:TurnSpeed:tooltipj_How quickly the NPC rotates to face their target or when searching for the origin of an attack.
�
cs:LogicalPeriod:tooltipj�To avoid overusing the server's CPU the NPC's only make decisions periodically. The LogicalPeriod is the length of that interval, in seconds.
s
cs:ReturnToSpawn:tooltipjWIf true, the NPC will try to return to their spawn point after they have nothing to do.
�
cs:VisionHalfAngle:tooltipj�This is half the vision cone's angle. Enemies outside the angle will not be seen. If set to 0 or greater than 360 then the NPC has full vision all around it. A value of 90 degrees would result in a half-sphere of peripheral vision. The smaller the value, the worse is the NPC's vision.
�
cs:VisionRadius:tooltipjmThe max range of the vision (in centimeters). Enemies at a distance greater than this value will not be seen.
�
cs:HearingRadius:tooltipj�If an ally is hit by an attack, the point of impact is compared against the HearingRadius. If closer than this distance, then the NPC will begin a search to find the source of the attack.

cs:SearchBonusVision:tooltipj_While searching for an enemy that recently attacked, the NPC can be given a bonus vision range.
I
cs:SearchDuration:tooltipj,Duration, in seconds, if the search pattern.
�
cs:PossibilityRadius:tooltipj�When searching for an enemy that attacked recently, the NPC will scan an area starting at itself then moving in the direction where the attack came from. The PossibilityRadius is the search volume that moves in that direction. A larger value means the NPC has an easier time spotting enemies.
�
cs:ChaseRadius:tooltipj�If engaging an enemy that is outside of attack range, the NPC will give up the chase if the enemy goes further than their ChaseRadius.
�
cs:AttackRange:tooltipj�The NPC engages and moves towards a target until that target is within the AttackRange. That's when it changes to an Attack state and produces the projectile that is the combat interaction. A smaller attack range means the NPC must get closer before executing an attack.
�
cs:AttackCast:tooltipjxWhile executing an attack, the AttackCast is the amount of "windup" time, in seconds, before the projectile is produced.
�
cs:AttackRecovery:tooltipj�During an attack, the AttackRecovery time is an amount in seconds after the projectile is created, during which the NPC winds down their attack and essentially does nothing.
�
cs:AttackCooldown:tooltipj�The AttackCooldown is the minimum amount of time, in seconds, between NPC attacks. If the attack is on cooldown and the target continues within attack range, the NPC will essentially do nothing until the attack cooldown time completes.
�
cs:IsPushable:tooltipjkIf true, then the NPC can be pushed aside by allied characters if they are trying to occupy the same space.
�
cs:RewardResourceType:tooltipj|Some NPCs can grant resources to players that kill them. The RewardResourceType is the Type of resource to grant to players.
�
cs:RewardResourceAmount:tooltipj�Some NPCs can grant resources to players that kill them. The RewardResourceAmount is the Amount of the resource to grant to playerspz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������RNPCAIServer"
  �B   �?  �?  �?(�ХÆ���jZ�

cs:Root�
�ХÆ���j

cs:RotationRoot�
�ХÆ���j

cs:Collider�
�����ܫ�q


cs:Trigger���ҿ�Ւ��
"
cs:AttackComponent��Ŵ�ە���pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���������*��Ŵ�ە���NPCAttackServer".

 �B���B�K�@�ƫ)id�+  �?  �?  �?(�ХÆ���jZ�

cs:Root�
�ХÆ���j

cs:DamageToPlayersX2

cs:DamageToNPCse  HB
!
cs:ProjectileBody����͙��̮

cs:MuzzleFlash�
��������

cs:ImpactSurface�
���ɲ���x
"
cs:ImpactCharacter��Ԧغ����

cs:ProjectileLifeSpane�G�=

cs:ProjectileSpeede  HB

cs:ProjectileGravitye    

cs:ProjectileHomingPpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ͨ��鉹�*������ܫ�qCollider"
  �B fff?fff?�̌?(�ХÆ���jZd

cs:WalkableP 
)
ma:Shared_BaseMaterial:id����������
&
ma:Shared_BaseMaterial:color�%  �?pz
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�

�����ɩ�8�
 *���ҿ�Ւ��Trigger"
  �B ��?��?��?(�ХÆ���jpz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�!"08*
mc:etriggershape:sphere*����������ClientContext"
    �?  �?  �?(�ХÆ���j2'¯�Ɵ���N炍���������Ψ�����������pz
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent� *�¯�Ɵ���NNPCAIClient"
  ���?���?���?(���������Z�

cs:Root�
�ХÆ���j


cs:GeoRoot���������

cs:Sleeping�
��������Q

cs:Engaging�
��������Q

cs:Attacking�
��������Q

cs:Patrolling�
��������Q

cs:Dead�
��������Q

cs:ForwardNode����Ψ���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ߧ��x*�炍������NPCAttackClient"
  ���?���?���?(���������ZS

cs:Root�
�ХÆ���j

cs:DamageFX�������ȥ�

cs:DestroyFX�������ȥ�z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

ۣ������8*����Ψ���ForwardNode"

  �B  �B   �?  �?  �?(���������z
mc:ecollisionsetting:forceon�)
'mc:evisibilitysetting:inheritfromparent�*���������GeoRoot"
    �?  �?  �?(���������2D�����즣�Ֆî�����������ݳ���������Q����ዎ�*����������᫔�����z
mc:ecollisionsetting:forceoff� 
mc:evisibilitysetting:forceoff�*������즣�NPCHealthBarDataProviderClient"
�ǜC   �?  �?  �?(��������Z

cs:Root�
�ХÆ���jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Ц�������*�Ֆî�����AnimControllerHumanoidSwordsman"
    �?  �?  �?(��������Z8

cs:AnimatedMesh�
��������Q

cs:Root�
�ХÆ���jz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������%*�������ݳ�AnimatedMeshCostume"
    �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������⬁*���������QSkeleton Mob"
p��B�.�  �?  �?  �?(��������Za
(
ma:Shared_BaseMaterial:id�
��������<
5
ma:Shared_BaseMaterial:color�PU?qT�>e4>%  �?z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�<
�����˅��08�&"unarmed_bind_pose-  �?0=  �?J  �?*�����ዎ�*
right_prop"3
 `�@ PUB��B3ڔB���w;B  �?  �?  �?(��������2zƴ������ǧ����������뤙��2񯐶�ݘ��Ǖ�����G���Ӥ��V���궐��]�ŵ�����0Ԟ�ŷ�Ŀ����ʶ�������������æ���o��Ø��ŕIZ z
mc:ecollisionsetting:forceoff�)
'mc:evisibilitysetting:inheritfromparent�*�ƴ������Cone - Bullet"

 ��8SA �F�=�F�<G��>(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�Z�>
#
ma:Shared_BaseMaterial:vtilee2t?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�ǧ�������Cube"$

 ���B���B�F�<�8�;�$e?(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?
 
ma:Shared_BaseMaterial:smartP z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
 *����뤙��2Wedge - Concave Polished"$

 ���8SA���B��:�Ff=J�?(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�񯐶�ݘ��Wedge - Concave Polished"$

 ���8SA������:�Ff=J�?(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *�Ǖ�����GWedge - Concave Polished"$

 �?8SA������:�Ff=J�?(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtileeH��?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����Ӥ��VWedge - Concave Polished"$

 �?8SA���B��:�Ff=J�?(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee�>
#
ma:Shared_BaseMaterial:vtileeĝ�?
5
ma:Shared_BaseMaterial:color��n?�n?�n?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��⎦��.088�
 *����궐��]Cube"

 ��`&A �F�=R�Z=�Ff=(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

������F088�
%
�#<*��ŵ�����0Sphere"$
@�A |տ��'A �88=�88=�88=(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *�Ԟ�ŷ�Ŀ�Horn"3
 �@ ��`&ARp�?�V�B���Gf=�Ff=Y>�>(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *����ʶ��Sphere"3
@�� ��?��'A��8��3��f8�88=�88=�88=(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������Horn"3
 �� ��`&A�n�?@������Gf=�Ff=Y>�>(����ዎ�*Z�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
�ڪ��Կ��088�
 *����æ���oDecal Stains Round 01"3
�3�?D��J/�B�d�?�%�`�B��<���=���=(����ዎ�*Z

bp:color�
�>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��������� *���Ø��ŕIHandle"

 ��G�@   �?  �?  �?(����ዎ�*2�ā��Ǉ��������������ʾ�����������U��Ȫ����񆽋�����������)���������ٚ���vɰ���	޾�檹�ˈ���������Đф�H���ݷ������������m÷����������ģ�ԓ���Ŗ���������֡�����������C��������������ю�����������v؟��������������C���������������l������������������������抠�������ȡ��}����Ѡ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ā��Ǉ���Sphere"
�3� &��=&��=&��=(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
�ס�ո��[
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�]�?]�?]�?%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *���������!Cylinder - Rounded Bottom-Aligned"

 �=��� Zۉ=s�j=�<�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ʾ���!Cylinder - Rounded Bottom-Aligned")
0^�= �=�X�M��@�f�=�f=@ҧ<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������U!Cylinder - Rounded Bottom-Aligned")
��(� �= �� ���F|�=jJa=V�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���Ȫ���!Cylinder - Rounded Bottom-Aligned")
`Kx= �=����|�@Jx�=�Ca=KQ�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��񆽋���!Cylinder - Rounded Bottom-Aligned")
 �x� �=�E����J��͉=J�a=���<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������)!Cylinder - Rounded Bottom-Aligned")
��w= �= ������@��=8\`=Q��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
P� �=����ɥ�~��=s�^=펢<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��ٚ���v!Cylinder - Rounded Bottom-Aligned")
 "!> �=������@}�=]Y]=v�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�ɰ���	!Cylinder - Rounded Bottom-Aligned")
�u� �= ���T��.,�=��[=Y`�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�޾�檹�ˈ!Cylinder - Rounded Bottom-Aligned")
�W> �=�'�� �@.,�=��[=Z`�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
@�p� �=X�5��=��wE�=�bZ=�L�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Đф�H!Cylinder - Rounded Bottom-Aligned")
X�E> �=X�?��i!A��=W/X=���<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����ݷ����!Cylinder - Rounded Bottom-Aligned")
�p�� �=$�K�@����
�=��V=���<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������m!Cylinder - Rounded Bottom-Aligned")
��#> �=��W���@/��=�V=��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�÷���!Cylinder - Rounded Bottom-Aligned")
`|̼ �=�Ph�@ѓ����=��T=m�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������!Cylinder - Rounded Bottom-Aligned")
�A> �=�+t�,�@J�=5�S=��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ģ�ԓ��!Cylinder - Rounded Bottom-Aligned")
�"b� �=d����}��/�=��Q=~��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��Ŗ�����!Cylinder - Rounded Bottom-Aligned")
�^> �=�����@v�=(�Q=��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����֡���!Cylinder - Rounded Bottom-Aligned")
�O[� �=XT�� ,��O@~=�PP=��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������C!Cylinder - Rounded Bottom-Aligned")
�� > �=8R��SD�@$�|=W�N=��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *������!Cylinder - Rounded Bottom-Aligned")
8�� �=:����<���z=��M=/�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
0^�= �=���M��@8�y=ّL=�8�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���ю����!Cylinder - Rounded Bottom-Aligned")
��(� �=ӫ� ����~t=NRH=c�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������v!Cylinder - Rounded Bottom-Aligned")
`Kx= �=6��|�@�wt=yLH=$�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�؟�������!Cylinder - Rounded Bottom-Aligned")
 �x� �=�a����J�0u=S�H==v�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������C!Cylinder - Rounded Bottom-Aligned")
��w= �=bʿ����@Z|s=|~G=焑<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���������!Cylinder - Rounded Bottom-Aligned")
P� �=�����ɥ���q='F=���<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������l!Cylinder - Rounded Bottom-Aligned")
 "!> �=r�����@�7p=�D=�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������!Cylinder - Rounded Bottom-Aligned")
�u� �=$P���T����n=�~C=	��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *��������!Cylinder - Rounded Bottom-Aligned")
�W> �=���� �@��n=�~C=
��<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�������!Cylinder - Rounded Bottom-Aligned")
@�p� �=�����=��^ m=p.B=פ�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *���抠���!Cylinder - Rounded Bottom-Aligned")
X�E> �=�����i!A�j=�9@=w7�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����ȡ��}!Cylinder - Rounded Bottom-Aligned")
�p�� �=(���@����	i=�>=ZF�<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *�����Ѡ��!Cylinder - Rounded Bottom-Aligned")
��= �=h���w�>DAh=�J>=�Ί<(��Ø��ŕIZ�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�   @`q�?(\�>%  �?
#
ma:Shared_BaseMaterial:utilee�X]>
#
ma:Shared_BaseMaterial:vtilee�X]>z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Փ�088�
 *����������upper_spine"$
  ��  8���C   �?  �?  �?(��������21���ٗ������������Ε߼�ޢ�b�Бԓ�����������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����ٗ����Lung"$
  � ��@���A   �?  �?  �?(���������2��ҟ�ؘ�������ă��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���ҟ�ؘ��ChanceToDestroyParent"
 �$!8  �?  �?  �?(���ٗ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������ă��Thorn"$
 �.�6��3�X�(���>�K>�܊>(���ٗ����Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�k�t>���=i4�=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�����(088�
 *���������Guts"
    �?  �?  �?(���������20����Էۦ��Ʒò���@����؈����������ó��Πkz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����Էۦ�ChanceToDestroyParent"
 �$!8  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*��Ʒò���@Ring - Thick"
  �=վ~>վ~>(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�����؈��Ring - Thick"
 ʄ� i��=]�m>]�m>(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *�������Ring - Thick"
 ��� r0�=��U>��U>(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�Ð���f088�
 *���ó��ΠkCone - Bullet"3
 �?  �� 8���.�6��3���3��,=�,=�N`=(��������Zb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���t>���=���=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

��݃����1088�
 *�Ε߼�ޢ�bHeart")
 �� x�� (`A�5D�  �?  �?  �?(���������2%��������0���᫧���������\���������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������0ChanceToDestroyParent"
 �5DA  �?  �?  �?(Ε߼�ޢ�bz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*����᫧��Sphere")
   ��ү=���:��d��=d��=��">(Ε߼�ޢ�bZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��������\Sphere")
   ���?�:�?����=��=��=(Ε߼�ޢ�bZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color�q=
>�=9=Te�<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *����������Sphere")
   ��=����T@��YB��=��=}��=(Ε߼�ޢ�bZb
)
ma:Shared_BaseMaterial:id����������
5
ma:Shared_BaseMaterial:color���>�ϵ=DB[=%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
������Ȭ088�
 *��Бԓ����	Grass Rib"$
 @@ fA ��   �?  �?  �?(���������2ޓ���!��얘���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ޓ���!ChanceToDestroyParent"
 �ȶ  �?  �?  �?(�Бԓ����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*���얘���
Grass Tall"
 
�(RB��3Cj7�;w19=���>(�Бԓ����ZS
!
ma:Nature_Grass:id�
��ڈ��ѿ
.
ma:Nature_Grass:color��ȣ=�x�=df<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

����ﺱ�~088�
 *��������
Moss Chest"$
 �'A �����A   �?  �?  �?(���������2Ү�����������ƒ��yz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�Ү�������ChanceToDestroyParent"
 �H7  �?  �?  �?(�������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*�����ƒ��yDecal Moss Patch"
 
 �����B
P�=OI�=�=0=(�������Z#
!
bp:color�0H�>��?X�b<%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�οğ���B� *��᫔�����head"$
  ��  8���C   �?  �?  �?(��������2	����ϯ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����ϯ��	Eye Patch"$
 ��? ���+JB   �?  �?  �?(�᫔�����2&���Ս��������ʼ��������
���䆃���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����Ս���ChanceToDestroyParent")
 �A h��@"	� �H7  �?  �?  �?(����ϯ��Z

cs:ChanceToDestroye��Y?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
���ӏ����*������ʼHill 05"3
 ��@  � �>��tB��gBN>��Cg@<Cg@<Cg@<(����ϯ��Z�
(
ma:Shared_BaseMaterial:id�
��ճ��ŤC
 
ma:Shared_BaseMaterial:smartP 
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee   >
5
ma:Shared_BaseMaterial:color��Sc>�Sc>�Sc>%  �?z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
��̠����088�
 *���������
Ring - Thin".

 ��� ��?��<�����B�:c>�fX>��f>(����ϯ��Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 *����䆃���Ring - Thin"3
 ��� �*? `�?��<�����Bd:c>�cA>"�f>(����ϯ��Z�
)
ma:Shared_BaseMaterial:id���ϟ��۠
 
ma:Shared_BaseMaterial:smartP 
5
ma:Shared_BaseMaterial:color�o=o=o=%  �?
#
ma:Shared_BaseMaterial:utilee   >
#
ma:Shared_BaseMaterial:vtilee.@z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
Į�������088�
 
NoneNone�I*GA basic spinning axe trap.
I used NPC Kit would recommend having it!!!�
I��ϟ��۠Metal Frame 01R*
MaterialAssetRefmi_metal_frames_001_uv
>Į�������Ring - ThinR"
StaticMeshAssetRefsm_torus_003
9��̠����Hill 05R!
StaticMeshAssetRefsm_hill_005
Q�οğ���BDecal Moss PatchR1
DecalBlueprintAssetRefbp_decal_moss_patch_001
Q��ڈ��ѿCustom Grass from Grass Tall�$��ژ�����

wind_intensitye���=
K��ژ�����Grass (default)R+
MaterialAssetRefmi_grass_dynamic_001_uv
D����ﺱ�~
Grass TallR*
StaticMeshAssetRefsm_grass_generic_001
>�Ð���fRing - ThickR"
StaticMeshAssetRefsm_torus_005
7�����(ThornR"
StaticMeshAssetRefsm_tooth_002
A��ճ��ŤC
Asphalt 01R'
MaterialAssetRefmi_gen_asphault_001
X��������Decal Stains Round 01R2
DecalBlueprintAssetRefbp_decal_stain_round_001
L�ڪ��Կ��Cone - TruncatedR+
StaticMeshAssetRefsm_cone_truncated_001
\��⎦��.Wedge - Concave PolishedR4
StaticMeshAssetRefsm_wedge_curved_concave_hq_001
I�ס�ո��[Metal Iron Rusted 02R%
MaterialAssetRefmi_metal_iron_003
@��݃����1Cone - BulletR#
StaticMeshAssetRefsm_bullet_001
U�����˅��Skeleton MobR8
AnimatedMeshAssetRef npc_human_guy_skelington_001_ref
��������%AnimControllerHumanoidSwordsmanZ��--[[
	Animation Controller - Humanoid Swordsman
	v1.0
	by: standardcombo, blackdheart
	
	Controls the animations for an NPC based on the Skeleton Animated Mesh.
	Changes in animation occur in response to movement and state machine changes.
--]]

local MESH = script:GetCustomProperty("AnimatedMesh"):WaitForObject()
local ROOT = script:GetCustomProperty("Root"):WaitForObject()
local IDLE_STANCE = script:GetCustomProperty("IdleStance") or "1hand_melee_idle_ready"
local WALK_STANCE = script:GetCustomProperty("WalkStance") or "1hand_melee_walk_forward"
local RUN_STANCE = script:GetCustomProperty("RunStance") or "1hand_melee_run_forward"
local WALKING_SPEED = 5
local RUNNING_SPEED = 250

local lastPos = script.parent:GetWorldPosition()

local attackIndex = 1
local speed = 0

function PlayAttack()
	if attackIndex == 1 then
		MESH:PlayAnimation("1hand_melee_slash_left", {playbackRate = 0.6})
		attackIndex = 2
	else
		MESH:PlayAnimation("1hand_melee_slash_right", {playbackRate = 0.6})
		attackIndex = 1
	end
	MESH.playbackRateMultiplier = 1
end

function PlayDeath()
	MESH:PlayAnimation("unarmed_death")
	Task.Wait(1.96)
	MESH.playbackRateMultiplier = 0
end

function PlayDamaged()
	MESH:PlayAnimation("unarmed_react_damage", {playbackRate = 0.8})
	MESH.playbackRateMultiplier = 1
end

function Tick(deltaTime)
	if deltaTime <= 0 then return end
	
	local pos = script.parent:GetWorldPosition()
	local v = pos - lastPos
	speed = v.size / deltaTime
	
	lastPos = pos
	
	if speed < WALKING_SPEED then
		MESH.animationStance = IDLE_STANCE
		
	elseif speed < RUNNING_SPEED then
		MESH.animationStance = WALK_STANCE
		MESH.animationStancePlaybackRate = 2 * (speed - WALKING_SPEED) / (RUNNING_SPEED - WALKING_SPEED)
	else
		MESH.animationStance = RUN_STANCE
		MESH.animationStancePlaybackRate = 0.5 + (speed - RUNNING_SPEED) * 0.002
	end
end


local STATE_SLEEPING = 0
local STATE_ENGAGING = 1
local STATE_ATTACK_CAST = 2
local STATE_ATTACK_RECOVERY = 3
local STATE_PATROLLING = 4
local STATE_LOOKING_AROUND = 5
local STATE_DEAD_1 = 6
local STATE_DEAD_2 = 7
local STATE_DISABLED = 8

function UpdateArt(state)		
	if (state == STATE_ATTACK_CAST) then
		PlayAttack()
				
	elseif (state == STATE_DEAD_1) then
		PlayDeath()
	end
end


function GetID()
	if Object.IsValid(ROOT) then
		return ROOT:GetCustomProperty("ObjectId")
	end
	return nil
end

function GetCurrentState()
	if not Object.IsValid(ROOT) then
		return 0
	end
	return ROOT:GetCustomProperty("CurrentState")
end


function OnPropertyChanged(object, propertyName)
	
	if (propertyName == "CurrentState") then
		UpdateArt(GetCurrentState())
	end
end

function OnObjectDamaged(id, prevHealth, dmgAmount, impactPosition, impactRotation, sourceObject)
	local state = GetCurrentState()
	if state == STATE_ATTACK_CAST then return end
	if state >= STATE_DEAD_1 then return end
	if speed > 40 then return end
	-- Ignore other NPCs, make sure this event is about this NPC
	if id == GetID() then
		PlayDamaged()
	end
end

local damagedListener = Events.Connect("ObjectDamaged", OnObjectDamaged)

function OnDestroyed(obj)
	if damagedListener then
		damagedListener:Disconnect()
		damagedListener = nil
	end
end

ROOT.destroyEvent:Connect(OnDestroyed)
ROOT.networkedPropertyChangedEvent:Connect(OnPropertyChanged)

--[[
function OnBindingPressed(player, action)
	if action == "ability_primary" then
		PlayAttack()
		
	elseif action == "ability_secondary" then
		PlayDeath()
	end
end

Game.playerJoinedEvent:Connect(function(player)
	player.bindingPressedEvent:Connect(OnBindingPressed)
end)
--]]�

cs:AnimatedMesh� 

cs:Root� 
'
cs:IdleStancej1hand_melee_idle_ready
)
cs:WalkStancej1hand_melee_walk_forward
'
cs:RunStancej1hand_melee_run_forward
N
cs:AnimatedMesh:tooltipj3Reference to the animated mesh object for this NPC.
n
cs:Root:tooltipj[A reference to the root of the template, where most of the NPC's custom properties are set.
;�����ɩ�CapsuleR$
StaticMeshAssetRefsm_capsule_001
���������Axe Trap Swing Affectb�
� ��Ϙ�޲*���Ϙ�޲Axe Trap Swing Affect"  �?  �?  �?(�����B2
ِ�ܖ��ɌZ e   ?pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ِ�ܖ��ɌClientContext"
    �?  �?  �?(��Ϙ�޲2�����������ֺۭ��KZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *����������Sword Swipe Half Circle VFX"
    �?  �?  �?(ِ�ܖ��ɌZm
!
bp:color�  @@z��?~��>%   ?

bp:Edge Color�
���=%  �?

bp:Sizer   @   @  �?

bp:Lifee33�>z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�

Ƃ�������*���ֺۭ��KSword Swipe Half Circle VFX"
    �?  �?  �?(ِ�ܖ��ɌZ}

bp:color�
  �@%  �?

bp:Edge Color�
���>%  �?

bp:Sizer��@��@  �?

bp:Lifee)\�>

bp:Emissive Booste  �?z(
&mc:ecollisionsetting:inheritfromparent� 
mc:evisibilitysetting:forceoff�

Ƃ�������
NoneNone
VƂ������Sword Swipe Half Circle VFXR+
VfxBlueprintAssetReffxbp_sword_swipe_01
�Rͨ��鉹�NPCAttackServerZ�R�=--[[
	NPCAttack - Server
	by: standardcombo
	v0.9.1
	
	Works in conjunction with NPCAIServer. The separation of the two scripts makes it
	easier to design diverse kinds of enemies.
--]]

-- Component dependencies
local MODULE = require( script:GetCustomProperty("ModuleManager") )
require ( script:GetCustomProperty("DestructibleManager") )
function DESTRUCTIBLE_MANAGER() return MODULE.Get("standardcombo.NPCKit.DestructibleManager") end
function COMBAT() return MODULE.Get("standardcombo.Combat.Wrap") end
function PLAYER_HOMING_TARGETS() return MODULE.Get("standardcombo.Combat.PlayerHomingTargets") end
function CROSS_CONTEXT_CALLER() return MODULE.Get("standardcombo.Utils.CrossContextCaller") end
function LOOT_DROP_FACTORY() return MODULE.Get_Optional("standardcombo.NPCKit.LootDropFactory") end


local ROOT = script:GetCustomProperty("Root"):WaitForObject()

local DAMAGE_TO_PLAYERS = script:GetCustomProperty("DamageToPlayers") or 1
local DAMAGE_TO_NPCS = script:GetCustomProperty("DamageToNPCs") or 1

local PROJECTILE_BODY = script:GetCustomProperty("ProjectileBody")
local MUZZLE_FLASH_VFX = script:GetCustomProperty("MuzzleFlash")
local IMPACT_SURFACE_VFX = script:GetCustomProperty("ImpactSurface")
local IMPACT_CHARACTER_VFX = script:GetCustomProperty("ImpactCharacter")
local PROJECTILE_LIFESPAN = script:GetCustomProperty("ProjectileLifeSpan") or 10
local PROJECTILE_SPEED = script:GetCustomProperty("ProjectileSpeed") or 4000
local PROJECTILE_GRAVITY = script:GetCustomProperty("ProjectileGravity") or 1
local IS_PROJECTILE_HOMING = script:GetCustomProperty("ProjectileHoming")
local HOMING_DRAG = script:GetCustomProperty("HomingDrag") or 7
local HOMING_ACCELERATION = script:GetCustomProperty("HomingAcceleration") or 15000

local REWARD_RESOURCE_TYPE = ROOT:GetCustomProperty("RewardResourceType")
local REWARD_RESOURCE_AMOUNT = ROOT:GetCustomProperty("RewardResourceAmount")

local LOOT_ID = ROOT:GetCustomProperty("LootId")

local attackCooldown = 2
local cooldownRemaining = 0

local projectileImpactListener = nil


local hasQuest = script:GetCustomProperty("hasQuest")
local QuestID = script:GetCustomProperty("QuestID") or 0

local QUESTDATA = require(script:GetCustomProperty("QUESTDATA"))
local questTable = QUESTDATA.GetItems()

--Magic Numbers
local questID = 1
local questName = 2
local rewardType = 3
local rewardValue = 4
local questDescText = 5
local questCompleteText = 6
local reqLevel = 7
local RES_NAME = 8
local RES_REQ = 9
local QUEST_DESC = 10



function GetTeam()
	return ROOT:GetCustomProperty("Team")
end

function GetObjectTeam(object)
	if object.team ~= nil then
		return object.team
	end
	local templateRoot = object:FindTemplateRoot()
	if templateRoot then
		return templateRoot:GetCustomProperty("Team")
	end
	return nil
end

function Attack(target)	
	if target:IsA("Player") and PLAYER_HOMING_TARGETS() then
		target = PLAYER_HOMING_TARGETS().GetTargetForPlayer(target)
	end
	
	local startPos = script:GetWorldPosition()
	local rotation = script:GetWorldRotation()
	local direction = rotation * Vector3.FORWARD
	if not IS_PROJECTILE_HOMING then
		local v = target:GetWorldPosition() - startPos
		direction = v:GetNormalized() + 200 * Vector3.UP * v.size * PROJECTILE_GRAVITY / PROJECTILE_SPEED / PROJECTILE_SPEED
	end
	
	CROSS_CONTEXT_CALLER().Call(function()
		local projectile = Projectile.Spawn(PROJECTILE_BODY, startPos, direction)
		projectile.lifeSpan = PROJECTILE_LIFESPAN
		projectile.speed = PROJECTILE_SPEED
		projectile.gravityScale = PROJECTILE_GRAVITY
		
		if IS_PROJECTILE_HOMING then
			projectile.homingTarget = target
			projectile.drag = HOMING_DRAG
			projectile.homingAcceleration = HOMING_ACCELERATION
		end
		
		projectile.piercesRemaining = 999
		
		projectileImpactListener = projectile.impactEvent:Connect(OnProjectileImpact)
	end)
	
	SpawnAsset(MUZZLE_FLASH_VFX, startPos, rotation)
end


function OnProjectileImpact(projectile, other, hitResult)
	
	local myTeam = GetTeam()
	local impactTeam = GetObjectTeam(other)
	if (impactTeam ~= 0 and myTeam == impactTeam) then return end
	
	CleanupProjectileListener()
	
	local pos = hitResult:GetImpactPosition()
	local rot = projectile:GetWorldTransform():GetRotation()
	
	local damageAmount = 0
	
	if other:IsA("Player") then
		damageAmount = DAMAGE_TO_PLAYERS
		SpawnAsset(IMPACT_CHARACTER_VFX, pos, rot)
	else
		damageAmount = DAMAGE_TO_NPCS
		SpawnAsset(IMPACT_SURFACE_VFX, pos, hitResult:GetTransform():GetRotation())
	end
	
	local dmg = Damage.New(damageAmount)
	dmg:SetHitResult(hitResult)
	dmg.reason = DamageReason.COMBAT
		
	COMBAT().ApplyDamage(other, dmg, script, pos, rot)
		
	projectile:Destroy()
end


function CleanupProjectileListener()
	if projectileImpactListener then
		projectileImpactListener:Disconnect()
		projectileImpactListener = nil
	end
end


function SpawnAsset(template, pos, rot)
	if not template then return end
	
	CROSS_CONTEXT_CALLER().Call(function()
		local spawnedVfx = World.SpawnAsset(template, {position = pos, rotation = rot})
		if spawnedVfx and spawnedVfx.lifeSpan <= 0 then
			spawnedVfx.lifeSpan = 1.5
		end
	end)
end


function OnDestroyed(obj)
	--print("OnDestroyed()")
	CleanupProjectileListener()
end
ROOT.destroyEvent:Connect(OnDestroyed)


-- Damage / destructible


local id = DESTRUCTIBLE_MANAGER().Register(script)
ROOT:SetNetworkedCustomProperty("ObjectId", id)


function ApplyDamage(dmg, source, position, rotation)
	local amount = dmg.amount
	if (amount ~= 0) then
		local prevHealth = GetHealth()
		local newHealth = prevHealth - amount
		SetHealth(newHealth)
		
		local hitResult = dmg:GetHitResult()
		
		-- Determine best value for impact position
		local impactPosition
		
		if not position and hitResult and hitResult:GetImpactPosition() ~= Vector3.ZERO then
			impactPosition = hitResult:GetImpactPosition()
		
		elseif position then
			impactPosition = position
		else
			impactPosition = script:GetWorldPosition()
		end

		-- Determine best value for impact rotation
		local impactRotation = Rotation.New()
		if hitResult then
			impactRotation = hitResult:GetTransform():GetRotation()
		
		elseif rotation then
			impactRotation = rotation
		end
		
		-- Source position
		local sourcePosition = nil
		if Object.IsValid(source) then
			sourcePosition = source:GetWorldPosition()
		end
		
		-- Effects
		local spawnedVfx = nil
		
		if (newHealth <= 0 and DESTROY_FX) then
			SpawnAsset(DESTROY_FX, impactPosition, impactRotation)
			
		elseif DAMAGE_FX then
			SpawnAsset(DAMAGE_FX, impactPosition, impactRotation)
		end
		
		-- Events
		
		Events.Broadcast("ObjectDamaged", id, prevHealth, amount, impactPosition, impactRotation, source)
		Events.BroadcastToAllPlayers("ObjectDamaged", id, prevHealth, amount, impactPosition, impactRotation)

		if (newHealth <= 0) then
			Events.Broadcast("ObjectDestroyed", id)
			Events.BroadcastToAllPlayers("ObjectDestroyed", id)
			
			DropRewards(source)
		end

		--print(ROOT.name .. " Health = " .. newHealth)
	end
end

function GetHealth()
	return ROOT:GetCustomProperty("CurrentHealth")
end

function SetHealth(value)
	ROOT:SetNetworkedCustomProperty("CurrentHealth", value)
end


function DropRewards(killer)
	-- Give resources
	if REWARD_RESOURCE_TYPE 
	and Object.IsValid(killer) 
	and killer:IsA("Player") then
		killer:AddResource(REWARD_RESOURCE_TYPE, REWARD_RESOURCE_AMOUNT)
	end
	--
	if hasQuest then
	   killer:AddResource(questTable[QuestID][RES_NAME], 1)
	
	end
	-- Drop loot
	if LOOT_DROP_FACTORY() then
		local pos = script:GetWorldPosition()
		LOOT_DROP_FACTORY().Drop(LOOT_ID, pos)
	end
end


�

cs:ModuleManager�
���憐��1
&
cs:DestructibleManager�����Ã��

cs:Root� 

cs:DamageToPlayersX

cs:DamageToNPCse  �@

cs:ProjectileBody� 

cs:MuzzleFlash� 

cs:ImpactSurface� 

cs:ImpactCharacter� 

cs:ProjectileLifeSpane  �@

cs:ProjectileSpeede  zE

cs:ProjectileGravitye    

cs:ProjectileHomingP

cs:HomingDrage  �@

cs:HomingAcceleratione `jF

cs:hasQuestP 


cs:QuestIDX 

cs:QUESTDATA���������
n
cs:Root:tooltipj[A reference to the root of the template, where most of the NPC's custom properties are set.
�
cs:DestructibleManager:tooltipjaThe Destructible Manager is a required script that provides interaction between NPCs and weapons.
H
cs:DamageToPlayers:tooltipj*How much damage this NPC deals to players.
H
cs:DamageToNPCs:tooltipj-How much damage this NPC deals to other NPCs.
�
cs:ProjectileBody:tooltipj�Visual template used for the body of the projectile that is shot when this NPC attacks. The projectile is spawned with rotation and direction matching those of the NPCAttackServer script object, which is why the orientation of this script within the template hierarchy is important.
�
cs:MuzzleFlash:tooltipj�Visual effect to spawn at the "weapon muzzle", this can also be a sword swipe effect or sometimes just a sound. It is positioned and rotated to where the NPCAttackServer is located, which is why the orientation of this script within the template hierarchy is important.
�
cs:ImpactSurface:tooltipjzVisual effect to spawn at the point of impact of the projectile, in case a non-character object is impacted (e.g. a wall).
�
cs:ImpactCharacter:tooltipjeVisual effect to spawn at the point of impact of the projectile, in case a Player or NPC is impacted.
�
cs:ProjectileLifeSpan:tooltipjiHow many seconds the projectile will fly in the air and be destroyed in case it does not impact anything.
]
cs:ProjectileSpeed:tooltipj?The initial speed of the projectile, in centimeters per second.
�
cs:ProjectileGravity:tooltipj�The scale of gravity to be used for the projectile. A value of 1 represents Earth gravity. Can be greater than 1. If zero it goes in a straight line (assuming 'homing' is disabled). If negative the projectile will move upwards over time.
�
cs:ProjectileHoming:tooltipj�The homing property causes the projectile to accelerate towards its target. HomingDrag and HomingAcceleration are important companion properties for homing to work correctly, otherwise the projectile might orbit around the target.
I
cs:HomingDrag:tooltipj0"Air drag" to be used in case homing is enabled.
g
cs:HomingAcceleration:tooltipjFAcceleration towards the target, to be used in case homing is enabled.
^��������Bricks Cobblestone Floor 01R2
MaterialAssetRefmi_brick_cobblestone_floor_001
Tˡ�������Fantasy Axe Blade 01R/
StaticMeshAssetRefsm_weap_fan_blade_axe_001
Y���݂���Fantasy Hammer Guard 01R2
StaticMeshAssetRefsm_weap_fan_guard_hammer_001
Q�Я�����Fantasy Axe Base 01R.
StaticMeshAssetRefsm_weap_fan_base_axe_001
NȽ�������Fantasy Pommel 02R,
StaticMeshAssetRefsm_weap_fan_pommel_002
Q��˷����Fantasy Axe Grip 01R.
StaticMeshAssetRefsm_weap_fan_grip_axe_001
;��棿����Metal ChromeR
MaterialAssetRef
chrome_001
N�����Diamond - 8-SidedR,
StaticMeshAssetRefsm_diamond_8_sided_001
\�Ƕ򝆺�"Fantasy Castle Wall 03 HalfR1
StaticMeshAssetRefsm_ts_fan_cas_wall_half_003
I������,Custom Floor from Fantasy Castle Floor 01 4m�����ۛ�! 
I����ۛ�!Castle FloorR-
MaterialAssetRefmi_ts_fan_cas_floor_01_uv
�+�����-Fantasy Castle Wall 01 - Door Double Templateb�+
�* ��ț����*���ț����-Fantasy Castle Wall 01 - Door Double Template"  �?  �?  �?(�҈�绺�K2���������������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*����������#Fantasy Castle Wall 01 - Doorway 02"
    �?  �?  �?(��ț����z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�������s088�
 *�������Double Door - Castle")
  \C  �8  B����  �?  �?  �?(��ț����2&ƃˢ�ʱ��æ�ℊ���ẛ����p���ů�վ�Z�

cs:AutoOpenP

cs:TimeOpene  @@

cs:OpenLabelj	Open Door

cs:CloseLabelj
Close Door

cs:Speede  �C

cs:ResetOnRoundStartP
`
cs:AutoOpen:tooltipjIThis door will open when a player gets close, and cannot be interact with
V
cs:TimeOpen:tooltipj?With AutoOpen, how long the day stays open with no player near.
E
cs:OpenLabel:tooltipj-Use label to open the door (without AutoOpen)
G
cs:CloseLabel:tooltipj.Use label to close the door (without AutoOpen)
J
cs:Speed:tooltipj6How fast the door opens or closes, in degrees / second
Q
cs:ResetOnRoundStart:tooltipj1Will reset (to be closed) at the start of a roundz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�ƃˢ�ʱ�ServerContext"
    �?  �?  �?(������2�����Ƣ�������������������Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*������Ƣ��DoubleDoorControllerServer"
    �?  �?  �?(ƃˢ�ʱ�Z�

cs:ComponentRoot�
������

cs:RotationRoot1�
�ẛ����p
"
cs:RotatingTrigger1�
���Ӱ���*
 
cs:RotationRoot2����ů�վ�
#
cs:RotatingTrigger2����ۖ�۽�
!
cs:StaticTrigger1����������
 
cs:StaticTrigger2�
��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

���ï�ٞO*����������StaticTrigger1"

  �B  C   �?ff�?  @@(ƃˢ�ʱ�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*���������StaticTrigger2"$

  �C  C�.�6  �?ff�?  @@(ƃˢ�ʱ�Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*��æ�ℊ��ClientContext"
  /C   �?  �?  �?(������2/�؂��׷�>������Ο��Ձ������������S����ט���Z z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent� *��؂��׷�>DoubleDoorControllerClient"
    �?  �?  �?(�æ�ℊ��Z�

cs:RotationRoot�
�ẛ����p

cs:OpenSound1�������Ο�

cs:CloseSound1�
�Ձ�����

cs:OpenSound2�
�������S

cs:CloseSound2�����ט���z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�

�ς����*�������Ο�Helper_DoorOpenSound"
  ��   �?  �?  �?(�æ�ℊ��Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��Ձ�����Helper_DoorCloseSound"
  ��   �?  �?  �?(�æ�ℊ��ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��������SHelper_DoorOpenSound"$

  �C  ���.�  �?  �?  �?(�æ�ℊ��Zc
.
bp:Door Type�
mc:esfx_domestic_doors_01:4
1
bp:Creak Type�
mc:esfx_door_wood_creaks_01:2z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*�����ט���Helper_DoorCloseSound"$

  �C  ���.�  �?  �?  �?(�æ�ℊ��ZH
.
bp:Door Type�
mc:esfx_domestic_doors_01:7

bp:Creak Volumee    z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�%

����㹩�5  �?=  aEE  �CXx�*��ẛ����pRotationRoot1"
    �?  �?  �?(������2�����������Ӱ���*Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���������Geo_StaticContext"
    �?  �?  �?(�ẛ����p2
����̓쎲Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����̓쎲Fantasy Castle Door 02"
 ���B  �?  �?  �?(��������z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
盁֞����088�
 *����Ӱ���*RotatingTrigger1"

  �B  C   �?ff�?  @@(�ẛ����pZ pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:box*����ů�վ�RotationRoot2"
  �C   �?  �?  �?(������2��Ԣ�����ۖ�۽�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*���Ԣ��Geo_StaticContext"
   4C  �?  �?  �?(���ů�վ�2
����٬���Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�*�����٬���Fantasy Castle Door 02"$

  �,�������B  �?  �?  �?(��Ԣ��z(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�
盁֞����088�
 *����ۖ�۽�RotatingTrigger2"$

  ��  C��3�  �?ff�?  @@(���ů�վ�Z pz(
&mc:ecollisionsetting:inheritfromparent�)
'mc:evisibilitysetting:inheritfromparent�"08*
mc:etriggershape:boxA
TemplateAssetRef-Fantasy_Castle_Wall_01_-_Door_Double_Template
��������	Automatic Fire Trapbf
V ���㊉��*I���㊉��TemplateBundleDummy"
    �?  �?  �?�Z
鶽Ъ����
NoneNone��
 0d5dea08546d400a88f4f2e20ed9dbb2 c7306b5515514d95bd7ff6fb2be11343Iscender"1.0.0*RI modified the original fire trap by LanaLux toswitch after a given period of time