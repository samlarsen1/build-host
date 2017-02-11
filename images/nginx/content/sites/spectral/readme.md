## Pre-requisites
Node (for developing the app, not required to run it) and Docker for running the app.

* Node (v4.2.6) - https://nodejs.org/en/download/
* Docker (version 1.11.2) -
    * For Linux - https://docs.docker.com/engine/installation/linux/
    * For Windows - https://docs.docker.com/docker-for-windows/
    * For Mac - https://docs.docker.com/docker-for-mac/

To check whether you have the aformentioned software, run these commands;
```
node --version
docker --version
```

To install node, it is recommended that you use nvm so that switching between different versions is easy. To install nvm, run the following command:
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
```

You can then install a specific version of node as follows:
```
nvm install v4.7.0
```

In order to build and run the docker container, you will need to be able to run docker without sudo. This can be achieved with the following commands (add your username in place of ${USER}):
```
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart
```
You will then need to log out and log back in for this change to apply.

## Installation
Note: Run the following commands from a command window opened at the universal-web-viewer project root directory.
```
npm install
git-hooks/git-hooks-setup
```

### Launching the web app (dev build)
```
npm run docker-build-and-run
```
 Runs a dev-build version of the app code (non minified code with source maps) in a docker image. By default the image uses dev.conf and runs on host port 80, you can navigate to the app via http://localhost:80

### Launching the web app (release build)
```
npm start  
```
Runs a release-build version of the app code in a docker image. By default the image uses dev.conf and runs on host port 80.

If running npm start or npm run docker-build-and-run prints errors related to the gulp task and the dist folder,
this issue is fixed by assigning full file permissions to the dist folder;
```
chmod 777 dist
chmod 777 dist/css
chmod 777 dist/js
```

### UWV Web app data end points
The UWV app performs REST calls (for map data etc) to several end points e.g. http://wms.locationcentre.co.uk (for map tile images) and a GeoServer docker container. The NGINX config files in the nginx-config folder define the URLs used by the app for REST data end points (see proxy_pass URLs). The app uses development config (dev.conf) by default and no configuration/set up is required by the developer, just build your app code (e.g. npm start) and go, REST end points/NGINX proxy_pass URLs are defined/set up - the dev config accesses a GeoServer docker container running on a shared development server http://10.23.14.227:8080/geoserver/ (you don't need to do anything). If necessary, you can pull and build a local GeoServer docker container and update NGINX dev.conf to proxy calls to your local GeoServer URL (GeoServer GIT repo and info here - https://gitlab.ros.gov.uk/mapping/geoserver).


### Running unit tests and tasks
Unit tests and tasks have been configured to run through npm commands.
These commands can be run from a command window opened anywhere inside the universal-web-viewer project.

| Command                         |   Description           |
| :------------------------------ | :---------------------- |
| npm start                       |   Runs a release-build version of the app code in a docker image. By default the image uses dev.conf and runs on host port 80. Different config and host port can be passed to the script as parameters<br> ```npm start <configFilename.conf> <hostPortNumber>```<br>e.g. npm start prod-dev.conf 8088<br>If you want to run in docker during development with expanded js/css code, use npm run docker-build-and-run instead of npm start. |
| npm test                        |   Executes jasmine unit tests   |
| npm run docker-build-and-run | Runs a dev-build version of the app code in a docker image. By default nginx uses dev.conf (from nginx-config folder) and the docker container runs on port 80. Different config and host port can be passed to the script as parameters<br> ```npm run docker-build-and-run <configFilename.conf> <hostPortNumber>```<br>e.g. npm run docker-build-and-run prod-dev.conf 8088 |
| npm run generate-css-expanded   |   Runs gulp task to compiles sass files and generate css file(s) containing expanded css  |
| npm run generate-css-minified   |   Runs gulp task to compiles sass files and generates css file(s) containing minified css (used by deployed site) |
| npm run webpack-dev | Runs gulp task to transpiles our es6 source javascript code to expanded es5 code  |
| npm run webpack-prod  | Runs gulp task to transpiles our es6 source javascript code to minified es5 code  |
| npm run clean-dist-files | Runs gulp task to remove dist files (deletes the dist folder) - this task is called internally by other tasks e.g. dev-build and release-build |
| npm run dev-build | Runs gulp tasks to remove dist files, compile sass to expanded css and webpack transpile es6 code to expanded es5 code  |
| npm run release-build | Runs gulp tasks to remove dist files, compile sass to minified css and webpack transpile es6 code to minified es5 code  |
| npm run dev-watch | Starts a gulp watch task to watch project sass and src js files - re compiles sass to expanded css when sass files are saved, re-compiles es6 to expanded es5 (webpack-dev task) when src es6 files are saved<br>Type Ctrl + C in command window to stop the watch task |
| npm run eslint                  |   Lints our javascript es6 source files and reports any code quality or code style issues   |
| npm run eslint-auto-fix         |   Lints our javascript es6 source files and attempts to automatically fix any code quality or code style issues |
| npm run coverage                |  Runs code coverage on our es6 files. The report is generated in coverage/lcov-report/ |


## UWV app Acceptance/Browser tests
The acceptance/integration tests for this project are in a seperate GIT repo and can be found here;
https://gitlab.ros.gov.uk/mapping/universal-web-viewer-bdd


## Configuring your code editor
This project uses an EditorConfig file to maintain consistent coding styles (whitespace etc) between different editors.
Some editors (e.g. IntelliJ) will automatically read this file, other editors (e.g. atom & sublime) require a plugin.
You can check if your editor supports EditorConfig, and download a plugin if necessary via this url;
```
http://editorconfig.org/#download
```
If you are using the atom editor, please install the editorconfig and eslint packages
```
apm install editorconfig
apm install linter-eslint
```

## Project structure

| Folder/file name  |   Description                                         |
| :-----------------| :---------------------------------------------------- |
| ansilbe-scripts   | scripts used for ansible tasks |
| ansible-scripts-dev-hosts | Contains ip address of local docker target vm. Used when testing ansible scripts against local redhat/centos vm |
| ansible-scripts/sandbox-hosts | Contains environment specific global vars (web app port number on vm, config file, registry address etc) |
| ansible-scripts/docker.yml | Ansible playbook file which installs docker on target vm. Will not reinstall if docker already exists |
| ansible-scripts/uwv-web-app.yml | Ansible playbook file which pushes image to remote registry in prod network and deploys and runs docker image |
| ansible-scripts/roles | These roles are used by the playbook files |
| assets/           | Contains any images, svg files or icons used by the web app |
| dist/             | This folder contains the distributable application source files (js and css).<br><br>The contents of this folder are automatically generated by webpack and gulp tasks<br><br>**Heads up** Do not manually add or edit files within this folder.|
| git-hooks/       | Contains a bash script to setup the git hooks and the node scripts run by the pre-commit and pre-push git hooks |
| git-hooks/copy-on-install | Contains the git hook pre-commit and pre-push files to be copied into the .git/hooks folder. |
| gulp-tasks/       | Contains a file for each individual gulp task. These tasks are imported into the main gulpfile.js |
| nginx-config/     | Environment specific nginx config files that can be applied to the running web app docker container |
| src/scss/         | Contains the sass (.scss) files that define the universal viewer css (except CSS used to style components, component css is defined in sass files that are in the component's folder alongside the components tag and js files).<br><br>These scss files are compiled (via a gulp task that uses the node lib-sass package) to produce the CSS files used by the app. CSS files are generated (via gulp task) by running npm run generate-css-expanded or npm run generate-css-minified.<br><br>The generated CSS files will be output to the dist/css directory. |
| src/components| Contains a folder for each UI component - component folders typically contain (a) an es6 class that contains all js code for a component (this class contains vanilla javascript and has no framework/library dependency), (2) a .tag file - this file contains the html template for a component defined as a custom tag. The tag file also contains a small script block that instantaites the components es6 class (the .tag file is a feature from the Riot js library), (3) A sass file for the component defining any css utilised by the component. |
| src/enums | Enumerations e.g. search-types.json |
| src/providers | Provider classes are responsible for managing ajax requests to back end REST services |
| src/events | Contains code related to app events (app events are used for pub/sub communication between components (via an event bus/dispatcher) |
| src/events/events.json | JSON file defining all app component events as constant key/value pairs |
| src/events/dispatcher.js | es6 class that makes any class that imports it an observable - the dispatcher is essentially the UWV apps event bus |
| tests/    | Contains our unit test spec files.<br><br>The folder structure inside this tests folder should match the folder structure inside the src folder. |
| vendor/           | This folder is for any external third party javascript or css files e.g. fetch-polyfill.js.<br><br>There should be no ROS authored code/files in this folder.<br><br> If you are adding a library to this folder, adding the minified version only should be sufficient.<br><br>This folder will be distributed with the web app code (copied into the jar file).<br><br>The vendor files in this folder should be served (included in page) seperately and not be bundled together with the applications source code e.g. don't include any vendor files in webpack bundles. |
| .babelrc          | babel configuration file |
| build-and-run-docker-image.sh | bash script to bring the app up in a docker container. By default the container will be running on port 80 and be configured to use the dev.conf nginx config file. To specify a different config file and port - bash build-and-run-docker-image.sh <configFileName> <hostPortNumber> e.g. <br> bash build-and-run-docker-image.sh prod-dev.conf 8088
| .editorconfig | Editor configuration settings e.g. use 4 spaces for a tab, use UTF-8 encoding etc |
| .eslintignore | Config file defining folders/files that eslint rules should not be applied to |
| .eslintrc | eslint config file defining the javascript linting rules to be applied to our source code.<br>EsLint reference - http://eslint.org/docs/user-guide/configuring |
| gulp-config.js | Config settings used by gulp tasks. |
| gulpfile.js | Main gulp file (tasks from gulp-tasks folder are imported into this file) |
| index.html | Universal web viewer app main entry page |
| jasmine.json | jasmine config file, defines the location of the javascript unit test spec files |
| nginx-config-reload.sh | This file is copied into the docker image and executed inside the running image (via docker exec) to set the nginx environment config we want the web app to use. |
| package.json | Defines npm scripts that can be run against this project (e.g. npm scripts to run unit tests, generate css etc). Lists all the node modules used by (installed in) this project |
| webpack-dev.config | webpack bundler configuration for local dev builds<br> webpack config reference - https://webpack.github.io/docs/configuration.html |
| webpack-prod.config | webpack bundler configuration settings for release build |


### Example src folder structure
Where applicable, files should be organised by component, with each component folder containing all component files (typically a component.js, component.tag and component.scss/css file) e.g.
```
src/
 |-- app.js
 |-- components/
        | -- map/
            | -- map.js
            | -- map.tag
            | -- _map.scss

        | -- deeds-viewer/
            | -- deeds-viewer.js
            | -- deeds-viewer.tag
            | -- _deeds-viewer.scss
|
| -- providers/
        | -- wps/
        | -- wfs/
|
| -- events/
```

### Naming convention for files and folders

File and folder names should be written in lower case with hyphen separators.

For javascript classes, name the file the same as the class but convert to lower
case dash-case
```
e.g. The file for class PostcodeSearch would be named postcode-search.js
```
If classes are models or services, include 'model' or 'service' in their file and class names
```
e.g. class PostcodeSearchModel file name postcode-search-model.js
```
**Test spec file names** should match the name of the file it is testing and end with ".spec.js"
```
Source file name:  map.js
Tests file name:  map.spec.js
```

### Naming convention for CSS selectors
CSS selector names should be lowercase and hyphen seperated e.g.
```
.my-class-name {}
```

### Spec file code structure
Spec files should be structured with a top level describe block for the class
that is under test, and then describe blocks for each method.
```
describe("ClassName", ()=> {

    describe("methodName", function() {
        it("should...", ()=> {});
        it("should...", ()=> {});
    });

    describe("anotherMethodName", function() {
        it("should...", ()=>) {});
    });
}
```

## GIT Workflow
Please see link below for the GIT workflow used at ROS.
http://netconfluence1.core.rosdev.org.uk/pages/viewpage.action?pageId=15958020


## Jenkins ci pipeline
Our jenkins build pipeline can be found here.

http://dev-ops.core.rosdev.org.uk/jenkins/job/universal-web-viewer/view/UWV%20Pipeline/

There are six stages to our pipeline so far
1) Assemble

     a) runs unit tests using node and if successful creates a docker image

     b) deploys the UWV to dev server http://em-vud-jnsa03/

     This will be rebuilt and deployed whenever there is a new build of the respective RC* branch.  The build and deploys are also part of our pipleline (but will not block the pipeline if they fail)

     c) copies docker image to the sandpit host in the prod network.
2) Sandpit Test

    a) deploys the UWV docker image

    b) runs our BDDs. The tests are run from our dev jekins slave, using selenium grid which targets the app running on the sandpit host.

    c) if the BDDs are successful the UWV image is published to the proddev docker registry
3) Prodev deploy (manual step)

    a) deploys the UWV docker image in the prod-dev environment. Access on prod network via URL 
    http://pdev1.maps.ros.local

4) Prodev test

    a) runs BDDs

5) promote-to-uat deploy (manual step)

    a) publishe to the uat docker registry

6) UAT Deploy

    a) deploys to UAT

### Jenkins deploy feature branches

There is now a job for building and deploying a UWV branch to dev

http://dev-ops.core.rosdev.org.uk/jenkins/job/universal-web-viewer/job/Build_UWV_Feature/

In the menu on the left, click "Build with parameters"

Enter your git branch name and press build

Build_Deploy_UWV_Feature job takes GIT_BRANCH as a parameter and will build and deploy this branch to our dev server
(after the pipeline has completed the "sandbox-test" step, your feature branch will be deployed to/viewable on our dev server).

The story number will be used to define which port the container runs on.

eg

MAP-1924 would produce a UWV container running on http://em-vud-jnsa03:1924
MAP-2011 would produce a UWV container running on http://em-vud-jnsa03:2011

note the initial value of '1' prefixed to the port number. This will increase as wecreate more release branches (RC2, RC3 etc)

We can also build RC* branches

RC1 would produce a UWV container running on http://em-vud-jnsa03:8081
RC2 would produce a UWV container running on http://em-vud-jnsa03:8082
RC3 would produce a UWV container running on http://em-vud-jnsa03:8083

So theoretically we can have a couple of feature branches of UWV running, the latest RC* (RC2) build and an older RC* build (RC1)

And so on, it will do for the moment but will need some adjustment once we hit RC10 etc

The default build of UWV (dev.conf) will point to this geoserver instance from now on. It you're running geoserver locally just change build-and-run-docker-image.sh to load the 'local.conf' file instead of dev.conf and it will point to localhost.

### GeoServer Pipeline

This UWV web app references a development GeoServer running as a docker container (the URL of the dev GeoServer is in the dev.conf file).

Sometimes this dev GeoServer needs re-deployed (e.g. updated data), or it can need re-started. To re-deploy the development GeoServer, go to this page on Jenkins;

http://dev-ops.core.rosdev.org.uk/jenkins/job/Geoserver/view/Geoserver%20Pipeline/

Login and in the "assemble" box click on the small icon to the right of "Deploy Geoserver on dev" label.

### Openlayers Map Config

Most config is stored in
```
src/components/map/config.json
```
Min/Max Resolution

Because of the inexact floating point nature of the maxResolution value when we put restrictions on maxResolution we need to use a value that is slightly higher than the actual maxResolution for the layer

| Scale  |   Resolution                                         | Open Layers  zoom level | Product      |
| :-----------------| :---------------------------------------------------- | ------ | ----- |
|3779520|1000|0|Overview|
|1889760|	500|	1	|Overview|
|755904	|200	|2	|Miniscale|
|377952	|100	|3	|Miniscale|
|188976	|50	|4	|250k|
|94488	|25	|5	|250k|
|37795.2|	10|	6	|50k|
|18897.6|	5	|7	|50k|
|9448.8	|2.5	|8	|25k|
|4799.99|	1.27|	9	|Vector Map Local|
|1889.76|	0.5	|10	|MasterMap|
|755.9	|0.2	|11	|MasterMap|


As long as it is NOT more than the next resolution size this will ensure the correct resolution is displayed.

For example:

resolution according to zoom level = 1.27

maxResolution = 2  (this is below the next zoom level max resolution of 2.5 and slightly above 1.27)

## Project Documentation and Reference

* Creating components - ./src/components/ReadMe.md
* UWV app Architecture notes - ./docs/architecture-notes.md
* Reference resources for the technologies used in this project - ./docs/reference.md