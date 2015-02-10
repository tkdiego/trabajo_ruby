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

function check_create_game() {
    opponent_ok= false;
    index_t=0;
    index_o=0;
    for (i = 0; i < document.formu.opponent.length; i++) {
        if (document.formu.opponent[i].checked) {
            index_o=i;
            opponent_ok = true;
        }
    }
    table_ok = false;
    for (x = 0; x < document.formu.table.length; x++) {
        if (document.formu.table[x].checked) {
            index_t=x;
            table_ok = true;
        }
    }
    if (opponent_ok && table_ok) {
        return true;
    } else {
        alert("No se ha realizado la seleccion de manera correcta.");
        return false;
    }
}
