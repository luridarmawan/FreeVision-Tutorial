# 90 - Experiments
## 35 - HistoryViewer

![image.png](image.png)

With TListBox you must definitely free the memory of TList with a destructor.
This is not Free-Vision usual. This also makes sense, since lists are often used globally,
otherwise you would always have to create a copy of it.
The **destructor** which cleans up the memory is missing there.

---

---
**Unit with the new dialog.**
<br>
The dialog with the ListBox

```pascal
unit MyDialog;

```

Declare the **destructor** which frees the **memory** of the list.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;

    constructor Init;
    destructor Done; virtual;  // Because of memory leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Generate components for the dialog.

```pascal
const
  cmTag = 1000;  // Local event constant

constructor TMyDialog.Init;
var
  R: TRect;
  HScrollBar, VScrollBar: PScrollBar;
  i: Integer;
  hw:PHistoryViewer;
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');

begin
  R.Assign(10, 5, 64, 17);
  inherited Init(R, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;

  // HScrollBar for ListBox
  R.Assign(5, 7, 31, 8);
  HScrollBar := new(PScrollBar, Init(R));
  Insert(HScrollBar);

  // VScrollBar for ListBox
  R.Assign(31, 2, 32, 7);
  VScrollBar := new(PScrollBar, Init(R));
  Insert(VScrollBar);

  //// ListBox
  //R.A.X := 5;
  //Dec(R.B.X, 1);
  //ListBox := new(PListBox, Init(R, 1, VScrollBar));
  //ListBox^.NewList(StringCollection);
  //Insert(ListBox);

  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  hw := new(PHistoryViewer, Init(R, HScrollBar, VScrollBar,1));
//  hw^.NewList(StringCollection);
  Insert(hw);



  // Day-Button
  R.Assign(5, 9, 18, 11);
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));

  // Cancel-Button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

  // Ok-Button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

Manually free the memory of the list.

```pascal
destructor TMyDialog.Done;
begin
//  Dispose(ListBox^.List, Done); // Free the list
  inherited Done;
end;

```

The event handler
When you click on **[Day]**, the focused entry of the ListBox is displayed.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // do something
        end;
        cmTag: begin
          // Read focused entry
          // And output
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' selected', nil, mfOKButton);
          // End event.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

```
