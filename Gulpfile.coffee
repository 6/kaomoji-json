fs = require("fs")
gulp = require("gulp")
glob = require("glob")
iconv = require("iconv-lite")

# Comments or unannotated kaomoji
IgnoredRowRegex = /^(ｂ|ｊ|ｋ|!|・|かおすて|.+＠|.+・)/

gulp.task "(ﾟзﾟ)ｲｲﾝﾃﾞﾈｰﾉ?", (callback) ->
  faces = []
  face_unique_keys = []
  for filePath in glob.sync("src/*.txt")
    data = iconv.decode(fs.readFileSync(filePath), "shift_jis")
    for row in data.split("\n")
      continue  if row.match(IgnoredRowRegex)
      rowParts = row.split(/\s+/)
      rowParts.pop() # Pop off "顔文字" or "顔文字*"
      annotation = rowParts.shift()
      face = rowParts.join("")
      face_unique_key = "#{annotation}#{face}"
      continue  if face_unique_key in face_unique_keys
      face_unique_keys.push(face_unique_key)
      faces.push({
        annotation: annotation
        face: face
      })
  console.log("Found #{faces.length} unique 顔文字")
  facesJSON = JSON.stringify(faces, undefined, 2)
  fs.writeFileSync("kao-shiftjis.json", iconv.encode(facesJSON, "shift_jis"))
  fs.writeFileSync("kao-utf8.json", iconv.encode(facesJSON, "utf8"))
  callback()

gulp.task("default", ["(ﾟзﾟ)ｲｲﾝﾃﾞﾈｰﾉ?"])
