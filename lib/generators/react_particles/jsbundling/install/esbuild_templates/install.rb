puts "Install esbuild"
system "yarn add esbuild"

puts "Add build script"

# build_script = "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds"   # OG

build_script = "esbuild --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js"  # BG


if (`npx -v`.to_f < 7.1 rescue "Missing")
  puts %(Add "scripts": { "build": "#{build_script}" } to your package.json), :green
else
  system %(npm set-script build "#{build_script}")
  system %(yarn build)
end
