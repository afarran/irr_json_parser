local json = loadfile('json.lua\\json.lua')()

local inputJsonFile = arg[1] -- "IRR_EXAMPLE.json"
if not inputJsonFile then
  print("Usage:\n >lua.exe irr_json_parser.lua <JSON source file name>")
  return
end

local outputCsvFile = inputJsonFile:lower():gsub(".json", ".csv")
print("Reading from ", inputJsonFile)
local fileHandle, err = io.open(inputJsonFile, "r")
if fileHandle then
  local jsonText = fileHandle:read("*a"):gsub("%c", "") --remove control characters
  fileHandle:close()
  local jsonTable = json.decode(jsonText)
  print("Writing to ", outputCsvFile)
  fileHandle = io.open(outputCsvFile, "w")
  if fileHandle then
    local totalRecords = 0
    local totalAdverstisedArinNonAuthOnlyRecords = 0
    local str = "IsAdvertisedAndArinNonAuthOnly,Index,rir,bgpOrigins,prefix,prefixSortKey,goodnessOverall,routeSource,asn,rpslPk,rpkiStatus,rpkiMaxLength,routeSource,asn,rpslPk,rpkiStatus,rpkiMaxLength,routeSource,asn,rpslPk,rpkiStatus,rpkiMaxLength"
    fileHandle:write(str.."\n")
    for idx, val in ipairs(jsonTable) do
      totalRecords = totalRecords + 1
      str = string.format("%s,%s,%s,%s,%s,%s", idx, val.rir or "", val.bgpOrigins[1] or "", val.prefix or "", val.prefixSortKey or "", val.goodnessOverall or "")
      local isArinNonAuthOnly
      for key, routeVal in pairs(val.irrRoutes) do
        if val.bgpOrigins[1] and key ~= "ARIN-NONAUTH" then
          isArinNonAuthOnly = false
        elseif val.bgpOrigins[1] and isArinNonAuthOnly == nil and key == "ARIN-NONAUTH" then
          isArinNonAuthOnly = true
          totalAdverstisedArinNonAuthOnlyRecords = totalAdverstisedArinNonAuthOnlyRecords + 1
        end
        local routeTable = routeVal[1]
        str = str..string.format(",%s,%s,%s,%s,%s", key, routeTable.asn, routeTable.rpslPk, routeTable.rpkiStatus, routeTable.rpkiMaxLength or "")
      end
      fileHandle:write(tostring(isArinNonAuthOnly)..","..str.."\n")
    end
    fileHandle:close()
    print(string.format("Found %d total records in %s. %d are advertised ARIN-NONAUTH routes. Output is stored in %s.", totalRecords, inputJsonFile, totalAdverstisedArinNonAuthOnlyRecords, outputCsvFile))
  else
    print("File writing error: ", err)
  end
else
  print("File reading error: ", err)
end