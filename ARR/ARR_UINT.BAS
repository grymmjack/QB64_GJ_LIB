
'_UNSIGNED INTEGER = actual type used in syntax uppercase         _BYTE       _UNSIGNED _BYTE     INTEGER     _UNSIGNED INTEGER   LONG    _UNSIGNED LONG  _INTEGER64  _UNSIGNED _INTEGER64    SINGLE  DOUBLE  _FLOAT
'_unsigned INTEGER = actual type used in syntax as lowercase      _byte       _unsigned _byte     integer     _unsigned integer   long    _unsigned long  _integer64  _unsigned _integer64    single  double  _float
'UINT = uppercase type full name identifier         BYTE        UBYTE               INTEGER     UNSIGNED INTEGER    LONG    ULONG           INTEGER64   UINT64                  SINGLE  DOUBLE  FLOAT
'uint = lowercase type full name identifier         byte        ubyte               integer     unsigned integer    long    ulong           integer64   uint64                  single  double  float
'~% = sigil                                       %%          ~%%                 %           ~%                  &       ~&              &&          ~&&                     !       #       ##

'_UNSIGNED INTEGER = actual type used in syntax uppercase         STRING
'_unsigned INTEGER = actual type used in syntax as lowercase      string
'UINT = uppercase type full name identifier         STRING
'uint = lowercase type full name identifier         string
'~% = sigil                                       $

'$DYNAMIC
OPTION _EXPLICIT



''
' Slice an array from source to destination starting at index and count slices
'
' @param UINT() source_arr~% to slice from
' @param UINT() dest_arr~% to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_UINT.slice(source_arr~%(), dest_arr~%(), start_idx%, count%)
    DIM AS LONG ub, lb, i, n
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED INTEGER
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr~%(n&) = source_arr~%(i&)
            n& = n& + 1
        NEXT i&
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
        n& = 0
        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr~%(n&) = source_arr~%(i&)
            n& = n& + 1
        NEXT i&
    END IF
END SUB


''
' Push a uint onto the end of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER arr~%() array to push into
' @param _UNSIGNED INTEGER value~% of byte to push
'
SUB ARR_UINT.push(arr~%(), value~%)
    DIM AS LONG ub, lb
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED INTEGER
    arr~%(ub& + 1) = value~%
END SUB


''
' Pop a uint from the end of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER arr~%() array to pop from
' @param _UNSIGNED INTEGER var~% of uint to store popped uint
'
SUB ARR_UINT.pop(arr~%(), var~%)
    DIM AS LONG ub, lb
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    var~% = arr~%(ub&)
    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED INTEGER
END SUB


''
' Pop a uint from the beginning of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER arr~%() array to pop from
' @param _UNSIGNED INTEGER var~% of uint to store popped uint
'
SUB ARR_UINT.shift(arr~%(), var~%)
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    var~% = arr~%(lb&)
    FOR i& = lb& TO ub& - 1
        arr~%(i&) = arr~%(i& + 1) 
    NEXT i&
    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED INTEGER
END SUB


''
' Copy an array of UINTs to another _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY source_arr~%() source array to copy
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() dest array to copy into
'
SUB ARR_UINT.copy(source_arr~%(), dest_arr~%())
    DIM AS LONG ub, lb, i
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        dest_arr~%(i&) = source_arr~%(i&)
    NEXT i&
END SUB


''
' Push a uint into the beginning of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER arr~%() array to push into
' @param _UNSIGNED INTEGER value~% of uint to push
'
SUB ARR_UINT.unshift(arr~%(), value~%)
    DIM AS LONG ub, lb, i
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    DIM work(lb& TO ub&) AS _UNSIGNED INTEGER
    CALL ARR_UINT.copy(arr~%(), work~%())
    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED INTEGER
    FOR i& = lb& + 1 TO ub& + 1
        arr~%(i&) = work~%(i& - 1)
    NEXT i&
    arr~%(lb&) = value~%
END SUB


''
' Joins an array of UINTs as a string
' @param _UNSIGNED INTEGER ARRAY arr~%() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_UINT.join(arr~%(), s$)
    DIM AS LONG ub, lb, i
    s$ = ""
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    FOR i& = lb& TO ub&
        s$ = s$ + _TRIM$(STR$(arr~%(i&))) + ", "
    NEXT i&
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
END SUB


''
' Create a new _UNSIGNED INTEGER array using string of uints seperated by commas
' @param _UNSIGNED INTEGER ARRAY arr~%() to store the uints in
' @param STRING s$ string of comma separated uints
'
SUB ARR_UINT.new(arr~%(), s$)
    DIM AS LONG i, count
    DIM t AS STRING
    count& = 0
    FOR i& = 1 TO LEN(s$)
        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
    NEXT i&
    REDIM arr(0 TO count&) AS _UNSIGNED INTEGER
    IF count& = 0 THEN
        arr~%(0) = VAL(s$)
        EXIT SUB
    END IF
    count& = 0
    FOR i& = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i&))
        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
            arr~%(count&) = VAL(t$)
            count& = count& + 1
            t$ = ""
        END IF
    NEXT i&
END SUB


''
' Return the visually longest element of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @return _UNSIGNED INTEGER value of visually longest element
'
FUNCTION ARR_UINT.longest~%(arr~%())
    DIM AS LONG lb, ub, i, res, lw
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    res& = 0 : lw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr~%(i&)))) > lw& THEN
            lw&  = LEN(_TRIM$(STR$(arr~%(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_UINT.longest~% = arr~%(res&)
END FUNCTION


''
' Perform some math on every element of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY source_arr~%() to do math on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store results in
' @param STRING op$ one of:
'                          and   or    xor   shl   shr 
' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
' @param _UNSIGNED INTEGER value~% to use for operand
'
SUB ARR_UINT.math(source_arr~%(), dest_arr~%(), op$, value~%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        SELECT CASE op$
            CASE "+":
                dest_arr~%(i&) = source_arr~%(i&) + value~%
            CASE "-":
                dest_arr~%(i&) = source_arr~%(i&) - value~%
            CASE "*":
                dest_arr~%(i&) = source_arr~%(i&) * value~%
            CASE "\":
                IF value~% > 0 THEN
                    dest_arr~%(i&) = source_arr~%(i&) \ value~%
                END IF
            CASE "&&":
                dest_arr~%(i&) = source_arr~%(i&) AND value~%
            CASE "||":
                dest_arr~%(i&) = source_arr~%(i&) OR value~%
            CASE "!!":
                dest_arr~%(i&) = source_arr~%(i&) XOR value~%
            CASE "<<":
                dest_arr~%(i&) = _SHL(source_arr~%(i&), value~%)
            CASE ">>":
                dest_arr~%(i&) = _SHR(source_arr~%(i&), value~%)
        END SELECT
    NEXT i&
END SUB


''
' Return the minimum element value in _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @return _UNSIGNED INTEGER minimum value found
'
FUNCTION ARR_UINT.min~%(arr~%())
    DIM AS LONG lb, ub, i
    DIM AS _UNSIGNED INTEGER s
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    s~% = 127
    FOR i& = lb& TO ub&
        IF arr~%(i&) < s~% THEN
            s~% = arr~%(i&)
        END IF
    NEXT i&
    ARR_UINT.min~% = s~%
END FUNCTION


''
' Return the maximum element value in _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @return _UNSIGNED INTEGER maximum value found
'
FUNCTION ARR_UINT.max~%(arr~%())
    DIM AS LONG lb, ub, i
    DIM AS _UNSIGNED INTEGER s
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    s~% = 0
    FOR i& = lb& TO ub&
        IF arr~%(i&) > s~% THEN
            s~% = arr~%(i&)
        END IF
    NEXT i&
    ARR_UINT.max~% = s~%
END FUNCTION


''
' Return the visually shortest element of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @return _UNSIGNED INTEGER value of visually shortest element
'
FUNCTION ARR_UINT.shortest~%(arr~%())
    DIM AS LONG lb, ub, i, res, sw
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    res& = 0 : sw& = 0
    FOR i& = lb& TO ub&
        IF LEN(_TRIM$(STR$(arr~%(i&)))) < sw& THEN
            sw&  = LEN(_TRIM$(STR$(arr~%(i&))))
            res& = i&
        END IF
    NEXT i&
    ARR_UINT.shortest~% = arr~%(res&)
END FUNCTION


''
' Return the first element of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @return _UNSIGNED INTEGER value of first element
'
FUNCTION ARR_UINT.first~%(arr~%())
    ARR_UINT.first~% = arr~%(LBOUND(arr~%))
END FUNCTION


''
' Return the last element of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @return _UNSIGNED INTEGER value of last element
'
FUNCTION ARR_UINT.last~%(arr~%())
    ARR_UINT.last~% = arr~%(UBOUND(arr~%))
END FUNCTION


''
' Return every nth array element of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY source_arr~%() to get from
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store in
' @param INTEGER nth% element
'
SUB ARR_UINT.nth(source_arr~%(), dest_arr~%(), nth%)
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    n& = (ub& - lb&) \ nth%
    REDIM dest_arr(n&) AS _UNSIGNED INTEGER
    n& = 0
    FOR i& = lb& to ub&
        IF i& MOD nth% = 0 THEN
            dest_arr~%(n&) = source_arr~%(i&)
            n& = n& + 1
        END IF
    NEXT i&
END SUB


''
' Checks if value exists in _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @param _UNSIGNED INTEGER value~% value to check for
' @return INTEGER -1 if found or 0 if not found
'
FUNCTION ARR_UINT.in%(arr~%(), value~%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    FOR i& = lb& TO ub&
        IF arr~%(i&) = value~% THEN
            ARR_UINT.in% = -1
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_UINT.in% = 0
END FUNCTION


''
' Checks if value exists in _UNSIGNED INTEGER array and returns index if found
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @param _UNSIGNED INTEGER value~% value to check for
' @return INTEGER index of element if found or -1 if not found
'
FUNCTION ARR_UINT.find%(arr~%(), value~%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    FOR i& = lb& TO ub&
        IF arr~%(i&) = value~% THEN
            ARR_UINT.find% = i&
            EXIT FUNCTION
        END IF
    NEXT i&
    ARR_UINT.find% = -1
END FUNCTION


''
' Return the number of elements in a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to count
' @return INTEGER number of elements
'
FUNCTION ARR_UINT.count&(arr~%())
    ARR_UINT.count& = UBOUND(arr~%) - LBOUND(arr~%)
END FUNCTION


''
' Return the size of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() to get size of
' @return LONG size in bytes
'
FUNCTION ARR_UINT.size&(arr~%())
    ARR_UINT.size& = LEN(arr~%())
END FUNCTION


''
' Reverses the elements of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY source_arr~%() to reverse
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store reversed array in
'
SUB ARR_UINT.reverse(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, i, n
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED INTEGER
    n& = 0
    FOR i& = ub& TO lb& STEP -1
        dest_arr~%(n&) = source_arr~%(i&)
        n& = n& + 1
    NEXT i&
END SUB


''
' Returns a random uint from a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() array to get random element from
' @return _UNSIGNED INTEGER random element
'
FUNCTION ARR_UINT.random~%(arr~%())
    DIM AS LONG lb, ub
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    RANDOMIZE TIMER 
    ARR_UINT.random~% = arr~%(INT(RND * (ub& - lb&)) + 1)
END FUNCTION


''
' Returns the sum of all elements in a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() array to get some for
' @return LONG sum of all elements
'
FUNCTION ARR_UINT.sum&(arr~%())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    FOR i& = lb& TO ub&
        sum& = sum& + arr~%(i&)
    NEXT i&
    ARR_UINT.sum& = sum&
END FUNCTION


''
' Returns the average value of elements in a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY arr~%() array to get average for
' @return LONG average of elements
'
FUNCTION ARR_UINT.avg&(arr~%())
    DIM AS LONG lb, ub, i
    DIM sum AS LONG
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    FOR i& = lb& TO ub&
        sum& = sum& + arr~%(i&)
    NEXT i&
    ARR_UINT.avg& = sum& / (ub& - lb&)
END FUNCTION


''
' Shuffle the elements of a _UNSIGNED INTEGER array
' @param _UNSIGNED INTEGER ARRAY source_arr~%() to shuffle
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store shuffled array in
'
SUB ARR_UINT.shuffle(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, i, count
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED INTEGER
    CALL ARR_UINT.copy(source_arr~%(), dest_arr~%())
    RANDOMIZE TIMER 
    FOR i& = 0 TO count&
        SWAP dest_arr~%(i&), dest_arr~%(lb& + RND * (ub& - lb&)) 
    NEXT i&
END SUB


''
' Makes a _UNSIGNED INTEGER array contain only unique values
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to get uniques for
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store uniques in
'
SUB ARR_UINT.unique(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF NOT ARR_UINT.in%(work_arr~%(), source_arr~%(i&)) THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements greater than value
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
' @param _UNSIGNED INTEGER value~% to be greater than to be returned
'
SUB ARR_UINT.gt(source_arr~%(), dest_arr~%(), value~%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) > value~% THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements greater than or equal to value
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
' @param _UNSIGNED INTEGER value~% to be greater than or equal to be returned
'
SUB ARR_UINT.gte(source_arr~%(), dest_arr~%(), value~%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) >= value~% THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements less than value
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
' @param _UNSIGNED INTEGER value~% to be less than to be returned
'
SUB ARR_UINT.lt(source_arr~%(), dest_arr~%(), value~%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) < value~% THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements less than or equal to value
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
' @param _UNSIGNED INTEGER value~% to be less than or equal to be returned
'
SUB ARR_UINT.lte(source_arr~%(), dest_arr~%(), value~%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) <= value~% THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Finds and replaces values across all elements in a _UNSIGNED INTEGER ARRAY
' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
' @param _UNSIGNED INTEGER find~% value to find
' @param _UNSIGNED INTEGER replace~% value to replace with if found
'
SUB ARR_UINT.replace(arr~%(), find~%, replace~%)
    DIM AS LONG lb, ub, i
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    FOR i& = lb& TO ub&
        IF arr~%(i&) = find~% THEN
            arr~%(i&) = replace~%
        END IF
    NEXT i&
END SUB


''
' Inserts a new element into _UNSIGNED INTEGER array after index
' @param _UNSIGNED INTEGER ARRAY arr~%() array to work on
' @param _UNSIGNED INTEGER value~% to insert
' @param INTEGER index% of element to insert at
'
SUB ARR_UINT.insert(arr~%(), value~%, index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    DIM work_arr(0) AS _UNSIGNED INTEGER
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index%
            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
        NEXT i&
        ' insert new element
        CALL ARR_UINT.push(work_arr~%(), value~%)
        ' finish building array from index + 1
        FOR i& = index% + 1 TO ub&
            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
        NEXT i&
        CALL ARR_UINT.shift(work_arr~%(), tmp~%)
        CALL ARR_UINT.copy(work_arr~%(), arr~%())
    END IF
END SUB


''
' Removes element from a _UNSIGNED INTEGER array by element index
' @param _UNSIGNED INTEGER ARRAY arr~%() array to work on
' @param INTEGER index% of element to remove
'
SUB ARR_UINT.remove(arr~%(), index%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    DIM work_arr(0) AS _UNSIGNED INTEGER
    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
    IF index% >= lb& AND index% <= ub& THEN
        ' build new array up to index
        FOR i& = lb& TO index% - 1
            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
        NEXT i&
        ' skip elements
        FOR i& = index% + 1 TO ub&
            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
        NEXT i&
        CALL ARR_UINT.shift(work_arr~%(), tmp~%)
        CALL ARR_UINT.copy(work_arr~%(), arr~%())
    END IF
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements that have odd values
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
'
SUB ARR_UINT.odd(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) MOD 2 <> 0 THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements that have even values
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
'
SUB ARR_UINT.even(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) MOD 2 = 0 THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements that have values evenly divisible by divisor
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
' @param _UNSIGNED INTEGER divisor~% for modulo
'
SUB ARR_UINT.mod(source_arr~%(), dest_arr~%(), divisor~%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) MOD divisor~% = 0 THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Filters a _UNSIGNED INTEGER array to only elements between min and max
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
' @param _UNSIGNED INTEGER min~% to be greater than or equal to be returned
' @param _UNSIGNED INTEGER max~% to be less than or equal to be returned
'
SUB ARR_UINT.between(source_arr~%(), dest_arr~%(), min~%, max~%)
    DIM AS LONG lb, ub, i
    DIM tmp AS _UNSIGNED INTEGER
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    DIM work_arr(0) AS _UNSIGNED INTEGER
    FOR i& = lb& TO ub&
        IF source_arr~%(i&) >= min~% _
        AND source_arr~%(i&) <= max~% THEN
            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
        END IF
    NEXT i&
    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
END SUB


''
' Sorts _UNSIGNED INTEGER array in ascending order
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to sort
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store sorted in
'
SUB ARR_UINT.sort(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED INTEGER
    CALL ARR_UINT.copy(source_arr~%(), dest_arr~%())
    CALL ARR_UINT.quicksort(dest_arr~%(), lb&, ub&, 0)
END SUB


''
' Sorts _UNSIGNED INTEGER array in descending order
' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to sort
' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store sorted in
'
SUB ARR_UINT.rsort(source_arr~%(), dest_arr~%())
    DIM AS LONG lb, ub, count
    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
    count& = ub& - lb&
    REDIM dest_arr(0 TO count&) AS _UNSIGNED INTEGER
    CALL ARR_UINT.copy(source_arr~%(), dest_arr~%())
    CALL ARR_UINT.quicksort(dest_arr~%(), lb&, ub&, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param _UNSIGNED INTEGER ARRAY array~%() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_UINT.quicksort(arr~%(), start%, finish%, order%)
    DIM i AS LONG
    DIM pivot AS INTEGER
    DIM pivotvalue AS _UNSIGNED INTEGER

    'first, partition the array
    pivot% = start%
    pivotvalue~% = arr~%(pivot%)
    FOR i& = start% + 1 TO finish%
        IF order% = 0 THEN ' ascending order
            IF arr~%(i&) < pivotvalue~% THEN
                arr~%(pivot%) = arr~%(i&)
                arr~%(i&) = arr~%(pivot% + 1)
                arr~%(pivot% + 1) = pivotvalue~%
                pivot% = pivot% + 1
            END IF
        ELSEIF order% = 1 THEN ' descending order
            IF arr~%(i&) > pivotvalue~% THEN
                arr~%(pivot%) = arr~%(i&)
                arr~%(i&) = arr~%(pivot% + 1)
                arr~%(pivot% + 1) = pivotvalue~%
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i&

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_UINT.quicksort(arr~%(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_UINT.quicksort(arr~%(), pivot% + 1, finish%, order%)
    END IF
END SUB
