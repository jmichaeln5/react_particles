puts "Add build script"
build_script = "rollup -c rollup.config.js"

if (`npx -v`.to_f < 7.1 rescue "Missing")
  puts %(Add "scripts": { "build": "#{build_script}" } to your package.json), :green
else
  system %(npm set-script build "#{build_script}")
  system %(yarn build)
end
