# 03 - Dialogs
## 35 - Remember Values in Dialog

![image.png](image.png)

Until now, the values in the dialog were always lost when you closed and reopened it.
For this reason, the values are now stored in a record.

---
  In this record the values of the dialog are stored.
  The order of the data in the record **must** be exactly the same as when creating the components, otherwise there will be a crash.
  With Turbo-Pascal you had to use a **Word** instead of **LongWord**, this is important when porting old applications.

```pascal
type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];
  end;
```

Here the constructor is also inherited, this descendant is needed to load the dialog data with default values.

```pascal
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Data for parameter dialog
    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyParameter;                             // new function for a dialog.
  end;
```

The constructor which loads the values for the dialog.
The data structure for the radio buttons is simple. 0 is the first button, 1 the second, 2 the third, etc.
For the checkboxes, it's best to do it binary. In the example, the first and third checkboxes are set.

```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;     // Call ancestor
    with ParameterData do begin
      Druck := %0101;
      Schrift := 2;
      Hinweis := 'Hello world';
    end;
  end;
```

The dialog is now loaded with values.
You do this as soon as you are finished creating components.

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
    Dlg^.SetData(ParameterData);      // Load dialog with the values.
    dummy := Desktop^.ExecView(Dlg);  // Execute dialog.
    if dummy = cmOK then begin        // If dialog ended with Ok, then load data from dialog to record.
      Dlg^.GetData(ParameterData);
    end;

    Dispose(Dlg, Done);               // Free dialog and memory.
  end;
```
