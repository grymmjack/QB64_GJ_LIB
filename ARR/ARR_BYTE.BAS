'$DYNAMIC

''
' Slice an array from source to destination starting at index and count slices
'
' @param BYTE() source_arr%% to slice from
' @param BYTE() dest_arr%% to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_BYTE.slice(source_arr%%(), dest_arr%%(), start_idx%, count%)
    DIM AS LONG ub, lb, i, n
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS _BYTE
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr%%(n&) = source_arr%%(i&)
            n& = n& + 1
        NEXT i&
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr%%(n&) = source_arr%%(i&)
            n& = n& + 1
        NEXT i&
    END IF
END SUB


''
' Push a byte onto the end of a _BYTE array
' @param _BYTE arr%%() array to push into
' @param _BYTE value%% of byte to push
'
SUB ARR_BYTE.push(arr%%(), value%%)
    DIM AS LONG ub, lb
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _BYTE
    arr%%(ub& + 1) = value%%
END SUB


''
' Pop a byte from the end of a _BYTE array
' @param _BYTE arr%%() array to pop from
' @param _BYTE var%% of byte to store popped byte
'
SUB ARR_BYTE.pop(arr%%(), var%%)
    DIM AS LONG ub, lb
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    var%% = arr%%(ub&)
    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _BYTE
END SUB


''
' Pop a byte from the beginning of a _BYTE array
' @param _BYTE arr%%() array to pop from
' @param _BYTE var%% of byte to store popped byte
'
SUB ARR_BYTE.shift(arr%%(), var%%)
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    var%% = arr%%(lb&)
    FOR i& = lb& TO ub& - 1
        arr%%(i&) = arr%%(i& + 1) 
    NEXT i&
    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _BYTE
END SUB


''
' Copy an array of BYTEs to another _BYTE array
' @param _BYTE ARRAY source_arr%%() source array to copy
' @param _BYTE ARRAY dest_arr%%() dest array to copy into
'
SUB ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    DIM AS LONG ub, lb, i
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    REDIM dest_arr(lb& TO ub&) AS _BYTE
    FOR i& = lb& TO ub&
        dest_arr%%(i&) = source_arr%%(i&)
    NEXT i&
END SUB


''
' Push a byte into the beginning of a _BYTE array
' @param _BYTE arr%%() array to push into
' @param _BYTE value%% of byte to push
'
SUB ARR_BYTE.unshift(arr%%(), value%%)
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    DIM work(lb& TO ub&) AS _BYTE
    CALL ARR_BYTE.copy(arr%%(), work%%())
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _BYTE
    FOR i& = lb& + 1 TO ub& + 1
        arr%%(i&) = work%%(i& - 1)
    NEXT i&
    arr%%(lb&) = value%%
END SUB


''
' Joins an array of BYTEs as a string
' @param _BYTE ARRAY arr%%() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_BYTE.join(arr%%(), s$)
    DIM AS LONG ub, lb, i
    s$ = ""
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    FOR i& = lb& TO ub&
        s$ = s$ + _TRIM$(STR$(arr%%(i&))) + ", "
    NEXT i&
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
END SUB


''
' Create a new _BYTE array using string of bytes seperated by commas
' @param _BYTE ARRAY arr%%() to store the bytes in
' @param STRING s$ string of comma separated bytes
'
SUB ARR_BYTE.new(arr%%(), s$)
    DIM AS LONG i, count
    DIM t AS STRING
    count& = 0
    FOR i& = 1 TO LEN(s$)
        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
    NEXT i&
    REDIM arr(0 TO count&) AS _BYTE
    IF count& = 0 THEN
        arr%%(0) = VAL(s$)
        EXIT SUB
    END IF
    count& = 0
    FOR i& = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i&))
        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
            arr%%(count&) = VAL(t$)
            count& = count& + 1
            t$ = ""
        END IF
    NEXT i&
END SUB


''
' Return the visually longest element of a _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @return _BYTE value of visually longest element
'
FUNCTION ARR_BYTE.longest%%(arr%%())
    DIM AS LONG lb, ub, i, res, lw
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    res& = 0 : lw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr%%(i&)))) > lw& THEN
            lw&  = LEN(_TRIM$(STR$(arr%%(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_BYTE.longest%% = arr%%(res&)
END FUNCTION


''
' Perform some math on every element of a _BYTE array
' @param _BYTE ARRAY source_arr%%() to do math on
' @param _BYTE ARRAY dest_arr%%() to store results in
' @param STRING op$ one of:
'                          and   or    xor   shl   shr 
' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
' @param _BYTE value%% to use for operand
'
SUB ARR_BYTE.math(source_arr%%(), dest_arr%%(), op$, value%%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    REDIM dest_arr(lb& TO ub&) AS _BYTE
    FOR i& = lb& TO ub&
        SELECT CASE op$
            CASE "+":
                dest_arr%%(i&) = source_arr%%(i&) + value%%
            CASE "-":
                dest_arr%%(i&) = source_arr%%(i&) - value%%
            CASE "*":
                dest_arr%%(i&) = source_arr%%(i&) * value%%
            CASE "\":
                IF value%% > 0 THEN
                    dest_arr%%(i&) = source_arr%%(i&) \ value%%
                END IF
            CASE "&&":
                dest_arr%%(i&) = source_arr%%(i&) AND value%%
            CASE "||":
                dest_arr%%(i&) = source_arr%%(i&) OR value%%
            CASE "!!":
                dest_arr%%(i&) = source_arr%%(i&) XOR value%%
            CASE "<<":
                dest_arr%%(i&) = _SHL(source_arr%%(i&), value%%)
            CASE ">>":
                dest_arr%%(i&) = _SHR(source_arr%%(i&), value%%)
        END SELECT
    NEXT i&
END SUB


''
' Return the minimum element value in _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @return _BYTE minimum value found
'
FUNCTION ARR_BYTE.min%%(arr%%())
    DIM AS LONG lb, ub, i
    DIM AS _BYTE s
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    s%% = 127
    FOR i& = lb& TO ub&
        IF arr%%(i&) < s%% THEN
            s%% = arr%%(i&)
        END IF
    NEXT i&
    ARR_BYTE.min%% = s%%
END FUNCTION


''
' Return the maximum element value in _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @return _BYTE maximum value found
'
FUNCTION ARR_BYTE.max%%(arr%%())
    DIM AS LONG lb, ub, i
    DIM AS _BYTE s
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    s%% = 0
    FOR i& = lb& TO ub&
        IF arr%%(i&) > s%% THEN
            s%% = arr%%(i&)
        END IF
    NEXT i&
    ARR_BYTE.max%% = s%%
END FUNCTION


''
' Return the visually shortest element of a _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @return _BYTE value of visually shortest element
'
FUNCTION ARR_BYTE.shortest%%(arr%%())
    DIM AS LONG lb, ub, i, res, sw
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    res& = 0 : sw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr%%(i&)))) < sw& THEN
            sw&  = LEN(_TRIM$(STR$(arr%%(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_BYTE.shortest%% = arr%%(res&)
END FUNCTION


''
' Return the first element of a _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @return _BYTE value of first element
'
FUNCTION ARR_BYTE.first%%(arr%%())
    ARR_BYTE.first%% = arr%%(LBOUND(arr%%))
END FUNCTION


''
' Return the last element of a _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @return _BYTE value of last element
'
FUNCTION ARR_BYTE.last%%(arr%%())
    ARR_BYTE.last%% = arr%%(UBOUND(arr%%))
END FUNCTION


''
' Return every nth array element of a _BYTE array
' @param _BYTE ARRAY source_arr%%() to get from
' @param _BYTE ARRAY dest_arr%%() to store in
' @param INTEGER nth% element
'
SUB ARR_BYTE.nth(source_arr%%(), dest_arr%%(), nth%)
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    n& = (ub& - lb&) \ nth%
    REDIM dest_arr(n&) AS _BYTE
    n& = 0
    FOR i& = lb& to ub&
        IF i& MOD nth% = 0 THEN
            dest_arr%%(n&) = source_arr%%(i&)
            n& = n& + 1
        END IF
    NEXT i&
END SUB


''
' Checks if value exists in _BYTE array
' @param _BYTE ARRAY arr%%() to check in
' @param _BYTE value%% value to check for
' @return INTEGER -1 if found or 0 if not found
'
FUNCTION ARR_BYTE.in%(arr%%(), value%%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    FOR i& = lb& TO ub&
        IF arr%%(i&) = value%% THEN
            ARR_BYTE.in% = -1
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_BYTE.in% = 0
END FUNCTION


''
' Checks if value exists in _BYTE array and returns index if found
' @param _BYTE ARRAY arr%%() to check in
' @param _BYTE value%% value to check for
' @return INTEGER index of element if found or -1 if not found
'
FUNCTION ARR_BYTE.find%(arr%%(), value%%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    FOR i& = lb& TO ub&
        IF arr%%(i&) = value%% THEN
            ARR_BYTE.find% = i&
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_BYTE.find% = -1
END FUNCTION


''
' Return the number of elements in a _BYTE array
' @param _BYTE ARRAY arr%%() to count
' @return INTEGER number of elements
'
FUNCTION ARR_BYTE.count&(arr%%())
    ARR_BYTE.count& = UBOUND(arr%%) - LBOUND(arr%%)
END FUNCTION


''
' Return the size of a _BYTE array
' @param _BYTE ARRAY arr%%() to get size of
' @return LONG size in bytes
'
FUNCTION ARR_BYTE.size&(arr%%())
    ARR_BYTE.size& = LEN(arr%%())
END FUNCTION


''
' Reverses the elements of a _BYTE array
' @param _BYTE ARRAY source_arr%%() to reverse
' @param _BYTE ARRAY dest_arr%%() to store reversed array in
'
SUB ARR_BYTE.reverse(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    REDIM dest_arr(0 TO (ub& - lb&)) AS _BYTE
    n& = 0
    FOR i& = ub& TO lb& STEP -1
        dest_arr%%(n&) = source_arr%%(i&)
        n& = n& + 1
    NEXT i&
END SUB


''
' Returns a random byte from a _BYTE array
' @param _BYTE ARRAY arr%%() array to get random element from
' @return _BYTE random element
'
FUNCTION ARR_BYTE.random%%(arr%%())
    DIM AS LONG lb, ub
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    RANDOMIZE TIMER 
    ARR_BYTE.random%% = arr%%(INT(RND * (ub& - lb&)) + 1)
END FUNCTION


''
' Returns the sum of all elements in a _BYTE array
' @param _BYTE ARRAY arr%%() array to get some for
' @return LONG sum of all elements
'
FUNCTION ARR_BYTE.sum&(arr%%())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    FOR i& = lb& TO ub&
        sum& = sum& + arr%%(i&)
    NEXT i&
    ARR_BYTE.sum& = sum&
END FUNCTION


''
' Returns the average value of elements in a _BYTE array
' @param _BYTE ARRAY arr%%() array to get average for
' @return LONG average of elements
'
FUNCTION ARR_BYTE.avg&(arr%%())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    FOR i& = lb& TO ub&
        sum& = sum& + arr%%(i&)
    NEXT i&
    ARR_BYTE.avg& = sum& / (ub& - lb&)
END FUNCTION


''
' Shuffle the elements of a _BYTE array
' @param _BYTE ARRAY source_arr%%() to shuffle
' @param _BYTE ARRAY dest_arr%%() to store shuffled array in
'
SUB ARR_BYTE.shuffle(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, i, count
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _BYTE
    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    RANDOMIZE TIMER 
    FOR i& = 0 TO count&
        SWAP dest_arr%%(i&), dest_arr%%(lb& + RND * (ub& - lb&)) 
    NEXT i&
END SUB


''
' Makes a _BYTE array contain only unique values
' @param _BYTE ARRAY source_arr%%() array to get uniques for
' @param _BYTE ARRAY dest_arr%%() array to store uniques in
'
SUB ARR_BYTE.unique(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF NOT ARR_BYTE.in%(work_arr%%(), source_arr%%(i&)) THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements greater than value
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
' @param _BYTE value%% to be greater than to be returned
'
SUB ARR_BYTE.gt(source_arr%%(), dest_arr%%(), value%%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) > value%% THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements greater than or equal to value
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
' @param _BYTE value%% to be greater than or equal to be returned
'
SUB ARR_BYTE.gte(source_arr%%(), dest_arr%%(), value%%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) >= value%% THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements less than value
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
' @param _BYTE value%% to be less than to be returned
'
SUB ARR_BYTE.lt(source_arr%%(), dest_arr%%(), value%%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) < value%% THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements less than or equal to value
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
' @param _BYTE value%% to be less than or equal to be returned
'
SUB ARR_BYTE.lte(source_arr%%(), dest_arr%%(), value%%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) <= value%% THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Finds and replaces values across all elements in a _BYTE ARRAY
' @param _BYTE ARRAY arr%%() to check in
' @param _BYTE find%% value to find
' @param _BYTE replace%% value to replace with if found
'
SUB ARR_BYTE.replace(arr%%(), find%%, replace%%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    FOR i& = lb& TO ub&
        IF arr%%(i&) = find%% THEN
            arr%%(i&) = replace%%
        END IF
    NEXT i&
END SUB


''
' Inserts a new element into _BYTE array after index
' @param _BYTE ARRAY arr%%() array to work on
' @param _BYTE value%% to insert
' @param INTEGER index% of element to insert at
'
SUB ARR_BYTE.insert(arr%%(), value%%, index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    DIM work_arr(0) AS _BYTE
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index%
            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
        NEXT i&
        ' insert new element
        CALL ARR_BYTE.push(work_arr%%(), value%%)
        ' finish building array from index + 1
        FOR i& = index% + 1 TO ub&
            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
        NEXT i&
        CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
        CALL ARR_BYTE.copy(work_arr%%(), arr%%())
    END IF
END SUB


''
' Removes element from a _BYTE array by element index
' @param _BYTE ARRAY arr%%() array to work on
' @param INTEGER index% of element to remove
'
SUB ARR_BYTE.remove(arr%%(), index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    DIM work_arr(0) AS _BYTE
    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index% - 1
            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
        NEXT i&
        ' skip elements
        FOR i& = index% + 1 TO ub&
            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
        NEXT i&
        CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
        CALL ARR_BYTE.copy(work_arr%%(), arr%%())
    END IF
END SUB


''
' Filters a _BYTE array to only elements that have odd values
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
'
SUB ARR_BYTE.odd(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) MOD 2 <> 0 THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements that have even values
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
'
SUB ARR_BYTE.even(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) MOD 2 = 0 THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements that have values evenly divisible by divisor
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
' @param _BYTE divisor%% for modulo
'
SUB ARR_BYTE.mod(source_arr%%(), dest_arr%%(), divisor%%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) MOD divisor%% = 0 THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Filters a _BYTE array to only elements between min and max
' @param _BYTE ARRAY source_arr%%() array to work on
' @param _BYTE ARRAY dest_arr%%() array to store in
' @param _BYTE min%% to be greater than or equal to be returned
' @param _BYTE max%% to be less than or equal to be returned
'
SUB ARR_BYTE.between(source_arr%%(), dest_arr%%(), min%%, max%%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _BYTE
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    DIM work_arr(0) AS _BYTE
    FOR i& = lb& TO ub&
        IF source_arr%%(i&) >= min%% _
        AND source_arr%%(i&) <= max%% THEN
            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
        END IF
    NEXT i&
    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
END SUB


''
' Sorts _BYTE array in ascending order
' @param _BYTE ARRAY source_arr%%() array to sort
' @param _BYTE ARRAY dest_arr%%() array to store sorted in
'
SUB ARR_BYTE.sort(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _BYTE
    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    CALL ARR_BYTE.quicksort(dest_arr%%(), lb&, ub&, 0)
END SUB


''
' Sorts _BYTE array in descending order
' @param _BYTE ARRAY source_arr%%() array to sort
' @param _BYTE ARRAY dest_arr%%() array to store sorted in
'
SUB ARR_BYTE.rsort(source_arr%%(), dest_arr%%())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _BYTE
    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    CALL ARR_BYTE.quicksort(dest_arr%%(), lb&, ub&, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param _BYTE ARRAY array%%() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_BYTE.quicksort(arr%%(), start%, finish%, order%)
    DIM i AS LONG
    DIM pivot AS INTEGER
    DIM pivotvalue AS _BYTE

    'first, partition the array
    pivot% = start%
    pivotvalue%% = arr%%(pivot%)
    FOR i& = start% + 1 TO finish%
        IF order% = 0 THEN ' ascending order
            IF arr%%(i&) < pivotvalue%% THEN
                arr%%(pivot%) = arr%%(i&)
                arr%%(i&) = arr%%(pivot% + 1)
                arr%%(pivot% + 1) = pivotvalue%%
                pivot% = pivot% + 1
            END IF
        ELSEIF order% = 1 THEN ' descending order
            IF arr%%(i&) > pivotvalue%% THEN
                arr%%(pivot%) = arr%%(i&)
                arr%%(i&) = arr%%(pivot% + 1)
                arr%%(pivot% + 1) = pivotvalue%%
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i&

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_BYTE.quicksort(arr%%(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_BYTE.quicksort(arr%%(), pivot% + 1, finish%, order%)
    END IF
END SUB
