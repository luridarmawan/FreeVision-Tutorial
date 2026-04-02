# 15 - Ready-made Dialogs
## 25 - Change Folder

![image.png](image.png)

Folder change dialog.
The **PChDirDialog**.

---
The folder change dialog

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    ChDirDialog: PChDirDialog;
    Ordner: ShortString;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmChDir: begin
          New(ChDirDialog, Init(fdOpenButton, 1));
          if ExecuteDialog(ChDirDialog, nil) <> cmCancel then begin
            MessageBox('Ordner wurde gewechselt', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;
```
