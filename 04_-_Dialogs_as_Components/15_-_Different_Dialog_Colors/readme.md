# 04 - Dialogs as Components
## 15 - Different Dialog Colors

![image.png](image.png)

A window/dialog can be assigned different color schemes.
By default, the following is used:

```pascal
Editor window : Blue
Dialog         : Gray
Help window    : Cyan
```


Without intervention, the windows/dialogs always appear in the correct color.
A modification only makes sense in special cases.

---
**Unit with the new dialog.**
<br>
With the 3 upper buttons, you can change the color scheme of the dialog.

```pascal
unit MyDialog;

```

Here 3 event constants have been added.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button with counter.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Building the dialog is nothing special.

```pascal
const
  cmBlue = 1006;
  cmCyan = 1007;
  cmGray = 1008;

constructor TMyDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'Mein Dialog');

  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R, 'Choose a color')));

  // Color
  R.Assign(7, 5, 15, 7);
  Insert(new(PButton, Init(R, 'blue', cmBlue, bfNormal)));
  R.Assign(17, 5, 25, 7);
  Insert(new(PButton, Init(R, 'cyan', cmCyan, bfNormal)));
  R.Assign(27, 5, 35, 7);
  Insert(new(PButton, Init(R, 'gray', cmGray, bfNormal)));

  // Ok-Button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

Here the color schemes are changed with the help of **Palette := dpxxx**.
It is also important here to call **Draw**, this time not for a component, but for the whole dialog.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);    // Call ancestor.

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmBlue: begin
          Palette := dpBlueDialog; // Assign palette, here blue.
          Draw;                    // Redraw dialog.
          ClearEvent(Event);       // The event is completed.
        end;
        cmCyan: begin
          Palette := dpCyanDialog;
          Draw;
          ClearEvent(Event);
        end;
        cmGray: begin
          Palette := dpGrayDialog;
          Draw;
          ClearEvent(Event);
        end;
      end;
    end;
  end;

end;

```
