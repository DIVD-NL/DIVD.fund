var loadJS = function(url, implementationCode, location){
    //url is URL of external file, implementationCode is the code
    //to be called from the file, location is the location to 
    //insert the <script> element

    var scriptTag = document.createElement('script');
    scriptTag.src = url;

    scriptTag.onload = implementationCode;
    scriptTag.onreadystatechange = implementationCode;

    location.appendChild(scriptTag);
};
var yourCodeToBeCalled = function(){
//your code goes here
}
script_url = window.location.protocol + "//" + window.location.hostname + ":35729/livereload.js"
host = window.location.hostname
window.LiveReloadOptions = { "host" : host }
console.log(script_url)
loadJS(script_url, yourCodeToBeCalled, document.body);
