// Function: contains()
// Description: recursively searches a list for a target value. returns true if the value is
//   found, false otherwise.
// Arguments:
//   target = the value to search for in the list
//   values = the list of values to search within
//   i = the current index being checked. used internally for recursion and should not be passed
//     by the caller. default is 0.
function contains(target, values, i = 0) =
    i >= len(values) ? false :
    values[i] == target ? true :
    contains(target, values, i + 1);
