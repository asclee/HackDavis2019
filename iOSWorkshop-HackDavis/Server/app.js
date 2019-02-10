const express = require('express')
const app = express()

app.get('/mansplain', (req, res) => {
  console.log('hello world');
  var text = req.query.text;
  if (text.includes('actually')) {
    var result = {"isMansplaining":true};
    console.log(result);
    res.send(result.stringify);
  } else {
    var result = {"isMansplaining":false};
    console.log(result);
    res.send(result.stringify);
  }
  
});

app.get('/test', (req, res) => { console.log("hello test"); res.send("hello test"); })

app.listen(3000, () => console.log('Example app listening on port 3000!'))