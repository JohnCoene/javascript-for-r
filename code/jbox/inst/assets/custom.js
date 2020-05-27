// custom.js
Shiny.addCustomMessageHandler(type = 'send-alert', function(message) {
  message.notice.onClose = function(){
    console.log("close");
    Shiny.setInputValue(message.id + '_alert_close', true);
  }
  new jBox('Notice', message.notice);
});