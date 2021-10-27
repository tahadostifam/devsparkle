"use strict";

process.env.NODE_ENV = process.env.NODE_ENV || 'production';

var environment = require('./environment');

module.exports = environment.toWebpackConfig();