// Initialize the Image Classifier method with MobileNet
const classifier = ml5.imageClassifier('MobileNet', modelLoaded);
// When the model is loaded
function modelLoaded() {
  console.log('Model Loaded!');
}

Shiny.addCustomMessageHandler('classify', function(data){
  // Make a prediction with a selected image
  classifier.classify(document.getElementById("bird"), (err, results) => {
    Shiny.setInputValue("classification:class", results);
  });
});