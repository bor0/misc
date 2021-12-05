-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- useful for debugging
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function walk(p1, p2)
  t = {}
  x1, y1, x2, y2 = p1.x, p1.y, p2.x, p2.y
  if x1 == x2 then
    if y2 < y1 then x1, y1, x2, y2 = x2, y2, x1, y1 end
    while y1 <= y2 do
      table.insert(t, {x = x1, y = y1})
      y1 = y1 + 1
    end
  elseif y1 == y2 then
    if x2 < x1 then x1, y1, x2, y2 = x2, y2, x1, y1 end
    while x1 <= x2 do
      table.insert(t, {x = x1, y = y1})
      x1 = x1 + 1
    end
  elseif math.abs(x1 - x2) == math.abs(y1 - y2) then
    if x1 < x2 then dx = 1 else dx = -1 end
    if y1 < y2 then dy = 1 else dy = -1 end

    while not(x1 == x2 and y1 == y2) do
      table.insert(t, {x = x1, y = y1})
      x1 = x1 + dx
      y1 = y1 + dy
    end
    table.insert(t, {x = x1, y = y1})
  end

  return t
end

-- tests the functions above
local file = 'input'
local lines = lines_from(file)

points = {}
for k, v in pairs(lines) do
   x1, y1, x2, y2 = string.match(v, "(%d+),(%d+) .> (%d+),(%d+)")
   if x1 == x2 or y1 == y2 or math.abs(x1 - x2) == math.abs(y1 - y2) then
     p1 = {x = tonumber(x1), y = tonumber(y1)}
     p2 = {x = tonumber(x2), y = tonumber(y2)}
     table.insert(points, {from = p1, to = p2})
   end
end

processed={}

for _, p in ipairs(points) do
  new_points = walk(p.from, p.to)
  for _, pp in ipairs(new_points) do
    pp = dump(pp)
    if processed[pp] ~= nil then
      processed[pp] = processed[pp] + 1
    else
      processed[pp] = 1
    end
  end
end

count = 0
for _, p in pairs(processed) do
  if p ~= 1 then count = count + 1 end
end

print(count)
