// custom.js
Shiny.addCustomMessageHandler(type = 'send-alert', function(message) {
  message.notice.onClose = function(){
    console.log("close");
    Shiny.setInputValue(message.id + '_alert_close', true, {priority: 'event'});
  }
  new jBox('Notice', message.notice);
});