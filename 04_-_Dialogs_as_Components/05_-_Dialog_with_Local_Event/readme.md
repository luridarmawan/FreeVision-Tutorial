# 04 - Dialogs as Components
## 05 - Dialog with Local Event

![image.png](image.png)

In inherited dialogs it is possible to install buttons that perform an action locally in the dialog.
In the example, a MessageBox is called.

---
Nothing changes in the main program, it doesn't matter whether something is done locally.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);
          if ValidView(AboutDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(AboutDialog);           // Execute About dialog.
            Dispose(AboutDialog, Done);               // Free dialog and memory.
          end;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```


---
**Unit with the new dialog.**
<br>
There you can clearly see that it has a button for local events.
It is important with the numbering that it does not overlap with another event number.
Especially when the dialog is not opened modally.
Unless it is desired, e.g. if you want to access the dialog via the menu.

```pascal
unit MyDialog;

```

A HandleEvent is added for the dialog.

```pascal
type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

In the constructor, the dialog is extended by the Msg-box button, which processes the local event **cmMsg**.

```pascal
const
    cmMsg = 1003;  // Local event

constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'About');

  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +
    'Written by MB'+ #13#32#13 +
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));

  // MessageBox-Button, with local event.
  R.Assign(19, 8, 32, 10);
  Insert(new(PButton, Init(R, '~M~sg-Box', cmMsg, bfNormal)));

  // Ok-Button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

In the new event handler, local events (cmMsg) are processed.
Other events, e.g. **cmOk** are passed on to the main program, which then closes the dialog.

```pascal
procedure TMyAbout.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        // Execute local event.
        cmMsg: begin
          MessageBox('Ich bin eine MessageBox !', nil, mfOKButton);
          ClearEvent(Event);  // End event.
        end;
      end;
    end;
  end;

end;

```
