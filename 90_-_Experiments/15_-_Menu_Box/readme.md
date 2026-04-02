# 90 - Experiments
## 15 - Menu Box

![image.png](image.png)

Add buttons to the dialog.

---
Add buttons to the dialog.
With **Insert** you add the components, in this case the buttons.
With bfDefault you set the default button, this is activated with **[Enter]**.
bfNormal is a normal button.
The dialog is now opened modally, so **no** further dialogs can be opened.
dummy has the value of the button that was pressed, this corresponds to the **cmxxx** value.
The height of the buttons must always be **2**, otherwise there is an incorrect display.

```pascal
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    R: TRect;
    dummy: word;
  begin
    R.Assign(0, 0, 35, 15);                    // Size of the dialog.
    R.Move(23, 3);                             // Position of the dialog.
    Dia := New(PDialog, Init(R, 'Parameter')); // Create dialog.
    with Dia^ do begin

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Close-Button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));
    end;
    dummy := Desktop^.ExecView(Dia);   // Open dialog modally.
    Dispose(Dia, Done);                // Free dialog and memory.
  end;
```
