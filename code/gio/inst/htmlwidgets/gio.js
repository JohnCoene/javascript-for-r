HTMLWidgets.widget({

  name: 'gio',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var controller;
    var rendered = false;

    return {

      renderValue: function(x) {

        var container = document.getElementById(el.id);
        controller = new GIO.Controller(container);
        
        // add data
        controller.addData(x.data);

        controller.setStyle(x.style);

        // callback
        controller.onCountryPicked( callback );

        function callback (selectedCountry, relatedCountries) {
          Shiny.setInputValue(el.id + '_selected', selectedCountry);
          Shiny.setInputValue(el.id + '_related:gio.related.countries', relatedCountries);
        }

        // render
        if(!rendered)
          controller.init();

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
        controller.resizeUpdate()

      }

    };
  }
});