HTMLWidgets.widget({

  name: 'gio',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var container = document.getElementById(el.id);
        var controller = new GIO.Controller(container);
        
        // add data
        controller.addData(x.data);

        controller.setStyle(x.style);

        // callback
        controller.onCountryPicked( callback );

        function callback (selectedCountry, relatedCountries) {
          Shiny.setInputValue(el.id + '_selected', selectedCountry.ISOCode);
        }

        // render
        controller.init();

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});