const express = require('express');
const router = express.Router();
const AuthService = require('../services/auth-service');
const { verifySignUp } = require("../helpers");
const Exceptions = require('../exceptions/exceptions');

router.get('/login', loginPage);
router.get('/register', registerPage);
router.post('/register', register);
router.post('/login', login);
router.get('/logout', logout);

function loginPage (req, res) {
  try {
    res.render('pages/login',
        {
          error: undefined,
          message: "test"
        });
  } catch(err) {
    console.log(err)
    res.status(400).send(err)
  }
}

function registerPage (req, res) {
  try {
    res.render('pages/register',
        {
          error: undefined,
          message: "Welcome!"
        });
  } catch(err) {
    console.log(err)
    res.status(400).send(err)
  }
}

async function login (req, res) {
  try {
    await AuthService.authenticate(req, res)
  } catch(err) {
    console.log(err)
    throw Exceptions.failedLogin
  }
}

async function register (req, res) {
  try {
   verifySignUp.checkDuplicateUsernameOrEmail(req, res)

  } catch(err) {
    console.log(err)
    throw Exceptions.failedRegisteration
  }
}

function logout (req, res) {
  req.session.destroy(function (err) {
    if (!err) {
      res.redirect('/');
    }
  })
}

module.exports = router;
