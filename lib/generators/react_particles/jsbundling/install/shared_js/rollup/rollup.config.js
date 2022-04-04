import resolve from "@rollup/plugin-node-resolve"

export default {
  // input: "app/javascript/application.js", // default
  input: `app/javascript/${namespace}/application.js`, // custom
  output: {
    // file: "app/assets/builds/application.js", // default
    file: "app/assets/javascripts/react_particles/application.js", // custom
    format: "es",
    inlineDynamicImports: true,
    sourcemap: true
  },
  plugins: [
    resolve()
  ]
}
