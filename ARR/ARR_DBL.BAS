
'DOUBLE = actual type used in syntax uppercase         _BYTE       _UNSIGNED _BYTE     INTEGER     _UNSIGNED INTEGER   LONG    _UNSIGNED LONG  _INTEGER64  _UNSIGNED _INTEGER64    SINGLE  DOUBLE  _FLOAT
'double = actual type used in syntax as lowercase      _byte       _unsigned _byte     integer     _unsigned integer   long    _unsigned long  _integer64  _unsigned _integer64    single  double  _float
'DBL = uppercase type full name identifier         BYTE        UBYTE               INTEGER     UNSIGNED INTEGER    LONG    ULONG           INTEGER64   UINT64                  SINGLE  DOUBLE  FLOAT
'dbl = lowercase type full name identifier         byte        ubyte               integer     unsigned integer    long    ulong           integer64   uint64                  single  double  float
'# = sigil                                       %%          ~%%                 %           ~%                  &       ~&              &&          ~&&                     !       #       ##

'DOUBLE = actual type used in syntax uppercase         STRING
'double = actual type used in syntax as lowercase      string
'DBL = uppercase type full name identifier         STRING
'dbl = lowercase type full name identifier         string
'# = sigil                                       $

'$DYNAMIC
OPTION _EXPLICIT



''
' Slice an array from source to destination starting at index and count slices
'
' @param DBL() source_arr# to slice from
' @param DBL() dest_arr# to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_DBL.slice(source_arr#(), dest_arr#(), start_idx%, count%)
    DIM AS LONG ub, lb, i, n
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS DOUBLE
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr#(n&) = source_arr#(i&)
            n& = n& + 1
        NEXT i&
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr#(n&) = source_arr#(i&)
            n& = n& + 1
        NEXT i&
    END IF
END SUB


''
' Push a dbl onto the end of a DOUBLE array
' @param DOUBLE arr#() array to push into
' @param DOUBLE value# of byte to push
'
SUB ARR_DBL.push(arr#(), value#)
    DIM AS LONG ub, lb
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS DOUBLE
    arr#(ub& + 1) = value#
END SUB


''
' Pop a dbl from the end of a DOUBLE array
' @param DOUBLE arr#() array to pop from
' @param DOUBLE var# of dbl to store popped dbl
'
SUB ARR_DBL.pop(arr#(), var#)
    DIM AS LONG ub, lb
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    var# = arr#(ub&)
    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS DOUBLE
END SUB


''
' Pop a dbl from the beginning of a DOUBLE array
' @param DOUBLE arr#() array to pop from
' @param DOUBLE var# of dbl to store popped dbl
'
SUB ARR_DBL.shift(arr#(), var#)
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    var# = arr#(lb&)
    FOR i& = lb& TO ub& - 1
        arr#(i&) = arr#(i& + 1) 
    NEXT i&
    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS DOUBLE
END SUB


''
' Copy an array of DBLs to another DOUBLE array
' @param DOUBLE ARRAY source_arr#() source array to copy
' @param DOUBLE ARRAY dest_arr#() dest array to copy into
'
SUB ARR_DBL.copy(source_arr#(), dest_arr#())
    DIM AS LONG ub, lb, i
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    REDIM dest_arr(lb& TO ub&) AS DOUBLE
    FOR i& = lb& TO ub&
        dest_arr#(i&) = source_arr#(i&)
    NEXT i&
END SUB


''
' Push a dbl into the beginning of a DOUBLE array
' @param DOUBLE arr#() array to push into
' @param DOUBLE value# of dbl to push
'
SUB ARR_DBL.unshift(arr#(), value#)
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    DIM work(lb& TO ub&) AS DOUBLE
    CALL ARR_DBL.copy(arr#(), work#())
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS DOUBLE
    FOR i& = lb& + 1 TO ub& + 1
        arr#(i&) = work#(i& - 1)
    NEXT i&
    arr#(lb&) = value#
END SUB


''
' Joins an array of DBLs as a string
' @param DOUBLE ARRAY arr#() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_DBL.join(arr#(), s$)
    DIM AS LONG ub, lb, i
    s$ = ""
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    FOR i& = lb& TO ub&
        s$ = s$ + _TRIM$(STR$(arr#(i&))) + ", "
    NEXT i&
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
END SUB


''
' Create a new DOUBLE array using string of dbls seperated by commas
' @param DOUBLE ARRAY arr#() to store the dbls in
' @param STRING s$ string of comma separated dbls
'
SUB ARR_DBL.new(arr#(), s$)
    DIM AS LONG i, count
    DIM t AS STRING
    count& = 0
    FOR i& = 1 TO LEN(s$)
        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
    NEXT i&
    REDIM arr(0 TO count&) AS DOUBLE
    IF count& = 0 THEN
        arr#(0) = VAL(s$)
        EXIT SUB
    END IF
    count& = 0
    FOR i& = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i&))
        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
            arr#(count&) = VAL(t$)
            count& = count& + 1
            t$ = ""
        END IF
    NEXT i&
END SUB


''
' Return the visually longest element of a DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @return DOUBLE value of visually longest element
'
FUNCTION ARR_DBL.longest#(arr#())
    DIM AS LONG lb, ub, i, res, lw
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    res& = 0 : lw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr#(i&)))) > lw& THEN
            lw&  = LEN(_TRIM$(STR$(arr#(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_DBL.longest# = arr#(res&)
END FUNCTION


''
' Perform some math on every element of a DOUBLE array
' @param DOUBLE ARRAY source_arr#() to do math on
' @param DOUBLE ARRAY dest_arr#() to store results in
' @param STRING op$ one of:
'                          and   or    xor   shl   shr 
' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
' @param DOUBLE value# to use for operand
'
SUB ARR_DBL.math(source_arr#(), dest_arr#(), op$, value#)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    REDIM dest_arr(lb& TO ub&) AS DOUBLE
    FOR i& = lb& TO ub&
        SELECT CASE op$
            CASE "+":
                dest_arr#(i&) = source_arr#(i&) + value#
            CASE "-":
                dest_arr#(i&) = source_arr#(i&) - value#
            CASE "*":
                dest_arr#(i&) = source_arr#(i&) * value#
            CASE "\":
                IF value# > 0 THEN
                    dest_arr#(i&) = source_arr#(i&) \ value#
                END IF
            CASE "&&":
                dest_arr#(i&) = source_arr#(i&) AND value#
            CASE "||":
                dest_arr#(i&) = source_arr#(i&) OR value#
            CASE "!!":
                dest_arr#(i&) = source_arr#(i&) XOR value#
            CASE "<<":
                dest_arr#(i&) = _SHL(source_arr#(i&), value#)
            CASE ">>":
                dest_arr#(i&) = _SHR(source_arr#(i&), value#)
        END SELECT
    NEXT i&
END SUB


''
' Return the minimum element value in DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @return DOUBLE minimum value found
'
FUNCTION ARR_DBL.min#(arr#())
    DIM AS LONG lb, ub, i
    DIM AS DOUBLE s
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    s# = 127
    FOR i& = lb& TO ub&
        IF arr#(i&) < s# THEN
            s# = arr#(i&)
        END IF
    NEXT i&
    ARR_DBL.min# = s#
END FUNCTION


''
' Return the maximum element value in DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @return DOUBLE maximum value found
'
FUNCTION ARR_DBL.max#(arr#())
    DIM AS LONG lb, ub, i
    DIM AS DOUBLE s
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    s# = 0
    FOR i& = lb& TO ub&
        IF arr#(i&) > s# THEN
            s# = arr#(i&)
        END IF
    NEXT i&
    ARR_DBL.max# = s#
END FUNCTION


''
' Return the visually shortest element of a DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @return DOUBLE value of visually shortest element
'
FUNCTION ARR_DBL.shortest#(arr#())
    DIM AS LONG lb, ub, i, res, sw
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    res& = 0 : sw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr#(i&)))) < sw& THEN
            sw&  = LEN(_TRIM$(STR$(arr#(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_DBL.shortest# = arr#(res&)
END FUNCTION


''
' Return the first element of a DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @return DOUBLE value of first element
'
FUNCTION ARR_DBL.first#(arr#())
    ARR_DBL.first# = arr#(LBOUND(arr#))
END FUNCTION


''
' Return the last element of a DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @return DOUBLE value of last element
'
FUNCTION ARR_DBL.last#(arr#())
    ARR_DBL.last# = arr#(UBOUND(arr#))
END FUNCTION


''
' Return every nth array element of a DOUBLE array
' @param DOUBLE ARRAY source_arr#() to get from
' @param DOUBLE ARRAY dest_arr#() to store in
' @param INTEGER nth% element
'
SUB ARR_DBL.nth(source_arr#(), dest_arr#(), nth%)
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    n& = (ub& - lb&) \ nth%
    REDIM dest_arr(n&) AS DOUBLE
    n& = 0
    FOR i& = lb& to ub&
        IF i& MOD nth% = 0 THEN
            dest_arr#(n&) = source_arr#(i&)
            n& = n& + 1
        END IF
    NEXT i&
END SUB


''
' Checks if value exists in DOUBLE array
' @param DOUBLE ARRAY arr#() to check in
' @param DOUBLE value# value to check for
' @return INTEGER -1 if found or 0 if not found
'
FUNCTION ARR_DBL.in%(arr#(), value#)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    FOR i& = lb& TO ub&
        IF arr#(i&) = value# THEN
            ARR_DBL.in% = -1
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_DBL.in% = 0
END FUNCTION


''
' Checks if value exists in DOUBLE array and returns index if found
' @param DOUBLE ARRAY arr#() to check in
' @param DOUBLE value# value to check for
' @return INTEGER index of element if found or -1 if not found
'
FUNCTION ARR_DBL.find%(arr#(), value#)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    FOR i& = lb& TO ub&
        IF arr#(i&) = value# THEN
            ARR_DBL.find% = i&
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_DBL.find% = -1
END FUNCTION


''
' Return the number of elements in a DOUBLE array
' @param DOUBLE ARRAY arr#() to count
' @return INTEGER number of elements
'
FUNCTION ARR_DBL.count&(arr#())
    ARR_DBL.count& = UBOUND(arr#) - LBOUND(arr#)
END FUNCTION


''
' Return the size of a DOUBLE array
' @param DOUBLE ARRAY arr#() to get size of
' @return LONG size in bytes
'
FUNCTION ARR_DBL.size&(arr#())
    ARR_DBL.size& = LEN(arr#())
END FUNCTION


''
' Reverses the elements of a DOUBLE array
' @param DOUBLE ARRAY source_arr#() to reverse
' @param DOUBLE ARRAY dest_arr#() to store reversed array in
'
SUB ARR_DBL.reverse(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    REDIM dest_arr(0 TO (ub& - lb&)) AS DOUBLE
    n& = 0
    FOR i& = ub& TO lb& STEP -1
        dest_arr#(n&) = source_arr#(i&)
        n& = n& + 1
    NEXT i&
END SUB


''
' Returns a random dbl from a DOUBLE array
' @param DOUBLE ARRAY arr#() array to get random element from
' @return DOUBLE random element
'
FUNCTION ARR_DBL.random#(arr#())
    DIM AS LONG lb, ub
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    RANDOMIZE TIMER 
    ARR_DBL.random# = arr#(INT(RND * (ub& - lb&)) + 1)
END FUNCTION


''
' Returns the sum of all elements in a DOUBLE array
' @param DOUBLE ARRAY arr#() array to get some for
' @return LONG sum of all elements
'
FUNCTION ARR_DBL.sum&(arr#())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    FOR i& = lb& TO ub&
        sum& = sum& + arr#(i&)
    NEXT i&
    ARR_DBL.sum& = sum&
END FUNCTION


''
' Returns the average value of elements in a DOUBLE array
' @param DOUBLE ARRAY arr#() array to get average for
' @return LONG average of elements
'
FUNCTION ARR_DBL.avg&(arr#())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    FOR i& = lb& TO ub&
        sum& = sum& + arr#(i&)
    NEXT i&
    ARR_DBL.avg& = sum& / (ub& - lb&)
END FUNCTION


''
' Shuffle the elements of a DOUBLE array
' @param DOUBLE ARRAY source_arr#() to shuffle
' @param DOUBLE ARRAY dest_arr#() to store shuffled array in
'
SUB ARR_DBL.shuffle(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, i, count
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS DOUBLE
    CALL ARR_DBL.copy(source_arr#(), dest_arr#())
    RANDOMIZE TIMER 
    FOR i& = 0 TO count&
        SWAP dest_arr#(i&), dest_arr#(lb& + RND * (ub& - lb&)) 
    NEXT i&
END SUB


''
' Makes a DOUBLE array contain only unique values
' @param DOUBLE ARRAY source_arr#() array to get uniques for
' @param DOUBLE ARRAY dest_arr#() array to store uniques in
'
SUB ARR_DBL.unique(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF NOT ARR_DBL.in%(work_arr#(), source_arr#(i&)) THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements greater than value
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
' @param DOUBLE value# to be greater than to be returned
'
SUB ARR_DBL.gt(source_arr#(), dest_arr#(), value#)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) > value# THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements greater than or equal to value
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
' @param DOUBLE value# to be greater than or equal to be returned
'
SUB ARR_DBL.gte(source_arr#(), dest_arr#(), value#)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) >= value# THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements less than value
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
' @param DOUBLE value# to be less than to be returned
'
SUB ARR_DBL.lt(source_arr#(), dest_arr#(), value#)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) < value# THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements less than or equal to value
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
' @param DOUBLE value# to be less than or equal to be returned
'
SUB ARR_DBL.lte(source_arr#(), dest_arr#(), value#)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) <= value# THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Finds and replaces values across all elements in a DOUBLE ARRAY
' @param DOUBLE ARRAY arr#() to check in
' @param DOUBLE find# value to find
' @param DOUBLE replace# value to replace with if found
'
SUB ARR_DBL.replace(arr#(), find#, replace#)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    FOR i& = lb& TO ub&
        IF arr#(i&) = find# THEN
            arr#(i&) = replace#
        END IF
    NEXT i&
END SUB


''
' Inserts a new element into DOUBLE array after index
' @param DOUBLE ARRAY arr#() array to work on
' @param DOUBLE value# to insert
' @param INTEGER index% of element to insert at
'
SUB ARR_DBL.insert(arr#(), value#, index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    DIM work_arr(0) AS DOUBLE
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index%
            CALL ARR_DBL.push(work_arr#(), arr#(i&))
        NEXT i&
        ' insert new element
        CALL ARR_DBL.push(work_arr#(), value#)
        ' finish building array from index + 1
        FOR i& = index% + 1 TO ub&
            CALL ARR_DBL.push(work_arr#(), arr#(i&))
        NEXT i&
        CALL ARR_DBL.shift(work_arr#(), tmp#)
        CALL ARR_DBL.copy(work_arr#(), arr#())
    END IF
END SUB


''
' Removes element from a DOUBLE array by element index
' @param DOUBLE ARRAY arr#() array to work on
' @param INTEGER index% of element to remove
'
SUB ARR_DBL.remove(arr#(), index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    DIM work_arr(0) AS DOUBLE
    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index% - 1
            CALL ARR_DBL.push(work_arr#(), arr#(i&))
        NEXT i&
        ' skip elements
        FOR i& = index% + 1 TO ub&
            CALL ARR_DBL.push(work_arr#(), arr#(i&))
        NEXT i&
        CALL ARR_DBL.shift(work_arr#(), tmp#)
        CALL ARR_DBL.copy(work_arr#(), arr#())
    END IF
END SUB


''
' Filters a DOUBLE array to only elements that have odd values
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
'
SUB ARR_DBL.odd(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) MOD 2 <> 0 THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements that have even values
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
'
SUB ARR_DBL.even(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) MOD 2 = 0 THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements that have values evenly divisible by divisor
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
' @param DOUBLE divisor# for modulo
'
SUB ARR_DBL.mod(source_arr#(), dest_arr#(), divisor#)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) MOD divisor# = 0 THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Filters a DOUBLE array to only elements between min and max
' @param DOUBLE ARRAY source_arr#() array to work on
' @param DOUBLE ARRAY dest_arr#() array to store in
' @param DOUBLE min# to be greater than or equal to be returned
' @param DOUBLE max# to be less than or equal to be returned
'
SUB ARR_DBL.between(source_arr#(), dest_arr#(), min#, max#)
    DIM AS LONG lb, ub, i
    DIM tmp AS DOUBLE
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    DIM work_arr(0) AS DOUBLE
    FOR i& = lb& TO ub&
        IF source_arr#(i&) >= min# _
        AND source_arr#(i&) <= max# THEN
            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
        END IF
    NEXT i&
    CALL ARR_DBL.shift(work_arr#(), tmp#)
    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
END SUB


''
' Sorts DOUBLE array in ascending order
' @param DOUBLE ARRAY source_arr#() array to sort
' @param DOUBLE ARRAY dest_arr#() array to store sorted in
'
SUB ARR_DBL.sort(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS DOUBLE
    CALL ARR_DBL.copy(source_arr#(), dest_arr#())
    CALL ARR_DBL.quicksort(dest_arr#(), lb&, ub&, 0)
END SUB


''
' Sorts DOUBLE array in descending order
' @param DOUBLE ARRAY source_arr#() array to sort
' @param DOUBLE ARRAY dest_arr#() array to store sorted in
'
SUB ARR_DBL.rsort(source_arr#(), dest_arr#())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS DOUBLE
    CALL ARR_DBL.copy(source_arr#(), dest_arr#())
    CALL ARR_DBL.quicksort(dest_arr#(), lb&, ub&, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param DOUBLE ARRAY array#() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_DBL.quicksort(arr#(), start%, finish%, order%)
    DIM i AS LONG
    DIM pivot AS INTEGER
    DIM pivotvalue AS DOUBLE

    'first, partition the array
    pivot% = start%
    pivotvalue# = arr#(pivot%)
    FOR i& = start% + 1 TO finish%
        IF order% = 0 THEN ' ascending order
            IF arr#(i&) < pivotvalue# THEN
                arr#(pivot%) = arr#(i&)
                arr#(i&) = arr#(pivot% + 1)
                arr#(pivot% + 1) = pivotvalue#
                pivot% = pivot% + 1
            END IF
        ELSEIF order% = 1 THEN ' descending order
            IF arr#(i&) > pivotvalue# THEN
                arr#(pivot%) = arr#(i&)
                arr#(i&) = arr#(pivot% + 1)
                arr#(pivot% + 1) = pivotvalue#
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i&

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_DBL.quicksort(arr#(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_DBL.quicksort(arr#(), pivot% + 1, finish%, order%)
    END IF
END SUB
