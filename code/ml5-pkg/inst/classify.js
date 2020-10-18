// Initialize the Image Classifier method with MobileNet
const classifier = ml5.imageClassifier('MobileNet', modelLoaded);
// When the model is loaded
function modelLoaded() {
  console.log('Model Loaded!');
}

Shiny.addCustomMessageHandler('ml5-classify', function(data){
  // Make a prediction with a selected image
  classifier.classify(document.getElementById(data), (err, results) => {
    Shiny.setInputValue(data + "_classification:ml5.class", results);
  });
});
