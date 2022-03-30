const express = require('express')
const router = express.Router()

router.all('*', function (req, res, next) {
  if (!req.session.auth) {
    req.session.auth = {};
  }

  if(req.session.auth.token) {
    return next();
  } else {
    res.redirect('/auth');
  }
})

module.exports = router