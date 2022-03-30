var express = require('express');
var router = express.Router();
const authMiddleware = require('../helpers/auth-middleware');
const AuthService = require('../services/auth-service');
const config = require('../config')


router.get('/login', loginPage);
router.get('/register', registerPage);
router.post('/register', register);
router.post('/login', login);
router.get('/logout', authMiddleware, logout);

function loginPage (req, res, next) {
  res.render('pages/login',
   {error: undefined,
    message: "test"});
}

function registerPage (req, res, next) {
  res.render('pages/register',
   {error: undefined,
    message: "test"});
}

async function login (req, res, next) {
  try {
    await AuthService.authenticate(req)
    res.redirect('/')
  } catch(err) {
    console.log(err)
    res.render('auth/login', {error: JSON.parse(err.response.body).error.message})
  }
}

async function register (req, res, next) {
  try {
    console.log(req.body)
    await AuthService.register(req)
  } catch(err) {
    console.log(err)
    res.render('auth/login', {error: JSON.parse(err.response.body).error.message})
  }
}

function logout (req, res, next) {
  req.session.destroy(function (err) {
    if (!err) {
      res.redirect('/');
    }
  })
}

module.exports = router;
