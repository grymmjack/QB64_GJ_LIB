'$DYNAMIC

''
' Slice an array from source to destination starting at index and count slices
'
' @param UINT64() source_arr~{SY}{SY} to slice from
' @param UINT64() dest_arr~{SY}{SY} to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_UINT64.slice(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), start_idx%, count%)
    DIM AS LONG ub, lb, i, n
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED _INTEGER64
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr~{SY}{SY}(n&) = source_arr~{SY}{SY}(i&)
            n& = n& + 1
        NEXT i&
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr~{SY}{SY}(n&) = source_arr~{SY}{SY}(i&)
            n& = n& + 1
        NEXT i&
    END IF
END SUB


''
' Push a uint64 onto the end of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 arr~{SY}{SY}() array to push into
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} of byte to push
'
SUB ARR_UINT64.push(arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG ub, lb
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED _INTEGER64
    arr~{SY}{SY}(ub& + 1) = value~{SY}{SY}
END SUB


''
' Pop a uint64 from the end of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 arr~{SY}{SY}() array to pop from
' @param _UNSIGNED _INTEGER64 var~{SY}{SY} of uint64 to store popped uint64
'
SUB ARR_UINT64.pop(arr~{SY}{SY}(), var~{SY}{SY})
    DIM AS LONG ub, lb
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    var~{SY}{SY} = arr~{SY}{SY}(ub&)
    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED _INTEGER64
END SUB


''
' Pop a uint64 from the beginning of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 arr~{SY}{SY}() array to pop from
' @param _UNSIGNED _INTEGER64 var~{SY}{SY} of uint64 to store popped uint64
'
SUB ARR_UINT64.shift(arr~{SY}{SY}(), var~{SY}{SY})
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    var~{SY}{SY} = arr~{SY}{SY}(lb&)
    FOR i& = lb& TO ub& - 1
        arr~{SY}{SY}(i&) = arr~{SY}{SY}(i& + 1) 
    NEXT i&
    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED _INTEGER64
END SUB


''
' Copy an array of UINT64s to another _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() source array to copy
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() dest array to copy into
'
SUB ARR_UINT64.copy(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG ub, lb, i
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&)
    NEXT i&
END SUB


''
' Push a uint64 into the beginning of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 arr~{SY}{SY}() array to push into
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} of uint64 to push
'
SUB ARR_UINT64.unshift(arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    DIM work(lb& TO ub&) AS _UNSIGNED _INTEGER64
    CALL ARR_UINT64.copy(arr~{SY}{SY}(), work~{SY}{SY}())
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED _INTEGER64
    FOR i& = lb& + 1 TO ub& + 1
        arr~{SY}{SY}(i&) = work~{SY}{SY}(i& - 1)
    NEXT i&
    arr~{SY}{SY}(lb&) = value~{SY}{SY}
END SUB


''
' Joins an array of UINT64s as a string
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_UINT64.join(arr~{SY}{SY}(), s$)
    DIM AS LONG ub, lb, i
    s$ = ""
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    FOR i& = lb& TO ub&
        s$ = s$ + _TRIM$(STR$(arr~{SY}{SY}(i&))) + ", "
    NEXT i&
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
END SUB


''
' Create a new _UNSIGNED _INTEGER64 array using string of uint64s seperated by commas
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to store the uint64s in
' @param STRING s$ string of comma separated uint64s
'
SUB ARR_UINT64.new(arr~{SY}{SY}(), s$)
    DIM AS LONG i, count
    DIM t AS STRING
    count& = 0
    FOR i& = 1 TO LEN(s$)
        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
    NEXT i&
    REDIM arr(0 TO count&) AS _UNSIGNED _INTEGER64
    IF count& = 0 THEN
        arr~{SY}{SY}(0) = VAL(s$)
        EXIT SUB
    END IF
    count& = 0
    FOR i& = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i&))
        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
            arr~{SY}{SY}(count&) = VAL(t$)
            count& = count& + 1
            t$ = ""
        END IF
    NEXT i&
END SUB


''
' Return the visually longest element of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @return _UNSIGNED _INTEGER64 value of visually longest element
'
FUNCTION ARR_UINT64.longest~{SY}{SY}(arr~{SY}{SY}())
    DIM AS LONG lb, ub, i, res, lw
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    res& = 0 : lw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr~{SY}{SY}(i&)))) > lw& THEN
            lw&  = LEN(_TRIM$(STR$(arr~{SY}{SY}(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_UINT64.longest~{SY}{SY} = arr~{SY}{SY}(res&)
END FUNCTION


''
' Perform some math on every element of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() to do math on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() to store results in
' @param STRING op$ one of:
'                          and   or    xor   shl   shr 
' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} to use for operand
'
SUB ARR_UINT64.math(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), op$, value~{SY}{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        SELECT CASE op$
            CASE "+":
                dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) + value~{SY}{SY}
            CASE "-":
                dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) - value~{SY}{SY}
            CASE "*":
                dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) * value~{SY}{SY}
            CASE "\":
                IF value~{SY}{SY} > 0 THEN
                    dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) \ value~{SY}{SY}
                END IF
            CASE "&&":
                dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) AND value~{SY}{SY}
            CASE "||":
                dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) OR value~{SY}{SY}
            CASE "!!":
                dest_arr~{SY}{SY}(i&) = source_arr~{SY}{SY}(i&) XOR value~{SY}{SY}
            CASE "<<":
                dest_arr~{SY}{SY}(i&) = _SHL(source_arr~{SY}{SY}(i&), value~{SY}{SY})
            CASE ">>":
                dest_arr~{SY}{SY}(i&) = _SHR(source_arr~{SY}{SY}(i&), value~{SY}{SY})
        END SELECT
    NEXT i&
END SUB


''
' Return the minimum element value in _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @return _UNSIGNED _INTEGER64 minimum value found
'
FUNCTION ARR_UINT64.min~{SY}{SY}(arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM AS _UNSIGNED _INTEGER64 s
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    s~{SY}{SY} = 127
    FOR i& = lb& TO ub&
        IF arr~{SY}{SY}(i&) < s~{SY}{SY} THEN
            s~{SY}{SY} = arr~{SY}{SY}(i&)
        END IF
    NEXT i&
    ARR_UINT64.min~{SY}{SY} = s~{SY}{SY}
END FUNCTION


''
' Return the maximum element value in _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @return _UNSIGNED _INTEGER64 maximum value found
'
FUNCTION ARR_UINT64.max~{SY}{SY}(arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM AS _UNSIGNED _INTEGER64 s
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    s~{SY}{SY} = 0
    FOR i& = lb& TO ub&
        IF arr~{SY}{SY}(i&) > s~{SY}{SY} THEN
            s~{SY}{SY} = arr~{SY}{SY}(i&)
        END IF
    NEXT i&
    ARR_UINT64.max~{SY}{SY} = s~{SY}{SY}
END FUNCTION


''
' Return the visually shortest element of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @return _UNSIGNED _INTEGER64 value of visually shortest element
'
FUNCTION ARR_UINT64.shortest~{SY}{SY}(arr~{SY}{SY}())
    DIM AS LONG lb, ub, i, res, sw
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    res& = 0 : sw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr~{SY}{SY}(i&)))) < sw& THEN
            sw&  = LEN(_TRIM$(STR$(arr~{SY}{SY}(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_UINT64.shortest~{SY}{SY} = arr~{SY}{SY}(res&)
END FUNCTION


''
' Return the first element of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @return _UNSIGNED _INTEGER64 value of first element
'
FUNCTION ARR_UINT64.first~{SY}{SY}(arr~{SY}{SY}())
    ARR_UINT64.first~{SY}{SY} = arr~{SY}{SY}(LBOUND(arr~{SY}{SY}))
END FUNCTION


''
' Return the last element of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @return _UNSIGNED _INTEGER64 value of last element
'
FUNCTION ARR_UINT64.last~{SY}{SY}(arr~{SY}{SY}())
    ARR_UINT64.last~{SY}{SY} = arr~{SY}{SY}(UBOUND(arr~{SY}{SY}))
END FUNCTION


''
' Return every nth array element of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() to get from
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() to store in
' @param INTEGER nth% element
'
SUB ARR_UINT64.nth(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), nth%)
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    n& = (ub& - lb&) \ nth%
    REDIM dest_arr(n&) AS _UNSIGNED _INTEGER64
    n& = 0
    FOR i& = lb& to ub&
        IF i& MOD nth% = 0 THEN
            dest_arr~{SY}{SY}(n&) = source_arr~{SY}{SY}(i&)
            n& = n& + 1
        END IF
    NEXT i&
END SUB


''
' Checks if value exists in _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} value to check for
' @return INTEGER -1 if found or 0 if not found
'
FUNCTION ARR_UINT64.in%(arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    FOR i& = lb& TO ub&
        IF arr~{SY}{SY}(i&) = value~{SY}{SY} THEN
            ARR_UINT64.in% = -1
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_UINT64.in% = 0
END FUNCTION


''
' Checks if value exists in _UNSIGNED _INTEGER64 array and returns index if found
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} value to check for
' @return INTEGER index of element if found or -1 if not found
'
FUNCTION ARR_UINT64.find%(arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    FOR i& = lb& TO ub&
        IF arr~{SY}{SY}(i&) = value~{SY}{SY} THEN
            ARR_UINT64.find% = i&
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_UINT64.find% = -1
END FUNCTION


''
' Return the number of elements in a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to count
' @return INTEGER number of elements
'
FUNCTION ARR_UINT64.count&(arr~{SY}{SY}())
    ARR_UINT64.count& = UBOUND(arr~{SY}{SY}) - LBOUND(arr~{SY}{SY})
END FUNCTION


''
' Return the size of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to get size of
' @return LONG size in bytes
'
FUNCTION ARR_UINT64.size&(arr~{SY}{SY}())
    ARR_UINT64.size& = LEN(arr~{SY}{SY}())
END FUNCTION


''
' Reverses the elements of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() to reverse
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() to store reversed array in
'
SUB ARR_UINT64.reverse(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED _INTEGER64
    n& = 0
    FOR i& = ub& TO lb& STEP -1
        dest_arr~{SY}{SY}(n&) = source_arr~{SY}{SY}(i&)
        n& = n& + 1
    NEXT i&
END SUB


''
' Returns a random uint64 from a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() array to get random element from
' @return _UNSIGNED _INTEGER64 random element
'
FUNCTION ARR_UINT64.random~{SY}{SY}(arr~{SY}{SY}())
    DIM AS LONG lb, ub
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    RANDOMIZE TIMER 
    ARR_UINT64.random~{SY}{SY} = arr~{SY}{SY}(INT(RND * (ub& - lb&)) + 1)
END FUNCTION


''
' Returns the sum of all elements in a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() array to get some for
' @return LONG sum of all elements
'
FUNCTION ARR_UINT64.sum&(arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    FOR i& = lb& TO ub&
        sum& = sum& + arr~{SY}{SY}(i&)
    NEXT i&
    ARR_UINT64.sum& = sum&
END FUNCTION


''
' Returns the average value of elements in a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() array to get average for
' @return LONG average of elements
'
FUNCTION ARR_UINT64.avg&(arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    FOR i& = lb& TO ub&
        sum& = sum& + arr~{SY}{SY}(i&)
    NEXT i&
    ARR_UINT64.avg& = sum& / (ub& - lb&)
END FUNCTION


''
' Shuffle the elements of a _UNSIGNED _INTEGER64 array
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() to shuffle
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() to store shuffled array in
'
SUB ARR_UINT64.shuffle(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, i, count
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED _INTEGER64
    CALL ARR_UINT64.copy(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    RANDOMIZE TIMER 
    FOR i& = 0 TO count&
        SWAP dest_arr~{SY}{SY}(i&), dest_arr~{SY}{SY}(lb& + RND * (ub& - lb&)) 
    NEXT i&
END SUB


''
' Makes a _UNSIGNED _INTEGER64 array contain only unique values
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to get uniques for
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store uniques in
'
SUB ARR_UINT64.unique(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF NOT ARR_UINT64.in%(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&)) THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements greater than value
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} to be greater than to be returned
'
SUB ARR_UINT64.gt(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) > value~{SY}{SY} THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements greater than or equal to value
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} to be greater than or equal to be returned
'
SUB ARR_UINT64.gte(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) >= value~{SY}{SY} THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements less than value
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} to be less than to be returned
'
SUB ARR_UINT64.lt(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) < value~{SY}{SY} THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements less than or equal to value
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} to be less than or equal to be returned
'
SUB ARR_UINT64.lte(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), value~{SY}{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) <= value~{SY}{SY} THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Finds and replaces values across all elements in a _UNSIGNED _INTEGER64 ARRAY
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() to check in
' @param _UNSIGNED _INTEGER64 find~{SY}{SY} value to find
' @param _UNSIGNED _INTEGER64 replace~{SY}{SY} value to replace with if found
'
SUB ARR_UINT64.replace(arr~{SY}{SY}(), find~{SY}{SY}, replace~{SY}{SY})
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    FOR i& = lb& TO ub&
        IF arr~{SY}{SY}(i&) = find~{SY}{SY} THEN
            arr~{SY}{SY}(i&) = replace~{SY}{SY}
        END IF
    NEXT i&
END SUB


''
' Inserts a new element into _UNSIGNED _INTEGER64 array after index
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 value~{SY}{SY} to insert
' @param INTEGER index% of element to insert at
'
SUB ARR_UINT64.insert(arr~{SY}{SY}(), value~{SY}{SY}, index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index%
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), arr~{SY}{SY}(i&))
        NEXT i&
        ' insert new element
        CALL ARR_UINT64.push(work_arr~{SY}{SY}(), value~{SY}{SY})
        ' finish building array from index + 1
        FOR i& = index% + 1 TO ub&
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), arr~{SY}{SY}(i&))
        NEXT i&
        CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
        CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), arr~{SY}{SY}())
    END IF
END SUB


''
' Removes element from a _UNSIGNED _INTEGER64 array by element index
' @param _UNSIGNED _INTEGER64 ARRAY arr~{SY}{SY}() array to work on
' @param INTEGER index% of element to remove
'
SUB ARR_UINT64.remove(arr~{SY}{SY}(), index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    lb& = LBOUND(arr~{SY}{SY}) : ub& = UBOUND(arr~{SY}{SY})
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index% - 1
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), arr~{SY}{SY}(i&))
        NEXT i&
        ' skip elements
        FOR i& = index% + 1 TO ub&
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), arr~{SY}{SY}(i&))
        NEXT i&
        CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
        CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), arr~{SY}{SY}())
    END IF
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements that have odd values
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
'
SUB ARR_UINT64.odd(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) MOD 2 <> 0 THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements that have even values
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
'
SUB ARR_UINT64.even(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) MOD 2 = 0 THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements that have values evenly divisible by divisor
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
' @param _UNSIGNED _INTEGER64 divisor~{SY}{SY} for modulo
'
SUB ARR_UINT64.mod(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), divisor~{SY}{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) MOD divisor~{SY}{SY} = 0 THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Filters a _UNSIGNED _INTEGER64 array to only elements between min and max
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to work on
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store in
' @param _UNSIGNED _INTEGER64 min~{SY}{SY} to be greater than or equal to be returned
' @param _UNSIGNED _INTEGER64 max~{SY}{SY} to be less than or equal to be returned
'
SUB ARR_UINT64.between(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}(), min~{SY}{SY}, max~{SY}{SY})
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED _INTEGER64
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    DIM work_arr(0) AS _UNSIGNED _INTEGER64
    FOR i& = lb& TO ub&
        IF source_arr~{SY}{SY}(i&) >= min~{SY}{SY} _
        AND source_arr~{SY}{SY}(i&) <= max~{SY}{SY} THEN
            CALL ARR_UINT64.push(work_arr~{SY}{SY}(), source_arr~{SY}{SY}(i&))
        END IF
    NEXT i&
    CALL ARR_UINT64.shift(work_arr~{SY}{SY}(), tmp~{SY}{SY})
    CALL ARR_UINT64.copy(work_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
END SUB


''
' Sorts _UNSIGNED _INTEGER64 array in ascending order
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to sort
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store sorted in
'
SUB ARR_UINT64.sort(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED _INTEGER64
    CALL ARR_UINT64.copy(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    CALL ARR_UINT64.quicksort(dest_arr~{SY}{SY}(), lb&, ub&, 0)
END SUB


''
' Sorts _UNSIGNED _INTEGER64 array in descending order
' @param _UNSIGNED _INTEGER64 ARRAY source_arr~{SY}{SY}() array to sort
' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~{SY}{SY}() array to store sorted in
'
SUB ARR_UINT64.rsort(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr~{SY}{SY}) : ub& = UBOUND(source_arr~{SY}{SY})
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED _INTEGER64
    CALL ARR_UINT64.copy(source_arr~{SY}{SY}(), dest_arr~{SY}{SY}())
    CALL ARR_UINT64.quicksort(dest_arr~{SY}{SY}(), lb&, ub&, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param _UNSIGNED _INTEGER64 ARRAY array~{SY}{SY}() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_UINT64.quicksort(arr~{SY}{SY}(), start%, finish%, order%)
    DIM i AS LONG
    DIM pivot AS INTEGER
    DIM pivotvalue AS _UNSIGNED _INTEGER64

    'first, partition the array
    pivot% = start%
    pivotvalue~{SY}{SY} = arr~{SY}{SY}(pivot%)
    FOR i& = start% + 1 TO finish%
        IF order% = 0 THEN ' ascending order
            IF arr~{SY}{SY}(i&) < pivotvalue~{SY}{SY} THEN
                arr~{SY}{SY}(pivot%) = arr~{SY}{SY}(i&)
                arr~{SY}{SY}(i&) = arr~{SY}{SY}(pivot% + 1)
                arr~{SY}{SY}(pivot% + 1) = pivotvalue~{SY}{SY}
                pivot% = pivot% + 1
            END IF
        ELSEIF order% = 1 THEN ' descending order
            IF arr~{SY}{SY}(i&) > pivotvalue~{SY}{SY} THEN
                arr~{SY}{SY}(pivot%) = arr~{SY}{SY}(i&)
                arr~{SY}{SY}(i&) = arr~{SY}{SY}(pivot% + 1)
                arr~{SY}{SY}(pivot% + 1) = pivotvalue~{SY}{SY}
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i&

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_UINT64.quicksort(arr~{SY}{SY}(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_UINT64.quicksort(arr~{SY}{SY}(), pivot% + 1, finish%, order%)
    END IF
END SUB
