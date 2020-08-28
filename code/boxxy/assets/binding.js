var boxxyBinding = new Shiny.OutputBinding();

$.extend(boxxyBinding, {
  find: function(scope) {
    return $(scope).find(".boxxy");
  },
  renderValue: function(el, data) {

    el.style.backgroundColor = data.color;

    if(data.animate){
      Shiny.renderDependencies(data.deps);
      var counter = new CountUp(el.id + '-boxxy-value', 0, data.value);
      counter.start();
    } else {
      document.getElementById(el.id + '-boxxy-value').innerText = data.value;
    }

    document.getElementById(el.id + '-boxxy-title').innerText = data.title;
  }
});

Shiny.outputBindings.register(boxxyBinding, "john.boxxy");