
var height = prompt('Enter height in cm');

if (height) {
    var weight = prompt('Enter weight in kg');

    if (weight) {
        alert('BMI type is ' + getTypeByBMI(calcBMI(height, weight)));
    }
}

function calcBMI(height, weight) {
    return (10000 * weight / (height * height)).toFixed(2);
}

function getTypeByBMI(bmi) {
    var intervals = [
        {l: -Infinity, h: 18.5, t: 'Underweight'},
        {l: 18.5, h: 25, t: 'Normal weight'},
        {l: 25, h: 30, t: 'Overweight'},
        {l: 30, h: Infinity, t: 'Obesity'},
    ];

    for (var i in intervals) {
        if (intervals[i].l <= bmi
            && bmi < intervals[i].h) {
            return intervals[i].t;
        }
    }
}
