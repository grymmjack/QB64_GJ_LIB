# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S ASEPRITE LIBRARY

Adds native [ASEPRITE](https://www.aseprite.org/) support to QB64!

### USAGE for ASEPRITE LIB (separately)
```basic
'Insert at top of file:
'$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BI' at the top of file

' ...your code here...

'Insert at bottom of file: 
'$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BM' at the bottom of file
```



## WHAT'S IN THE LIBRARY (WIP)
| SUB / FUNCTION | NOTES |
|----------------|-------|
| load_aseprite_file&      | Top-level convenience loader that returns a composite image handle ready for _PUTIMAGE
| load_aseprite_image      | Loads a .ase/.aseprite file into an ASEPRITE_IMAGE structure
| get_aseprite_info$       | Returns human-readable information about an ASEPRITE_IMAGE
| is_valid_aseprite_file   | Checks whether a file is a valid Aseprite file
| get_aseprite_extension$  | Returns the canonical Aseprite file extension (".ase")
| get_blend_mode_name$     | Maps blend mode constant to descriptive string
| get_animation_direction_name$ | Maps animation direction constant to descriptive string
| create_image_from_aseprite&| Creates a QB64PE image handle from loaded Aseprite pixel data
| display_aseprite_image   | Draws an ASEPRITE_IMAGE to the screen (with scale/centering)
| preview_aseprite_image   | Quick preview helper (original size)
| preview_aseprite_scaled  | Scaled preview helper (e.g. 2x)
| load_aseprite_pixels%    | Attempts to load pixel data from file chunks into an image
| load_raw_pixel_data%     | Reads uncompressed pixel data into a target image
| load_compressed_pixel_data% | Decompresses zlib-compressed cel data into an image
| load_compressed_pixel_data_for_layer% | Specialized loader for layer extraction (positions at 0,0)
| create_compressed_placeholder% | Fallback placeholder renderer for compressed data (uses _INFLATE$)
| get_indexed_color&       | Returns RGB color for an indexed palette entry
| load_aseprite_enhanced   | Loads enhanced ASEPRITE data with layers and animation metadata
| parse_layer_chunks%      | Parses layer chunk data from file into structures
| parse_frame_chunks%      | Parses frame and timing chunks from file
| init_aseprite_animation  | Initializes animation timing/state for enhanced images
| update_aseprite_animation| Advances animation timing and handles frame progression
| play_aseprite_animation  | Starts/resumes animation playback
| pause_aseprite_animation | Pauses animation playback
| set_aseprite_frame       | Sets the current animation frame (by index)
| get_aseprite_layer_count%| Returns number of layers in ASEPRITE_IMAGE
| get_aseprite_frame_count%| Returns number of frames in ASEPRITE_IMAGE
| get_aseprite_cel_count%  | Returns total number of cels in ASEPRITE_IMAGE
| get_aseprite_tag_count%  | Returns number of animation tags in ASEPRITE_IMAGE
| is_valid_layer_index%    | Validates a layer index against an ASEPRITE_IMAGE
| is_valid_frame_index%    | Validates a frame index against an ASEPRITE_IMAGE
| get_layer_count%         | Returns layer count for ASEPRITE_ENHANCED_IMAGE
| get_layer_name$          | Returns the name of a layer in an enhanced image
| is_layer_visible%        | Checks whether a layer is currently visible
| set_layer_visibility     | Set visibility for a layer and update composite image
| update_composite_image   | Rebuilds composite image from visible layers
| load_specific_layer_image& | Extracts a single layer's pixels into a QB64PE image
| load_specific_layer_image_enhanced& | Enhanced layer extraction with improved scope handling
| create_aseprite_image_from_layer& | High-level wrapper to create an image from a named/indexed layer
| create_full_composite_image& | Composites all layers for a given frame into a single image handle

### SAMPLE PROGRAMS
- [ASEPRITE.BAS](ASEPRITE.BAS) - Simple implementation to load a `.aseprite` image
- [WORKING-KEEP-debug_layers_example.bas](WORKING-KEEP-debug_layers_example.bas) - WIP on showing how to load layers
- [WORKING-KEEP-visual_pumpkin_viewer.bas](WORKING-KEEP-visual_pumpkin_viewer.bas) - WIP on showing how to load a single layer at various sizes

### SCREENSHOTS
> Screenshot of output from [ASEPRITE.BAS](ASEPRITE.BAS)
![Example output from [ASEPRITE.BAS](ASEPRITE.BAS)](ASEPRITE.png)

> Screenshot of output from [WORKING-KEEP-visual_pumpkin_viewer.BAS](WORKING-KEEP-visual_pumpkin_viewer.BAS)
![Example output from [WORKING-KEEP-visual_pumpkin_viewer.BAS](WORKING-KEEP-visual_pumpkin_viewer.BAS)](WORKING-KEEP-visual_pumpkin_viewer.png)
![alt text](image.png)