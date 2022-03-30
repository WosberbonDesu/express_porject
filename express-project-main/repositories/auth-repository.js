const AuthUserModel = require('../models/authUser');
const UserModel = require('../models/user');
const mongoose = require('mongoose');

async function authenticate(username, password) {
    return await AuthUserModel.find({username: username, password: password});
}

async function register(username, password, email) {
    const ObjectId = mongoose.Types.ObjectId();
    const userObject = {
        _id: ObjectId,
        id: ObjectId.toString(),
        username: username,
        password: password,
        email: email,
        recordTime: {
            createdAt: Date.now(),
            updatedAt: Date.now()
        }
    };
    return await UserModel.create(userObject);
}

module.exports = {
    authenticate,
    register
};