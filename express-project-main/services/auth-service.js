const AuthRepository = require('../repositories/auth-repository');
const Exceptions = require('../exceptions/exceptions');

async function authenticate(req) {
    const username = req.body.username
    const password = req.body.password
    const response = await AuthRepository.authenticate(username, password);

    if (response) return response;

    throw Exceptions.forbidden;
}

async function register(req) {
    console.log(req.body)
    const username = req.body.username
    const email = req.body.email
    const password = req.body.password
    const response = await AuthRepository.register(username, password, email);

    if (response) return response;

    throw Exceptions.failedRegisteration;
}

module.exports = {
    authenticate,
    register
}