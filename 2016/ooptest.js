function extend(a, b) {
    for (var key in b) {
        if (b.hasOwnProperty(key)) {
            a[key] = b[key];
        }
    }

    return a;
}

var baseClass = function() {
    var thisIsPrivate;
    var thisIsPublic = 123;

    this.thisIsPublic = thisIsPublic;
    this.className = 'baseClass';

    console.log("baseClass constructor called")

    this.getPriv = function() {
        return thisIsPrivate;
    }

    this.setPriv = function(p) {
        return thisIsPrivate = p;
    }
}

var inheritClass = function() {
    this.inheritsFrom = baseClass;
    this.inheritsFrom(baseClass);

    console.log("inheritClass constructor called")

    this.className = 'inheritClass';
    this.test = 123;
}

baseClass.prototype.test = function() {
    console.log("prototype.test called from " + this.className);
}

var extendClass = {
    moo: function() {
        console.log("moo");
    }
}

var x = new baseClass();
extend(x, extendClass);
x.moo();
x.setPriv(123);
console.log(x.getPriv());
console.log(x.thisIsPrivate);
x.test();

console.log(x);

var y = new inheritClass();
// y.test(); // prototype is not defined for inheritClass
console.log(y);
