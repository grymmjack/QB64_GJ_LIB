''
' ZLIB TEST - Test ZLIB decompression capabilities
'
OPTION _EXPLICIT

'$INCLUDE:'ZLIB.BI'

DIM test_data$, result$

_CONSOLE ON

PRINT "ZLIB DECOMPRESSION TEST"
PRINT "======================"
PRINT

' Test 1: Simple uncompressed ZLIB data
PRINT "Test 1: Creating simple test data..."

' Create a simple ZLIB header + uncompressed DEFLATE block + checksum
' ZLIB header: CMF=0x78 (DEFLATE, 32K window), FLG=0x01 (no dict, fastest compression, check=0x01)
' DEFLATE: BFINAL=1, BTYPE=00 (uncompressed), LEN=5, NLEN=65530, data="HELLO"
' Checksum: Adler-32 (4 bytes)

test_data$ = CHR$(&H78) + CHR$(&H01)  ' ZLIB header (should pass checksum)
test_data$ = test_data$ + CHR$(&H05)  ' DEFLATE: BFINAL=1, BTYPE=00, first 3 bits of LEN
test_data$ = test_data$ + CHR$(&H00) + CHR$(&H00)  ' LEN = 5 (little-endian)
test_data$ = test_data$ + CHR$(&HFA) + CHR$(&HFF)  ' NLEN = 65530 (one's complement of 5)
test_data$ = test_data$ + "HELLO"    ' Uncompressed data
test_data$ = test_data$ + CHR$(&H05) + CHR$(&H7C) + CHR$(&H01) + CHR$(&HF5)  ' Dummy Adler-32

PRINT "Test data created: "; LEN(test_data$); " bytes"

result$ = zlib_decompress_simple$(test_data$)

IF LEN(result$) > 0 THEN
    PRINT "✓ ZLIB decompression successful!"
    PRINT "  Decompressed: '"; result$; "'"
    PRINT "  Length: "; LEN(result$); " bytes"
ELSE
    PRINT "✗ ZLIB decompression failed"
END IF

PRINT
PRINT "ZLIB test completed."
SYSTEM

'$INCLUDE:'ZLIB.BM'
