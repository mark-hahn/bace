#!/usr/bin/env node

var bacePath =  __dirname.split('/').slice(0,-1).join('/');
process.chdir(bacePath);
console.log('>>> starting bace', process.cwd());
require('bace');
