var exec = require('cordova/exec');

exports.generateReport = function (arg0, success, error) {
    exec(success, error, 'MyReport', 'generateReport', [arg0]);
};
