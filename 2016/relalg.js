'use strict';
var underscore = require('underscore');

var RelAlg = function (attributes, rows) {
    function convertToCanonical(attributes, rows) {
        return underscore.map(rows, function (row) {
            return underscore.reduce(row, function (memo, value, index) {
                memo[attributes[index]] = value;
                return memo;
            }, {});
        });
    }

    // Canonical form (needs more space, faster execution)
    this.data = convertToCanonical(attributes, rows);
};

underscore.extend(RelAlg.prototype, {
    toString: function () {
        return JSON.stringify(this.data);
    },
    dataToAttributes: function () {
        return underscore.keys(underscore.first(this.data));
    },
    dataToRows: function () {
        return underscore.map(this.data, underscore.values);
    },
    project: function (attributes) {
        this.data = underscore.map(this.data, function (row) {
            return underscore.reduce(attributes, function (memo, value) {
                if (underscore.has(row, value)) {
                    memo[value] = row[value];
                }
                return memo;
            }, {});
        });

        return this;
    },
    select: function (filter) {
        this.data = underscore.filter(this.data, filter);

        return this;
    },
    rename: function (oldattr, newattr) {
        this.data = underscore.map(this.data, function (row) {
            return underscore.reduce(row, function (memo, value, index) {
                memo[index === oldattr ? newattr : index] = value;
                return memo;
            }, {});
        });

        return this;
    },
    union: function (algebra) {
        if (!(algebra instanceof RelAlg)) {
            return this;
        }

        var data = algebra.data;

        if (underscore.isEqual(underscore.keys(underscore.first(data)), underscore.keys(underscore.first(this.data)))) {
            underscore.each(data, function (item) {
                if (underscore.every(this.data, function (item2) {
                        return !underscore.isEqual(item, item2);
                    })) {
                    this.data.push(item);
                }
            }, this);
        }

        return this;
    },
    difference: function (algebra) {
        if (!(algebra instanceof RelAlg)) {
            return this;
        }

        var data = algebra.data;

        if (underscore.isEqual(underscore.keys(underscore.first(data)), underscore.keys(underscore.first(this.data)))) {
            this.data = underscore.filter(this.data, function (item) {
                return underscore.every(data, function (item2) {
                    return !underscore.isEqual(item, item2);
                });
            });
        }

        return this;
    },
    crossjoin: function (algebra) {
        if (!(algebra instanceof RelAlg)) {
            return this;
        }

        var newdata = [];

        underscore.each(this.data, function (row) {
            underscore.each(algebra.data, function (row2) {
                newdata.push(underscore.extend({}, row2, row));
            });
        });

        this.data = newdata;

        return this;
    },
});

module.exports.RelAlg = RelAlg;
