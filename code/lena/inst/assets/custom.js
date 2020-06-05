var lenaBinding = new Shiny.OutputBinding();

$.extend(lenaBinding, {
  find: function(scope) {
    return $(scope).find(".lena");
  },
  getId: function(el){
    return el.id;
  },
  renderValue: function(el, data) {

    $(document).ready(function(){
      // Get the image
      var originalImage = document.getElementById(data.img_id);
      // The canvas where the processed image will be rendered (With filter)
      var filteredImageCanvas = document.getElementById(el.id);

      // Filter to apply, in this case the red filter
      var filter = LenaJS[data.filter];

      // Apply the filter
      LenaJS.filterImage(filteredImageCanvas, filter, originalImage);
    });
  
  }
});

Shiny.outputBindings.register(lenaBinding, "john.lenaBinding");