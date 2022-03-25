# react_particles *** WIP ***
A barebones React application built with encapsulation in mind.

react_particles automates the installation of React using yarn, generates an encapsulated skeleton for your React application under the namespace of your choosing, then bundles your React application's JavaScript to your copy of the gems asset pipeline using esbuild, seperate from the asset pipeline of the application it is installed in.

react_particles_manifest.js is referenced in the file app/views/layouts/react_application/application.html.erb generated upon installation.

## Usage
How to use my plugin.

## Installation
You must already have node and yarn installed on your system. You will also need npx version 7.1.0 or later. Then:

Add this line to your application's Gemfile:

```ruby
gem "react_particles"
```

Feel free to fork or clone the repo then reference copy in your application's Gemfile:
```ruby
gem "react_particles", path: "/Users/your_name_here/Desktop/don_frye/another_possible_directory/code/react_particles"
```

And then execute the following in the root of your application:
```bash
$ bundle
```

```bash
$ rails generate react_particles:install
```
Or
```bash
$ rails generate react_particles:install --namespace=name_of_my_react_app
```

This will generate/modify the necessary files/directories including a new directory where your React application will live.
## Displaying Updates
When changes are made to your JavaScript files you must re-build and precompile your assets + bounce your server to see any of your changes.

To re-build change directories into the home of your new React app's directory...
```bash
$ cd app/javascript/react_application 
```
Or 
```bash
$ cd app/javascript/name_of_my_react_app 
```

Then run:
```bash
$ yarn build 
```
```bash
$ rake assets:precompile
```
Finally
```bash
$ rails s
```

Feel free to speed up this process using an alias to maximize your productivity:
```bash
$ alias react-particles-start='yarn run build && rake assets:precompile && rails s'
```
Add the alias above to ~./bash____ or ~/zsh_____ then source your profile for reuse.

## Confirm seperation of assests
After building, precompiling assets, and starting server lets open the browser to make sure we're recieving the correct JS assets and confirm your JavaScript is properly seperated.

Navigate to the default route of your barebones React application http://localhost:3000/components/index 

Open the developer tools of your browser and click the network tab

Then select JS to view what JS was provided by the response to your request. 

Go back to your root path (http://localhost:3000) and compare the JS provided from the previous response and we're gravy 😎


Feel free to edit/add your own namespaced controllers, views, and routes.

-Adding generators in the future for ease of use.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
