var canvas = document.getElementById('c1');
var ctx = canvas.getContext('2d');

var mainColors = ['red', 'blue', 'green', 'gray'];

ctx.beginPath();
ctx.moveTo(10, 50);
ctx.lineTo(1110, 50);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(10, 100);
ctx.lineTo(1110, 100);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(10, 150);
ctx.lineTo(1110, 150);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(50, 0);
ctx.lineTo(50, 200);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(1050, 0);
ctx.lineTo(1050, 200);
ctx.stroke();

for (var i = 0; i < mainColors.length; i++) {
    ctx.fillStyle = mainColors[i];
    ctx.fillRect(10, 10 + 50 * i, 30, 30);
}

var deceleration = 6;
var speed = [50, 60, 55, 75];
var vitality = [70, 60, 65, 45];

canvas.onclick = function startRace() {

    var pos = [20, 20, 20, 20];
    var t = setInterval(drawHorses, 100);
    var step = 1;

    for(var i = 0; i < mainColors.length; i++) {
        ctx.clearRect(10, 10 + 50 * i, 30, 30);
        ctx.fillStyle = mainColors[i];
        ctx.fillRect(pos[i], 10 + 50 * i, 30, 30)
    }

    function drawHorses() {
        for (var i = 0; i < pos.length; i++) {
            if (pos[i] < 1020) {
                ctx.clearRect(pos[i] - 5, 10 + 50 * i, 30, 30);
                if (Math.random() * 100 > vitality[i] && step % 5 == 0) {
                    speed[i] = speed[i] * (100 - deceleration) / 100;
                }
                pos[i] = pos[i] + 0.1 * speed[i];
                ctx.fillStyle = mainColors[i];
                ctx.fillRect(pos[i], 10 + 50 * i, 30, 30);
                step++;
            } else {
                clearInterval(t);
                alert('Horse ' + (i + 1) + ' win!');
                break;
            }
        }
    }
}
