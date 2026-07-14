function contains(target, values, i = 0) =
    i >= len(values) ? false :
    values[i] == target ? true :
    contains(target, values, i + 1);
