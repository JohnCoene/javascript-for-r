const canvas = document.getElementById("canvas");
const context = canvas.getContext("2d");
var video = document.getElementById('webcam');

var model = null;

const modelParams = {
  flipHorizontal: true,   // flip e.g for video  
  maxNumBoxes: 1,        // maximum number of boxes to detect
  scoreThreshold: 0.7,    // confidence threshold for predictions.
}

handTrack.load(modelParams).then(real_model => {

  // override model
  model = real_model;

  handTrack.startVideo(video).then(function (status) {
    
    if(status){
      runDetection();
    }
    
  });
});

function runDetection() {
  model.detect(video).then(predictions => {
      Shiny.setInputValue('predictions', predictions);
      requestAnimationFrame(runDetection);
  });
}

