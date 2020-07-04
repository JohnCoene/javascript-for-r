const progress = new RsupProgress();

Shiny.addCustomMessageHandler('rsup-options', function(msg){
  progress.setOptions(msg);
});

Shiny.addCustomMessageHandler('rsup-start', function(msg){
  progress.start();
});

Shiny.addCustomMessageHandler('rsup-end', function(msg){
  progress.end();
});
