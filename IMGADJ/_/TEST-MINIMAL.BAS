DECLARE FUNCTION TestFunc

DIM result AS LONG
result = TestFunc
PRINT "Result: "; result

FUNCTION TestFunc
    TestFunc = 42
END FUNCTION
