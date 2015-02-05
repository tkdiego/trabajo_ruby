function select_ship(obj) {
    total = parseInt(document.getElementById("left_ships").value);
    if (obj.checked) {
        total -= 1;
    } else {
        total += 1;
    }
    document.getElementById("left_ships").value = total;
}

function check_ships_selected() {
    if (parseInt(document.getElementById("left_ships").value) !== 0) {
        alert("Coloque la cantidad correcta de barcos");
        return false;
    } else {
        return true;
    }

}

function set_attack(coordinate) {
    if (parseInt(document.getElementById("first_attack").value) === 0) {
        document.getElementById("attack").value = coordinate;
        document.getElementById("first_attack").value = 1;
    } else {
        document.getElementById("first_attack").value = 2;
    }
}

function control_attack() {
    if (parseInt(document.getElementById("first_attack").value) === 2) {
        alert("Ya ha realizado el ataque");
        return false;
    }
    return true;
}

