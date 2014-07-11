fs = require("fs")
gulp = require("gulp")
glob = require("glob")
iconv = require("iconv-lite")

# Comments or unannotated kaomoji
IgnoredRowRegex = /^(ｊ|ｋ|!|かおすて)/

gulp.task "(ﾟзﾟ)ｲｲﾝﾃﾞﾈｰﾉ?", (callback) ->
  faces = []
  for filePath in glob.sync("src/*.txt")
    data = iconv.decode(fs.readFileSync(filePath), "shift_jis")
    for row in data.split("\n")
      continue  if row.match(IgnoredRowRegex)
      rowParts = row.split(/\s+/)
      faces.push({
        annotation: rowParts[0]
        face: rowParts[1]
      })
  facesJSON = JSON.stringify(faces, undefined, 2)
  fs.writeFileSync("kao-shiftjis.json", iconv.encode(facesJSON, "shift_jis"))
  fs.writeFileSync("kao-utf8.json", iconv.encode(facesJSON, "utf8"))
  callback()

gulp.task("default", ["(ﾟзﾟ)ｲｲﾝﾃﾞﾈｰﾉ?"])
