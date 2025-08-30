''
' TEST SIMPLE FUNCTION
''

$CONSOLE:ONLY

DIM result AS LONG
result = TestFunc&()
PRINT "Result:", result
SYSTEM

FUNCTION TestFunc& ()
    TestFunc& = 42
END FUNCTION
