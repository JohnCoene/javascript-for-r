var mprogress;

Shiny.addCustomMessageHandler('mprogress-init', function(msg){
  mprogress = new Mprogress(msg);
})

Shiny.addCustomMessageHandler('mprogress-start', function(msg){
  mprogress.start();
})

Shiny.addCustomMessageHandler('mprogress-end', function(msg){
  mprogress.end();
})
