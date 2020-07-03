HTMLWidgets.widget({

  name: 'plotly',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var plot;

    return {

      renderValue: function(x) {

        plot = document.getElementById(el.id);
        Plotly.newPlot(el.id, x.options);

        plot.on('plotly_click', function(data){
          var coords = [data.points[0].x, data.points[0].y];
          Shiny.setInputValue(el.id + '_clicked', coords);
        });

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
        Plotly.relayout(el.id, {width: width, height: height});

      }

    };
  }
});

if(HTMLWidgets.shinyMode){

  Shiny.addCustomMessageHandler(type = 'add-traces', function(msg){
    Plotly.addTraces(msg.id, msg.data);
  })

}