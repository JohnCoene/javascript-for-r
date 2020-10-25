import Shiny from 'shiny'
import { secret } from './secret.js';
import 'mousetrap';

Mousetrap.bind(secret, function() { 
  Shiny.setInputValue('secret', true);
});

