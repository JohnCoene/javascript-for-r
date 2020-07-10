function getCookies(){
  let res = Cookies.get();
  Shiny.setInputValue('cookies', res);
}

Shiny.addCustomMessageHandler('cookie-set', function(msg){
  Cookies.set(msg.name, msg.value);
  getCookies();
})

Shiny.addCustomMessageHandler('cookie-remove', function(msg){
  Cookies.remove(msg.name);
  getCookies();
})

$(document).on('shiny:connected', function(ev){
  getCookies();
})

