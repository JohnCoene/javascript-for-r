var lenaBinding = new Shiny.OutputBinding();

$.extend(lenaBinding, {
  find: function(scope) {
    return $(scope).find(".boxxy");
  },
  getId: function(el){
    return el.id;
  },
  renderValue: function(el, data) {

    el.style.backgroundColor = data.color;

    var counter = new CountUp(el.id + '-boxxy-counter', 0, data.value);
    counter.start();
    document.getElementById(el.id + '-boxxy-title').innerText = data.title
  }
});

Shiny.outputBindings.register(lenaBinding, "john.boxxy");