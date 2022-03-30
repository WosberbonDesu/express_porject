const express = require('express')
const app = express()
const port = 3040
var bodyParser = require('body-parser');

app.set('view engine', 'ejs')
require('./database-connection')

app.use(bodyParser.json({limit: '6mb'}));
app.use(bodyParser.urlencoded({extended: true}));

app.get('/', (req, res) => {
    res.render('pages/index')
})
app.listen(port, () => {
    console.log(`App listening at port ${port}`)
})

const authController = require('./controllers/auth');

app.use('/auth', authController);

