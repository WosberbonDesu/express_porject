const express = require('express')
const app = express()
const port = 3040
var bodyParser = require('body-parser');
const cors = require("cors");
var corsOptions = {
    origin: "http://localhost:3041"
};

app.set('view engine', 'ejs')
require('./database-connection')

app.use(cors(corsOptions));
// parse requests of content-type - application/json

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

