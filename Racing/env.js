var canvas = document.getElementById('c1');
var ctx = canvas.getContext('2d');

var mainColors = ['red', 'blue', 'green', 'gray'];

var deceleration = 7;
var speed = [50, 70, 80, 60];
var vitality = [80, 60, 50, 70];
var pos = [20, 20, 20, 20];

function refresh() {  
    
    ctx.clearRect(0, 0, 1200, 200);

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

    speed = [50, 70, 80, 60];
    pos = [20, 20, 20, 20];
}

function startRace() {
    for(var i = 0; i < mainColors.length; i++) {
        ctx.clearRect(10, 10 + 50 * i, 30, 30);
        ctx.fillStyle = mainColors[i];
        ctx.fillRect(pos[i], 10 + 50 * i, 30, 30)
    }
    
    var bet = prompt('Which horse you bet?', 'red');
    var t = setInterval(drawHorses, 100);

    function drawHorses() {
        for (var i = 0; i < pos.length; i++) {
            if (pos[i] < 1020) {
                ctx.clearRect(pos[i] - 5, 10 + 50 * i, 30, 30);
                if (Math.random() * 100 > vitality[i] && Math.ceil(Math.random() * 100) % 5  == 0) {
                    speed[i] = speed[i] * (100 - deceleration) / 100;
                }
                pos[i] = pos[i] + 0.1 * speed[i];
                ctx.fillStyle = mainColors[i];
                ctx.fillRect(pos[i], 10 + 50 * i, 30, 30);
            } else {
                clearInterval(t);
                if (mainColors[i] == bet) {
                    alert('You WIN! The ' + mainColors[i] + ' horse is first!');
                    refresh();
                    var p = document.createElement("p");
                    var node = document.createTextNode(mainColors[i] + '    (WIN)');
                    p.appendChild(node);
                    var div = document.getElementById("log");
                    div.appendChild(p);
                } else {
                    alert('You LOSE! The ' + mainColors[i] + ' horse is first.');
                    refresh();
                    var p = document.createElement("p");
                    var node = document.createTextNode(mainColors[i] + '    (lose)');
                    p.appendChild(node);
                    var div = document.getElementById("log");
                    div.appendChild(p);
                }
                break;
            }
        }
    }
}
refresh();
