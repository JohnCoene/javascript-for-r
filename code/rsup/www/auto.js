var progress;

$(document).on('shiny:busy', function(event){
  progress = new RsupProgress();
  progress.start();
});

$(document).on('shiny:idle', function(event){
  progress.end();
});