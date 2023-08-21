#!/usr/bin/env bash

# generate was used on MacOS - so gnu-sed is needed on MacOS:
# brew install gnu-sed
# on linux, just replace $SED with sed
SED=gsed

TYPES=(
    BYTE
    UBYTE
    INT
    UINT
    LONG
    ULONG
    INT64
    UINT64
    SNG
    DBL
    FLT
)
for t in ${TYPES[@]}; do
    cp ARR_TEMPLATE.BAS "ARR_${t}.BAS"
done

# BYTE
$SED -i 's/{Q}/_BYTE/g' ARR_BYTE.BAS
$SED -i 's/{q}/_byte/g' ARR_BYTE.BAS
$SED -i 's/{UT}/BYTE/g' ARR_BYTE.BAS
$SED -i 's/{LT}/byte/g' ARR_BYTE.BAS
$SED -i 's/{SY}/%%/g' ARR_BYTE.BAS

# UBYTE
$SED -i 's/{Q}/_UNSIGNED _BYTE/g' ARR_UBYTE.BAS
$SED -i 's/{q}/_unsigned _byte/g' ARR_UBYTE.BAS
$SED -i 's/{UT}/UBYTE/g' ARR_UBYTE.BAS
$SED -i 's/{LT}/ubyte/g' ARR_UBYTE.BAS
$SED -i 's/{SY}/~%%/g' ARR_UBYTE.BAS

# INT
$SED -i 's/{Q}/INTEGER/g' ARR_INT.BAS
$SED -i 's/{q}/INTEGER/g' ARR_INT.BAS
$SED -i 's/{UT}/INT/g' ARR_INT.BAS
$SED -i 's/{LT}/int/g' ARR_INT.BAS
$SED -i 's/{SY}/~%/g' ARR_INT.BAS

# UINT
$SED -i 's/{Q}/_UNSIGNED INTEGER/g' ARR_UINT.BAS
$SED -i 's/{q}/_unsigned INTEGER/g' ARR_UINT.BAS
$SED -i 's/{UT}/UINT/g' ARR_UINT.BAS
$SED -i 's/{LT}/uint/g' ARR_UINT.BAS
$SED -i 's/{SY}/~%/g' ARR_UINT.BAS

# LONG
$SED -i 's/{Q}/LONG/g' ARR_LONG.BAS
$SED -i 's/{q}/long/g' ARR_LONG.BAS
$SED -i 's/{UT}/LONG/g' ARR_LONG.BAS
$SED -i 's/{LT}/long/g' ARR_LONG.BAS
$SED -i 's/{SY}/\&/g' ARR_LONG.BAS

# ULONG
$SED -i 's/{Q}/_UNSIGNED LONG/g' ARR_ULONG.BAS
$SED -i 's/{q}/_unsigned long/g' ARR_ULONG.BAS
$SED -i 's/{UT}/ULONG/g' ARR_ULONG.BAS
$SED -i 's/{LT}/ulong/g' ARR_ULONG.BAS
$SED -i 's/{SY}/~\&/g' ARR_ULONG.BAS

# INT64
$SED -i 's/{Q}/_INTEGER64/g' ARR_INT64.BAS
$SED -i 's/{q}/_integer64/g' ARR_INT64.BAS
$SED -i 's/{UT}/INT64/g' ARR_INT64.BAS
$SED -i 's/{LT}/int64/g' ARR_INT64.BAS
$SED -i 's/{SY}/\&\&/g' ARR_INT64.BAS

# UINT64
$SED -i 's/{Q}/_UNSIGNED _INTEGER64/g' ARR_UINT64.BAS
$SED -i 's/{q}/_unsigned _integer64/g' ARR_UINT64.BAS
$SED -i 's/{UT}/UINT64/g' ARR_UINT64.BAS
$SED -i 's/{LT}/uint64/g' ARR_UINT64.BAS
$SED -i 's/{SY}/~\&\&/g' ARR_UINT64.BAS

# SNG
$SED -i 's/{Q}/SINGLE/g' ARR_SNG.BAS
$SED -i 's/{q}/single/g' ARR_SNG.BAS
$SED -i 's/{UT}/SNG/g' ARR_SNG.BAS
$SED -i 's/{LT}/sng/g' ARR_SNG.BAS
$SED -i 's/{SY}/!/g' ARR_SNG.BAS

# DBL
$SED -i 's/{Q}/DOUBLE/g' ARR_DBL.BAS
$SED -i 's/{q}/double/g' ARR_DBL.BAS
$SED -i 's/{UT}/DBL/g' ARR_DBL.BAS
$SED -i 's/{LT}/dbl/g' ARR_DBL.BAS
$SED -i 's/{SY}/#/g' ARR_DBL.BAS

# FLT
$SED -i 's/{Q}/_FLOAT/g' ARR_FLT.BAS
$SED -i 's/{q}/_float/g' ARR_FLT.BAS
$SED -i 's/{UT}/FLT/g' ARR_FLT.BAS
$SED -i 's/{LT}/flt/g' ARR_FLT.BAS
$SED -i 's/{SY}/##/g' ARR_FLT.BAS

# STR
$SED -i 's/{Q}/STRING/g' ARR_STR.BAS
$SED -i 's/{q}/string/g' ARR_STR.BAS
$SED -i 's/{UT}/STR/g' ARR_STR.BAS
$SED -i 's/{LT}/str/g' ARR_STR.BAS
$SED -i 's/{SY}/$/g' ARR_STR.BAS
