# MSG_BOX — Message Box / Input Box Dialog

Modal message box and input box dialog for QB64-PE with dark flat theme.

## Features

- **Message box mode** — Display text with icon and buttons
- **Input box mode** — Message + text input field with placeholder
- Button presets: OK, OK+Cancel, Yes+No, Yes+No+Cancel, Retry+Cancel, Custom
- Icon types: None, Info, Warning, Error, Question
- Max 3 buttons, word-wrapped message text, keyboard shortcuts
- Draggable title bar, close [X] button
- Tab focus cycling between input field and buttons
- Escape cancels, Enter confirms
- Screen overlay with captured background

## Dependencies

- **TEXT_INPUT** — Used for the input field in input box mode

## Usage

```basic
'$INCLUDE:'path/to/MSG_BOX/MSG-BOX.BI'

' ... your code ...

' Simple alert
MB_alert "Welcome", "Hello World!"

' Confirm dialog
IF MB_confirm%("Save?", "Save changes?") THEN
    ' user clicked Yes
END IF

' Warning
IF MB_warning%("Delete", "Are you sure?") THEN
    ' user clicked OK
END IF

' Error
MB_error "Oops", "Something went wrong."

' Input box
DIM name$ AS STRING
name$ = MB_input_box$("Rename", "Enter name:", "default", "placeholder...")

' Custom button preset
DIM result AS INTEGER
result = MB_message_box%("Title", "Message", MB_BTN_YES_NO_CANCEL, MB_ICON_QUESTION)

'$INCLUDE:'path/to/MSG_BOX/MSG-BOX.BM'
```

## Files

| File | Purpose |
|------|---------|
| `MSG-BOX.BI` | Leader include |
| `MSG-BOX.BM` | Leader implementation |
| `MB-TYPES.BI` | Type definitions, button/icon/result constants |
| `MB-THEME.BI` | Layout and color constants |
| `MB-API.BM` | Public API, init, layout, modal loop, text wrapping |
| `MB-INPUT.BM` | Mouse and keyboard input handling |
| `MB-RENDER.BM` | Dialog rendering (title, content, icons, buttons) |
| `MB-TEST.BAS` | Standalone test program |

## API

| Function/Sub | Description |
|-------------|-------------|
| `MB_message_box%(title$, msg$, buttons%, icon%)` | Show message box, returns MB_RESULT_* |
| `MB_input_box$(title$, msg$, default$, placeholder$)` | Show input box, returns text or "" |
| `MB_alert(title$, msg$)` | Simple OK info box |
| `MB_confirm%(title$, msg$)` | Yes/No with question icon |
| `MB_warning%(title$, msg$)` | OK/Cancel with warning icon |
| `MB_error(title$, msg$)` | OK with error icon |

## Constants

- `MB_BTN_OK`, `MB_BTN_OK_CANCEL`, `MB_BTN_YES_NO`, `MB_BTN_YES_NO_CANCEL`, `MB_BTN_RETRY_CANCEL`, `MB_BTN_CUSTOM`
- `MB_ICON_NONE`, `MB_ICON_INFO`, `MB_ICON_WARNING`, `MB_ICON_ERROR`, `MB_ICON_QUESTION`
- `MB_RESULT_NONE`, `MB_RESULT_1`, `MB_RESULT_2`, `MB_RESULT_3`

## Author

grymmjack (Rick Christy) — MIT License
