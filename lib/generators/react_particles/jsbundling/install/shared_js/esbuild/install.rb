say "Install esbuild"
run "yarn add esbuild"
say "Add build script"

# build_script = "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds" # default
build_script = "esbuild --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js" # custom


if (`npx -v`.to_f < 7.1 rescue "Missing")
  say %(Add "scripts": { "build": "#{build_script}" } to your package.json), :green
else
  run %(npm set-script build "#{build_script}")
  run %(yarn build)
end
