''
' ZLIB.BI - ZLIB Decompression Support for QB64PE
' 
' Basic ZLIB/DEFLATE decompression implementation for Aseprite files
' This implements a simplified version of RFC 1951 (DEFLATE) and RFC 1950 (ZLIB)
'
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE

' ZLIB header constants
CONST ZLIB_CM_DEFLATE = 8    ' Compression method: DEFLATE
CONST ZLIB_FCHECK_MASK = 31  ' Check bits mask
CONST ZLIB_FDICT_FLAG = 32   ' Preset dictionary flag
CONST ZLIB_FLEVEL_MASK = 192 ' Compression level mask

' DEFLATE block types
CONST DEFLATE_BTYPE_NONE = 0      ' No compression
CONST DEFLATE_BTYPE_FIXED = 1     ' Compressed with fixed Huffman codes
CONST DEFLATE_BTYPE_DYNAMIC = 2   ' Compressed with dynamic Huffman codes
CONST DEFLATE_BTYPE_RESERVED = 3  ' Reserved (error)

' DEFLATE constants
CONST DEFLATE_MAX_BITS = 15       ' Maximum bits in a code
CONST DEFLATE_MAX_LCODES = 286    ' Maximum literal/length codes
CONST DEFLATE_MAX_DCODES = 30     ' Maximum distance codes
CONST DEFLATE_MAX_CODES = 316     ' Maximum codes total

TYPE ZLIB_HEADER
    compression_method AS _UNSIGNED _BYTE  ' CMF byte: Compression method (low 4 bits)
    compression_info   AS _UNSIGNED _BYTE  ' CMF byte: Compression info (high 4 bits)  
    fcheck             AS _UNSIGNED _BYTE  ' FLG byte: Check bits (low 5 bits)
    fdict              AS _UNSIGNED _BYTE  ' FLG byte: Preset dictionary flag (bit 5)
    flevel             AS _UNSIGNED _BYTE  ' FLG byte: Compression level (bits 6-7)
END TYPE

TYPE HUFFMAN_CODE
    bits   AS _UNSIGNED _BYTE     ' Number of bits in code
    symbol AS _UNSIGNED INTEGER   ' Symbol value
END TYPE

TYPE HUFFMAN_TABLE
    ' Huffman lookup table for fast decoding
    max_bits     AS INTEGER             ' Maximum code length
    min_bits     AS INTEGER             ' Minimum code length  
    num_symbols  AS INTEGER             ' Number of symbols
    ' Note: In a full implementation, we'd have arrays for:
    ' - code_lengths(0 TO 287) AS INTEGER
    ' - symbols(0 TO 287) AS INTEGER
    ' - codes(0 TO 287) AS LONG
    ' For now, we'll use a simplified approach
END TYPE

TYPE DEFLATE_STATE
    ' Input buffer
    input_data    AS STRING       ' Input compressed data
    input_pos     AS LONG         ' Current position in input
    input_bits    AS LONG         ' Bit buffer for input
    input_bitlen  AS INTEGER      ' Number of bits in bit buffer
    
    ' Output buffer  
    output_data   AS STRING       ' Output decompressed data
    output_pos    AS LONG         ' Current position in output
    
    ' Block state
    is_final      AS _BYTE        ' Is this the final block?
    block_type    AS _BYTE        ' Current block type
    
    ' For uncompressed blocks
    block_len     AS INTEGER      ' Length of uncompressed block
    block_nlen    AS INTEGER      ' One's complement of length
    
    ' Huffman tables
    lit_table    AS HUFFMAN_TABLE     ' Literal/length codes table
    dist_table   AS HUFFMAN_TABLE     ' Distance codes table
END TYPE

' Fixed Huffman code tables (RFC 1951)
' Literal/Length codes: 0-143 = 8 bits, 144-255 = 9 bits, 256-279 = 7 bits, 280-287 = 8 bits
' Distance codes: 0-31 = 5 bits

' Length base values and extra bits
CONST DEFLATE_LENGTH_BASES_COUNT = 29
CONST DEFLATE_DISTANCE_BASES_COUNT = 30

' Function declarations
DECLARE FUNCTION zlib_decompress$ (compressed_data$)
DECLARE FUNCTION zlib_parse_header% (data_input$, header AS ZLIB_HEADER)
DECLARE FUNCTION deflate_decompress$ (deflate_data$)
DECLARE FUNCTION deflate_read_bits% (state AS DEFLATE_STATE, num_bits AS INTEGER)
DECLARE FUNCTION deflate_process_block% (state AS DEFLATE_STATE)
DECLARE FUNCTION deflate_decode_fixed_huffman% (state AS DEFLATE_STATE)
DECLARE FUNCTION deflate_decode_dynamic_huffman% (state AS DEFLATE_STATE)
DECLARE FUNCTION deflate_decode_symbol% (state AS DEFLATE_STATE, is_literal AS INTEGER)
DECLARE FUNCTION deflate_get_length_extra_bits% (length_code AS INTEGER)
DECLARE FUNCTION deflate_get_distance_extra_bits% (distance_code AS INTEGER)
DECLARE FUNCTION deflate_build_huffman_table% (code_lengths() AS INTEGER, num_codes AS INTEGER, table AS HUFFMAN_TABLE)
DECLARE FUNCTION deflate_decode_symbol_dynamic% (state AS DEFLATE_STATE, table AS HUFFMAN_TABLE)
