var switchInput = new Shiny.InputBinding();

// $(document).on("click", "input.switchInput", function() {
//   $(this).prop("checked", this.checked);
// })

$.extend(switchInput, {
  find: function(scope) {
    return $(scope).find(".switchInput");
  },
  getValue: function(el) {
    return $(el).prop("checked");
  },
  setValue: function(el, value) {
    $(el).prop("checked", value).change();
  },
  receiveMessage: function(el, value){
    this.setValue(el, value);
  },
  subscribe: function (el, callback) {
    $(el).on("change.switchInput", function(){
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".switchInput");
  },
  getRatePolicy: function(){
    return {
      policy: 'throttle',
      delay: 1000
    }
  }
});

Shiny.inputBindings.register(switchInput, 'john.switch');

