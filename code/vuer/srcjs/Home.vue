<template>
  <div>
    <b-form-input 
      v-model="inputText" 
      placeholder="Enter your name" 
      @keyup.enter="processText">
    </b-form-input>
    <b-button 
      @click="processText" 
      variant="outline-primary">
      Button
    </b-button>
    <h2>Your name is {{ text }}</h2>
  </div>
</template>

<script>
module.exports = {
  data: function() {
    return {
      text: '',
      inputText: ''
    };
  },
  methods: {
    processText: function(){
      this.text = this.inputText // set text var
      Shiny.setInputValue('text', this.text);
      this.inputText = '' // remove input once entered
    }
  }
};
</script>