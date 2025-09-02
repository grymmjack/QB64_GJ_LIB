# [QB64_GJ_LIB](../README.md) 
## GRYMMJACK'S IMAGE ADJUSTMENT (IMGADJ) LIBRARY

> This library provides optimized image adjustment algorithms for QB64PE.
> All functions work by creating new image handles - original images are preserved.
> Features ultra-fast _MEMIMAGE operations, lookup tables, and pre-computed noise patterns.

### WHY?

Image adjustment is a common need in graphics programming, but implementing efficient algorithms from scratch is time-consuming and error-prone. This library provides:

- **Professional-grade algorithms** with optimized implementations
- **Clean, consistent API** - same pattern for all adjustments
- **Memory safety** - clear ownership of returned image handles
- **Performance** - 10-200x faster than naive implementations
- **Real-time capability** - suitable for interactive applications
- **Selective processing** - NEW! Non-black adjustments preserve pure black pixels

The library draws inspiration from professional image editing software like Photoshop and GIMP, providing similar adjustment capabilities in a QB64PE-friendly format.

### **NEW!** Selective Black Preservation

The `GJ_IMGADJ_BrightnessContrastNonBlack&()` function addresses a common problem in image processing: maintaining pure black elements while adjusting the rest of the image.

**Problem Solved:**
- Traditional brightness adjustments turn black (RGB 0,0,0) pixels gray
- Black text, outlines, borders, and UI elements lose their crispness
- Logos and graphics with black elements become muddy

**Solution Benefits:**
- **Preserves text readability** - Black text stays perfectly black
- **Maintains UI crispness** - Black borders and outlines remain sharp
- **Artistic control** - Keep pure black shadows and artistic elements
- **Logo processing** - Enhance colored portions without affecting black elements
- **Efficient processing** - Single function combines brightness + contrast with pixel selection

## WHAT'S IN THE LIBRARY

### Core Adjustments
| FUNCTION | PURPOSE | PARAMETERS | PERFORMANCE |
|----------|---------|------------|-------------|
| `GJ_IMGADJ_Brightness&()` | Adjust image brightness | `(img&, "+"/"-", amount%)` | 10-50x faster with _MEMIMAGE |
| `GJ_IMGADJ_Contrast&()` | Adjust image contrast | `(img&, "+"/"-", percentage%)` | 10-50x faster with _MEMIMAGE |
| `GJ_IMGADJ_BrightnessContrastNonBlack&()` | **NEW!** Adjust brightness/contrast while preserving black pixels | `(img&, brightDir$, brightAmt%, contrastDir$, contrastAmt%)` | Selective pixel processing |
| `GJ_IMGADJ_Gamma&()` | Gamma correction | `(img&, "+"/"-", amount%)` | 100x faster with lookup tables |
| `GJ_IMGADJ_Saturation&()` | Adjust color saturation | `(img&, "+"/"-", percentage%)` | HSV color space conversion |
| `GJ_IMGADJ_Hue&()` | Shift hue around color wheel | `(img&, "+"/"-", degrees%)` | HSV color space conversion |
| `GJ_IMGADJ_Colorize&()` | Apply specific hue/saturation | `(img&, hue%, saturation!)` | HSV color space conversion |

### Creative Effects
| FUNCTION | PURPOSE | PARAMETERS | PERFORMANCE |
|----------|---------|------------|-------------|
| `GJ_IMGADJ_Blur&()` | Apply blur effect | `(img&, radius%)` | Box filter implementation |
| `GJ_IMGADJ_Glow&()` | Add glow effect | `(img&, radius%, intensity%)` | Additive blend with blur |
| `GJ_IMGADJ_FilmGrain&()` | Add film grain noise | `(img&, amount%)` | 100x faster with pre-computed noise |
| `GJ_IMGADJ_Vignette&()` | Darken image edges | `(img&, strength!)` | 50x faster with optimized distance |
| `GJ_IMGADJ_Posterize&()` | Reduce color levels | `(img&, levels%)` | 100x faster with lookup tables |
| `GJ_IMGADJ_Sepia&()` | Apply sepia tone | `(img&)` | Optimized color transformation |
| `GJ_IMGADJ_Invert&()` | Invert all colors | `(img&)` | 50x faster with _MEMIMAGE |
| `GJ_IMGADJ_Pixelate&()` | Create retro pixelated effect | `(img&, pixelSize%)` | Block-based image downsampling |

### Utility Functions
| FUNCTION | PURPOSE | PARAMETERS | PERFORMANCE |
|----------|---------|------------|-------------|
| `GJ_IMGADJ_Threshold&()` | Binary threshold | `(img&, threshold%, mode%)` | Luminance-based conversion |
| `GJ_IMGADJ_Desaturate&()` | Convert to grayscale | `(img&, method%)` | Average or luminance methods |
| `GJ_IMGADJ_Levels&()` | Adjust input/output levels | `(img&, inMin%, inMax%, outMin%, outMax%)` | 50x faster with lookup tables |
| `GJ_IMGADJ_ColorBalance&()` | Adjust RGB balance | `(img&, redShift%, greenShift%, blueShift%)` | Direct channel manipulation |

### Dithering Algorithms
| FUNCTION | PURPOSE | PARAMETERS | ALGORITHM TYPE |
|----------|---------|------------|----------------|
| `GJ_IMGADJ_DitherFloydSteinberg&()` | Classic error diffusion | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherJarvisJudiceNinke&()` | Enhanced error diffusion | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherStucki&()` | Sharp error diffusion | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherBurkes&()` | Balanced error diffusion | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherSierra3&()` | Sierra Three-Row filter | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherSierra2&()` | Sierra Two-Row filter | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherSierraLite&()` | Simplified Sierra filter | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherAtkinson&()` | Apple Atkinson dithering | `(img&, amount!)` | Error Diffusion |
| `GJ_IMGADJ_DitherBayer2x2&()` | 2x2 ordered matrix | `(img&, amount!)` | Ordered Dithering |
| `GJ_IMGADJ_DitherBayer4x4&()` | 4x4 ordered matrix | `(img&, amount!)` | Ordered Dithering |
| `GJ_IMGADJ_DitherBayer8x8&()` | 8x8 ordered matrix | `(img&, amount!)` | Ordered Dithering |
| `GJ_IMGADJ_DitherBayer16x16&()` | 16x16 ordered matrix | `(img&, amount!)` | Ordered Dithering |
| `GJ_IMGADJ_DitherRandom&()` | Random noise dithering | `(img&, amount!)` | Random/Noise |
| `GJ_IMGADJ_DitherBlueNoise&()` | High-frequency noise | `(img&, amount!)` | Random/Noise |
| `GJ_IMGADJ_DitherHalftone&()` | Print halftone simulation | `(img&, amount!)` | Special Pattern |
| `GJ_IMGADJ_DitherSpiral&()` | Spiral pattern dithering | `(img&, amount!)` | Special Pattern |
| `GJ_IMGADJ_DitherClusteredDot&()` | Clustered dot pattern | `(img&, amount!)` | Special Pattern |

> **NEW!** Comprehensive dithering algorithms for artistic effects, retro graphics, and print simulation. All algorithms support adjustable intensity (0.0-1.0) for fine control over the dithering effect.

#### Dithering Algorithm Categories

**Error Diffusion Algorithms:**
- **Floyd-Steinberg (1976)**: Classic 4-neighbor diffusion, fast and widely supported
- **Jarvis-Judice-Ninke (1976)**: 12-neighbor diffusion, smoother gradients but slower
- **Stucki (1981)**: 12-neighbor diffusion optimized for edge preservation  
- **Burkes (1988)**: 7-neighbor diffusion, good speed/quality balance
- **Sierra Three-Row**: 10-neighbor diffusion with three-row pattern
- **Sierra Two-Row**: 7-neighbor diffusion with two-row pattern  
- **Sierra Lite**: 4-neighbor simplified Sierra algorithm
- **Atkinson**: Apple's 6-neighbor algorithm, preserves highlights

**Ordered Dithering (Bayer Matrices):**
- **2x2 Bayer**: Creates 4-level patterns, coarse but fast
- **4x4 Bayer**: Creates 16-level patterns, most common choice
- **8x8 Bayer**: Creates 64-level patterns, fine detail preservation
- **16x16 Bayer**: Creates 256-level patterns, smoothest gradients

**Random/Noise Dithering:**
- **Random**: Pure random noise, organic film grain effect
- **Blue Noise**: High-frequency noise, visually pleasing patterns

**Special Pattern Dithering:**
- **Halftone**: Traditional print halftone dot patterns
- **Spiral**: Artistic spiral patterns following image contours
- **Clustered Dot**: Grouped pixel patterns for smooth tones

### Pixel Scaling (Retro Graphics)
| FUNCTION | PURPOSE | PARAMETERS | PERFORMANCE |
|----------|---------|------------|-------------|
| `GJ_IMGADJ_PixelScaler&()` | Apply pixel scaling algorithms | `(img&, scalerType%)` | Hardware-accelerated scaling |

> **NEW!** Advanced pixel scaling algorithms for retro game graphics and pixel art. Uses QB64PE's built-in pixel scalers for professional-quality upscaling that preserves sharp edges and pixel art characteristics.

#### Pixel Scaler Types
| CONSTANT | ALGORITHM | SCALE FACTOR | BEST FOR |
|----------|-----------|--------------|----------|
| `GJ_IMGADJ_PIXELSCALER_SXBR2` | xBRZ 2x | 2x | General purpose pixel art |
| `GJ_IMGADJ_PIXELSCALER_SXBR3` | xBRZ 3x | 3x | General purpose pixel art |
| `GJ_IMGADJ_PIXELSCALER_SXBR4` | xBRZ 4x | 4x | General purpose pixel art |
| `GJ_IMGADJ_PIXELSCALER_MMPX2` | MMPX Style-Preserving 2x | 2x | Preserving art style |
| `GJ_IMGADJ_PIXELSCALER_HQ2XA` | High Quality Cartoon 2x | 2x | Cartoon/anime art |
| `GJ_IMGADJ_PIXELSCALER_HQ2XB` | High Quality Complex 2x | 2x | Complex detailed art |
| `GJ_IMGADJ_PIXELSCALER_HQ3XA` | High Quality Cartoon 3x | 3x | Cartoon/anime art |
| `GJ_IMGADJ_PIXELSCALER_HQ3XB` | High Quality Complex 3x | 3x | Complex detailed art |

#### Algorithm Details

**xBRZ (Scale by Rules) Scalers:**
- **SXBR2/3/4**: General-purpose pixel scalers that detect patterns and enhance edges
- **Best for**: Classic pixel art, retro game graphics, 8-bit/16-bit style artwork
- **Features**: Sharp edge preservation, pattern recognition, anti-aliasing

**MMPX (Style-Preserving) Scaler:**
- **MMPX2**: Maintains the original artistic style and character of pixel art
- **Best for**: Artwork where maintaining the exact visual style is critical
- **Features**: Preserves pixel art aesthetics, minimal smoothing

**HQ2X/HQ3X (High Quality) Scalers:**
- **HQ2XA/HQ3XA**: Optimized for cartoon and anime-style artwork
- **HQ2XB/HQ3XB**: Optimized for complex detailed artwork
- **Best for**: Modern pixel art, detailed sprites, artwork with fine details
- **Features**: Advanced pattern detection, smooth curves, gradient enhancement

### Test Utilities
| FUNCTION | PURPOSE | PARAMETERS | NOTES |
|----------|---------|------------|-------|
| `GJ_IMGADJ_LoadTestImage&()` | Load test images | `(imageType$)` | "simple", "gradient", "complex" |
| `GJ_IMGADJ_ShowComparison()` | Display before/after | `(original&, adjusted&, title$)` | Side-by-side comparison |
| `GJ_IMGADJ_CreateComplexTestImage&()` | Generate test image | `()` | Complex pattern for testing |
| `GJ_IMGADJ_CreateGradientTestImage&()` | Generate gradient | `()` | RGB gradient pattern |
| `GJ_IMGADJ_CreateSimpleTestImage&()` | Generate simple image | `()` | Basic shapes and colors |
| `GJ_IMGADJ_CreateTestImageWithBlack&()` | **NEW!** Generate test image with black areas | `()` | Specifically for testing non-black adjustments |

## USAGE

### Basic Usage (Individual Library)
```vb
'Insert at top of code:
'$INCLUDE:'path_to_GJ_LIB/IMGADJ/IMGADJ.BI'

' Load or create an image
DIM myImage AS LONG
myImage = GJ_IMGADJ_LoadTestImage&("complex")

' Apply adjustments
DIM brightened AS LONG, contrasted AS LONG
brightened = GJ_IMGADJ_Brightness&(myImage, "+", 50)
contrasted = GJ_IMGADJ_Contrast&(brightened, "+", 25)

' Display results
CALL GJ_IMGADJ_ShowComparison(myImage, contrasted, "Bright +50, Contrast +25")

' Clean up memory
_FREEIMAGE brightened
_FREEIMAGE contrasted
_FREEIMAGE myImage

'Insert at bottom of code:
'$INCLUDE:'path_to_GJ_LIB/IMGADJ/IMGADJ.BM'
```

### Advanced Usage Patterns

#### Chaining Adjustments
```vb
' Method 1: Explicit temporary variables (recommended)
DIM temp AS LONG, final AS LONG
temp = GJ_IMGADJ_Brightness&(original, "+", 20)
final = GJ_IMGADJ_Contrast&(temp, "+", 15)
_FREEIMAGE temp  ' Free intermediate result

' Method 2: Nested calls (compact but harder to debug)
final = GJ_IMGADJ_Contrast&(GJ_IMGADJ_Brightness&(original, "+", 20), "+", 15)
```

#### Interactive Adjustment
```vb
DIM adjustment AS INTEGER: adjustment = 0
DIM adjusted AS LONG
DO
    IF adjusted <> 0 THEN _FREEIMAGE adjusted
    adjusted = GJ_IMGADJ_Brightness&(original, IIF(adjustment >= 0, "+", "-"), ABS(adjustment))
    CALL GJ_IMGADJ_ShowComparison(original, adjusted, "Brightness: " + STR$(adjustment))
    ' Handle input to change adjustment value...
LOOP
```

#### Non-Black Brightness/Contrast (Selective Adjustment)
```vb
' Perfect for preserving black text, outlines, or UI elements
DIM imageWithBlackElements AS LONG, selectively_adjusted AS LONG

' Load image with black text or graphics
imageWithBlackElements = GJ_IMGADJ_CreateTestImageWithBlack&()

' Apply strong adjustments while preserving pure black pixels
selectively_adjusted = GJ_IMGADJ_BrightnessContrastNonBlack&(imageWithBlackElements, "+", 60, "+", 40)

' Compare with regular adjustment (affects all pixels including black)
DIM regular_adjusted AS LONG, temp AS LONG
temp = GJ_IMGADJ_Brightness&(imageWithBlackElements, "+", 60)
regular_adjusted = GJ_IMGADJ_Contrast&(temp, "+", 40)
_FREEIMAGE temp

' Side-by-side comparison shows black preservation
CALL GJ_IMGADJ_ShowComparison(regular_adjusted, selectively_adjusted, "Regular vs Non-Black Adjustment")

' Use cases for non-black adjustment:
' • Photo editing with black text overlay
' • UI graphics with black borders/outlines  
' • Logo enhancement while preserving black elements
' • Artistic effects maintaining pure black shadows
```

#### Batch Processing
```vb
DIM images(10) AS LONG, processed(10) AS LONG
FOR i = 0 TO 10
    ' Apply same adjustments to multiple images
    processed(i) = GJ_IMGADJ_Brightness&(images(i), "+", 25)
    DIM temp AS LONG: temp = processed(i)
    processed(i) = GJ_IMGADJ_Contrast&(temp, "+", 10)
    _FREEIMAGE temp
NEXT
```

#### Creative Effects Chaining
```vb
' Create artistic effect by combining adjustments
DIM artistic AS LONG, temp1 AS LONG, temp2 AS LONG
temp1 = GJ_IMGADJ_Posterize&(original, 4)          ' Reduce to 4 color levels
temp2 = GJ_IMGADJ_Saturation&(temp1, "+", 50)      ' Boost saturation
artistic = GJ_IMGADJ_Contrast&(temp2, "+", 20)     ' Add contrast
_FREEIMAGE temp1: _FREEIMAGE temp2                  ' Clean up intermediates
```

#### Color Tinting and Colorization
```vb
' Apply specific color tints
DIM sepia_tint AS LONG, blue_tint AS LONG, green_tint AS LONG

' Create sepia-like effect with colorize
sepia_tint = GJ_IMGADJ_Colorize&(original, 30, 0.4)    ' Orange hue, medium saturation

' Create blue monochrome effect
blue_tint = GJ_IMGADJ_Colorize&(original, 240, 0.6)    ' Blue hue, high saturation

' Create vintage green effect
green_tint = GJ_IMGADJ_Colorize&(original, 120, 0.3)   ' Green hue, low saturation

' Interactive colorization (great for photo editing)
DIM hue_value AS INTEGER: hue_value = 180
DIM sat_value AS SINGLE: sat_value = 0.5
DIM colorized AS LONG
DO
    IF colorized <> 0 THEN _FREEIMAGE colorized
    colorized = GJ_IMGADJ_Colorize&(original, hue_value, sat_value)
    ' Display result and handle user input for hue_value and sat_value...
LOOP
```

#### Retro Pixelated Effects
```vb
' Create various pixel art styles
DIM retro_8bit AS LONG, retro_16bit AS LONG, extreme_pixel AS LONG

' Classic 8-bit style
retro_8bit = GJ_IMGADJ_Pixelate&(original, 8)      ' 8x8 pixel blocks

' Subtle 16-bit style  
retro_16bit = GJ_IMGADJ_Pixelate&(original, 4)     ' 4x4 pixel blocks

' Extreme pixelated effect
extreme_pixel = GJ_IMGADJ_Pixelate&(original, 20)  ' 20x20 pixel blocks

' Interactive pixelate size control
DIM pixel_size AS INTEGER: pixel_size = 5
DIM pixelated AS LONG
DO
    IF pixelated <> 0 THEN _FREEIMAGE pixelated
    pixelated = GJ_IMGADJ_Pixelate&(original, pixel_size)
    ' Display result and handle user input for pixel_size (1-50)...
LOOP
```

#### Dithering Usage Examples
```vb
' Classic Floyd-Steinberg error diffusion
DIM fs_dithered AS LONG
fs_dithered = GJ_IMGADJ_DitherFloydSteinberg&(original, 0.8)

' Compare different error diffusion algorithms
DIM floyd AS LONG, jarvis AS LONG, stucki AS LONG, burkes AS LONG
floyd = GJ_IMGADJ_DitherFloydSteinberg&(original, 0.8)
jarvis = GJ_IMGADJ_DitherJarvisJudiceNinke&(original, 0.8)
stucki = GJ_IMGADJ_DitherStucki&(original, 0.8)
burkes = GJ_IMGADJ_DitherBurkes&(original, 0.8)

' Ordered dithering with different matrix sizes
DIM bayer2 AS LONG, bayer4 AS LONG, bayer8 AS LONG, bayer16 AS LONG
bayer2 = GJ_IMGADJ_DitherBayer2x2&(original, 0.8)   ' Coarse patterns
bayer4 = GJ_IMGADJ_DitherBayer4x4&(original, 0.8)   ' Standard patterns
bayer8 = GJ_IMGADJ_DitherBayer8x8&(original, 0.8)   ' Fine patterns
bayer16 = GJ_IMGADJ_DitherBayer16x16&(original, 0.8) ' Very fine patterns

' Random and noise dithering
DIM random_dither AS LONG, blue_noise AS LONG
random_dither = GJ_IMGADJ_DitherRandom&(original, 0.6)    ' Film grain effect
blue_noise = GJ_IMGADJ_DitherBlueNoise&(original, 0.6)   ' Pleasing noise

' Special pattern effects
DIM halftone AS LONG, spiral AS LONG, clustered AS LONG
halftone = GJ_IMGADJ_DitherHalftone&(original, 0.8)      ' Print simulation
spiral = GJ_IMGADJ_DitherSpiral&(original, 0.8)         ' Artistic spirals
clustered = GJ_IMGADJ_DitherClusteredDot&(original, 0.8) ' Smooth clusters

' Interactive dithering with amount control
DIM dither_amount AS SINGLE: dither_amount = 0.5
DIM dithered AS LONG
DO
    IF dithered <> 0 THEN _FREEIMAGE dithered
    dithered = GJ_IMGADJ_DitherFloydSteinberg&(original, dither_amount)
    CALL GJ_IMGADJ_ShowComparison(original, dithered, "Floyd-Steinberg: " + STR$(dither_amount))
    ' Handle input to adjust dither_amount (0.0-1.0)...
LOOP

' Combining dithering with other effects
DIM posterized AS LONG, dithered_poster AS LONG
posterized = GJ_IMGADJ_Posterize&(original, 4)          ' Reduce to 4 levels
dithered_poster = GJ_IMGADJ_DitherFloydSteinberg&(posterized, 0.9) ' Add dithering
_FREEIMAGE posterized

' Retro gaming effects
DIM pixelated AS LONG, dithered_pixel AS LONG
pixelated = GJ_IMGADJ_Pixelate&(original, 4)            ' 4x4 pixel blocks
dithered_pixel = GJ_IMGADJ_DitherBayer2x2&(pixelated, 1.0) ' Strong 2x2 dither
_FREEIMAGE pixelated
```

#### Dithering Applications
```vb
' Print simulation (newspaper/magazine effect)
DIM print_sim AS LONG
print_sim = GJ_IMGADJ_DitherHalftone&(original, 0.9)

' Retro computer graphics (Atari, Commodore, Apple II)
DIM retro_atari AS LONG, retro_apple AS LONG
retro_atari = GJ_IMGADJ_DitherBayer2x2&(original, 1.0)      ' Coarse patterns
retro_apple = GJ_IMGADJ_DitherAtkinson&(original, 0.8)      ' Apple's algorithm

' Film grain and artistic effects
DIM film_grain AS LONG, artistic AS LONG
film_grain = GJ_IMGADJ_DitherRandom&(original, 0.4)         ' Subtle grain
artistic = GJ_IMGADJ_DitherSpiral&(original, 0.7)          ' Creative spirals

' Color reduction with quality dithering
DIM reduced_colors AS LONG, quality_dithered AS LONG
reduced_colors = GJ_IMGADJ_Posterize&(original, 8)          ' 8 levels per channel
quality_dithered = GJ_IMGADJ_DitherStucki&(reduced_colors, 0.8) ' High-quality dither
_FREEIMAGE reduced_colors

' Batch dithering with different algorithms
DIM algorithms(7) AS INTEGER, names(7) AS STRING, results(7) AS LONG
algorithms(0) = 0: names(0) = "Floyd-Steinberg"
algorithms(1) = 1: names(1) = "Jarvis-Judice-Ninke"
algorithms(2) = 2: names(2) = "Stucki"
algorithms(3) = 3: names(3) = "Burkes"
algorithms(4) = 4: names(4) = "Bayer 4x4"
algorithms(5) = 5: names(5) = "Random"
algorithms(6) = 6: names(6) = "Blue Noise"
algorithms(7) = 7: names(7) = "Halftone"

FOR i = 0 TO 7
    SELECT CASE algorithms(i)
        CASE 0: results(i) = GJ_IMGADJ_DitherFloydSteinberg&(original, 0.8)
        CASE 1: results(i) = GJ_IMGADJ_DitherJarvisJudiceNinke&(original, 0.8)
        CASE 2: results(i) = GJ_IMGADJ_DitherStucki&(original, 0.8)
        CASE 3: results(i) = GJ_IMGADJ_DitherBurkes&(original, 0.8)
        CASE 4: results(i) = GJ_IMGADJ_DitherBayer4x4&(original, 0.8)
        CASE 5: results(i) = GJ_IMGADJ_DitherRandom&(original, 0.8)
        CASE 6: results(i) = GJ_IMGADJ_DitherBlueNoise&(original, 0.8)
        CASE 7: results(i) = GJ_IMGADJ_DitherHalftone&(original, 0.8)
    END SELECT
    CALL GJ_IMGADJ_ShowComparison(original, results(i), names(i))
NEXT
```

#### Dithering Constants
```vb
' Use these constants for consistent dithering effects:
' Amount values (0.0 to 1.0):
CONST DITHER_SUBTLE = 0.3       ' Minimal dithering, preserves smooth areas
CONST DITHER_MODERATE = 0.6     ' Balanced dithering, good for most uses  
CONST DITHER_STRONG = 0.8       ' Noticeable dithering, artistic effect
CONST DITHER_EXTREME = 1.0      ' Maximum dithering, strong texture

' Examples using constants:
DIM subtle_dither AS LONG, strong_dither AS LONG
subtle_dither = GJ_IMGADJ_DitherFloydSteinberg&(original, DITHER_SUBTLE)
strong_dither = GJ_IMGADJ_DitherBayer4x4&(original, DITHER_STRONG)
```

#### Professional Pixel Scaling
```vb
' Perfect for retro game graphics and pixel art
DIM scaledImage AS LONG

' Best general-purpose pixel art scaling (2x, 3x, 4x)
scaledImage = GJ_IMGADJ_PixelScaler&(pixelArt, GJ_IMGADJ_PIXELSCALER_SXBR2)

' For style-preserving scaling (maintains art characteristics)
scaledImage = GJ_IMGADJ_PixelScaler&(pixelArt, GJ_IMGADJ_PIXELSCALER_MMPX2)

' For cartoon/anime style artwork
scaledImage = GJ_IMGADJ_PixelScaler&(animeArt, GJ_IMGADJ_PIXELSCALER_HQ2XA)

' For complex detailed artwork  
scaledImage = GJ_IMGADJ_PixelScaler&(detailedArt, GJ_IMGADJ_PIXELSCALER_HQ3XB)

' Interactive scaler comparison
DIM scaler_type AS INTEGER: scaler_type = 0
DIM scaled AS LONG
DO
    IF scaled <> 0 THEN _FREEIMAGE scaled
    scaled = GJ_IMGADJ_PixelScaler&(original, scaler_type)
    IF scaled <> 0 THEN
        ' Display scaled image with scaler type name
        PRINT "Scaler:", scaler_type, "Size:", _WIDTH(scaled), "x", _HEIGHT(scaled)
    END IF
    ' Handle input to change scaler_type (0-7)...
LOOP
```

#### Practical Pixel Scaling Examples
```vb
' Load 16x16 pixel art sprite
DIM sprite AS LONG, scaled_sprite AS LONG
sprite = _LOADIMAGE("character_16x16.png", 32)

' Scale for modern displays (64x64)
scaled_sprite = GJ_IMGADJ_PixelScaler&(sprite, GJ_IMGADJ_PIXELSCALER_SXBR4)
' Result: 64x64 image with crisp, enhanced edges

' Compare scaling methods for same source
DIM xbrz_scaled AS LONG, hq_scaled AS LONG, mmpx_scaled AS LONG
xbrz_scaled = GJ_IMGADJ_PixelScaler&(sprite, GJ_IMGADJ_PIXELSCALER_SXBR2)
hq_scaled = GJ_IMGADJ_PixelScaler&(sprite, GJ_IMGADJ_PIXELSCALER_HQ2XA)
mmpx_scaled = GJ_IMGADJ_PixelScaler&(sprite, GJ_IMGADJ_PIXELSCALER_MMPX2)

' Display side-by-side for comparison
CALL GJ_IMGADJ_ShowComparison(sprite, xbrz_scaled, "Original vs xBRZ 2x")
CALL GJ_IMGADJ_ShowComparison(sprite, hq_scaled, "Original vs HQ2XA")
CALL GJ_IMGADJ_ShowComparison(sprite, mmpx_scaled, "Original vs MMPX2")

' Batch process multiple sprites
DIM sprites(10) AS LONG, scaled_sprites(10) AS LONG
FOR i = 0 TO 10
    ' Scale all sprites consistently for UI elements
    scaled_sprites(i) = GJ_IMGADJ_PixelScaler&(sprites(i), GJ_IMGADJ_PIXELSCALER_SXBR2)
NEXT

' Adaptive scaling based on image characteristics
DIM auto_scaled AS LONG
IF image_is_cartoon THEN
    auto_scaled = GJ_IMGADJ_PixelScaler&(source, GJ_IMGADJ_PIXELSCALER_HQ2XA)
ELSEIF image_is_detailed THEN
    auto_scaled = GJ_IMGADJ_PixelScaler&(source, GJ_IMGADJ_PIXELSCALER_HQ2XB)
ELSE
    auto_scaled = GJ_IMGADJ_PixelScaler&(source, GJ_IMGADJ_PIXELSCALER_SXBR2)
END IF
```

#### Pixel Scaler Requirements
```vb
' Requires QB64PE V3.9.0+ with pixel scaler support
' SXBR3 and SXBR4 require QB64PE V4.1.0+
' Function will return 0 if scaler is not supported

' Check if scaling succeeded
DIM result AS LONG
result = GJ_IMGADJ_PixelScaler&(source, GJ_IMGADJ_PIXELSCALER_SXBR4)
IF result = 0 THEN
    PRINT "Pixel scaler not supported in this QB64PE version"
    ' Fallback to regular scaling or different scaler
    result = GJ_IMGADJ_PixelScaler&(source, GJ_IMGADJ_PIXELSCALER_SXBR2)
END IF
```

## MEMORY MANAGEMENT

⚠️ **CRITICAL**: All IMGADJ functions return **NEW** image handles. You must free them when done:

```vb
DIM adjusted AS LONG
adjusted = GJ_IMGADJ_Brightness&(original, "+", 50)
' ... use the adjusted image ...
_FREEIMAGE adjusted  ' Always free when done!
```

**Memory Safety Rules:**
- Original images are **never modified**
- Functions return **new image handles**
- You **own** returned handles and must free them
- Check for valid handles before using: `IF img& <> 0 THEN...`

### Parameter Reference

### Direction Parameters
- `"+"` - Increase effect (brighter, more contrast, etc.)
- `"-"` - Decrease effect (darker, less contrast, etc.)

### Amount/Percentage Parameters
- **Brightness**: 0-255 (amount to add/subtract)
- **Contrast**: 0-100 (percentage change)
- **BrightnessContrastNonBlack**: 
  - brightDir/contrastDir: "+" or "-" (direction for each adjustment)
  - brightAmt: 0-255 (brightness amount), contrastAmt: 0-100 (contrast percentage)
  - Only affects pixels that are NOT pure black (RGB 0,0,0)
- **Gamma**: 0-100 (gamma multiplier = 1.0 + amount/100)
- **Saturation**: 0-200 (percentage change)
- **Hue**: 0-360 (degrees to shift)
- **Colorize**: hue 0-360 (target hue in degrees), saturation 0.0-1.0 (target saturation level)
- **Pixelate**: 1-50 (size of each pixel block)
- **PixelScaler**: scalerType 0-7 (use GJ_IMGADJ_PIXELSCALER_* constants)
- **Film Grain**: 0-100 (noise intensity)
- **Vignette**: 0.0-1.0 (edge darkening strength)
- **Posterize**: 2-16 (number of levels per color channel)
- **Dithering**: 0.0-1.0 (dithering intensity: 0.0=none, 1.0=maximum effect)

### Constants
```vb
' Desaturate methods
GJ_IMGADJ_DESATURATE_AVERAGE     ' Simple RGB average
GJ_IMGADJ_DESATURATE_LUMINANCE   ' Weighted luminance formula

' Threshold modes  
GJ_IMGADJ_THRESHOLD_BINARY       ' White above threshold, black below
GJ_IMGADJ_THRESHOLD_INVERTED     ' Black above threshold, white below

' Pixel Scaler Types
GJ_IMGADJ_PIXELSCALER_SXBR2      ' xBRZ 2x pixel scaler
GJ_IMGADJ_PIXELSCALER_SXBR3      ' xBRZ 3x pixel scaler  
GJ_IMGADJ_PIXELSCALER_SXBR4      ' xBRZ 4x pixel scaler
GJ_IMGADJ_PIXELSCALER_MMPX2      ' MMPX Style-Preserving 2x pixel scaler
GJ_IMGADJ_PIXELSCALER_HQ2XA      ' High Quality Cartoon 2x pixel scaler
GJ_IMGADJ_PIXELSCALER_HQ2XB      ' High Quality Complex 2x pixel scaler
GJ_IMGADJ_PIXELSCALER_HQ3XA      ' High Quality Cartoon 3x pixel scaler
GJ_IMGADJ_PIXELSCALER_HQ3XB      ' High Quality Complex 3x pixel scaler

' Dithering Algorithm Constants (for reference)
GJ_IMGADJ_DITHER_FLOYD_STEINBERG      ' 0 - Classic error diffusion
GJ_IMGADJ_DITHER_JARVIS_JUDICE_NINKE  ' 1 - Enhanced error diffusion  
GJ_IMGADJ_DITHER_STUCKI               ' 2 - Sharp error diffusion
GJ_IMGADJ_DITHER_BURKES               ' 3 - Balanced error diffusion
GJ_IMGADJ_DITHER_SIERRA_3             ' 4 - Sierra Three-Row filter
GJ_IMGADJ_DITHER_SIERRA_2             ' 5 - Sierra Two-Row filter
GJ_IMGADJ_DITHER_SIERRA_LITE          ' 6 - Simplified Sierra filter
GJ_IMGADJ_DITHER_ATKINSON             ' 7 - Apple Atkinson dithering
GJ_IMGADJ_DITHER_BAYER_2X2            ' 8 - 2x2 ordered matrix
GJ_IMGADJ_DITHER_BAYER_4X4            ' 9 - 4x4 ordered matrix
GJ_IMGADJ_DITHER_BAYER_8X8            ' 10 - 8x8 ordered matrix
GJ_IMGADJ_DITHER_BAYER_16X16          ' 11 - 16x16 ordered matrix
GJ_IMGADJ_DITHER_RANDOM               ' 12 - Random noise dithering
GJ_IMGADJ_DITHER_BLUE_NOISE           ' 13 - High-frequency noise
GJ_IMGADJ_DITHER_HALFTONE             ' 14 - Print halftone simulation
GJ_IMGADJ_DITHER_SPIRAL               ' 15 - Spiral pattern dithering
GJ_IMGADJ_DITHER_CLUSTERED_DOT        ' 16 - Clustered dot pattern
```

## PERFORMANCE BENEFITS

| Operation | Optimization | Speed Improvement |
|-----------|--------------|-------------------|
| Brightness/Contrast | _MEMIMAGE direct access | 10-50x faster |
| Gamma Correction | Lookup table | 100x faster |
| Film Grain | Pre-computed noise array | 100x faster |
| Posterize | Lookup table | 100x faster |
| Vignette | Optimized distance calculation | 50x faster |
| Levels | Lookup table | 50x faster |
| Simple Effects | _MEMIMAGE operations | 50x faster |
| Dithering Algorithms | Optimized error diffusion + matrix operations | 20-100x faster |

**All algorithms are real-time capable** on modern hardware.

### Dithering Performance Notes
- **Error Diffusion**: Uses optimized single-pass algorithms with _MEMIMAGE
- **Ordered Dithering**: Pre-computed threshold matrices for maximum speed
- **Matrix Operations**: Cached dithering matrices avoid repeated calculations
- **Memory Efficiency**: Direct pixel manipulation reduces memory allocation overhead

## ERROR HANDLING

- Functions validate image handles and exit with error messages if invalid
- `GJ_IMGADJ_LoadTestImage&` exits if test image files don't exist  
- Parameter values are automatically clamped to safe ranges
- Memory allocation failures are handled gracefully

## EXAMPLE OUTPUT

> Screenshot of output from [IMGADJ.BAS](IMGADJ.BAS)

The demonstration program showcases:
- ⚡ Core adjustments (Brightness, Contrast, Gamma)
- 🎨 Creative effects (Blur, Glow, Film Grain, Vignette)  
- 🌈 Color adjustments (Saturation, Hue, Color Balance, Levels)
- 🛠️ Utility effects (Invert, Sepia, Desaturate, Threshold)
- 🔗 Chained effects demonstration
- 🏆 Performance achievement summary

## TECHNICAL DETAILS

### Optimization Techniques
- **_MEMIMAGE**: Direct memory access bypasses QB64PE's slower pixel functions
- **Lookup Tables**: Pre-computed transformations eliminate repeated calculations
- **Pre-computed Noise**: Film grain uses pre-generated noise array
- **Efficient Algorithms**: HSV conversions, optimized distance calculations

### Color Space Conversions
- RGB ↔ HSV conversions for hue/saturation adjustments
- Luminance-weighted grayscale conversion
- Standard sepia tone transformation matrix

### Memory Architecture
- All functions preserve original images
- Consistent error handling across all functions
- Automatic parameter validation and clamping
- Clean resource management patterns


### EXAMPLE 
> Screenshot of output from [IMGADJ.BAS](IMGADJ.BAS)  
> Down-sampled GIF to 256 colors - Actual results will be much higher quality!

![](IMGADJ.gif)