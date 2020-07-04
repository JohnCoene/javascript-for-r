// script.js
$(document).on('shiny:busy', function(event) {
  var gif = document.getElementById("loading");
  gif.style.visibility = "visible";
});

$(document).on('shiny:idle', function(event) {
  var gif = document.getElementById("loading");
  gif.style.visibility = "hidden";
});