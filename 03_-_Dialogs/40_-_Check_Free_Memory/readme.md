# 03 - Dialogs
## 40 - Check Free Memory

![image.png](image.png)

Check if there is enough memory to create the dialog.
On today's computers this will probably no longer be the case, that the memory overflows because of a dialog.

---
The virtual procedure **OutOfMemory**, in case the memory overflows.
If you don't override this method, no error message will be displayed, but then the user doesn't know why his view doesn't appear.

```pascal
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Parameter for dialog.
    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.

    procedure MyParameter;                             // new function for a dialog.
  end;
```

The procedure is called when there is too little memory available.

```pascal
  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;
```

The dialog is now loaded with values.
You do this as soon as you are finished creating components.
With **ValidView(...** you check if there is enough memory to create the component.
If not, **nil** is returned. It doesn't matter whether you override **OutOfMemory** or not.

```pascal
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
    dummy: word;
    View: PView;
  begin
    R.Assign(0, 0, 35, 15);
    R.Move(23, 3);
    Dlg := New(PDialog, Init(R, 'Parameter'));
    with Dlg^ do begin

      // CheckBoxes
      R.Assign(2, 3, 18, 7);
      View := New(PCheckBoxes, Init(R,
        NewSItem('~D~atei',
        NewSItem('~Z~eile',
        NewSItem('D~a~tum',
        NewSItem('~Z~eit',
        nil))))));
      Insert(View);
      // Label for CheckGroup.
      R.Assign(2, 2, 10, 3);
      Insert(New(PLabel, Init(R, 'Dr~u~cken', View)));

      // RadioButtons
      R.Assign(21, 3, 33, 6);
      View := New(PRadioButtons, Init(R,
        NewSItem('~G~ross',
        NewSItem('~M~ittel',
        NewSItem('~K~lein',
        nil)))));
      Insert(View);
      // Label for RadioGroup.
      R.Assign(20, 2, 31, 3);
      Insert(New(PLabel, Init(R, '~S~chrift', View)));

      // Edit Line
      R.Assign(3, 10, 32, 11);
      View := New(PInputLine, Init(R, 50));
      Insert(View);
      // Label for Edit Line
      R.Assign(2, 9, 10, 10);
      Insert(New(PLabel, Init(R, '~H~inweis', View)));

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Close-Button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));
    end;
    if ValidView(Dlg) <> nil then begin // Check if enough memory.
      Dlg^.SetData(ParameterData);      // Load dialog with the values.
      dummy := Desktop^.ExecView(Dlg);  // Execute dialog.
      if dummy = cmOK then begin        // If dialog ended with Ok, then load data from dialog to record.
        Dlg^.GetData(ParameterData);
      end;

      Dispose(Dlg, Done);               // Free dialog and memory.
    end;
  end;
```
