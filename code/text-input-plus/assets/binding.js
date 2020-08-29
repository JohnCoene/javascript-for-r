var textPlusBinding = new Shiny.InputBinding();

$.extend(textPlusBinding, {
  find: function(scope) {
    return $(scope).find(".text-plus");
  },
  getValue: function(el) {
    $(el).val();
  },
  setValue: function(el, value) {
    $(el).val(value);
  },
  subscribe: function (el, callback) {
    $(el).on("input.text-plus keyup.text-plus", function (e) {
        callback(true);
    });
    $(el).on("change.text-plus", function (e) {
        callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".text-plus");
  },
  receiveMessage: function(el, data){
    if (data.hasOwnProperty('value')) this.setValue(el, data.value); 
  },
});

Shiny.inputBindings.register(textPlusBinding);