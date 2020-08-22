var boxxyBinding = new Shiny.OutputBinding();

$.extend(boxxyBinding, {
  find: function(scope) {
    return $(scope).find(".boxxy");
  },
  renderValue: function(el, data) {

    el.style.backgroundColor = data.color;

    var counter = new CountUp(el.id + '-boxxy-value', 0, data.value);
    counter.start();
    document.getElementById(el.id + '-boxxy-title').innerText = data.title
  }
});

Shiny.outputBindings.register(boxxyBinding, "john.boxxy");