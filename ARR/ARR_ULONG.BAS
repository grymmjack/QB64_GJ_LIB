'$DYNAMIC

''
' Slice an array from source to destination starting at index and count slices
'
' @param ULONG() source_arr~{SY} to slice from
' @param ULONG() dest_arr~{SY} to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_ULONG.slice(source_arr~{SY}(), dest_arr~{SY}(), start_idx%, count%)
    DIM AS LONG ub, lb, i, n
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED LONG
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr~{SY}(n&) = source_arr~{SY}(i&)
            n& = n& + 1
        NEXT i&
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr~{SY}(n&) = source_arr~{SY}(i&)
            n& = n& + 1
        NEXT i&
    END IF
END SUB


''
' Push a ulong onto the end of a _UNSIGNED LONG array
' @param _UNSIGNED LONG arr~{SY}() array to push into
' @param _UNSIGNED LONG value~{SY} of byte to push
'
SUB ARR_ULONG.push(arr~{SY}(), value~{SY})
    DIM AS LONG ub, lb
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED LONG
    arr~{SY}(ub& + 1) = value~{SY}
END SUB


''
' Pop a ulong from the end of a _UNSIGNED LONG array
' @param _UNSIGNED LONG arr~{SY}() array to pop from
' @param _UNSIGNED LONG var~{SY} of ulong to store popped ulong
'
SUB ARR_ULONG.pop(arr~{SY}(), var~{SY})
    DIM AS LONG ub, lb
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    var~{SY} = arr~{SY}(ub&)
    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED LONG
END SUB


''
' Pop a ulong from the beginning of a _UNSIGNED LONG array
' @param _UNSIGNED LONG arr~{SY}() array to pop from
' @param _UNSIGNED LONG var~{SY} of ulong to store popped ulong
'
SUB ARR_ULONG.shift(arr~{SY}(), var~{SY})
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    var~{SY} = arr~{SY}(lb&)
    FOR i& = lb& TO ub& - 1
        arr~{SY}(i&) = arr~{SY}(i& + 1) 
    NEXT i&
    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED LONG
END SUB


''
' Copy an array of ULONGs to another _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() source array to copy
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() dest array to copy into
'
SUB ARR_ULONG.copy(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG ub, lb, i
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        dest_arr~{SY}(i&) = source_arr~{SY}(i&)
    NEXT i&
END SUB


''
' Push a ulong into the beginning of a _UNSIGNED LONG array
' @param _UNSIGNED LONG arr~{SY}() array to push into
' @param _UNSIGNED LONG value~{SY} of ulong to push
'
SUB ARR_ULONG.unshift(arr~{SY}(), value~{SY})
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    DIM work(lb& TO ub&) AS _UNSIGNED LONG
    CALL ARR_ULONG.copy(arr~{SY}(), work~{SY}())
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED LONG
    FOR i& = lb& + 1 TO ub& + 1
        arr~{SY}(i&) = work~{SY}(i& - 1)
    NEXT i&
    arr~{SY}(lb&) = value~{SY}
END SUB


''
' Joins an array of ULONGs as a string
' @param _UNSIGNED LONG ARRAY arr~{SY}() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_ULONG.join(arr~{SY}(), s$)
    DIM AS LONG ub, lb, i
    s$ = ""
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    FOR i& = lb& TO ub&
        s$ = s$ + _TRIM$(STR$(arr~{SY}(i&))) + ", "
    NEXT i&
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
END SUB


''
' Create a new _UNSIGNED LONG array using string of ulongs seperated by commas
' @param _UNSIGNED LONG ARRAY arr~{SY}() to store the ulongs in
' @param STRING s$ string of comma separated ulongs
'
SUB ARR_ULONG.new(arr~{SY}(), s$)
    DIM AS LONG i, count
    DIM t AS STRING
    count& = 0
    FOR i& = 1 TO LEN(s$)
        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
    NEXT i&
    REDIM arr(0 TO count&) AS _UNSIGNED LONG
    IF count& = 0 THEN
        arr~{SY}(0) = VAL(s$)
        EXIT SUB
    END IF
    count& = 0
    FOR i& = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i&))
        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
            arr~{SY}(count&) = VAL(t$)
            count& = count& + 1
            t$ = ""
        END IF
    NEXT i&
END SUB


''
' Return the visually longest element of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @return _UNSIGNED LONG value of visually longest element
'
FUNCTION ARR_ULONG.longest~{SY}(arr~{SY}())
    DIM AS LONG lb, ub, i, res, lw
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    res& = 0 : lw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr~{SY}(i&)))) > lw& THEN
            lw&  = LEN(_TRIM$(STR$(arr~{SY}(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_ULONG.longest~{SY} = arr~{SY}(res&)
END FUNCTION


''
' Perform some math on every element of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() to do math on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() to store results in
' @param STRING op$ one of:
'                          and   or    xor   shl   shr 
' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
' @param _UNSIGNED LONG value~{SY} to use for operand
'
SUB ARR_ULONG.math(source_arr~{SY}(), dest_arr~{SY}(), op$, value~{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        SELECT CASE op$
            CASE "+":
                dest_arr~{SY}(i&) = source_arr~{SY}(i&) + value~{SY}
            CASE "-":
                dest_arr~{SY}(i&) = source_arr~{SY}(i&) - value~{SY}
            CASE "*":
                dest_arr~{SY}(i&) = source_arr~{SY}(i&) * value~{SY}
            CASE "\":
                IF value~{SY} > 0 THEN
                    dest_arr~{SY}(i&) = source_arr~{SY}(i&) \ value~{SY}
                END IF
            CASE "&&":
                dest_arr~{SY}(i&) = source_arr~{SY}(i&) AND value~{SY}
            CASE "||":
                dest_arr~{SY}(i&) = source_arr~{SY}(i&) OR value~{SY}
            CASE "!!":
                dest_arr~{SY}(i&) = source_arr~{SY}(i&) XOR value~{SY}
            CASE "<<":
                dest_arr~{SY}(i&) = _SHL(source_arr~{SY}(i&), value~{SY})
            CASE ">>":
                dest_arr~{SY}(i&) = _SHR(source_arr~{SY}(i&), value~{SY})
        END SELECT
    NEXT i&
END SUB


''
' Return the minimum element value in _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @return _UNSIGNED LONG minimum value found
'
FUNCTION ARR_ULONG.min~{SY}(arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM AS _UNSIGNED LONG s
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    s~{SY} = 127
    FOR i& = lb& TO ub&
        IF arr~{SY}(i&) < s~{SY} THEN
            s~{SY} = arr~{SY}(i&)
        END IF
    NEXT i&
    ARR_ULONG.min~{SY} = s~{SY}
END FUNCTION


''
' Return the maximum element value in _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @return _UNSIGNED LONG maximum value found
'
FUNCTION ARR_ULONG.max~{SY}(arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM AS _UNSIGNED LONG s
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    s~{SY} = 0
    FOR i& = lb& TO ub&
        IF arr~{SY}(i&) > s~{SY} THEN
            s~{SY} = arr~{SY}(i&)
        END IF
    NEXT i&
    ARR_ULONG.max~{SY} = s~{SY}
END FUNCTION


''
' Return the visually shortest element of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @return _UNSIGNED LONG value of visually shortest element
'
FUNCTION ARR_ULONG.shortest~{SY}(arr~{SY}())
    DIM AS LONG lb, ub, i, res, sw
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    res& = 0 : sw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr~{SY}(i&)))) < sw& THEN
            sw&  = LEN(_TRIM$(STR$(arr~{SY}(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_ULONG.shortest~{SY} = arr~{SY}(res&)
END FUNCTION


''
' Return the first element of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @return _UNSIGNED LONG value of first element
'
FUNCTION ARR_ULONG.first~{SY}(arr~{SY}())
    ARR_ULONG.first~{SY} = arr~{SY}(LBOUND(arr~{SY}))
END FUNCTION


''
' Return the last element of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @return _UNSIGNED LONG value of last element
'
FUNCTION ARR_ULONG.last~{SY}(arr~{SY}())
    ARR_ULONG.last~{SY} = arr~{SY}(UBOUND(arr~{SY}))
END FUNCTION


''
' Return every nth array element of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() to get from
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() to store in
' @param INTEGER nth% element
'
SUB ARR_ULONG.nth(source_arr~{SY}(), dest_arr~{SY}(), nth%)
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    n& = (ub& - lb&) \ nth%
    REDIM dest_arr(n&) AS _UNSIGNED LONG
    n& = 0
    FOR i& = lb& to ub&
        IF i& MOD nth% = 0 THEN
            dest_arr~{SY}(n&) = source_arr~{SY}(i&)
            n& = n& + 1
        END IF
    NEXT i&
END SUB


''
' Checks if value exists in _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @param _UNSIGNED LONG value~{SY} value to check for
' @return INTEGER -1 if found or 0 if not found
'
FUNCTION ARR_ULONG.in%(arr~{SY}(), value~{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    FOR i& = lb& TO ub&
        IF arr~{SY}(i&) = value~{SY} THEN
            ARR_ULONG.in% = -1
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_ULONG.in% = 0
END FUNCTION


''
' Checks if value exists in _UNSIGNED LONG array and returns index if found
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @param _UNSIGNED LONG value~{SY} value to check for
' @return INTEGER index of element if found or -1 if not found
'
FUNCTION ARR_ULONG.find%(arr~{SY}(), value~{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    FOR i& = lb& TO ub&
        IF arr~{SY}(i&) = value~{SY} THEN
            ARR_ULONG.find% = i&
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_ULONG.find% = -1
END FUNCTION


''
' Return the number of elements in a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to count
' @return INTEGER number of elements
'
FUNCTION ARR_ULONG.count&(arr~{SY}())
    ARR_ULONG.count& = UBOUND(arr~{SY}) - LBOUND(arr~{SY})
END FUNCTION


''
' Return the size of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() to get size of
' @return LONG size in bytes
'
FUNCTION ARR_ULONG.size&(arr~{SY}())
    ARR_ULONG.size& = LEN(arr~{SY}())
END FUNCTION


''
' Reverses the elements of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() to reverse
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() to store reversed array in
'
SUB ARR_ULONG.reverse(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED LONG
    n& = 0
    FOR i& = ub& TO lb& STEP -1
        dest_arr~{SY}(n&) = source_arr~{SY}(i&)
        n& = n& + 1
    NEXT i&
END SUB


''
' Returns a random ulong from a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() array to get random element from
' @return _UNSIGNED LONG random element
'
FUNCTION ARR_ULONG.random~{SY}(arr~{SY}())
    DIM AS LONG lb, ub
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    RANDOMIZE TIMER 
    ARR_ULONG.random~{SY} = arr~{SY}(INT(RND * (ub& - lb&)) + 1)
END FUNCTION


''
' Returns the sum of all elements in a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() array to get some for
' @return LONG sum of all elements
'
FUNCTION ARR_ULONG.sum&(arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    FOR i& = lb& TO ub&
        sum& = sum& + arr~{SY}(i&)
    NEXT i&
    ARR_ULONG.sum& = sum&
END FUNCTION


''
' Returns the average value of elements in a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY arr~{SY}() array to get average for
' @return LONG average of elements
'
FUNCTION ARR_ULONG.avg&(arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    FOR i& = lb& TO ub&
        sum& = sum& + arr~{SY}(i&)
    NEXT i&
    ARR_ULONG.avg& = sum& / (ub& - lb&)
END FUNCTION


''
' Shuffle the elements of a _UNSIGNED LONG array
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() to shuffle
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() to store shuffled array in
'
SUB ARR_ULONG.shuffle(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, i, count
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED LONG
    CALL ARR_ULONG.copy(source_arr~{SY}(), dest_arr~{SY}())
    RANDOMIZE TIMER 
    FOR i& = 0 TO count&
        SWAP dest_arr~{SY}(i&), dest_arr~{SY}(lb& + RND * (ub& - lb&)) 
    NEXT i&
END SUB


''
' Makes a _UNSIGNED LONG array contain only unique values
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to get uniques for
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store uniques in
'
SUB ARR_ULONG.unique(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF NOT ARR_ULONG.in%(work_arr~{SY}(), source_arr~{SY}(i&)) THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements greater than value
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
' @param _UNSIGNED LONG value~{SY} to be greater than to be returned
'
SUB ARR_ULONG.gt(source_arr~{SY}(), dest_arr~{SY}(), value~{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) > value~{SY} THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements greater than or equal to value
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
' @param _UNSIGNED LONG value~{SY} to be greater than or equal to be returned
'
SUB ARR_ULONG.gte(source_arr~{SY}(), dest_arr~{SY}(), value~{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) >= value~{SY} THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements less than value
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
' @param _UNSIGNED LONG value~{SY} to be less than to be returned
'
SUB ARR_ULONG.lt(source_arr~{SY}(), dest_arr~{SY}(), value~{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) < value~{SY} THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements less than or equal to value
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
' @param _UNSIGNED LONG value~{SY} to be less than or equal to be returned
'
SUB ARR_ULONG.lte(source_arr~{SY}(), dest_arr~{SY}(), value~{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) <= value~{SY} THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Finds and replaces values across all elements in a _UNSIGNED LONG ARRAY
' @param _UNSIGNED LONG ARRAY arr~{SY}() to check in
' @param _UNSIGNED LONG find~{SY} value to find
' @param _UNSIGNED LONG replace~{SY} value to replace with if found
'
SUB ARR_ULONG.replace(arr~{SY}(), find~{SY}, replace~{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    FOR i& = lb& TO ub&
        IF arr~{SY}(i&) = find~{SY} THEN
            arr~{SY}(i&) = replace~{SY}
        END IF
    NEXT i&
END SUB


''
' Inserts a new element into _UNSIGNED LONG array after index
' @param _UNSIGNED LONG ARRAY arr~{SY}() array to work on
' @param _UNSIGNED LONG value~{SY} to insert
' @param INTEGER index% of element to insert at
'
SUB ARR_ULONG.insert(arr~{SY}(), value~{SY}, index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    DIM work_arr(0) AS _UNSIGNED LONG
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index%
            CALL ARR_ULONG.push(work_arr~{SY}(), arr~{SY}(i&))
        NEXT i&
        ' insert new element
        CALL ARR_ULONG.push(work_arr~{SY}(), value~{SY})
        ' finish building array from index + 1
        FOR i& = index% + 1 TO ub&
            CALL ARR_ULONG.push(work_arr~{SY}(), arr~{SY}(i&))
        NEXT i&
        CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
        CALL ARR_ULONG.copy(work_arr~{SY}(), arr~{SY}())
    END IF
END SUB


''
' Removes element from a _UNSIGNED LONG array by element index
' @param _UNSIGNED LONG ARRAY arr~{SY}() array to work on
' @param INTEGER index% of element to remove
'
SUB ARR_ULONG.remove(arr~{SY}(), index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    DIM work_arr(0) AS _UNSIGNED LONG
    lb& = LBOUND(arr~{SY}) : ub& = UBOUND(arr~{SY})
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index% - 1
            CALL ARR_ULONG.push(work_arr~{SY}(), arr~{SY}(i&))
        NEXT i&
        ' skip elements
        FOR i& = index% + 1 TO ub&
            CALL ARR_ULONG.push(work_arr~{SY}(), arr~{SY}(i&))
        NEXT i&
        CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
        CALL ARR_ULONG.copy(work_arr~{SY}(), arr~{SY}())
    END IF
END SUB


''
' Filters a _UNSIGNED LONG array to only elements that have odd values
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
'
SUB ARR_ULONG.odd(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) MOD 2 <> 0 THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements that have even values
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
'
SUB ARR_ULONG.even(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) MOD 2 = 0 THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements that have values evenly divisible by divisor
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
' @param _UNSIGNED LONG divisor~{SY} for modulo
'
SUB ARR_ULONG.mod(source_arr~{SY}(), dest_arr~{SY}(), divisor~{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) MOD divisor~{SY} = 0 THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Filters a _UNSIGNED LONG array to only elements between min and max
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to work on
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store in
' @param _UNSIGNED LONG min~{SY} to be greater than or equal to be returned
' @param _UNSIGNED LONG max~{SY} to be less than or equal to be returned
'
SUB ARR_ULONG.between(source_arr~{SY}(), dest_arr~{SY}(), min~{SY}, max~{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED LONG
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    DIM work_arr(0) AS _UNSIGNED LONG
    FOR i& = lb& TO ub&
        IF source_arr~{SY}(i&) >= min~{SY} _
        AND source_arr~{SY}(i&) <= max~{SY} THEN
            CALL ARR_ULONG.push(work_arr~{SY}(), source_arr~{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_ULONG.shift(work_arr~{SY}(), tmp~{SY})
    CALL ARR_ULONG.copy(work_arr~{SY}(), dest_arr~{SY}())
END SUB


''
' Sorts _UNSIGNED LONG array in ascending order
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to sort
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store sorted in
'
SUB ARR_ULONG.sort(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED LONG
    CALL ARR_ULONG.copy(source_arr~{SY}(), dest_arr~{SY}())
    CALL ARR_ULONG.quicksort(dest_arr~{SY}(), lb&, ub&, 0)
END SUB


''
' Sorts _UNSIGNED LONG array in descending order
' @param _UNSIGNED LONG ARRAY source_arr~{SY}() array to sort
' @param _UNSIGNED LONG ARRAY dest_arr~{SY}() array to store sorted in
'
SUB ARR_ULONG.rsort(source_arr~{SY}(), dest_arr~{SY}())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr~{SY}) : ub& = UBOUND(source_arr~{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED LONG
    CALL ARR_ULONG.copy(source_arr~{SY}(), dest_arr~{SY}())
    CALL ARR_ULONG.quicksort(dest_arr~{SY}(), lb&, ub&, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param _UNSIGNED LONG ARRAY array~{SY}() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_ULONG.quicksort(arr~{SY}(), start%, finish%, order%)
    DIM i AS LONG
    DIM pivot AS INTEGER
    DIM pivotvalue AS _UNSIGNED LONG

    'first, partition the array
    pivot% = start%
    pivotvalue~{SY} = arr~{SY}(pivot%)
    FOR i& = start% + 1 TO finish%
        IF order% = 0 THEN ' ascending order
            IF arr~{SY}(i&) < pivotvalue~{SY} THEN
                arr~{SY}(pivot%) = arr~{SY}(i&)
                arr~{SY}(i&) = arr~{SY}(pivot% + 1)
                arr~{SY}(pivot% + 1) = pivotvalue~{SY}
                pivot% = pivot% + 1
            END IF
        ELSEIF order% = 1 THEN ' descending order
            IF arr~{SY}(i&) > pivotvalue~{SY} THEN
                arr~{SY}(pivot%) = arr~{SY}(i&)
                arr~{SY}(i&) = arr~{SY}(pivot% + 1)
                arr~{SY}(pivot% + 1) = pivotvalue~{SY}
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i&

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_ULONG.quicksort(arr~{SY}(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_ULONG.quicksort(arr~{SY}(), pivot% + 1, finish%, order%)
    END IF
END SUB
