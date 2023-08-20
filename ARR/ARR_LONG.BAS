'$DYNAMIC

''
' Slice an array from source to destination starting at index and count slices
'
' @param LONG() source_arr{SY} to slice from
' @param LONG() dest_arr{SY} to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_LONG.slice(source_arr{SY}(), dest_arr{SY}(), start_idx%, count%)
    DIM AS LONG ub, lb, i, n
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS LONG
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr{SY}(n&) = source_arr{SY}(i&)
            n& = n& + 1
        NEXT i&
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr{SY}(n&) = source_arr{SY}(i&)
            n& = n& + 1
        NEXT i&
    END IF
END SUB


''
' Push a long onto the end of a LONG array
' @param LONG arr{SY}() array to push into
' @param LONG value{SY} of byte to push
'
SUB ARR_LONG.push(arr{SY}(), value{SY})
    DIM AS LONG ub, lb
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS LONG
    arr{SY}(ub& + 1) = value{SY}
END SUB


''
' Pop a long from the end of a LONG array
' @param LONG arr{SY}() array to pop from
' @param LONG var{SY} of long to store popped long
'
SUB ARR_LONG.pop(arr{SY}(), var{SY})
    DIM AS LONG ub, lb
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    var{SY} = arr{SY}(ub&)
    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS LONG
END SUB


''
' Pop a long from the beginning of a LONG array
' @param LONG arr{SY}() array to pop from
' @param LONG var{SY} of long to store popped long
'
SUB ARR_LONG.shift(arr{SY}(), var{SY})
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    var{SY} = arr{SY}(lb&)
    FOR i& = lb& TO ub& - 1
        arr{SY}(i&) = arr{SY}(i& + 1) 
    NEXT i&
    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS LONG
END SUB


''
' Copy an array of LONGs to another LONG array
' @param LONG ARRAY source_arr{SY}() source array to copy
' @param LONG ARRAY dest_arr{SY}() dest array to copy into
'
SUB ARR_LONG.copy(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG ub, lb, i
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    REDIM dest_arr(lb& TO ub&) AS LONG
    FOR i& = lb& TO ub&
        dest_arr{SY}(i&) = source_arr{SY}(i&)
    NEXT i&
END SUB


''
' Push a long into the beginning of a LONG array
' @param LONG arr{SY}() array to push into
' @param LONG value{SY} of long to push
'
SUB ARR_LONG.unshift(arr{SY}(), value{SY})
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    DIM work(lb& TO ub&) AS LONG
    CALL ARR_LONG.copy(arr{SY}(), work{SY}())
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS LONG
    FOR i& = lb& + 1 TO ub& + 1
        arr{SY}(i&) = work{SY}(i& - 1)
    NEXT i&
    arr{SY}(lb&) = value{SY}
END SUB


''
' Joins an array of LONGs as a string
' @param LONG ARRAY arr{SY}() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_LONG.join(arr{SY}(), s$)
    DIM AS LONG ub, lb, i
    s$ = ""
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    FOR i& = lb& TO ub&
        s$ = s$ + _TRIM$(STR$(arr{SY}(i&))) + ", "
    NEXT i&
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
END SUB


''
' Create a new LONG array using string of longs seperated by commas
' @param LONG ARRAY arr{SY}() to store the longs in
' @param STRING s$ string of comma separated longs
'
SUB ARR_LONG.new(arr{SY}(), s$)
    DIM AS LONG i, count
    DIM t AS STRING
    count& = 0
    FOR i& = 1 TO LEN(s$)
        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
    NEXT i&
    REDIM arr(0 TO count&) AS LONG
    IF count& = 0 THEN
        arr{SY}(0) = VAL(s$)
        EXIT SUB
    END IF
    count& = 0
    FOR i& = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i&))
        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
            arr{SY}(count&) = VAL(t$)
            count& = count& + 1
            t$ = ""
        END IF
    NEXT i&
END SUB


''
' Return the visually longest element of a LONG array
' @param LONG ARRAY arr{SY}() to check in
' @return LONG value of visually longest element
'
FUNCTION ARR_LONG.longest{SY}(arr{SY}())
    DIM AS LONG lb, ub, i, res, lw
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    res& = 0 : lw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr{SY}(i&)))) > lw& THEN
            lw&  = LEN(_TRIM$(STR$(arr{SY}(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_LONG.longest{SY} = arr{SY}(res&)
END FUNCTION


''
' Perform some math on every element of a LONG array
' @param LONG ARRAY source_arr{SY}() to do math on
' @param LONG ARRAY dest_arr{SY}() to store results in
' @param STRING op$ one of:
'                          and   or    xor   shl   shr 
' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
' @param LONG value{SY} to use for operand
'
SUB ARR_LONG.math(source_arr{SY}(), dest_arr{SY}(), op$, value{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    REDIM dest_arr(lb& TO ub&) AS LONG
    FOR i& = lb& TO ub&
        SELECT CASE op$
            CASE "+":
                dest_arr{SY}(i&) = source_arr{SY}(i&) + value{SY}
            CASE "-":
                dest_arr{SY}(i&) = source_arr{SY}(i&) - value{SY}
            CASE "*":
                dest_arr{SY}(i&) = source_arr{SY}(i&) * value{SY}
            CASE "\":
                IF value{SY} > 0 THEN
                    dest_arr{SY}(i&) = source_arr{SY}(i&) \ value{SY}
                END IF
            CASE "&&":
                dest_arr{SY}(i&) = source_arr{SY}(i&) AND value{SY}
            CASE "||":
                dest_arr{SY}(i&) = source_arr{SY}(i&) OR value{SY}
            CASE "!!":
                dest_arr{SY}(i&) = source_arr{SY}(i&) XOR value{SY}
            CASE "<<":
                dest_arr{SY}(i&) = _SHL(source_arr{SY}(i&), value{SY})
            CASE ">>":
                dest_arr{SY}(i&) = _SHR(source_arr{SY}(i&), value{SY})
        END SELECT
    NEXT i&
END SUB


''
' Return the minimum element value in LONG array
' @param LONG ARRAY arr{SY}() to check in
' @return LONG minimum value found
'
FUNCTION ARR_LONG.min{SY}(arr{SY}())
    DIM AS LONG lb, ub, i
    DIM AS LONG s
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    s{SY} = 127
    FOR i& = lb& TO ub&
        IF arr{SY}(i&) < s{SY} THEN
            s{SY} = arr{SY}(i&)
        END IF
    NEXT i&
    ARR_LONG.min{SY} = s{SY}
END FUNCTION


''
' Return the maximum element value in LONG array
' @param LONG ARRAY arr{SY}() to check in
' @return LONG maximum value found
'
FUNCTION ARR_LONG.max{SY}(arr{SY}())
    DIM AS LONG lb, ub, i
    DIM AS LONG s
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    s{SY} = 0
    FOR i& = lb& TO ub&
        IF arr{SY}(i&) > s{SY} THEN
            s{SY} = arr{SY}(i&)
        END IF
    NEXT i&
    ARR_LONG.max{SY} = s{SY}
END FUNCTION


''
' Return the visually shortest element of a LONG array
' @param LONG ARRAY arr{SY}() to check in
' @return LONG value of visually shortest element
'
FUNCTION ARR_LONG.shortest{SY}(arr{SY}())
    DIM AS LONG lb, ub, i, res, sw
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    res& = 0 : sw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr{SY}(i&)))) < sw& THEN
            sw&  = LEN(_TRIM$(STR$(arr{SY}(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_LONG.shortest{SY} = arr{SY}(res&)
END FUNCTION


''
' Return the first element of a LONG array
' @param LONG ARRAY arr{SY}() to check in
' @return LONG value of first element
'
FUNCTION ARR_LONG.first{SY}(arr{SY}())
    ARR_LONG.first{SY} = arr{SY}(LBOUND(arr{SY}))
END FUNCTION


''
' Return the last element of a LONG array
' @param LONG ARRAY arr{SY}() to check in
' @return LONG value of last element
'
FUNCTION ARR_LONG.last{SY}(arr{SY}())
    ARR_LONG.last{SY} = arr{SY}(UBOUND(arr{SY}))
END FUNCTION


''
' Return every nth array element of a LONG array
' @param LONG ARRAY source_arr{SY}() to get from
' @param LONG ARRAY dest_arr{SY}() to store in
' @param INTEGER nth% element
'
SUB ARR_LONG.nth(source_arr{SY}(), dest_arr{SY}(), nth%)
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    n& = (ub& - lb&) \ nth%
    REDIM dest_arr(n&) AS LONG
    n& = 0
    FOR i& = lb& to ub&
        IF i& MOD nth% = 0 THEN
            dest_arr{SY}(n&) = source_arr{SY}(i&)
            n& = n& + 1
        END IF
    NEXT i&
END SUB


''
' Checks if value exists in LONG array
' @param LONG ARRAY arr{SY}() to check in
' @param LONG value{SY} value to check for
' @return INTEGER -1 if found or 0 if not found
'
FUNCTION ARR_LONG.in%(arr{SY}(), value{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    FOR i& = lb& TO ub&
        IF arr{SY}(i&) = value{SY} THEN
            ARR_LONG.in% = -1
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_LONG.in% = 0
END FUNCTION


''
' Checks if value exists in LONG array and returns index if found
' @param LONG ARRAY arr{SY}() to check in
' @param LONG value{SY} value to check for
' @return INTEGER index of element if found or -1 if not found
'
FUNCTION ARR_LONG.find%(arr{SY}(), value{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    FOR i& = lb& TO ub&
        IF arr{SY}(i&) = value{SY} THEN
            ARR_LONG.find% = i&
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_LONG.find% = -1
END FUNCTION


''
' Return the number of elements in a LONG array
' @param LONG ARRAY arr{SY}() to count
' @return INTEGER number of elements
'
FUNCTION ARR_LONG.count&(arr{SY}())
    ARR_LONG.count& = UBOUND(arr{SY}) - LBOUND(arr{SY})
END FUNCTION


''
' Return the size of a LONG array
' @param LONG ARRAY arr{SY}() to get size of
' @return LONG size in bytes
'
FUNCTION ARR_LONG.size&(arr{SY}())
    ARR_LONG.size& = LEN(arr{SY}())
END FUNCTION


''
' Reverses the elements of a LONG array
' @param LONG ARRAY source_arr{SY}() to reverse
' @param LONG ARRAY dest_arr{SY}() to store reversed array in
'
SUB ARR_LONG.reverse(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    REDIM dest_arr(0 TO (ub& - lb&)) AS LONG
    n& = 0
    FOR i& = ub& TO lb& STEP -1
        dest_arr{SY}(n&) = source_arr{SY}(i&)
        n& = n& + 1
    NEXT i&
END SUB


''
' Returns a random long from a LONG array
' @param LONG ARRAY arr{SY}() array to get random element from
' @return LONG random element
'
FUNCTION ARR_LONG.random{SY}(arr{SY}())
    DIM AS LONG lb, ub
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    RANDOMIZE TIMER 
    ARR_LONG.random{SY} = arr{SY}(INT(RND * (ub& - lb&)) + 1)
END FUNCTION


''
' Returns the sum of all elements in a LONG array
' @param LONG ARRAY arr{SY}() array to get some for
' @return LONG sum of all elements
'
FUNCTION ARR_LONG.sum&(arr{SY}())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    FOR i& = lb& TO ub&
        sum& = sum& + arr{SY}(i&)
    NEXT i&
    ARR_LONG.sum& = sum&
END FUNCTION


''
' Returns the average value of elements in a LONG array
' @param LONG ARRAY arr{SY}() array to get average for
' @return LONG average of elements
'
FUNCTION ARR_LONG.avg&(arr{SY}())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    FOR i& = lb& TO ub&
        sum& = sum& + arr{SY}(i&)
    NEXT i&
    ARR_LONG.avg& = sum& / (ub& - lb&)
END FUNCTION


''
' Shuffle the elements of a LONG array
' @param LONG ARRAY source_arr{SY}() to shuffle
' @param LONG ARRAY dest_arr{SY}() to store shuffled array in
'
SUB ARR_LONG.shuffle(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, i, count
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS LONG
    CALL ARR_LONG.copy(source_arr{SY}(), dest_arr{SY}())
    RANDOMIZE TIMER 
    FOR i& = 0 TO count&
        SWAP dest_arr{SY}(i&), dest_arr{SY}(lb& + RND * (ub& - lb&)) 
    NEXT i&
END SUB


''
' Makes a LONG array contain only unique values
' @param LONG ARRAY source_arr{SY}() array to get uniques for
' @param LONG ARRAY dest_arr{SY}() array to store uniques in
'
SUB ARR_LONG.unique(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF NOT ARR_LONG.in%(work_arr{SY}(), source_arr{SY}(i&)) THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements greater than value
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
' @param LONG value{SY} to be greater than to be returned
'
SUB ARR_LONG.gt(source_arr{SY}(), dest_arr{SY}(), value{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) > value{SY} THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements greater than or equal to value
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
' @param LONG value{SY} to be greater than or equal to be returned
'
SUB ARR_LONG.gte(source_arr{SY}(), dest_arr{SY}(), value{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) >= value{SY} THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements less than value
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
' @param LONG value{SY} to be less than to be returned
'
SUB ARR_LONG.lt(source_arr{SY}(), dest_arr{SY}(), value{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) < value{SY} THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements less than or equal to value
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
' @param LONG value{SY} to be less than or equal to be returned
'
SUB ARR_LONG.lte(source_arr{SY}(), dest_arr{SY}(), value{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) <= value{SY} THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Finds and replaces values across all elements in a LONG ARRAY
' @param LONG ARRAY arr{SY}() to check in
' @param LONG find{SY} value to find
' @param LONG replace{SY} value to replace with if found
'
SUB ARR_LONG.replace(arr{SY}(), find{SY}, replace{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    FOR i& = lb& TO ub&
        IF arr{SY}(i&) = find{SY} THEN
            arr{SY}(i&) = replace{SY}
        END IF
    NEXT i&
END SUB


''
' Inserts a new element into LONG array after index
' @param LONG ARRAY arr{SY}() array to work on
' @param LONG value{SY} to insert
' @param INTEGER index% of element to insert at
'
SUB ARR_LONG.insert(arr{SY}(), value{SY}, index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    DIM work_arr(0) AS LONG
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index%
            CALL ARR_LONG.push(work_arr{SY}(), arr{SY}(i&))
        NEXT i&
        ' insert new element
        CALL ARR_LONG.push(work_arr{SY}(), value{SY})
        ' finish building array from index + 1
        FOR i& = index% + 1 TO ub&
            CALL ARR_LONG.push(work_arr{SY}(), arr{SY}(i&))
        NEXT i&
        CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
        CALL ARR_LONG.copy(work_arr{SY}(), arr{SY}())
    END IF
END SUB


''
' Removes element from a LONG array by element index
' @param LONG ARRAY arr{SY}() array to work on
' @param INTEGER index% of element to remove
'
SUB ARR_LONG.remove(arr{SY}(), index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    DIM work_arr(0) AS LONG
    lb& = LBOUND(arr{SY}) : ub& = UBOUND(arr{SY})
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index% - 1
            CALL ARR_LONG.push(work_arr{SY}(), arr{SY}(i&))
        NEXT i&
        ' skip elements
        FOR i& = index% + 1 TO ub&
            CALL ARR_LONG.push(work_arr{SY}(), arr{SY}(i&))
        NEXT i&
        CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
        CALL ARR_LONG.copy(work_arr{SY}(), arr{SY}())
    END IF
END SUB


''
' Filters a LONG array to only elements that have odd values
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
'
SUB ARR_LONG.odd(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) MOD 2 <> 0 THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements that have even values
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
'
SUB ARR_LONG.even(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) MOD 2 = 0 THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements that have values evenly divisible by divisor
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
' @param LONG divisor{SY} for modulo
'
SUB ARR_LONG.mod(source_arr{SY}(), dest_arr{SY}(), divisor{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) MOD divisor{SY} = 0 THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Filters a LONG array to only elements between min and max
' @param LONG ARRAY source_arr{SY}() array to work on
' @param LONG ARRAY dest_arr{SY}() array to store in
' @param LONG min{SY} to be greater than or equal to be returned
' @param LONG max{SY} to be less than or equal to be returned
'
SUB ARR_LONG.between(source_arr{SY}(), dest_arr{SY}(), min{SY}, max{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS LONG
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    DIM work_arr(0) AS LONG
    FOR i& = lb& TO ub&
        IF source_arr{SY}(i&) >= min{SY} _
        AND source_arr{SY}(i&) <= max{SY} THEN
            CALL ARR_LONG.push(work_arr{SY}(), source_arr{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_LONG.shift(work_arr{SY}(), tmp{SY})
    CALL ARR_LONG.copy(work_arr{SY}(), dest_arr{SY}())
END SUB


''
' Sorts LONG array in ascending order
' @param LONG ARRAY source_arr{SY}() array to sort
' @param LONG ARRAY dest_arr{SY}() array to store sorted in
'
SUB ARR_LONG.sort(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS LONG
    CALL ARR_LONG.copy(source_arr{SY}(), dest_arr{SY}())
    CALL ARR_LONG.quicksort(dest_arr{SY}(), lb&, ub&, 0)
END SUB


''
' Sorts LONG array in descending order
' @param LONG ARRAY source_arr{SY}() array to sort
' @param LONG ARRAY dest_arr{SY}() array to store sorted in
'
SUB ARR_LONG.rsort(source_arr{SY}(), dest_arr{SY}())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr{SY}) : ub& = UBOUND(source_arr{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS LONG
    CALL ARR_LONG.copy(source_arr{SY}(), dest_arr{SY}())
    CALL ARR_LONG.quicksort(dest_arr{SY}(), lb&, ub&, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param LONG ARRAY array{SY}() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_LONG.quicksort(arr{SY}(), start%, finish%, order%)
    DIM i AS LONG
    DIM pivot AS INTEGER
    DIM pivotvalue AS LONG

    'first, partition the array
    pivot% = start%
    pivotvalue{SY} = arr{SY}(pivot%)
    FOR i& = start% + 1 TO finish%
        IF order% = 0 THEN ' ascending order
            IF arr{SY}(i&) < pivotvalue{SY} THEN
                arr{SY}(pivot%) = arr{SY}(i&)
                arr{SY}(i&) = arr{SY}(pivot% + 1)
                arr{SY}(pivot% + 1) = pivotvalue{SY}
                pivot% = pivot% + 1
            END IF
        ELSEIF order% = 1 THEN ' descending order
            IF arr{SY}(i&) > pivotvalue{SY} THEN
                arr{SY}(pivot%) = arr{SY}(i&)
                arr{SY}(i&) = arr{SY}(pivot% + 1)
                arr{SY}(pivot% + 1) = pivotvalue{SY}
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i&

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_LONG.quicksort(arr{SY}(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_LONG.quicksort(arr{SY}(), pivot% + 1, finish%, order%)
    END IF
END SUB
