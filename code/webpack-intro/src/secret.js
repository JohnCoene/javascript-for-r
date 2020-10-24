var Shiny = require('shiny')
var Mousetrap = require('mousetrap');

Mousetrap.bind('s e c r e t', function() { 
  Shiny.setInputValue('secret', true);
});

