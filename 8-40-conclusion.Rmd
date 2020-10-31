# (PART) Closing Remarks {-}

# Conclusion {#conclusion}

The book covered a few topics and introduced many concepts probably new to many; these are sometimes difficult to fully understand at first and will likely require some more exploring. So here, we wrap up with some heartening thoughts to encourage the reader to persevere as much of what was covered in the book requires practice to be fully comprehended.

## Performances {#conclusion-performances}

As mentioned in the opening of this book some of the code presented is not entirely optimal as we need to make use of R as much as possible to limit any confusion caused by the fresh-to-the-eyes JavaScript code. In places, this involves making use of R where it is in fact not needed, namely within shiny applications where data is sent from the front end to R, only to be sent back to JavaScript again. For instance, when the click of a button triggers something in the shiny UI but uses the server as an intermediary, oftentimes it is not necessary to involve the server.

This, though has little impact on performances in most cases, can be improved upon by not involving R in the process, handling everything in the front-end with JavaScript but this was judged outside the scope of the book as it focuses on interactions between the two languages. Nonetheless, somewhat interestingly, the book covered all the code necessary to do so, only not in the same section or chapter. It might therefore take some practice to make the connection.

```js
// toggle an input at the click of a button
$('#button').on('click', function(){
  $('#input').toggle();
});
```

Note, however, that placing much of the business logic server-side rather than on the front-end might create more secure applications since said logic remains internal and cannot be interfered with.

## Trial & Error {#conclusion-trial-and-error}

We hope the book demonstrated how well JavaScript works with R as well as how much of difference it has the potential to have on your data science projects. Making JavaScript work _for R_ is fascinating because they are so far removed from one another; while one excels at data wrangling and statistics, the other runs in the browser and focuses on aesthetics and functionalities of web pages. 

However, being so different, JavaScript introduces numerous concepts likely to be new to many R developers. The only way one can truly grasp how it all works, and become at ease with using custom JavaScript code in shiny applications and packages is to practice. Repeated trial and error is fundamental to approaching new programming languages and notions. 

Some small exercises were scattered at the end of significant parts of the book; you are encouraged to attempt some of them. Like interactive visualisations? Try to build one for a straightforward library!

## Functionality & UX {#conclusion-ux}

A lot of JavaScript in the browser is about designing user experiences and better functionalities for users of your data product---never overlook those. 

We don't say of a chart with good aesthetics that's just a pretty plot; a great chart does a better job of communicating insights, and the same is true of many other data products, including web applications. Hopefully, the learnings contained in this book will help you create much more engaging and compelling products thanks to JavaScript.

Sadly, in the fields where R is popular, things like aesthetics, or great user experience are perceived as superfluous. You might be told that "the only thing that matters is the analysis or the model," anything else is often seen as make-up to cover up flawed science. This could not be further from the truth. First, put to rest the false dichotomy that it's either a great front-end or a great back-end; both can (and must) be done. Second, while it could be said that spending two hours looking for a fun colour palette for a chart is "a waste of time." However, spending the same amount of time developing a new JavaScript Functionality to allow users to interrogate your model better or visualise (and therefore understand) the outcome of an analysis is not. Also, if your visualisations and web applications are engaging, users will gladly spend more time clicking away, filtering results, and use your product.
