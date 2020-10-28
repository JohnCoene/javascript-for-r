import { CountUp } from 'countup.js';

function counter(id, value){
  var countUp = new CountUp(id, value);
  countUp.start();
}

export { counter };
